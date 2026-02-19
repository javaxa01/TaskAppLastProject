//
//  AddTaskView.swift
//  TaskAppLastProject
//
//  Created by Saba Javakhishvili on 19.02.26.
//

import Foundation
import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var tasks: [ToDoItem]
    @State private var text: String = ""
    
    var body: some View {
        ZStack {
            backgroundGradient
            VStack(spacing: 30) {
                TextField("Task Detail", text: $text)
                    .padding().background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.1)))
                    .foregroundColor(.white).padding(.horizontal, 20).padding(.top, 50)
                
                Button("Create Task") {
                    if !text.isEmpty {
                        tasks.append(ToDoItem(title: text, isCompleted: false))
                        dismiss()
                    }
                }
                .font(.headline).foregroundColor(.white).frame(maxWidth: .infinity).padding()
                .background(Color.blue).cornerRadius(15).padding(.horizontal, 20)
                Spacer()
            }
        }
        .navigationTitle("New Task")
    }
}
