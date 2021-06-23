///// Copyright (c) 2021 Razeware LLC
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

  let workerQueue = DispatchQueue(label: "com.raywenderlich.worker", attributes: .concurrent)
  let nameChangeGroup = DispatchGroup()
  let nameChangingPerson = Person(firstName: "Alison", lastName: "Anderson")
  let nameChangingActorPerson = ActorPerson(firstName: "Alison", lastName: "Anderson")
  let nameList = [("Ben", "Beagle"), ("Charlie", "Cheesecake"), ("Delia", "Dingle"), ("Eva", "Evershed"), ("Freddie", "Frost"), ("Gina", "Gregory")]

  var body: some View {
    Text("Hello, world!")
      .padding()
      .task {
        for name in nameList {
          workerQueue.async(group: nameChangeGroup) {
            nameChangingPerson.changeName(firstName: name.0, lastName: name.1)
            print("current name: \(nameChangingPerson.firstName) \(nameChangingPerson.lastName)")
            async {
              await nameChangingActorPerson.changeName(firstName: name.0, lastName: name.1)
              print("current actor name: \(await nameChangingActorPerson.firstName) \(await nameChangingActorPerson.lastName)")
            }

          }
          nameChangeGroup.notify(queue: DispatchQueue.global()) {
            print("current name: \(nameChangingPerson.firstName) \(nameChangingPerson.lastName)")
            async {
              print("fianl actor name: \(await nameChangingActorPerson.firstName) \(await nameChangingActorPerson.lastName)")
            }
          }
        }
      }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

class Person {
  var firstName: String
  var lastName: String

  init(firstName: String, lastName: String) {
    self.firstName = firstName
    self.lastName = lastName
  }

  func randomDelay(maxDuration: Double) {
    let randomWait = UInt32.random(in: 0...UInt32(maxDuration * Double(USEC_PER_SEC)))
    usleep(randomWait)
  }

  func changeName(firstName: String, lastName: String) {
    randomDelay(maxDuration: 0.2)
    self.firstName = firstName
    randomDelay(maxDuration: 1.0)
    self.lastName = lastName
  }
}

actor ActorPerson {
  var firstName: String
  var lastName: String

  init(firstName: String, lastName: String) {
    self.firstName = firstName
    self.lastName = lastName
  }

  func randomDelay(maxDuration: Double) {
    let randomWait = UInt32.random(in: 0...UInt32(maxDuration * Double(USEC_PER_SEC)))
    usleep(randomWait)
  }

  func changeName(firstName: String, lastName: String) {
    randomDelay(maxDuration: 0.2)
    self.firstName = firstName
    randomDelay(maxDuration: 1.0)
    self.lastName = lastName
  }
}
