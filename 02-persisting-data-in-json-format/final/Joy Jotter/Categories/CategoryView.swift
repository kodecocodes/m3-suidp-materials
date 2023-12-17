/// Copyright (c) 2023 Kodeco Inc.
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

struct CategoryView: View {
  var category: String
  @EnvironmentObject var joyJotterVM: JoyJotterVM
  @State private var isAddJokeViewPresented = false

  var body: some View {
    let jokesInCategory = joyJotterVM.jokes.filter { $0.category == category }

    VStack {
      if jokesInCategory.isEmpty {
        VStack(spacing: 10) {
          Image(systemName: "exclamationmark.magnifyingglass")
            .resizable()
            .frame(width: 30, height: 30)
          Text("There are no jokes in this category yet.")
        }
      } else {
        VStack {
          Text("Count: \(jokesInCategory.count)")
            .font(.subheadline)
            .foregroundStyle(.gray)
          List {
            ForEach(jokesInCategory) { joke in
              JokeView(joke: joke)
            }
          }
          .listStyle(PlainListStyle())
        }
      }
    }
    .navigationTitle(category)
    .navigationBarItems(
      trailing:
        Button(action: {
          isAddJokeViewPresented = true
        }, label: {
          Image(systemName: "plus")
            .foregroundColor(.blue)
        })
    )
    .sheet(isPresented: $isAddJokeViewPresented) {
      AddJokeView(category: category, isPresented: $isAddJokeViewPresented)
    }
  }
}

#Preview {
  CategoryView(category: "Programmers Jokes")
  .environmentObject(JoyJotterVM(jokes: JoyJotterVM.basicJokes))
}
