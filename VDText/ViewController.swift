//
//  ViewController.swift
//  VDText
//
//  Created by Harwyn T'an on 2019/12/13.
//  Copyright © 2019 vvard3n. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    private let kTextViewFont = UIFont.systemFont(ofSize: 18)
    private let kTextViewTextColor = UIColor.black
    private let kHighlightBlueColor = UIColor.blue

    private weak var textEditor: VDTextEditor?

    override func viewDidLoad() {
        super.viewDidLoad()

        let editor = VDTextEditor(frame: .zero)
        textEditor = editor
        editor.placeholderFont = kTextViewFont
        editor.placeholderTextColor = UIColor(white: 0, alpha: 0.5)
        editor.placeholderText = "占位文本"
        editor.textContainerInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        editor.textColor = .black
        editor.font = kTextViewFont
        editor.backgroundColor = .systemGroupedBackground
        view.addSubview(editor)
        editor.frame = CGRect(x: 17,
                              y: 100,
                              width: UIScreen.main.bounds.width - 17 * 2,
                              height: 200)

        let addBtn = UIButton(type: .system)
        addBtn.setTitle("添加链接", for: .normal)
        addBtn.titleLabel?.font = .systemFont(ofSize: 18)
        addBtn.backgroundColor = .blue
        addBtn.setTitleColor(.white, for: .normal)
        view.addSubview(addBtn)
        addBtn.frame = CGRect(x: 17, y: editor.frame.maxY + 20, width: 88, height: 44)
        addBtn.addTarget(self, action: #selector(addBtnDidClick(_:)), for: .touchUpInside)

        let endEditingBtn = UIButton(type: .system)
        endEditingBtn.setTitle("停止输入", for: .normal)
        endEditingBtn.frame = CGRect(x: addBtn.frame.maxX + 10,
                                     y: editor.frame.maxY + 20,
                                     width: 88,
                                     height: 44)
        view.addSubview(endEditingBtn)
        endEditingBtn.addTarget(self, action: #selector(endEditingBtnDidClick(_:)), for: .touchUpInside)
    }

    @objc private func addBtnDidClick(_ sender: UIButton) {
        guard let editor = textEditor else { return }
        let attributed = editor.attributedText ?? NSAttributedString()
        let mutable = NSMutableAttributedString(attributedString: attributed)

        let replaceText = NSMutableAttributedString(string: " ")
        replaceText.vd_color = kTextViewTextColor
        replaceText.vd_font = kTextViewFont

        let displayName = NSMutableAttributedString(string: "高亮链接")
        displayName.vd_color = kHighlightBlueColor
        displayName.vd_font = kTextViewFont
        replaceText.append(displayName)

        let trailingSpace = NSMutableAttributedString(string: " ")
        trailingSpace.vd_color = kTextViewTextColor
        trailingSpace.vd_font = kTextViewFont
        replaceText.append(trailingSpace)

        replaceText.vd_setTextBinding(VDTextBinding.binding(deleteConfirm: true),
                                      range: NSRange(location: 0, length: replaceText.length))
        replaceText.vd_setTextHighlight(range: NSRange(location: 1, length: replaceText.length - 2),
                                        color: kHighlightBlueColor,
                                        backgroundColor: nil,
                                        userInfo: ["type": "url", "text": "anyText"])

        let backed = VDTextBackedString.string(with: "高亮链接")
        replaceText.vd_setTextBackedString(backed,
                                           range: NSRange(location: 0, length: replaceText.length))

        let selectedRange = editor.selectedRange
        mutable.insert(replaceText, at: selectedRange.location)
        mutable.addAttributes([
            .foregroundColor: kHighlightBlueColor,
            .font: kTextViewFont
        ], range: selectedRange)

        editor.attributedText = NSAttributedString(attributedString: mutable)
        editor.selectedRange = NSRange(location: selectedRange.location + replaceText.length, length: 0)
    }

    @objc private func endEditingBtnDidClick(_ sender: UIButton) {
        view.endEditing(true)
    }
}
