//
//  ContentView.swift
//  NamecheapDDNS
//
//  Created by Nathan on 15.7.23..
//

import SwiftUI

struct ContentView: View {
    @StateObject var data = Hosts()
    @State private var angle: Double = 0.0
    private let animationDuration: Double = 0.2
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    "About",
                    destination: EntryView()
                )
                Section(header: Text("Domains")) {
                    ForEach(
                        data.domains.sorted(by: { $0.order < $1.order })
                    ) { domain in
                        NavigationLink(
                            domain.label,
                            destination: ConfigView(host: domain)
                        )
                    }
                    .onDelete { indexSet in
                        data.domains.remove(atOffsets: indexSet)
                    }
                }
            }
            .navigationTitle("Namecheap DDNS")
            .toolbar {
                ToolbarItem {
                    Button(
                        action: toggleSidebar,
                        label: {
                            Image(systemName: "sidebar.left")
                        }
                    )
                }
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        data.domains.append(
                            Host(
                                label: "New Host",
                                subdomain: "subdomain",
                                domain: "example.com",
                                password: "IThankKotaAndJacob<3"
                            )
                        )
                    }
                )
                {Image(systemName: "plus")}}
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        withAnimation(.spring(duration: animationDuration)) {
                            angle += 360.0
                            data.saveHosts(hosts: data.domains)
                            
                            data.domains.forEach { host in
                                URLSession.shared.dataTask(with: URL(string: "https://dynamicdns.park-your-domain.com/update?host=\(host.subdomain)&domain=\(host.domain)&password=\(host.password)")!).resume()
                            }
                        }
                    }, label: {
                        Image(systemName: "arrow.clockwise")
                            .rotationEffect(.degrees(angle))
                    }
                    )
                }
            }.environmentObject(data)
            EntryView()
        }.onAppear { data.loadHosts() }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Hosts())
    }
}

func toggleSidebar() {
    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
}
