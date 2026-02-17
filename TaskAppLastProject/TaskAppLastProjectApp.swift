//
//  TaskAppLastProjectApp.swift
//  TaskAppLastProject
//
//  Created by Saba Javakhishvili on 18.02.26.
//

import SwiftUI
import CoreData

@main
struct TaskAppLastProjectApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
