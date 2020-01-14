//
//  ZSPlayerView.swift
//  ZSPlayerView
//
//  Created by 张森 on 2019/8/16.
//  Copyright © 2019 张森. All rights reserved.
//

import UIKit
import AVKit

@objc public enum ZSPlayerStatus: Int {
    case loading = 1, playing, prepare, stop, pasue, end
}

@objc public protocol ZSPlayerViewDelegate {
    
    @objc optional func zs_movieFailed(_ playerView: ZSPlayerView, error: Error?)
    @objc optional func zs_movieReadyToPlay(_ playerView: ZSPlayerView)
    @objc optional func zs_movieUnknown(_ playerView: ZSPlayerView)
    
    @objc optional func zs_movieToEnd(_ playerView: ZSPlayerView)
    @objc optional func zs_movieJumped(_ playerView: ZSPlayerView)
    @objc optional func zs_movieStalle(_ playerView: ZSPlayerView)
    
    @objc optional func zs_movieCurrentTime(_ playerView: ZSPlayerView, second: Double)
    @objc optional func zs_movieChangePalyStatus(_ playerView: ZSPlayerView, status: ZSPlayerStatus)
    
    @objc optional func zs_movieEnterBackground(_ playerView: ZSPlayerView)
    @objc optional func zs_movieEnterForeground(_ playerView: ZSPlayerView)
}

@objcMembers public class ZSPlayerView: UIView {
    
    public var urlString: String?
    public var url: URL?
    public weak var delegate: ZSPlayerViewDelegate?
    public var isShouldLoop: Bool = false
    public var isShouldAutoplay: Bool = false
    
    public var videoGravity: AVLayerVideoGravity = .resizeAspect {
        
        willSet {
            av_playerLayer?.videoGravity = newValue
        }
    }
    
    public var player: AVPlayer? {
        get {
            return av_player
        }
    }
    
    public var endTimeValue: Double {
        get {
            guard av_playerItem != nil else { return 0 }
            return CMTimeGetSeconds(av_playerItem!.asset.duration)
        }
    }
    
    private var playStatus: ZSPlayerStatus = .loading
    private var isSeekToTime: Bool = false
    
    private var av_player: AVPlayer?
    private var av_playerItem: AVPlayerItem?
    private var av_playerTimeObserver: Any?
    private var av_playerLayer: AVPlayerLayer?
    
    // MARK: - 定时器失败自动重新载入
    private var timer: Timer?
    private var reloadCount: Int = 5
    private var currentReloadCount: Int = 0
    private var reloadTime: TimeInterval = 0
    
    private func reloadStartTimer() {
        guard timer == nil else { return }
        
        timer = Timer.supportiOS_10EarlierTimer(1, repeats: true, block: { [unowned self] (timer) in
            
            if Int(self.reloadTime) == self.currentReloadCount {
                self.play()
                self.reloadTime = 0
                self.currentReloadCount += 1
            }
            
            self.reloadTime += 1
            
            if self.currentReloadCount >= self.reloadCount {
                self.reloadStopTimer()
                let error: Error? = self.av_playerItem?.error
                self.delegate?.zs_movieFailed?(self, error: error == nil ? self.av_player?.error : error)
            }
        })
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    private func reloadStopTimer() {
        timer?.invalidate()
        timer = nil
        reloadTime = 0
        currentReloadCount = 0
    }
    
    // MARK: - 添加事件观察和通知
    private func addPlayerItemObserver() {
        av_playerItem?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        av_playerItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
        av_playerItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
    }
    
    private func removePlayerItemObserver() {
        av_playerItem?.removeObserver(self, forKeyPath: "status")
        av_playerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        av_playerItem?.removeObserver(self, forKeyPath: "playbackBufferEmpty")
    }
    
    private func addPlayerTimeObserver() {
        av_playerTimeObserver = av_player?.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 100), queue: nil, using: { [unowned self] (time) in
            
            guard !self.isSeekToTime else { return }
            
            self.delegate?.zs_movieCurrentTime?(self, second: Double(time.value * 1) / Double(time.timescale))
        })
    }
    
    private func addNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(movieToEnd(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(movieJumped(notification:)), name: .AVPlayerItemTimeJumped, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(movieStalle(notification:)), name: .AVPlayerItemPlaybackStalled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackground(notification:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterForeground(notification:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // MARK: - 通知#selector方法
    @objc private func movieToEnd(notification: Notification) {
        
        guard av_playerItem?.currentTime().seconds == endTimeValue else { return }
        
        playStatus = .end
        delegate?.zs_movieChangePalyStatus?(self, status: playStatus)
        
        guard isShouldLoop else {
            delegate?.zs_movieToEnd?(self)
            return
        }
        
        seek(to: 0)
    }
    
    @objc private func movieJumped(notification: Notification) {
        delegate?.zs_movieJumped?(self)
    }
    
    @objc private func movieStalle(notification: Notification) {
        playStatus = .loading
        delegate?.zs_movieChangePalyStatus?(self, status: playStatus)
        delegate?.zs_movieStalle?(self)
    }
    
    @objc private func enterBackground(notification: Notification) {
        
        delegate?.zs_movieEnterBackground?(self)
    }
    
    @objc private func enterForeground(notification: Notification) {
        
        delegate?.zs_movieEnterForeground?(self)
    }
    
    // MARK: - 观察者实现方法
    private func observeStatus() {
        
        guard let status: AVPlayerItem.Status = av_playerItem?.status else { return }
        
        switch status {
            
        case .readyToPlay:
            playStatus = .prepare
            
            delegate?.zs_movieChangePalyStatus?(self, status: playStatus)
            
            reloadStopTimer()
            
            guard isShouldAutoplay else {
                delegate?.zs_movieReadyToPlay?(self)
                return
            }
            
            play()
            
            break
            
        case .unknown:
            delegate?.zs_movieUnknown?(self)
            break
            
        case .failed:
            reloadStartTimer()
            break
            
        default:
            break
        }
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        switch keyPath {
        case "status":
            observeStatus()
            break
            
        case "loadedTimeRanges":
            
            break
            
        case "playbackBufferEmpty":
            
            break
            
        default:
            break
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        av_playerLayer?.frame = bounds
    }
    
    
    // MARK: - player操作
    private func reset() {
        av_player?.pause()
        reloadStopTimer()
        removePlayerItemObserver()
        NotificationCenter.default.removeObserver(self)
        if av_playerTimeObserver != nil {
            av_player?.removeTimeObserver(av_playerTimeObserver!)
        }
        
        av_playerLayer?.removeFromSuperlayer()
        av_playerItem = nil
        av_player = nil
        av_playerLayer?.player = nil
        av_playerLayer = nil
    }
    
    public func preparePlay() {
        
        reset()
        playStatus = .loading
        delegate?.zs_movieChangePalyStatus?(self, status: playStatus)
        
        var playUrl: URL? = url
        
        if playUrl == nil {
            
            let predcate: NSPredicate = NSPredicate(format: "SELF MATCHES%@", #"http[s]{0,1}://[^\s]*"#)
            playUrl = predcate.evaluate(with: urlString) ? URL(string: urlString!) : URL(fileURLWithPath: urlString!)
        }
        
        guard playUrl != nil else { return }
        
        av_playerItem = AVPlayerItem(url: playUrl!)
        av_player = AVPlayer(playerItem: av_playerItem)
        av_player?.volume = 1.0
        av_playerLayer = AVPlayerLayer(player: av_player)
        layer.addSublayer(av_playerLayer!)
        
        addNotification()
        addPlayerItemObserver()
        addPlayerTimeObserver()
    }
    
    public func play() {
        av_player?.play()
        playStatus = .playing
        delegate?.zs_movieChangePalyStatus?(self, status: playStatus)
    }
    
    public func pause() {
        av_player?.pause()
        playStatus = .pasue
        delegate?.zs_movieChangePalyStatus?(self, status: playStatus)
    }
    
    public func stop() {
        reset()
        playStatus = .stop
        delegate?.zs_movieChangePalyStatus?(self, status: playStatus)
    }
    
    public func seek(to pos: Double, isAccurate: Bool = true) {
        isSeekToTime = true
        pause()
        let time: CMTime = CMTime(value: CMTimeValue(endTimeValue * pos), timescale: CMTimeScale(1))
        
        if isAccurate {
            av_player?.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero, completionHandler: { [unowned self] (finished) in
                self.play()
                self.isSeekToTime = false
            })
        }else{
            av_player?.seek(to: time, completionHandler: { [unowned self] (finished) in
                self.play()
                self.isSeekToTime = false
            })
        }
    }
    
    public func destroy() {
        reloadStopTimer()
        reset()
    }
}



private extension Timer {
    
    class func supportiOS_10EarlierTimer(_ interval: TimeInterval, repeats: Bool, block: @escaping (_ timer: Timer) -> Void) -> Timer {
        
        if #available(iOS 10.0, *) {
            return Timer.init(timeInterval: interval, repeats: repeats, block: block)
        } else {
            return Timer.init(timeInterval: interval, target: self, selector: #selector(player_runTimer(_:)), userInfo: block, repeats: repeats)
        }
    }
    
    @objc private class func player_runTimer(_ timer: Timer) -> Void {
        
        guard let block: ((Timer) -> Void) = timer.userInfo as? ((Timer) -> Void) else { return }
        
        block(timer)
    }
}
