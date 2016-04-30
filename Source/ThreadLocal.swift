/// Convenience wrapper for generically storing values of type `T` in thread-local storage.
internal final class ThreadLocal<T> {

  let key: String

  init(_ key: String) {
    self.key = key
  }

  var value: T? {
    get {
      guard let value = _currentThread.threadDictionary[key] else { return nil }
      return (value as? Box<T>).map { $0.value } ?? value as? T
    }
    set {
      _currentThread.threadDictionary[key] = (newValue as? AnyObject) ?? newValue.map(Box.init)
    }
  }

  private var _currentThread: NSThread {
#if swift(>=3.0)
    return NSThread.current()
#else
    return NSThread.currentThread()
#endif
  }

}

private class Box<T> {
  let value: T
  init(_ value: T) { self.value = value }
}

import Foundation
