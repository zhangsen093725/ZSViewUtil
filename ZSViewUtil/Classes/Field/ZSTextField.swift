//
//  ZSTextFiled.swift
//  Pods-ZSViewUtil_Example
//
//  Created by 张森 on 2020/1/15.
//

import UIKit

open class ZSTextField: UIView, UITextFieldDelegate {
    
    public var text: String? {
        set {
            textField.text = zs_filedText(from: newValue ?? "")
        }
        get {
            return originText
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
    
    public var keyboardType: UIKeyboardType {
        set {
            textField.keyboardType = newValue
        }
        get {
            return textField.keyboardType
        }
    }
    
    public var replaceVisibleText: String = "*" {
        didSet {
            text = originText
        }
    }
    
    public var isVisibleText: Bool = true {
        didSet {
            text = originText
        }
    }
    
    private var originText: String = ""
    
    lazy var textField: UITextField = {
        return zs_configField()
    }()
    
    open func zs_filedText(from newValue: String) -> String {
        originText = newValue
        let count = originText.count
        return isVisibleText ? originText : String( repeating: replaceVisibleText, count: count)
    }
    
    open func zs_configField() -> UITextField {
        
        let textField = UITextField()
        textField.delegate = self
        textField.backgroundColor = .clear
        addSubview(textField)
        return textField
    }
    
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

    open func zs_textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    open func zs_textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    // TODO: UITextFieldDelegate
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let isShouldReplace = zs_textField(textField, shouldChangeCharactersIn: range, replacementString: string)
        
        guard isShouldReplace else { return false }
        
        var text: String = String(originText)
        
        if let indexRange = Range(range, in: text) {
            text.replaceSubrange(indexRange, with: string)
        } else {
            text.append(string)
        }
        
        self.text = text
        
        let length = range.location + string.count
        let start = textField.position(from: textField.beginningOfDocument, offset: length)
        textField.selectedTextRange = textField.textRange(from: start!, to: start!)
        return false
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        zs_textFieldDidEndEditing(textField)
    }
}
