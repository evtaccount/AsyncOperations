import Foundation


// MARK: - AsyncOperation

class AsyncOperation: Operation {
    // MARK: Properties

    var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }

    func finish() {
        self.state = .finished
    }
}


// MARK: - Overrides

extension AsyncOperation {
    override var isAsynchronous: Bool { true }
    override var isReady: Bool        { super.isReady && state == .ready }
    override var isExecuting: Bool    { state == .executing }
    override var isFinished: Bool     { state == .finished }

    override func start() {
        if isFinished {
            return
        }
        
        if isCancelled {
            state = .finished
            return
        }
        main()
        state = .executing
    }
    
    override func cancel() {
        state = .finished
    }
}

// MARK: - Operation state

extension AsyncOperation {
    enum State: String {
        case ready
        case executing
        case finished
        
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
}
