//
//  Lesson5.swift
//  CombineLessons
//
//  Created by Андрей Коваленко on 06.04.2024.
//

import SwiftUI
import Combine

struct Lesson5: View {
    
    @StateObject var viewModel = EmptyFailurePublisherViewModel()
    
    var body: some View {
        VStack (spacing: 20) {
            List(viewModel.dataToView, id: \.self) { item in
                Text(item)
            }
            .font(.title)
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
}

class EmptyFailurePublisherViewModel: ObservableObject {
    @Published var dataToView = [String]()
    
    let data = ["Value 1", "Value 2", "Value 3", nil, "Value 5", "Value 6"]
    
    func fetchData() {
        _ = data.publisher
            .flatMap { item -> AnyPublisher<String, Never> in
                if let item = item {
                    return Just(item)
                        .eraseToAnyPublisher()
                } else {
                    return Empty(completeImmediately: true)
                        .eraseToAnyPublisher()
                }
                
            }
            .sink { [unowned self] item in
                dataToView.append(item)
            }
    }
}

#Preview {
    Lesson5()
}
