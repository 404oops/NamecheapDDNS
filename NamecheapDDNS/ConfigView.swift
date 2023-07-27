//
//  ConfigView.swift
//  NamecheapDDNS
//
//  Created by Nathan on 15.7.23..
//

import SwiftUI

struct ConfigView: View {
    @EnvironmentObject var data: Hosts
    var host: Host
    @State var changedHost: Host = Host(
        label: "§",
        subdomain: "§",
        domain: "§",
        password: "§"
    )
    @State var labelEdit: Bool = false
    var body: some View {
        Text(labelEdit ? "Press enter when you finish editing" : changedHost.label )
            .font(.largeTitle)
            .multilineTextAlignment(.center)
            .padding()
        Group {
            Form {
                VStack{
                    if (labelEdit) {
                        TextField(
                            "Label",
                            text: $changedHost.label
                        )
                        .onSubmit {labelEdit.toggle()}
                    } else {
                        Button(action: {labelEdit.toggle()})
                        {
                            Image(systemName: "pencil")
                            Text("Edit Label")
                        }
                        .padding([.bottom], 10)
                    }
                    
                    HStack {
                        TextField(
                            "   " + "Domain", // Please don't ask why, merely a design choice
                            text: $changedHost.subdomain
                        ).multilineTextAlignment(.trailing)
                        TextField(".", text: $changedHost.domain)
                    }
                    SecureField(
                        "Password",
                        text: $changedHost.password
                    ).multilineTextAlignment(.center)
                }
            }
            .textFieldStyle(.roundedBorder)
            
            Text("Press the refresh button on top to refresh now")
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
        
            HStack {
                Button(action: {
                    data.removeHost(withID: host.id)
                    data.domains.append(changedHost)
                    data.saveHosts(hosts: data.domains)
                })
                {
                    Image(systemName: "square.and.arrow.down")
                    Text("Save")
                }
                Button(action: { data.removeHost(withID: host.id) })
                {
                    Image(systemName: "trash")
                    Text("Delete")
                }
            }
        }
        .frame(minWidth: 275)
        .frame(maxWidth: 350)
        .padding()
        .onAppear { changedHost = host }
    }
}
