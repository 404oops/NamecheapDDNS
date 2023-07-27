//
//  EntryView.swift
//  NamecheapDDNS
//
//  Created by Nathan on 19.7.23..
//

import SwiftUI

struct EntryView: View {
    var body: some View {
        VStack{
            homeView(title: "Welcome to NamecheapDDNS", subtitle: "Press the + button on the toolbar to create a new host", caption: "Made with <3 by 404oops")
        }
    }
}

struct homeView: View {
    var title : String
    var subtitle : String
    var caption : String
    var body: some View {
        VStack {
            Text(title)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding([.bottom], 1)
            Text(subtitle)
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding([.bottom], 7)
            Text(caption)
        }
        .frame(width: 400)
        .padding(50)
    }
}
#Preview {
    EntryView()
}
