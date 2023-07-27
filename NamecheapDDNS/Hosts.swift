//
//  Hosts.swift
//  NamecheapDDNS
//
//  Created by Nathan on 17.7.23..
//

import Foundation
import SwiftUI

class Hosts: ObservableObject {
    @Published var domains: [Host] = []

    func removeHost(withID id: UUID) {
        domains.removeAll { $0.id == id }
    }
    
    func serializeHost(host: Host) -> Dictionary<String, String> {
        let toret = [
            "label": host.label,
            "subdomain": host.subdomain,
            "domain": host.domain,
            "password": host.password,
            "order": String(host.order)
        ] as [String : String]
        return toret
    }
    
    func deserializeHost(host: Dictionary<String, String>) -> Host {
        return Host(
            label: host["label"]!,
            subdomain: host["subdomain"]!,
            domain: host["domain"]!,
            password: host["password"]!,
            order: Double(host["order"]!)!
        )
    }
    func saveHosts(hosts: [Host]) {
        var myArray: [[String: String]] = []
        hosts.forEach { host in
            myArray.append(
                serializeHost(host: host)
            )
        }
        do {
            UserDefaults.standard.set(
                try JSONSerialization.data(
                    withJSONObject: myArray,
                    options: []
                ),
                forKey: "AllHosts"
            )
        } catch {print("failed :trole:")}
    }
    func loadHosts(){
        do {
            guard let jsonData = UserDefaults.standard.data(forKey: "AllHosts")
            else {
                print("No data found for key 'myArrayData'")
                return
            }

            guard let loadedArray = try JSONSerialization.jsonObject(
                with: jsonData,
                options: []
            ) as? [[String: String]]
            else {
                print("Failed to convert UserDefaults data back to [[String: Any]]")
                return
            }
            loadedArray.forEach { host in
                let newHost = deserializeHost(host: host)
                if !domains.contains(
                    where: { $0.order == newHost.order }
                )
                {domains.append(newHost)}
            }
        } catch {
            print("Failed to load JSON data: \(error.localizedDescription)")
        }
    }
}

struct Host: Identifiable, Codable {
    var label: String
    var subdomain: String
    var domain: String
    var password: String
    var order = Date().timeIntervalSince1970
    var id = UUID()
}
