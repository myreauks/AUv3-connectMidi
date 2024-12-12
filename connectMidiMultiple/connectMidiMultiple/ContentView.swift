//
//  ContentView.swift
//  connectMidiMultiple
//
//  Created by Miro on 12.12.2024.
//

import AudioToolbox
import SwiftUI

struct ContentView: View {
    
    @State var engine = playerEngine()
    
    @GestureState private var dragActive: Bool = false
    @State var opacity = 0.75
    
    var body: some View {
        VStack() {
            Circle()
                .fill(.orange.opacity(opacity))
                .frame(width: 120)
                .overlay() {
                    Text("Send Note")
                }
                .gesture(DragGesture(minimumDistance: 0)
                    .updating($dragActive) { value, state, transaction in
                        state = true
                    }
                )
                .onChange(of: dragActive) {
                    self.opacity = (dragActive == true) ? 1.0 : 0.75
                    if dragActive == true {
                        engine.sendNote()
                        
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
