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

struct AddJokeView: View {
  var category: String
  @EnvironmentObject var joyJotterVM: JoyJotterVM
  @Binding var isPresented: Bool

  @State private var newJokeQuestion: String = ""
  @State private var newJokeAnswer: String = ""
  @State private var newJokeRating: Int = 0
  @State private var isFav = false

  var body: some View {
    NavigationStack {
      Form {
        Section(header: Text("Joke Details")) {
          TextField("Enter Question", text: $newJokeQuestion)
          TextField("Enter Answer", text: $newJokeAnswer)
        }

        Section(header: Text("Rating")) {
          Picker("Rating", selection: $newJokeRating) {
            ForEach(1..<6) { rating in
              Text("\(rating)")
            }
          }
          .pickerStyle(SegmentedPickerStyle())
        }

        Section(header: Text("Favorite")) {
          Toggle("Favorite", isOn: $isFav)
        }
      }
      .navigationTitle("Add Joke")
      .navigationBarItems(
        leading: Button("Cancel") { isPresented.toggle() },
        trailing: Button("Save") { addJoke() }
      )
    }
  }

  private func addJoke() {
    guard !newJokeQuestion.isEmpty, !newJokeAnswer.isEmpty else { return }
    let newJoke = Joke(
      question: newJokeQuestion,
      answer: newJokeAnswer,
      isFav: isFav,
      category: category,
      rating: newJokeRating + 1
    )
    joyJotterVM.add(joke: newJoke)
    isPresented.toggle()
  }
}

#Preview {
  AddJokeView(
    category: "Programmers Jokes",
    isPresented: .constant(true)
  )
  .environmentObject(JoyJotterVM(jokes: JoyJotterVM.basicJokes))
}
