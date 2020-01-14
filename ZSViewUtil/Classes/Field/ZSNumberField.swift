//
//  JDNumberFiled.swift
//  JadeKing
//
//  Created by 张森 on 2019/10/29.
//  Copyright © 2019 张森. All rights reserved.
//

import Foundation

open class ZSInputAccessoryView: UIView {
    
    private struct style {
        
        struct button {
            static let font: UIFont = .systemFont(ofSize: 15)
            static let color: UIColor = UIColor.systemBlue.filed_dark(UIColor(red: 82 / 255, green: 82 / 255, blue: 82 / 255, alpha: 1))
        }
    }
    
    public lazy var cancelBtn: UIButton = {
        
        let cancelBtn = createBtn()
        cancelBtn.setTitle("撤销", for: .normal)
        return cancelBtn
    }()
    
    public lazy var doneBtn: UIButton = {
        
        let doneBtn = createBtn()
        doneBtn.setTitle("完成", for: .normal)
        return doneBtn
    }()
    
    private func createBtn() -> UIButton {
        
        let button = UIButton(type: .system)
        button.titleLabel?.font = style.button.font
        button.setTitleColor(style.button.color, for: .normal)
        addSubview(button)
        return button
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        cancelBtn.frame = CGRect(x: 8, y: 0, width: 60, height: bounds.height)
        doneBtn.frame = CGRect(x: bounds.width - 68, y: 0, width: 60, height: bounds.height)
    }
}



@objc public protocol ZSNumberFieldDelegate {
    
    func zs_numberTextFieldDidEndEditing(_ textField: ZSNumberField)
    
    @objc optional func zs_number(textField: ZSNumberField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}


open class ZSNumberField: UIView, UITextFieldDelegate {
    
    public weak var delegate: ZSNumberFieldDelegate?
    
    public var text: String? {
        set {
            textField.text = newValue
        }
        get {
            return textField.text
        }
    }
    
    public var placeholder: String? {
        set {
            textField.placeholder = newValue
        }
        get {
            return textField.placeholder
        }
    }
    
    public var attributedText: NSAttributedString? {
        set {
            textField.attributedText = newValue
        }
        get {
            return textField.attributedText
        }
    }
    
    public var textColor: UIColor? {
        set {
            textField.textColor = newValue
        }
        get {
            return textField.textColor
        }
    }
    
    public var placeholderColor: UIColor = .systemGray {
        willSet {
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "", attributes: [.foregroundColor : newValue])
        }
    }
    
    public var cursorColor: UIColor {
        set {
            textField.tintColor = newValue
        }
        get {
            return textField.tintColor
        }
    }
    
    public var font: UIFont? {
        set {
            textField.font = newValue
        }
        get {
            return textField.font
        }
    }
    
    public var textAlignment: NSTextAlignment {
        set {
            textField.textAlignment = newValue
        }
        get {
            return textField.textAlignment
        }
    }
    
    public var borderStyle: UITextField.BorderStyle {
        set {
            textField.borderStyle = newValue
        }
        get {
            return textField.borderStyle
        }
    }
    
    public var clearButtonMode: UITextField.ViewMode {
        set {
            textField.clearButtonMode = newValue
        }
        get {
            return textField.clearButtonMode
        }
    }
    
    private struct style {
        
        struct input {
            static let color: UIColor = UIColor.white.filed_dark(UIColor(red: 82 / 255, green: 82 / 255, blue: 82 / 255, alpha: 1))
        }
        
        struct field {
            static let backgroundColor: UIColor = .clear
        }
    }
    
    open lazy var zs_inputAccessoryView: ZSInputAccessoryView = {
        
        let inputAccessoryView = ZSInputAccessoryView()
        inputAccessoryView.backgroundColor = style.input.color
        inputAccessoryView.cancelBtn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        inputAccessoryView.doneBtn.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        inputAccessoryView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        return inputAccessoryView
    }()
    
    fileprivate lazy var textField: UITextField = {
        
        let textField = UITextField()
        textField.delegate = self
        textField.keyboardType = .numberPad
        textField.backgroundColor = style.field.backgroundColor
        textField.inputAccessoryView = zs_inputAccessoryView
        addSubview(textField)
        return textField
    }()
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        textField.frame = bounds
    }
    
    public func zs_becomeFirstResponder() {
        textField.becomeFirstResponder()
    }
    
    public func zs_resignFirstResponder() {
        textField.resignFirstResponder()
    }
    
    // TODO: InputAccessoryAction
    @objc private func cancelAction() {
        textField.text = ""
    }
    
    @objc private func doneAction() {
        endEditing(true)
    }
    
    // TODO: UITextFieldDelegate
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "\n" {
            
            endEditing(true)
            
            return false
        }
        
        if string == "" {
            
            return true
        }
        
        return delegate?.zs_number?(textField: self, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.zs_numberTextFieldDidEndEditing(self)
    }
}



open class ZSPhoneField: ZSNumberField {
    
    public override var text: String? {
        set {
            
            guard var value = newValue else {
                textField.text = newValue
                return
            }
            
            if value.count > 3 {
                value.insert(" ", at: value.index(value.startIndex, offsetBy: 3))
            }
            
            if value.count > 7 {
                value.insert(" ", at: value.index(value.startIndex, offsetBy: 8))
            }
            
            if value.count > 13 {
                
                let endIndex = value.index(value.startIndex, offsetBy: 13)
                
                value = String(value[..<endIndex])
            }
            
            textField.text = value
        }
        get {
            return textField.text?.replacingOccurrences(of: " ", with: "")
        }
    }
    
    func shouldDeleteBlank(range: NSRange, fieldString: String) -> Bool {
    
        guard let spaceRange = Range(range, in: fieldString) else { return false }
        
        if String(fieldString[spaceRange]) == " " {
            return true
        }
        
        let space = NSRange(location: range.location - 1, length: 1)
                   
        guard let _spaceRange_ = Range(space, in: fieldString) else { return false }
                   
        if String(fieldString[_spaceRange_]) == " " {
            return true
        }
        
        return false
    }
    
    func shouldInsertBlank(range: NSRange, fieldString: String) -> Bool {
        
        let space = NSRange(location: range.location + range.length - 1, length: 1)
        
        guard let spaceRange = Range(space, in: fieldString) else { return false }
        
        if String(fieldString[spaceRange]) == " " {
            return true
        }
        
        return false
    }

    // TODO: UITextFieldDelegate
    public override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let _ = delegate?.zs_number?(textField: self, shouldChangeCharactersIn: range, replacementString: string)

        if string == "\n" {
            
            endEditing(true)
            
            return false
        }
        
        var text: String = String(textField.text ?? "")
        
        if string == "" {

            guard range.location > 0 else { return true }
            
            if shouldDeleteBlank(range: range, fieldString: text) {
                guard let subRange = Range(NSRange(location: range.location - 1, length: range.length + 1), in: text) else { return true }
                
                text.removeSubrange(subRange)
                textField.text = text
                
                let start = textField.position(from: textField.beginningOfDocument, offset: range.location - 1)
                textField.selectedTextRange = textField.textRange(from: start!, to: start!)
                
                return false
            }

            return true
        }
        
        if (textField.text?.count ?? 0) >= 13 { return false }
        
        if let indexRange = Range(range, in: text) {
            text.replaceSubrange(indexRange, with: string)
        } else {
            text.append(string)
        }
        
        self.text = text.replacingOccurrences(of: " ", with: "")
        
        let length = range.location + string.count
        
        let offset = shouldInsertBlank(range: NSRange(location: range.location, length: string.count), fieldString: textField.text!) ? 1 : 0

        let start = textField.position(from: textField.beginningOfDocument, offset: offset + (length > 13 ? 13 : length))
        textField.selectedTextRange = textField.textRange(from: start!, to: start!)
        
        return false
    }
}


fileprivate extension UIColor {
    
    func filed_dark(_ color: UIColor) -> UIColor {
        
        if #available(iOS 13.0, *) {
            return UIColor { (traitCollection) -> UIColor in
                
                switch traitCollection.userInterfaceStyle {
                case .light:
                    return self
                case .dark:
                    return color
                default:
                    fatalError()
                }
            }
        } else {
            return self
        }
    }
}
