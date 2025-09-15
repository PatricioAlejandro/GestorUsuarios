//
//  UserFormView.swift
//  GestorUsuarios
//
//  Created by Patricio Chavez on 15/9/25.
//

import SwiftUI
import CoreLocation

struct UserFormView: View {
    @StateObject var viewModel: UserFormViewModel
    @State private var showCoord = false

    var body: some View {
        Form {
            Section("Data") {
                TextField("Name", text: $viewModel.name)
                TextField("Email", text: $viewModel.email).keyboardType(.emailAddress)
                TextField("Phone", text: $viewModel.phone).keyboardType(.phonePad)
            }
            Section("Location") {
                Button("Get location") {
                    viewModel.requestLocation()
                    if viewModel.coordinate != nil { showCoord = true }
                }
            }
            Button("Create") { viewModel.submit() }
        }
        .alert("Coordinates", isPresented: $showCoord, actions: {
            Button("OK", role: .cancel) { }
        }, message: {
            if let c = viewModel.coordinate {
                Text("\(c.latitude), \(c.longitude)")
            } else {
                Text("No location yet")
            }
        })
        .navigationTitle("New User")
    }
}
