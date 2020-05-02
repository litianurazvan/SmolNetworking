import SmolNetwork
import Foundation

let requestDispatcher = APIRequestDispatcher(environment: Environment.development, networkSession: APINetworkSession())
let params: [String : Any] = [
   "name": "Gone with the wind",
   "author": "Margaret Mitchell"
]

let bookCreationRequest = BooksEndpoint.create(parameters: params)

let bookOperation = APIOperation(bookCreationRequest)
bookOperation.execute(in: requestDispatcher) { result in
  // Handle result
    print(result)
}

