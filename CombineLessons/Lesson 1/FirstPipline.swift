//
//  FirstPipline.swift
//  CombineLessons
//
//  Created by Андрей Коваленко on 05.04.2024.
//

import SwiftUI
import Combine

struct FirstPipline: View {
    
    @StateObject var viewModel = FirstPiplineViewModel()
    
    var body: some View {
        VStack {
            FormTextField(placeholder: "Ваше имя", text: $viewModel.name, validation: $viewModel.nameValidation)
            FormTextField(placeholder: "Ваша фамилия", text: $viewModel.surname, validation: $viewModel.surnameValidation)
            FormTextField(placeholder: "Ваша почта", text: $viewModel.email, validation: $viewModel.emailValidation)
        }
        .padding()
    }
}


struct FormTextField: View {
    @State var placeholder: String
    @Binding var text: String
    @Binding var validation: String
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .textFieldStyle(.roundedBorder)
            Text(validation)
        }
    }
}

class FirstPiplineViewModel: ObservableObject {
    @Published var name = ""
    @Published var surname = ""
    @Published var email = ""
    @Published var nameValidation = ""
    @Published var surnameValidation = ""
    @Published var emailValidation = ""
    
    init() {
        $name
            .map { $0.isEmpty ? "X" : "Y" }
            .assign(to: &$nameValidation)
        
        $surname
            .map { $0.isEmpty ? "X" : "Y" }
            .assign(to: &$surnameValidation)
        
        $email
            .map { $0.contains("@") ? "Y" : "X" }
            .assign(to: &$emailValidation)
    }
}
