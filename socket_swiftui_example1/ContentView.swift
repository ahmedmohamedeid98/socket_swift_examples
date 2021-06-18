//
//  ContentView.swift
//  socket_swiftui_example1
//
//  Created by Ahmed Eid on 6/18/21.
//

import SwiftUI
import SocketIO


final class Service: ObservableObject {
    private var manager = SocketManager(socketURL: URL(string: "ws://localhost:3000")! , config: [.log(true), .compress])
    
    
    @Published var messages = [String]()
    
    init() {
        let socket = manager.defaultSocket
        socket.on(clientEvent: .connect) { (data, akw) in
            socket.emit("NodeJs Server Port", "Hi from IOS")
        }
        
        socket.on("IOS Client Port") { [weak self] (data, akw) in
            if let data = data[0] as? [String: String] ,
               let rawMessage = data["msg"] {
                DispatchQueue.main.async {
                    self?.messages.append(rawMessage)
                }
            }
        }
        socket.connect()
    }
}

struct ContentView: View {
    @ObservedObject var service = Service()
    
    var body: some View {
        VStack {
            Text("Recive messages from Node.js").font(.largeTitle)
            ForEach(service.messages, id: \.self) { msg in
                Text(msg).padding()
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
