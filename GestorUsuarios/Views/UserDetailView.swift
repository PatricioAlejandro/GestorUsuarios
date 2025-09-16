//  UserDetailView.swift
//  UsersApp

import SwiftUI

struct UserDetailView: View {
    @StateObject var viewModel: UserDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var didRequestDismiss = false
    
    var body: some View {
        Form {
            Section("Profile") {
                HStack(alignment: .center){
                    Spacer()
                    Image(systemName: "person.circle.fill").resizable().frame(width: 72, height: 72)
                    Spacer()
                }
                TextField("Name", text: $viewModel.name)
                    .padding(.trailing, 36)
                    .overlay(alignment: .trailing) {
                        HStack {
                            if !viewModel.name.isEmpty {
                                Button {
                                    viewModel.name = ""
                                } label: {
                                    Image(systemName: "pencil")
                                        .imageScale(.medium)
                                        .foregroundStyle(.secondary)
                                        .padding(.trailing, 8)
                                        .contentShape(Rectangle()) // mejor hitbox
                                        .accessibilityLabel("Borrar texto")
                                }
                            }
                        }
                    }
                TextField("Email", text: $viewModel.email).keyboardType(.emailAddress)
                    .padding(.trailing, 36)
                    .overlay(alignment: .trailing) {
                        HStack {
                            if !viewModel.email.isEmpty {
                                Button {
                                    viewModel.email = ""
                                } label: {
                                    Image(systemName: "pencil")
                                        .imageScale(.medium)
                                        .foregroundStyle(.secondary)
                                        .padding(.trailing, 8)
                                        .contentShape(Rectangle()) // mejor hitbox
                                        .accessibilityLabel("Borrar texto")
                                }
                            }
                        }
                    }
                Text("\(viewModel.user?.phone ?? "124124124")")
                    .foregroundStyle(Color.blue)
                Text("\(viewModel.user?.email ?? "default@mail.com")")
                Text("\(viewModel.user?.city ?? "Default City")")

            }
            Button("Save") { viewModel.save() }
            Button("Delete", role: .destructive) { viewModel.deleteUser() }
        }
        .navigationTitle("Detail")
        .onChange(of: viewModel.state) { newState in
            guard newState == .saved, !didRequestDismiss else { return }
            didRequestDismiss = true
            DispatchQueue.main.async { dismiss() }
        }
    }
}
