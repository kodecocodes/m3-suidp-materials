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

import Foundation

class Joke: ObservableObject, Identifiable, Codable {
  var id: UUID
  var question: String
  var answer: String
  @Published var isFav: Bool
  @Published var category: String
  var rating: Int

  init(id: UUID = UUID(), question: String = "", answer: String = "", isFav: Bool = false, category: String = "Random Jokes", rating: Int = 1) {
    self.id = id
    self.question = question
    self.answer = answer
    self.isFav = isFav
    self.category = category
    self.rating = rating
  }

  // MARK: - Codable Conformance

  enum CodingKeys: String, CodingKey {
    case id, question, answer, isFav, rating, category
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(UUID.self, forKey: .id)
    question = try container.decode(String.self, forKey: .question)
    answer = try container.decode(String.self, forKey: .answer)
    isFav = try container.decode(Bool.self, forKey: .isFav)
    category = try container.decode(String.self, forKey: .category)
    rating = try container.decode(Int.self, forKey: .rating)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(question, forKey: .question)
    try container.encode(answer, forKey: .answer)
    try container.encode(isFav, forKey: .isFav)
    try container.encode(category, forKey: .category)
    try container.encode(rating, forKey: .rating)
  }
}
