//
//  UserFormViewModel.swift
//  GestorUsuarios
//
//  Created by Patricio Chavez on 15/9/25.
//


import Foundation
import Combine
import CoreLocation

@MainActor
final class UserFormViewModel: ObservableObject {
    enum State: Equatable { case idle, validating, submitting, success, error(String) }

    @Published private(set) var state: State = .idle

    @Published var name: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published private(set) var coordinate: CLLocationCoordinate2D?

    private let repo: UsersRepository
    private let location: LocationProvider
    private var bag = Set<AnyCancellable>()

    init(repo: UsersRepository, location: LocationProvider) {
        self.repo = repo
        self.location = location

        location.lastCoordinatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.coordinate = $0 }
            .store(in: &bag)
    }

    func requestLocation() {
        location.requestAuthorization()
        location.requestOneShot()
    }

    func submit() {
        state = .validating
        do {
            try Validators.required(name, field: "name")
            try Validators.email(email)
            try Validators.required(phone, field: "phone")

            state = .submitting
            try repo.create(user: .init(name: name, email: email, phone: phone, coordinate: coordinate))
            state = .success
            resetForm()
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    private func resetForm() {
        name = ""; email = ""; phone = ""
        coordinate = nil
    }
}
