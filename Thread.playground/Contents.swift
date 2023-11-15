import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

class ThreadSafe<T> {
    private var storage = [T]()
    private let queue = DispatchQueue(label: "com.my.Thread", attributes: .concurrent)
    private let semaphore = DispatchSemaphore(value: 1)

    func push(_ item: T) {
        queue.async(flags: .barrier) {
            self.storage.append(item)
        }
    }

    func pop() -> T? {
        var item: T?
        queue.sync(flags: .barrier) {
            if !storage.isEmpty {
                item = storage.removeLast()
            }
        }
        return item
    }

    var isEmpty: Bool {
        var empty = false
        queue.sync {
            empty = storage.isEmpty
        }
        return empty
    }
}

class GeneratorThread: Thread {
    private let storage: ThreadSafe<Chip>
    private let semaphore: DispatchSemaphore

    init(storage: ThreadSafe<Chip>, semaphore: DispatchSemaphore) {
        self.storage = storage
        self.semaphore = semaphore
        super.init()
    }

    override func main() {
        print("Генерирующий поток начал работу.")
        for _ in 1...10 {
            let chip = Chip.make()
            storage.push(chip)
            print("Сгенерирована микросхема.")
            Thread.sleep(forTimeInterval: 2)
        }
        semaphore.signal()
        print("Генерирующий поток завершил работу.")
    }
}

class WorkerThread: Thread {
    private let storage: ThreadSafe<Chip>
    private let semaphore: DispatchSemaphore

    init(storage: ThreadSafe<Chip>, semaphore: DispatchSemaphore) {
        self.storage = storage
        self.semaphore = semaphore
        super.init()
    }

    override func main() {
        print("Рабочий поток начал работу.")
        semaphore.wait()
        while !storage.isEmpty {
            if let chip = storage.pop() {
                chip.sodering()
                print("Микросхема обработана.")
            }
        }
        print("Рабочий поток завершил работу.")
    }
}

