//
//  UserDetailView.swift
//  GestorUsuarios
//
//  Created by Patricio Chavez on 15/9/25.
//

import SwiftUI

struct UserDetailView: View {
    @StateObject var viewModel: UserDetailViewModel
    @State private var newName = ""
    @State private var newEmail = ""

    var body: some View {
        Form {
            Section("Profile") {
                Image(systemName: "person.circle.fill").resizable().frame(width: 72, height: 72)
                Text(viewModel.user?.name ?? "Default Name")
                Text(viewModel.user?.email ?? "default@mail.com")
            }
            Section("Edit") {
                TextField("Name", text: $newName)
                TextField("Email", text: $newEmail)
                Button("Save") {
                    viewModel.save()
                }
                Button("Delete", role: .destructive) {
                    viewModel.deleteUser()
                }
            }
        }
        .navigationTitle("Detail")
    }
}
