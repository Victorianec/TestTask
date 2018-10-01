import UIKit

protocol ErrorDisplayable: UIAccessibilityIdentification {
    var error: Error? { get set }
}
