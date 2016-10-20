import ReactiveSwift
import UIKit
import enum Result.NoError

extension Reactive where Base: UIGestureRecognizer {
	
	/// Create a signal which sends a `next` event for each gesture event
	///
	/// - returns:
	///   A trigger signal.
	
	public func trigger() -> Signal<(), NoError> {
		return Signal { observer in
			let receiver = CocoaTarget(observer)
			base.addTarget(receiver, action: #selector(receiver.sendNext))
			
			let disposable = lifetime.ended.observeCompleted(observer.sendCompleted)
			
			return ActionDisposable { [weak base = self.base] in
				disposable?.dispose()
				base?.removeTarget(receiver, action: #selector(receiver.sendNext))
			}
		}
	}
}
