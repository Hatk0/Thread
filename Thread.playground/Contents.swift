import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

class ThreadSafe<T> {
    private var storage = [T]()
    private let queue = DispatchQueue(label: "com.my.Thread")
    
    func push(_ item: T) {
        queue.sync {
            storage.append(item)
        }
    }
    
    func pop() -> T? {
        return queue.sync {
            storage.popLast()
        }
    }
    
    var isEmpty: Bool {
        return queue.sync {
            storage.isEmpty
        }
    }
}

class GeneratorThread: Thread {
    
}

class WorkerThread: Thread {
    
}
