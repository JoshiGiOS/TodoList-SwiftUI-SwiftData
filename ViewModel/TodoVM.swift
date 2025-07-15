////
////  TodoVM.swift
////  UIinUI
////
////  Created by Nitin on 09/07/25.
////
//
//import Foundation
//
//class TodoVM: ObservableObject{
//    @Published var todos : [TodoItem] = []
//    @Published var newTask :  String = ""
//    
//    func addTodo() {
//        guard !newTask.trimmingCharacters(in: .whitespaces).isEmpty else {return}
//        let newTodo = TodoItem(title: newTask)
//        todos.append(newTodo)
//        newTask = ""
//    }
//    func toggleCompletion(for item : TodoItem){
//        if let index = todos.firstIndex(where: {$0.id == item.id }){
//            todos[index].isCompleted.toggle()
//        }
//    }
//    func delete(at offsets : IndexSet){
//        todos.remove(atOffsets: offsets)
//    }
//}
