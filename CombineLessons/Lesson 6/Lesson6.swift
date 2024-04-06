//
//  Lesson6.swift
//  CombineLessons
//
//  Created by Андрей Коваленко on 06.04.2024.
//

import SwiftUI
import Combine

struct Lesson6: View {
    
    @StateObject var viewModel = FailurePublisherViewModel()
    
    var body: some View {
        VStack {
            Text("\(viewModel.age)")
                .font(.title)
                .foregroundStyle(.green)
                .padding()
            TextField("Введите возраст", text: $viewModel.text)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .padding()
            Spacer()
            Button {
                viewModel.save()
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.green)
                    .overlay(alignment: .center) {
                        Text("Сохранить")
                            .font(.title3)
                            .foregroundStyle(.black)
                    }
                    .frame(height: 52)
                    .padding(.horizontal, 16)
            }
            .alert(item: $viewModel.error) { error in
                Alert(title: Text("Ошибка"), message: Text(error.rawValue), dismissButton: .cancel())
            }

        }
    }
}

enum InvalidAgeError: String, Error, Identifiable {
    var id: String { rawValue }
    case lessZero = "Значение не может быть меньше 0 "
    case moreHundred = "Значение не может быть больше 100"
}

class FailurePublisherViewModel: ObservableObject {
    @Published var text = ""
    @Published var age = 0
    @Published var error: InvalidAgeError?
    
    func save() {
        _ = ageValidation(age: Int(text) ?? -1)
            .sink { [unowned self] complition in
                switch complition {
                case .failure(let error):
                    self.error = error
                case .finished:
                    break
                }
            } receiveValue: { [unowned self] value in
                self.age = value
            }
    }
    
    func ageValidation(age: Int) -> AnyPublisher<Int, InvalidAgeError> {
        if age < 0 {
            return Fail(error: InvalidAgeError.lessZero).eraseToAnyPublisher()
        } else if age > 100 {
            return Fail(error: InvalidAgeError.moreHundred).eraseToAnyPublisher()
        } else {
            return Just(age)
                .setFailureType(to: InvalidAgeError.self)
                .eraseToAnyPublisher()
        }
    }
    
}

#Preview {
    Lesson6()
}
