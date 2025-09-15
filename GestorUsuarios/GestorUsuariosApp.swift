//
//  GestorUsuariosApp.swift
//  GestorUsuarios
//
//  Created by Patricio Chavez on 15/9/25.
//

import SwiftUI

@main
struct GestorUsuariosApp: App {
    @StateObject private var appCoordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            appCoordinator.rootView
        }
    }
}
