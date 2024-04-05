//
//  Lesson 3.swift
//  CombineLessons
//
//  Created by Андрей Коваленко on 05.04.2024.
//

import SwiftUI
import Combine

struct Lesson_3: View {
    
    @StateObject var viewModel = CancellableMiltiPiplineViewModel()
    
    var body: some View {
        VStack {
            Group {
                HStack {
                    TextField("Имя", text: $viewModel.firstName)
                        .textFieldStyle(.roundedBorder)
                    Text(viewModel.firstNameValidation)
                }
                .padding(.bottom, 8)
                HStack {
                    TextField("Фамилия", text: $viewModel.secondName)
                        .textFieldStyle(.roundedBorder)
                    Text(viewModel.secondNameValidation)
                }
                .padding(.bottom, 8)
                HStack {
                    TextField("Отчество", text: $viewModel.thirdName)
                        .textFieldStyle(.roundedBorder)
                    Text(viewModel.thirdNameValidation)
                }
                .padding(.bottom, 8)
                HStack {
                    TextField("email", text: $viewModel.email)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                    Text(viewModel.emailValidation)
                }
            }
            Text(viewModel.isAllDataValid ? "Данные заполнены верно" : "Проверьте поля на правильность заполнения")
                .foregroundStyle(viewModel.isAllDataValid ? .green : .red)
                .padding(.top, 10)
            Spacer()
            Button {
                if viewModel.isAllDataValid {
                    viewModel.cancelAllValidations()
                } else {
                    viewModel.subscribeToValidations()
                }
            } label: {
                Text("Проверить данные")
                    .foregroundStyle(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
            }
            .background(.green)
            .padding(10)
            Button {
                viewModel.cancelAllValidations()
            } label: {
                Text("Отменить Подписку")
                    .foregroundStyle(.black)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
            }
            .background(.red)
            .padding(.horizontal, 10)
        }
        .padding()
    }
}

class CancellableMiltiPiplineViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var firstNameValidation: String = ""
    
    @Published var secondName: String = ""
    @Published var secondNameValidation: String = ""
    
    @Published var thirdName: String = ""
    @Published var thirdNameValidation: String = ""
    
    @Published var email: String = ""
    @Published var emailValidation: String = ""
    
    private var validationCancellables: Set<AnyCancellable> = []
    
    @Published var isAllDataValid: Bool = false
    
    func cancelAllValidations() {
        firstNameValidation = ""
        secondNameValidation = ""
        thirdNameValidation = ""
        emailValidation = ""
        isAllDataValid = false
        validationCancellables.removeAll()
    }
    
    func subscribeToValidations() {
        $firstName
            .map { $0.isEmpty ? "❌" : "✅" }
            .sink { [weak self] value in
                self?.firstNameValidation = value
            }
            .store(in: &validationCancellables)
        
        $secondName
            .map { $0.isEmpty ? "❌" : "✅" }
            .sink { [weak self] value in
                self?.secondNameValidation = value
            }
            .store(in: &validationCancellables)
        
        $thirdName
            .map { $0.isEmpty ? "❌" : "✅" }
            .sink { [weak self] value in
                self?.thirdNameValidation = value
            }
            .store(in: &validationCancellables)
        
        $email
            .map { $0.isValidEmail() ? "✅" : "❌" }
            .sink { [weak self] value in
                self?.emailValidation = value
            }
            .store(in: &validationCancellables)
        
        Publishers.CombineLatest4($firstName, $secondName, $thirdName, $email)
            .map { firstName, secondName, thirdName, email in
                return !firstName.isEmpty && !secondName.isEmpty && !thirdName.isEmpty && email.isValidEmail()
            }
            .sink { [weak self] isValid in
                self?.isAllDataValid = isValid
            }
            .store(in: &validationCancellables)
    }
}

extension String {
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
}

#Preview {
    Lesson_3()
}
