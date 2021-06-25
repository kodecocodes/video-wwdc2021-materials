/// Copyright (c) 2021 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct ContentView: View {
  @State private var showAlert = false
  @State private var showActionSheet = false
  
  @State private var scaleUp = false
  @State private var changeColor = false
  
  var body: some View {
    NavigationView {
      VStack(spacing: 20.0) {
        Text("Hello, SwiftUI!")
          .fontWeight(.bold)
          .foregroundColor(changeColor ? .orange : .black)
          .scaleEffect(scaleUp ? 2 : 1)
          .animation(.easeInOut(duration: 1), value: changeColor)
          .onLongPressGesture(minimumDuration: 1, maximumDistance: 5) {
            scaleUp.toggle()
          } onPressingChanged: { pressing in
            changeColor = pressing
          }
    
        Button(action: { showActionSheet = true }) {
          Label("Action Required", systemImage: "checkmark.square.fill")
        }
        .contextMenu(menuItems: {
          Label("Item 1", systemImage: "1.square.fill")
          Label("Item 2", systemImage: "2.square.fill")
        })
      }
      .font(.title)
      .padding(45)
      .navigationTitle("Breaking Changes")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button { showAlert = true } label: {
            Label("Alert, Alert!", systemImage: "exclamationmark.triangle.fill")
          }
        }
      }
      .background(alignment: .leading) {
        Image(systemName: "triangle")
          .resizable()
          .scaledToFit()
          .foregroundColor(.orange)
          .opacity(0.15)
      }
      .overlay(alignment: .topTrailing) {
        Image(systemName: "bolt.circle.fill")
          .font(.title)
          .foregroundColor(.yellow)
      }
      .confirmationDialog("Action Required:", isPresented: $showActionSheet) {
        Button("I can't", role: .destructive) { fatalError() }
        Button("OK", role: .cancel) { print("Confirmed.") }
      } message: {
        Text("Replace actions sheets with confirmation dialogs.")
      }
      .alert(Text("Alert, Alert! SwiftUI deprecations incoming."), isPresented: $showAlert){
        //        Button("Yes!", role: .cancel) { print("Accepted") }
        //        Button("If I have to...") { print("Accepted, I guess.") }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
