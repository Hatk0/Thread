import Foundation

public class GeneratorThread: Thread {
    private let storage: ThreadSafe<Chip>

    public init(storage: ThreadSafe<Chip>) {
        self.storage = storage
        super.init()
    }

    public override func main() {
        print("Генерирующий поток начал работу.")
        for _ in 1...10 {
            let chip = Chip.make()
            storage.push(chip)
            print("Сгенерирована микросхема.")
            Thread.sleep(forTimeInterval: 2)
        }
    }
}
