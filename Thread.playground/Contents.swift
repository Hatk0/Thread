import Foundation

let chipStorage = ThreadSafe<Chip>()

let generatorThread = GeneratorThread(storage: chipStorage)
let workerThread = WorkerThread(storage: chipStorage)

generatorThread.start()
workerThread.start()

DispatchQueue.global().asyncAfter(deadline: .now() + 24) {
    generatorThread.cancel()
    workerThread.cancel()
    print("Генерирующий и рабочий потоки завершили работу.")
}
