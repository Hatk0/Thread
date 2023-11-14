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
    private let storage: ThreadSafe<Chip>
    
    init init(storage: ThreadSafe<Chip>) {
        self.storage = storage
        super.init()
    }
    
    override func main() {
        for _ in 1...10 {
            let chip = Chip.make()
            storage.push(chip)
            sleep(2)
        }
    }
}

class WorkerThread: Thread {
    private let storage: ThreadSafe<Chip>
    
    init(storage: ThreadSafe<Chip>) {
        self.storage = storage
        super.init()
    }
    
    override func main() {
        while true {
            if let chip = storage.pop() {
                chip.sodering()
            } else {
                sleep(1)
            }
        }
    }
}
