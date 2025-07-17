//
//  ContentView.swift
//  UIinUI
//
//  Created by Nitin on 08/07/25.
//

import SwiftUI

struct CounterView: View {
    @State private var counter: Int = 0
    @State private var scale: CGFloat = 1
    @State private var bgColor  : Color = .white

    var body: some View {
        ZStack{
            bgColor
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.4), value: bgColor)
        VStack(spacing : 20){
            Text("My Counter")
                .font(.largeTitle)
                .bold()
            
            Text("Count : \(counter)")
                .font(.system(size: 40))
                .foregroundColor(.blue)
                .scaleEffect(scale)
                .animation(.spring(response: 0.3,dampingFraction: 0.4), value: scale)
            
            HStack(spacing: 40){
                Button( action: {
                    if counter > 0{
                        counter -= 1
                        animateChange(color: Color.red.opacity(0.4))
                    }
                }){
                    Text("- Decrease")
                        .padding()
                        .background(Color.red.opacity(0.2))
                        .cornerRadius(8)
                    
                }
                Button( action: {
                    counter += 1
                    animateChange(color: .green.opacity(0.4))

                }){
                    Text("+ Increase")
                        .padding()
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            Button("Reset") {
                counter = 0
                animateChange(color: .gray.opacity(0.4))

            }
            .padding(.top,50)
            .foregroundColor(.gray)
        }
        .padding()
    }
    }
    // Animate scale + background flash
    func animateChange(color: Color) {
        scale = 1.3
        bgColor = color
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            scale = 1.0
            bgColor = .white
        }
    }
}


#Preview {
    CounterView()
}

