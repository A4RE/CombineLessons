//
//  AnyCancelable.swift
//  CombineLessons
//
//  Created by Андрей Коваленко on 05.04.2024.
//

import SwiftUI
import Combine

struct AnyCancelable: View {
    
    @StateObject var viewModel = FirstPiplineViewModel1()
    
    var body: some View {
        VStack {
            Spacer()
            Text(viewModel.data)
                .font(.title)
                .foregroundStyle(.green)
            Text(viewModel.status)
                .font(.title3)
                .foregroundStyle(.blue)
            Spacer()
            
            Button(action: {
                viewModel.refresh()
            }, label: {
                Text("Refresh")
                    .foregroundStyle(.black)
                    .padding(10)
            })
            .clipShape(RoundedRectangle(cornerRadius: 10), style: FillStyle())
            .background(.yellow)
            
            Button(action: {
                viewModel.cancel()
            }, label: {
                Text("Cancel")
                    .foregroundStyle(.white)
                    .padding(10)
            })
            .background(.red)
            .clipShape(RoundedRectangle(cornerRadius: 10), style: FillStyle())
            .opacity(viewModel.status == "Запрос" ? 1.0 : 0.0)
            
        }
        .padding()
    }
}

class FirstPiplineViewModel1: ObservableObject {
    @Published var data = ""
    @Published var status = ""
    
    
    private var cancelable: AnyCancellable?
    
    init() {
        cancelable = $data
            .map { [unowned self] value -> String in
                status = "Запрос"
                return value
            }
            .delay(for: 5, scheduler: DispatchQueue.main)
            .sink { [unowned self] value in
                self.data = "сумма всех счетов 2$"
                self.status = "Данные получены"
                
            }
    }
    
    func refresh() {
        data = "Перезапрос данных"
    }
    
    func cancel() {
        status = "Операция прервана"
        cancelable?.cancel()
        cancelable = nil
    }
}

#Preview {
    AnyCancelable()
}
