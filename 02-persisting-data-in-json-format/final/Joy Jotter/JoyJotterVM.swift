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

class JoyJotterVM: ObservableObject {
  // MARK: - Properties
  @Published var jokes: [Joke]
  @Published var favoriteJokes: [Joke] = []
  @Published var isFavTabVisible: Bool
  @Published var isFavVisibleInCard: Bool
  var categories: [String] {
    return Array(Set(jokes.map { $0.category })).sorted()
  }

  init(
    jokes: [Joke],
    isFavTabVisible: Bool = true,
    isFavVisibleInCard: Bool = true
  ) {
    self.jokes = jokes
    self.favoriteJokes = jokes.filter { $0.isFav }
    self.isFavTabVisible = isFavTabVisible
    self.isFavVisibleInCard = isFavVisibleInCard

    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(
      self,
      selector: #selector(appMovedToBackground),
      name: UIApplication.willResignActiveNotification,
      object: nil
    )
  }

  // MARK: - Methods
  func add(joke: Joke) {
    jokes.append(joke)
    updateFavorite(with: joke)
  }

  func updateFavorite(with joke: Joke) {
    if joke.isFav {
      favoriteJokes.append(joke)
    } else {
      favoriteJokes.removeAll { $0.id == joke.id }
    }
  }

  // MARK: - JSON Methods
  @objc func appMovedToBackground() {
    print("App moved to background")
    writeDataOf(jokes: jokes)
  }

  func writeDataOf(jokes: [Joke]) {
    do {
      // 1
      // Get the file URL for saving data
      let fileURL = try FileManager.default
        .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        .appendingPathComponent("savedJokes.json")
      print("Document Directory Path:", fileURL.path)

      // 2
      // If the file already exists, remove it
      if FileManager.default.fileExists(atPath: fileURL.path) {
        try FileManager.default.removeItem(at: fileURL)
      }

      // 3
      // Encode the jokes array to JSON data and write it to the file
      try JSONEncoder().encode(jokes).write(to: fileURL)
      print("Data written successfully.")
    } catch {
      print("Error writing Jokes: \(error.localizedDescription)")
    }
  }

  static func readDataOfJokes() -> [Joke]? {
    do {
      // 1
      // Get the file URL for reading data
      let fileURL = try FileManager.default
        .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        .appendingPathComponent("savedJokes.json")

      // 2
      // Read data from the file and decode it to an array of Joke objects
      if FileManager.default.fileExists(atPath: fileURL.path) {
        let data = try Data(contentsOf: fileURL)
        let jokes = try JSONDecoder().decode([Joke].self, from: data)
        print("Data read successfully.")
        return jokes
      } else {
        print("No jokes found at path:", fileURL.path)
        return nil
      }
    } catch {
      print("Error reading Jokes: \(error.localizedDescription)")
      return nil
    }
  }
}

extension JoyJotterVM {
  static let basicJokes = [
    Joke(
      question: "Why do programmers prefer dark mode?",
      answer: "Because light attracts bugs",
      isFav: true,
      category: "Programmers Jokes",
      rating: 5
    ),
    Joke(
      question: "Why did the developer go broke?",
      answer: "Because he used up all his cache!",
      isFav: true,
      category: "Programmers Jokes",
      rating: 3
    ),
    Joke(
      question: "What’s a better name for Frontend Developers?",
      answer: "<div>elopers",
      isFav: false,
      category: "Programmers Jokes",
      rating: 2
    ),
    Joke(
      question: "Why do cows never have any money?",
      answer: "Because the farmers milk them dry!",
      isFav: true,
      category: "Animal Jokes",
      rating: 4
    ),
    Joke(
      question: "What do you call an alligator wearing a vest?",
      answer: "An Investigator!",
      isFav: false,
      category: "Animal Jokes",
      rating: 1
    ),
    Joke(
      question: "Why shouldn't you fall in love with a pastry chef?",
      answer: "He'll dessert you.",
      isFav: false,
      category: "Diet Jokes",
      rating: 1
    ),
    Joke(
      question: "Why did the diet coach send her clients to the paint store?",
      answer: "She heard you could get thinner there.",
      isFav: true,
      category: "Diet Jokes",
      rating: 3
    ),
    Joke(
      question: "What's the difference between love and marriage?",
      answer: "Love is blind. Marriage is an eye opener.",
      isFav: true,
      category: "Marriage Jokes",
      rating: 5
    )
  ]
}
