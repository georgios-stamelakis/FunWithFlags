//
//  NetworkMonitor.swift
//  Fun with flags
//
//  Created by Georgios Stamelakis on 23/10/24.
//

import Network

class NetworkMonitor {
    let monitor = NWPathMonitor()
    var isConnected: Bool = true

    init() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = (path.status == .satisfied)
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
}
