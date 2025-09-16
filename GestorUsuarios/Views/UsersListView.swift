//
//  UsersListView.swift
//  GestorUsuarios
//
//  Created by Patricio Chavez on 15/9/25.
//

import SwiftUI

struct UsersListView: View {
    @StateObject var viewModel: UsersListViewModel
    @State private var path: [Int] = []

    var body: some View {
        NavigationStack(path: $path) {
            List(viewModel.users) { user in
                NavigationLink(value: user.id) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(user.username).font(.headline)
                        Text(user.name).font(.subheadline)
                        Text(user.email).font(.footnote)
                        Text(user.phone).font(.footnote)
                            .foregroundStyle(Color.blue)
                        Text(user.city).font(.footnote)
                    }
                }
                .swipeActions {
                    Button(role: .destructive) {
                        viewModel.delete(user)
                    } label: { Label("Delete", systemImage: "trash") }
                }
            }
            .searchable(text: $viewModel.searchText)
            .overlay {
                switch viewModel.state {
                case .loading: ProgressView("Loading…")
                case .error(let msg): Text(msg).foregroundColor(.red).padding()
                default: EmptyView()
                }
            }
            .task { viewModel.onAppear() }
            .navigationTitle("Users")
            .toolbar {
                NavigationLink("New") {
                    UserFormView(viewModel: UserFormViewModel(repo: viewModel.repo, location: DefaultLocationProvider()))
                }
            }
            .refreshable { await viewModel.manualRefresh() }
            .navigationDestination(for: Int.self) { userId in
                UserDetailView(viewModel: UserDetailViewModel(userId: userId, repo: viewModel.repo))
            }
        }
    }
}
