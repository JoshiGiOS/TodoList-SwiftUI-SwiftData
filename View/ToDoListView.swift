//
//  ToDoListView.swift
//  UIinUI
//
//  Created by Nitin on 08/07/25.
//

import SwiftUI
import SwiftData

enum PriorityFilter: String, CaseIterable {
    case all = "All"
    case high = "High"
    case medium = "Medium"
    case low = "Low"
}

struct ToDoListView: View {
    //    @Query var todos : [TodoItem] // for fetching the values
    @Query var allTodos: [TodoItem]
    var todos: [TodoItem] {
        switch selectedFilter {
        case .all: return allTodos
        case .high: return allTodos.filter { $0.priority == .high }
        case .medium: return allTodos.filter { $0.priority == .medium }
        case .low: return allTodos.filter { $0.priority == .low }
        }
    }
    
    @Environment(\.modelContext) private var context //for CRUD operations
    @State private var newTask : String = ""
    @State private var selectedPriority : TaskPriority = .medium
    @State private var selectedFilter: PriorityFilter = .all
    
    //    @State private var viewModel = TodoVM() //now not needed as @model and @query will handle most of its work
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        TextField("Enter new task and Tap + to add", text: $newTask)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: addTodo) {
                            Image(systemName: "plus")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                    }
                    
                    Picker("Priority", selection: $selectedPriority) {
                        ForEach(TaskPriority.allCases, id: \.self) { priority in
                            Text(priority.rawValue).tag(priority)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding()
                
                Divider()

                Picker("Filter", selection: $selectedFilter) {
                    ForEach(PriorityFilter.allCases, id: \.self) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                List {
                    ForEach(todos) { item in
                        HStack {
                            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                .onTapGesture {
                                    toggleCompletion(item)
                                }
                            VStack(alignment: .leading) {
                                Text(item.title)
                                    .strikethrough(item.isCompleted)
                                    .foregroundColor(item.isCompleted ? .gray : .black)
                                Text(item.priority.rawValue)
                                    .font(.caption)
                                    .foregroundColor(colorForPriority(item.priority))
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                
            }
            .navigationTitle("📝 SwiftData To-Do")
        }
    }
    func addTodo() {
        guard !newTask.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let newTodo = TodoItem(title: newTask, priority: selectedPriority)
        context.insert(newTodo)
        newTask = ""
        selectedPriority = .medium
    }
    
    func toggleCompletion(_ item: TodoItem) {
        item.isCompleted.toggle()
    }
    
    func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let item = todos[index]
            context.delete(item)
        }
    }
    func colorForPriority(_ priority: TaskPriority) -> Color {
        switch priority {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}
#Preview {
    ToDoListView()
}
