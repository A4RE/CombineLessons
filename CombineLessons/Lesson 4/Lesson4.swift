//
//  Lesson4.swift
//  CombineLessons
//
//  Created by Андрей Коваленко on 06.04.2024.
//

import SwiftUI
import Combine

struct Lesson4: View {
    
    @StateObject var viewModel = CurrentValueSubjectViewModel()
    
    var body: some View {
        VStack {
            Text("\(viewModel.selectionSame.value ? "Выбрали 2 раза" : "") \(viewModel.selection.value)")
                .foregroundStyle(viewModel.selectionSame.value ? .red : .green)
            Button("Картошка") {
                viewModel.selection.value = "Картошка"
            }
            .padding()
            Button("Cola") {
                viewModel.selection.send("Cola")
            }
            .padding()
        }
    }
}

class CurrentValueSubjectViewModel: ObservableObject {
    
//    @Published var selection: String = "Корзина пуста"
//    @Published var selectionSame: Bool = false
    
    var selection = CurrentValueSubject<String, Never>("Корзина пуста")
    var selectionSame = CurrentValueSubject<Bool, Never>(false)
    
    var cancellable: Set<AnyCancellable> = []
    
    init() {
//        $selection
//            .map { [unowned self] newValue -> Bool in
//                if newValue == selection {
//                    return true
//                } else {
//                    return false
//                }
//            }
//            .sink { [unowned self] value in
//                selectionSame = value
//            }
//            .store(in: &cancellable)
        
        selection
            .map { [unowned self] newValue -> Bool in
                if newValue == selection.value {
                    return true
                } else {
                    return false
                }
            }
            .sink { [unowned self] value in
                selectionSame.value = value
                objectWillChange.send()
            }
            .store(in: &cancellable)
        
    }
}

#Preview {
    Lesson4()
}
