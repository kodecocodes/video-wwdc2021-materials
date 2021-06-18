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

enum FetchError: Error {
  case statusCode(Int)
  case urlResponse
}

@available(iOS 15.0, *)
@available(iOS 15.0, *)
struct ContentView: View {

  @State private var songs = [MusicItem]()
  @State private var taskHandle: Task.Handle<Void, Never>?

  var body: some View {
    VStack {
      HStack {
        Button {
          taskHandle = async {
            do {
              let cohenSongs = try await fetchSongs(for: "cohen")
              let u2Songs = try await fetchSongs(for: "u2")
              songs = cohenSongs + u2Songs
            } catch {
              print(error.localizedDescription)
            }
          }
        } label: {
          Text("Fetch songs")
        }
        Button {
          taskHandle?.cancel()
        } label: {
          Text("Cancel")
        }
      }
      List(songs) { song in
        Text("\(song.trackName) - \(song.artistName)")
      }
      .task {
        do {
          try await withThrowingTaskGroup(of: [MusicItem].self) { group in
            group.async {
              try await fetchSongs(for: "cohen")
            }
            group.async {
              try await fetchSongs(for: "u2")
            }
            songs = try await group.reduce([], +)
          }
        } catch {
          print(error.localizedDescription)
        }
      }
    }
  }

  func fetchSongs(for artist: String) async throws -> [MusicItem] {
    print("fetch songs start: \(artist)")
    guard let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=\(artist)") else {
      fatalError()
    }
    let (data, response) = try await URLSession.shared.data(from: url)
    print("received data: \(artist)")
    if !Task.isCancelled {
      guard let httpResponse = response as? HTTPURLResponse else {
        throw FetchError.urlResponse
      }
      guard (200..<300).contains(httpResponse.statusCode) else {
        throw FetchError.statusCode(httpResponse.statusCode)
      }
      let decoder = JSONDecoder()
      let mediaResponse = try decoder.decode(MediaResponse.self, from: data)

      return mediaResponse.results
    } else {
      print("task cancelled")
      return [MusicItem]()
    }
  }

}

@available(iOS 15.0, *)
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
