//
//  VDTextEditor.swift
//  VDText
//
//  Created by Harwyn T'an on 2019/12/13.
//  Copyright © 2019 vvard3n. All rights reserved.
//

import UIKit

// MARK: - VDTextEditorDelegate

/// `VDTextEditor` 的 delegate。
/// 同时继承 `UIScrollViewDelegate`，方便外部对内部 UITextView 滚动事件做处理。
@objc public protocol VDTextEditorDelegate: UIScrollViewDelegate {

    @objc optional func textViewShouldBeginEditing(_ textView: VDTextEditor) -> Bool
    @objc optional func textViewShouldEndEditing(_ textView: VDTextEditor) -> Bool

    @objc optional func textViewDidBeginEditing(_ textView: VDTextEditor)
    @objc optional func textViewDidEndEditing(_ textView: VDTextEditor)

    @objc optional func textView(_ textView: VDTextEditor,
                                 shouldChangeTextIn range: NSRange,
                                 replacementText text: String) -> Bool
    @objc optional func textViewDidChange(_ textView: VDTextEditor)

    @objc optional func textViewDidChangeSelection(_ textView: VDTextEditor)

    @objc(textView:shouldInteractWithURL:inRange:interaction:)
    optional func textView(_ textView: VDTextEditor,
                           shouldInteractWith URL: URL,
                           in characterRange: NSRange,
                           interaction: UITextItemInteraction) -> Bool
    @objc(textView:shouldInteractWithTextAttachment:inRange:interaction:)
    optional func textView(_ textView: VDTextEditor,
                           shouldInteractWith textAttachment: NSTextAttachment,
                           in characterRange: NSRange,
                           interaction: UITextItemInteraction) -> Bool

    @objc optional func textView(_ textView: VDTextEditor,
                                 shouldTap highlight: VDTextHighlight,
                                 in characterRange: NSRange) -> Bool
    @objc optional func textView(_ textView: VDTextEditor,
                                 didTap highlight: VDTextHighlight,
                                 in characterRange: NSRange,
                                 rect: CGRect)
    @objc optional func textView(_ textView: VDTextEditor,
                                 shouldLongPress highlight: VDTextHighlight,
                                 in characterRange: NSRange) -> Bool
    @objc optional func textView(_ textView: VDTextEditor,
                                 didLongPress highlight: VDTextHighlight,
                                 in characterRange: NSRange,
                                 rect: CGRect)
}

// MARK: - VDTextEditor

/// 带 placeholder 的文本编辑容器视图。
/// 内部以 `VDTextView` 承担实际的文本编辑能力，外层主要负责 placeholder 渲染、对外属性转发和 delegate 适配。
@objcMembers
public final class VDTextEditor: UIView {

    // MARK: - Public Delegate
    public weak var delegate: VDTextEditorDelegate?

    // MARK: - Internal Views
    /// 真正承担文本编辑能力的 textView
    public private(set) var textView: VDTextView!
    /// 占位文字的展示 label，懒加载创建
    private var placeholderLabel: UILabel?

    // MARK: - Placeholder（保持与 OC 接口一致）

    /// 历史遗留属性。原 OC 实现只保存值未实际生效，这里保持等价。
    public var placeholder: String?

    /// 历史遗留属性。原 OC 实现只保存值未实际生效，这里保持等价。
    public var placeholderColor: UIColor?

    /// 真正影响展示的 placeholder 文本
    public var placeholderText: String? {
        didSet { applyPlaceholderUpdate(reason: .text) }
    }

    /// placeholder 字体
    public var placeholderFont: UIFont? {
        didSet { applyPlaceholderUpdate(reason: .font) }
    }

    /// placeholder 颜色
    public var placeholderTextColor: UIColor? {
        didSet { applyPlaceholderUpdate(reason: .color) }
    }

    /// placeholder 富文本（带格式）
    public var placeholderAttributedText: NSAttributedString? {
        didSet { applyPlaceholderUpdate(reason: .attributed) }
    }

    /// 防止 didSet 之间互相触发
    private var isApplyingPlaceholder = false

    private enum PlaceholderUpdateReason {
        case text, font, color, attributed
    }

    // MARK: - 透传到 textView 的属性

    public var scrollEnabled: Bool = true {
        didSet { textView?.isScrollEnabled = scrollEnabled }
    }

    /// 与 OC 接口对齐：`scrollView` 实际就是内部的 textView
    public var scrollView: UIScrollView { return textView }

    public override var backgroundColor: UIColor? {
        didSet { textView?.backgroundColor = backgroundColor }
    }

    public var text: String? {
        get { return textView?.text }
        set { textView?.text = newValue ?? "" }
    }

    public var font: UIFont? {
        get { return textView?.font }
        set { textView?.font = newValue }
    }

    public var textColor: UIColor? {
        get { return textView?.textColor }
        set { textView?.textColor = newValue }
    }

    public var textAlignment: NSTextAlignment {
        get { return textView?.textAlignment ?? .natural }
        set { textView?.textAlignment = newValue }
    }

    public var selectedRange: NSRange {
        get { return textView?.selectedRange ?? NSRange(location: 0, length: 0) }
        set { textView?.selectedRange = newValue }
    }

    public var selectedTextRange: UITextRange? {
        get { return textView?.selectedTextRange }
        set { textView?.selectedTextRange = newValue }
    }

    public var isEditable: Bool {
        get { return textView?.isEditable ?? true }
        set { textView?.isEditable = newValue }
    }

    public var isSelectable: Bool {
        get { return textView?.isSelectable ?? true }
        set { textView?.isSelectable = newValue }
    }

    public var dataDetectorTypes: UIDataDetectorTypes {
        get { return textView?.dataDetectorTypes ?? [] }
        set { textView?.dataDetectorTypes = newValue }
    }

    public var allowsEditingTextAttributes: Bool {
        get { return textView?.allowsEditingTextAttributes ?? false }
        set { textView?.allowsEditingTextAttributes = newValue }
    }

    public var attributedText: NSAttributedString? {
        get { return textView?.attributedText }
        set { textView?.attributedText = newValue ?? NSAttributedString() }
    }

    public var typingAttributes: [NSAttributedString.Key: Any] {
        get { return textView?.typingAttributes ?? [:] }
        set { textView?.typingAttributes = newValue }
    }

    public override var inputView: UIView? {
        get { return textView?.inputView }
        set { textView?.inputView = newValue }
    }

    public var clearsOnInsertion: Bool {
        get { return textView?.clearsOnInsertion ?? false }
        set { textView?.clearsOnInsertion = newValue }
    }

    public var textContainer: NSTextContainer { return textView.textContainer }

    public var textContainerInset: UIEdgeInsets {
        get { return textView?.textContainerInset ?? .zero }
        set { textView?.textContainerInset = newValue }
    }

    // MARK: - Init

    public override convenience init(frame: CGRect) {
        self.init(frame: frame, textContainer: nil)
    }

    public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame)
        commonInit(textContainer: textContainer)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit(textContainer: nil)
    }

    private func commonInit(textContainer: NSTextContainer?) {
        let tv = VDTextView(frame: bounds, textContainer: textContainer)
        tv.delegate = self
        tv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(tv)
        textView = tv

        tv.addObserver(self, forKeyPath: Self.kSelectedTextRangeKey, options: [.new, .old], context: nil)
        tv.addObserver(self, forKeyPath: Self.kAttributedTextKey, options: [.new], context: nil)
    }

    deinit {
        // UIView 的生命周期都在主线程，KVO 注销在主线程也是必须的。
        // 直接捕获 textView 弱引用，避开 main-actor 隔离的 self 访问。
        let observed = textView
        MainActor.assumeIsolated {
            observed?.removeObserver(self, forKeyPath: Self.kSelectedTextRangeKey)
            observed?.removeObserver(self, forKeyPath: Self.kAttributedTextKey)
        }
    }

    // MARK: - First responder & methods

    public override func becomeFirstResponder() -> Bool {
        return textView?.becomeFirstResponder() ?? false
    }

    public func scrollRangeToVisible(_ range: NSRange) {
        textView?.scrollRangeToVisible(range)
    }

    public func caretRect(for position: UITextPosition) -> CGRect {
        return textView?.caretRect(for: position) ?? .zero
    }

    // MARK: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()
        textView.frame = bounds

        guard let label = placeholderLabel else { return }
        let inset = textView.textContainerInset
        let availableWidth = bounds.width - inset.left - inset.right
        let fitting = label.sizeThatFits(CGSize(width: availableWidth, height: .greatestFiniteMagnitude))
        label.frame = CGRect(x: bounds.origin.x + 3 + inset.left,
                             y: bounds.origin.y + inset.top,
                             width: fitting.width,
                             height: fitting.height).integral
    }

    // MARK: - Placeholder 同步逻辑

    /// 任一 placeholder 属性变更时，按需在 4 个属性之间双向同步，并最终刷新 placeholder 视图。
    private func applyPlaceholderUpdate(reason: PlaceholderUpdateReason) {
        guard !isApplyingPlaceholder else { return }
        isApplyingPlaceholder = true
        defer { isApplyingPlaceholder = false }

        switch reason {
        case .text:
            syncFromText()
        case .font:
            syncFromFont()
        case .color:
            syncFromColor()
        case .attributed:
            syncFromAttributed()
        }

        commitPlaceholderUpdate()
    }

    private func syncFromText() {
        if let existing = placeholderAttributedText as? NSMutableAttributedString, existing.length > 0 {
            let replacement = placeholderText ?? ""
            existing.replaceCharacters(in: NSRange(location: 0, length: existing.length), with: replacement)
            if let font = placeholderFont { existing.vd_font = font }
            if let color = placeholderTextColor { existing.vd_color = color }
        } else if let text = placeholderText, !text.isEmpty {
            let attr = NSMutableAttributedString(string: text)
            if let font = placeholderFont { attr.vd_font = font }
            if let color = placeholderTextColor { attr.vd_color = color }
            placeholderAttributedText = attr
        }
    }

    private func syncFromFont() {
        if let mutable = placeholderAttributedText as? NSMutableAttributedString {
            mutable.vd_font = placeholderFont
        }
    }

    private func syncFromColor() {
        if let mutable = placeholderAttributedText as? NSMutableAttributedString {
            mutable.vd_color = placeholderTextColor
        }
    }

    private func syncFromAttributed() {
        if let attr = placeholderAttributedText {
            let mutable = NSMutableAttributedString(attributedString: attr)
            placeholderAttributedText = mutable
            placeholderText = mutable.vd_plainText(for: NSRange(location: 0, length: mutable.length))
            placeholderFont = mutable.vd_font
            placeholderTextColor = mutable.vd_color
        } else {
            placeholderText = nil
        }
    }

    // MARK: - Placeholder rendering

    private func commitPlaceholderUpdate() {
        updatePlaceholder()
    }

    private func updatePlaceholder() {
        let label = ensurePlaceholderLabel()
        if let attr = placeholderAttributedText, attr.length > 0 {
            label.attributedText = attr
        } else {
            label.attributedText = nil
        }
        // 即便 textView 的文本是先于 placeholder 设置好的，这里也要根据 textView 当前内容初始化 isHidden，
        // 否则 placeholder 可能错误地覆盖在已有文本之上。
        label.isHidden = (textView.attributedText?.length ?? 0) > 0
        // 真正的尺寸计算交给 layoutSubviews 统一处理，避免在 didSet 链中触发同步布局。
        setNeedsLayout()
    }

    private func ensurePlaceholderLabel() -> UILabel {
        if let label = placeholderLabel { return label }
        let label = UILabel()
        label.textColor = UIColor.vd_color(hexString: "333131")
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        let inset = textView.textContainerInset
        label.frame = CGRect(x: bounds.origin.x + 3 + inset.left,
                             y: bounds.origin.y + inset.top,
                             width: bounds.width - inset.left - inset.right,
                             height: 0)
        label.autoresizingMask = .flexibleWidth
        if let attr = placeholderAttributedText {
            label.attributedText = attr
        }
        // 将 placeholder 加在 self（VDTextEditor）上而不是 textView 上：
        // 1) 避免被 UITextView 内部子视图层级（光标 / 选择高亮等）干扰；
        // 2) 避免随 textView 内容滚动一同移动（placeholder 在内容为空时显示，本来就不需要滚动）；
        // 3) self.bounds 与 textView.frame 一致，原来的坐标计算可以原样保留。
        addSubview(label)
        placeholderLabel = label
        return label
    }

    // MARK: - KVO

    /// KVO 监听的 keyPath。声明为 `nonisolated static`：
    /// - `static` 是为了让 `deinit`（nonisolated 上下文）也能引用到同一份字符串，避免与 `addObserver` 时使用的字面量不一致；
    /// - `nonisolated` 是因为这些常量本身是值类型字符串，不依赖 MainActor。
    private nonisolated static let kSelectedTextRangeKey = "selectedTextRange"
    private nonisolated static let kAttributedTextKey = "attributedText"

    public override func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey: Any]?,
                                      context: UnsafeMutableRawPointer?) {
        // KVO 回调发生在被观察者属性变更的线程上。
        // UITextView 的 selectedTextRange / attributedText 变更都在主线程上。
        // 这里先在 nonisolated 上下文中把所需信息解出为 sendable 局部量，
        // 再通过 MainActor.assumeIsolated 进入主线程执行业务逻辑。
        let isAttributedTextChange = (keyPath == Self.kAttributedTextKey)
        let isSelectedRangeChange = (keyPath == Self.kSelectedTextRangeKey)

        // 把字典值预先转成可发送的局部量（UITextRange 是 OC reference type，跨上下文传引用是安全的，
        // 但 Swift 6 严格并发会拒绝直接传 [Key: Any] 字典。这里用 Unmanaged 中转避免误判）。
        let newRangeRef: Unmanaged<UITextRange>? = (change?[.newKey] as? UITextRange).map { Unmanaged.passUnretained($0) }
        let oldRangeRef: Unmanaged<UITextRange>? = (change?[.oldKey] as? UITextRange).map { Unmanaged.passUnretained($0) }

        MainActor.assumeIsolated {
            if isAttributedTextChange {
                placeholderLabel?.isHidden = (textView.attributedText?.length ?? 0) > 0
            } else if isSelectedRangeChange {
                textView.resetDelConform()
                let newRange = convertSelectedTextRange(newRangeRef?.takeUnretainedValue())
                let oldRange = convertSelectedTextRange(oldRangeRef?.takeUnretainedValue())
                guard newRange.location != oldRange.location else { return }
                constrainCaretOutsideBinding(newRange: newRange)
            }
        }
    }

    /// 当光标落入 binding 段内部时，将其推到 binding 段的边界
    private func constrainCaretOutsideBinding(newRange: NSRange) {
        guard let attributed = textView.attributedText, attributed.length > 0 else { return }

        let fullRange = NSRange(location: 0, length: attributed.length)
        attributed.enumerateAttribute(.vdTextBinding,
                                      in: fullRange,
                                      options: [.reverse]) { value, range, _ in
            guard value != nil else { return }
            let leftHit = newRange.location > range.location && newRange.location < range.location + range.length
            let rightEnd = newRange.location + newRange.length
            let rightHit = rightEnd < range.location + range.length && rightEnd > range.location

            guard leftHit || rightHit else { return }

            var leftLocation = newRange.location
            var rightLocation = newRange.location + newRange.length
            if leftHit {
                let midpoint = range.location + range.length / 2
                leftLocation = newRange.location > midpoint ? range.location + range.length : range.location
            }
            if rightHit {
                let midpoint = range.location + range.length / 2
                rightLocation = rightEnd > midpoint ? range.location + range.length : range.location
            }
            textView.selectedRange = NSRange(location: leftLocation, length: rightLocation - leftLocation)
        }
    }

    private func convertSelectedTextRange(_ range: UITextRange?) -> NSRange {
        guard let range = range, let tv = textView else { return NSRange(location: 0, length: 0) }
        let beginning = tv.beginningOfDocument
        let location = tv.offset(from: beginning, to: range.start)
        let length = tv.offset(from: range.start, to: range.end)
        return NSRange(location: location, length: length)
    }
}

// MARK: - UITextViewDelegate

extension VDTextEditor: UITextViewDelegate {

    public func textViewDidChange(_ textView: UITextView) {
        if textView === self.textView {
            placeholderLabel?.isHidden = (textView.attributedText?.length ?? 0) > 0
        }
        delegate?.textViewDidChange?(self)
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.textViewDidEndEditing?(self)
    }

    public func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.textViewDidBeginEditing?(self)
    }

    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return delegate?.textViewShouldEndEditing?(self) ?? true
    }

    public func textViewDidChangeSelection(_ textView: UITextView) {
        delegate?.textViewDidChangeSelection?(self)
    }

    public func textView(_ textView: UITextView,
                         shouldChangeTextIn range: NSRange,
                         replacementText text: String) -> Bool {
        return delegate?.textView?(self, shouldChangeTextIn: range, replacementText: text) ?? true
    }

    public func textView(_ textView: UITextView,
                         shouldInteractWith URL: URL,
                         in characterRange: NSRange,
                         interaction: UITextItemInteraction) -> Bool {
        return delegate?.textView?(self, shouldInteractWith: URL, in: characterRange, interaction: interaction) ?? true
    }

    public func textView(_ textView: UITextView,
                         shouldInteractWith textAttachment: NSTextAttachment,
                         in characterRange: NSRange,
                         interaction: UITextItemInteraction) -> Bool {
        return delegate?.textView?(self, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction) ?? true
    }

    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return delegate?.textViewShouldBeginEditing?(self) ?? true
    }
}

// MARK: - UIScrollViewDelegate 透传
// UIScrollViewDelegate 的方法通过 `delegate` 直接转发给外部观察者

extension VDTextEditor {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll?(scrollView)
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.scrollViewWillBeginDragging?(scrollView)
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                          withVelocity velocity: CGPoint,
                                          targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.scrollViewWillEndDragging?(scrollView,
                                              withVelocity: velocity,
                                              targetContentOffset: targetContentOffset)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }

    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        delegate?.scrollViewWillBeginDecelerating?(scrollView)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidEndDecelerating?(scrollView)
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }

    // 说明：UITextView 内部 scrollView 不支持缩放，因此 zoom 相关回调
    // (viewForZooming / scrollViewWillBeginZooming / scrollViewDidEndZooming / scrollViewDidZoom)
    // 不会被 UIKit 触发。外部 delegate 若需要 zoom 行为也只能用于普通 UIScrollView，
    // 故此处不再做空转发。

    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return delegate?.scrollViewShouldScrollToTop?(scrollView) ?? true
    }

    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScrollToTop?(scrollView)
    }
}
