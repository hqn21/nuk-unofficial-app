//
//  InformationViewModel.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/9/14.
//

import Foundation

class InformationViewModel: ObservableObject {
    @Published var showAlert: Bool = false
    @Published var alertMessage: String? = nil {
        didSet {
            if alertMessage != nil {
                showAlert = true
            }
        }
    }
}
