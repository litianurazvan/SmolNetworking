import SmolNetwork
import PlaygroundSupport
import Foundation

let requestDispatcher = APIRequestDispatcher(
    environment: Environment.development,
    networkSession: APINetworkSession()
)

struct Todo: Codable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}

let todoCreationRequest = TodoEndpoint.todo(identifier: 1)

let todoOperation = APIOperation<Todo>(todoCreationRequest)
todoOperation.execute(in: requestDispatcher) { result in
  // Handle result
    DispatchQueue.main.async {
        print(result)
    }
}

PlaygroundPage.current.needsIndefiniteExecution = true
