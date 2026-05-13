//
//  VDTextView.swift
//  VDText
//
//  Created by Harwyn T'an on 2019/12/12.
//  Copyright © 2020 vvard3n. All rights reserved.
//

import UIKit

/// 自定义 `UITextView`，主要扩展了 `deleteBackward` 行为：
/// 当光标前一个字符带有 `VDTextBinding` 属性时，删除操作会按"先确认、再整体删除"的方式处理整段 binding 文本。
@objcMembers
public final class VDTextView: UITextView {

    // MARK: - Public

    /// 重置"删除确认"标记。
    ///
    /// `VDTextEditor` 在监听到光标移动时会调用，避免上一次的"待确认删除"状态影响下一次操作。
    public func resetDelConform() {
        delConform = false
    }

    // MARK: - Private state

    private var preSelectedRange: NSRange = NSRange(location: 0, length: 0)
    private var delConform: Bool = false

    // MARK: - Init

    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Overrides

    public override var text: String! {
        didSet {
            // 与原 OC 行为保持一致：text 变更后请求一次重绘
            setNeedsDisplay()
        }
    }

    public override var font: UIFont? {
        didSet {
            setNeedsDisplay()
        }
    }

    public override func becomeFirstResponder() -> Bool {
        delConform = false
        return super.becomeFirstResponder()
    }

    public override func resignFirstResponder() -> Bool {
        delConform = false
        return super.resignFirstResponder()
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delConform = false
        super.touchesBegan(touches, with: event)
    }

    /// 处理删除：当光标前一个字符位于一段 `VDTextBinding` 内时，
    /// 第一次按删除会"选中"该 binding 段并把 `delConform` 置 true，
    /// 第二次按删除才真正移除整段 binding。
    public override func deleteBackward() {
        let attributed = attributedText ?? NSAttributedString()
        let selected = selectedRange

        if selected.location == 0 {
            super.deleteBackward()
            return
        }

        var effectiveRange = NSRange(location: 0, length: 0)
        let bindingValue = attributed.attribute(.vdTextBinding,
                                                at: selected.location - 1,
                                                longestEffectiveRange: &effectiveRange,
                                                in: NSRange(location: 0, length: attributed.length))

        guard let _ = bindingValue as? VDTextBinding else {
            delConform = false
            super.deleteBackward()
            return
        }

        let mutable = NSMutableAttributedString(attributedString: attributed)
        preSelectedRange = selected

        // 当前有选区：直接删除选区，恢复 caret
        if selected.length > 0 {
            delConform = false
            mutable.replaceCharacters(in: selected, with: "")
            attributedText = mutable
            preSelectedRange = NSRange(location: preSelectedRange.location, length: 0)
            selectedRange = preSelectedRange
            delegate?.textViewDidChange?(self)
            return
        }

        // 当前是 caret，且位于 binding 内：第一次只把整段 binding "选中"，第二次才真正删除
        if !delConform {
            delConform = true
            preSelectedRange = effectiveRange
        } else {
            delConform = false
            mutable.replaceCharacters(in: effectiveRange, with: "")
            preSelectedRange = NSRange(location: effectiveRange.location, length: 0)
            attributedText = mutable
        }

        selectedRange = preSelectedRange
    }
}
