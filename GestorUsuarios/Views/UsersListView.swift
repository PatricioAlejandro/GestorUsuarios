//
//  UsersListView.swift
//  GestorUsuarios
//
//  Created by Patricio Chavez on 15/9/25.
//

import SwiftUI

struct UsersListView: View {
    @StateObject var viewModel: UsersListViewModel
    
    var body: some View {
        NavigationStack {
            List(viewModel.users) { user in
                NavigationLink(user.username) {
                    VStack(alignment: .leading) {
                        Text(user.username).font(.headline)
                        Text(user.name).font(.subheadline)
                        Text(user.email).font(.footnote)
                        Text(user.phone).font(.footnote)
                        Text(user.city).font(.footnote)
                    }
                }
                .swipeActions {
                    Button(role: .destructive) {
                        viewModel.delete(user)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            .searchable(text: $viewModel.searchText)
            .task { viewModel.onAppear() }
            .navigationTitle("Users")
            .refreshable { await viewModel.refresh() }
        }
    }
}
