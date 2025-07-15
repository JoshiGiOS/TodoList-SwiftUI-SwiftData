//
//  UIinUIApp.swift
//  UIinUI
//
//  Created by Nitin on 08/07/25.
//

import SwiftUI

@main
struct UIinUIApp: App {
    var body: some Scene {
        WindowGroup {
            MainMenuView()
        }
        .modelContainer(for: TodoItem.self)

    }
}
