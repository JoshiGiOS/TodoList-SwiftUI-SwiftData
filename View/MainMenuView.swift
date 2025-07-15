//
//  MainMenuView.swift
//  UIinUI
//
//  Created by Nitin on 08/07/25.
//

import SwiftUI
import SwiftData

struct MainMenuView: View {
    var body: some View {
           NavigationStack {
               List {
                   NavigationLink("Counter View", destination: CounterView())
                   NavigationLink("To-Do List with SwiftData", destination: ToDoListView())

               }
               .navigationTitle("SwiftUI Demos")
           }
       }
   }
