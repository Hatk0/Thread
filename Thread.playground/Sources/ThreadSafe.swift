import Foundation

public class ThreadSafe<T> {
    private var storage = [T]()
    private let queue = DispatchQueue(label: "com.my.Thread")
    private let semaphore = DispatchSemaphore(value: 0)

    public init() {

    }

    func push(_ item: T) {
        queue.async(flags: .barrier) {
            self.storage.append(item)
            self.semaphore.signal()
        }
    }

    func pop() -> T? {
        var item: T?
        queue.sync {
            if !storage.isEmpty {
                item = storage.removeLast()
            }
        }
        return item
    }

    func wait() {
        semaphore.wait()
    }

    var isEmpty: Bool {
        var empty = false
        queue.sync {
            empty = storage.isEmpty
        }
        return empty
    }
}
