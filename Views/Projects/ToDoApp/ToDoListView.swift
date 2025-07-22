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
enum TaskFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case active = "Active"
    case completed = "Completed"
    
    var id: String { self.rawValue }
}


struct ToDoListView: View {
    //    @Query var todos : [TodoItem] // for fetching the values
    @Query var allTodos: [TodoItem]
    @Environment(\.undoManager) private var undoManager
    var filteredTodos: [TodoItem] {
        allTodos.filter { todo in
            let matchesPriority: Bool = {
                switch selectedPriorityFilter {
                case .all: return true
                case .high: return todo.priority == .high
                case .medium: return todo.priority == .medium
                case .low: return todo.priority == .low
                }
            }()
            
            let matchesStatus: Bool = {
                switch selectedTaskFilter {
                case .all: return true
                case .active: return !todo.isCompleted
                case .completed: return todo.isCompleted
                }
            }()
            
            return matchesPriority && matchesStatus
        }
    }
    
    @Environment(\.modelContext) private var context //for CRUD operations
    @State private var newTask : String = ""
    @State private var selectedPriority : TaskPriority = .medium
    @State private var selectedPriorityFilter: PriorityFilter = .all
    @State private var selectedTaskFilter: TaskFilter = .all
    @State private var autoDeleteCompletedTasks: Bool = false
    @AppStorage("bgColorHex") private var bgColorHex: String = "#FFFFFF"
    @State private var selectedBgColor: Color = .white
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
                    
                    VStack(spacing: 10) {
                        Text("Priority:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        Picker("Priority", selection: $selectedPriorityFilter) {
                            ForEach(PriorityFilter.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)

                        Text("Status:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        Picker("Status", selection: $selectedTaskFilter) {
                            ForEach(TaskFilter.allCases) { filter in
                                Text(filter.rawValue).tag(filter)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    if selectedTaskFilter == .completed {
                          Toggle("Auto-delete completed tasks", isOn: $autoDeleteCompletedTasks)
                              .padding(.top, 4)
                      }
                }
                .padding()
                
                Divider()

                Picker("Filter", selection: $selectedPriorityFilter) {
                    ForEach(PriorityFilter.allCases, id: \.self) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                List {
                    ForEach(filteredTodos) { item in
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                      Button(action: {
                          undoManager?.undo()
                      }) {
                          Image(systemName: "arrow.uturn.backward")
                      }
                      .disabled(!(undoManager?.canUndo ?? false))
                  }
            }
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
        let tasksToDelete = offsets.map { filteredTodos[$0] }
           delete(tasks: tasksToDelete)
    }
    func deleteCompletedTasks() {
        let completedTasks = filteredTodos.filter { $0.isCompleted }
        delete(tasks: completedTasks)
    }

    func delete(tasks: [TodoItem]) {
        for task in tasks {
            context.delete(task)
        }
        try? context.save()

        undoManager?.registerUndo(withTarget: context) { context in
            for task in tasks {
                context.insert(task)
            }
            try? context.save()
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

//MARK:  Helper to convert between Color and Hex
extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }

    func toHex() -> String? {
        let uiColor = UIColor(self)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        guard uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else { return nil }

        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)

        return String(format: "#%02X%02X%02X", r, g, b)
    }
}

#Preview {
    ToDoListView()
}
