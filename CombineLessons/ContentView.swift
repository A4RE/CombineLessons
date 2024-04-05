//
//  ContentView.swift
//  CombineLessons
//
//  Created by Андрей Коваленко on 05.04.2024.
//

import SwiftUI


struct ContentView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: FirstPipline()) {
                    Text("First Lesson")
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
