import SwiftUI
import UIKit

/// Tastatur: „Fertig“-Leiste über jeder Tastatur (auch bei Zahlen) und Tippen daneben schließt sie.
final class KeyboardHelper: NSObject, UIGestureRecognizerDelegate {
    static let shared = KeyboardHelper()
    private var installed = false

    static func install() { shared.setup() }

    private func setup() {
        guard !installed else { return }
        installed = true
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(began(_:)), name: UITextField.textDidBeginEditingNotification, object: nil)
        nc.addObserver(self, selector: #selector(began(_:)), name: UITextView.textDidBeginEditingNotification, object: nil)
        DispatchQueue.main.async { self.addTapRecognizer() }
    }

    private func addTapRecognizer() {
        guard let window = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).flatMap(\.windows).first(where: \.isKeyWindow) else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.addTapRecognizer() }
            return
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        window.addGestureRecognizer(tap)
    }

    @objc private func tapped() { Self.dismiss() }

    static func dismiss() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    @objc private func began(_ note: Notification) {
        guard let view = note.object as? UIView else { return }
        let bar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        bar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                     UIBarButtonItem(title: "Fertig", style: .plain, target: self, action: #selector(tapped))]
        bar.sizeToFit()
        if let tf = view as? UITextField, tf.inputAccessoryView == nil { tf.inputAccessoryView = bar; tf.reloadInputViews() }
        if let tv = view as? UITextView, tv.inputAccessoryView == nil { tv.inputAccessoryView = bar; tv.reloadInputViews() }
    }

    // Taps auf Eingabefelder und Bedienelemente nicht abfangen.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        var v = touch.view
        while let cur = v {
            if cur is UITextField || cur is UITextView || cur is UIControl || cur is UIToolbar { return false }
            v = cur.superview
        }
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer) -> Bool { true }
}

extension View {
    /// Ziehen im Scrollbereich schließt die Tastatur ebenfalls.
    func keyboardFriendly() -> some View { scrollDismissesKeyboard(.interactively) }
}
