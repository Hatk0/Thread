import Foundation

public class WorkerThread: Thread {
    private let storage: ThreadSafe<Chip>

    public init(storage: ThreadSafe<Chip>) {
        self.storage = storage
        super.init()
    }

    public override func main() {
        print("Рабочий поток начал работу.")
        while !isCancelled {
            storage.wait()
            if let chip = storage.pop() {
                chip.sodering()
                print("Микросхема обработана.")
            } else {
                break
            }
        }
    }
}
