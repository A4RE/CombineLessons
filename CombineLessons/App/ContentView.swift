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
                    Text("1 Lesson")
                }
                NavigationLink(destination: AnyCancelable()) {
                    Text("2 Lesson")
                }
                NavigationLink(destination: Lesson_3()) {
                    Text("3 Lesson")
                }
                NavigationLink(destination: Lesson4()) {
                    Text("4 Lesson")
                }
                NavigationLink(destination: Lesson5()) {
                    Text("5 Lesson")
                }
                NavigationLink(destination: Lesson6()) {
                    Text("6 Lesson")
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
