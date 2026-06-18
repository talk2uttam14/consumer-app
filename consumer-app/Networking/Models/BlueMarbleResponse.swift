import Foundation

protocol BlueMarbleResponse {
  var success: Bool { get }
  var message: String { get }
}

extension BlueMarbleResponse {
  func validate() throws {
    guard success else {
      throw AppError.unknown(message)
    }
  }
}
