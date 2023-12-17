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

struct JokeView: View {
  @EnvironmentObject var joyJotterVM: JoyJotterVM
  @ObservedObject var joke: Joke

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      questionAnswerView()
      bottomView()
    }
    .background(
      RoundedRectangle(cornerRadius: 5)
        .stroke(.gray, lineWidth: 1)
        .shadow(radius: 10)
    )
  }

  private func questionAnswerView() -> some View {
    return VStack(spacing: 0) {
      Text(joke.question)
        .multilineTextAlignment(.center)
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding()
      Text(joke.answer)
        .frame(minWidth: 0, maxWidth: .infinity)
        .multilineTextAlignment(.center)
        .padding()
        .foregroundStyle(.white)
        .background(
          RoundedRectangle(cornerRadius: 5)
            .fill(.black)
        )
    }
  }

  private func bottomView() -> some View {
    HStack(spacing: 0) {
      RatingView(rating: joke.rating)
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity)
      if joyJotterVM.isFavVisibleInCard {
        Divider()
          .background(.black)
          .frame(width: 3, height: 30)
        Button {
          joke.isFav.toggle()
          joyJotterVM.updateFavorite(with: joke)
        } label: {
          Image(systemName: joke.isFav ? "heart.fill" : "heart")
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundStyle(.red)
            .padding()
        }
        .buttonStyle(PlainButtonStyle())
      }
    }
  }
}

#Preview {
  JokeView(
    joke:
      Joke(
        question: "How many developers does it take to screw in a lightbulb?",
        answer: "None. It’s a hardware problem.",
        rating: 4
      )
  )
}
