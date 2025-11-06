import Foundation
import Network

/// NetworkMonitor tracks network connectivity status using NWPathMonitor
class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "com.demeter.network.monitor")
    
    private(set) var isConnected: Bool = true
    var onStatusChange: ((Bool) -> Void)?
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            let isConnected = path.status == .satisfied
            self?.isConnected = isConnected
            self?.onStatusChange?(isConnected)
        }
        
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
}