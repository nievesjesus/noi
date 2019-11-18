//
//  noi.swift
//  noi
//
//  Created by Jesus Nieves on 04/10/2019.
//

import Foundation

public protocol NoiDelegate: class {
    func onNoiError(_ type: NoiErrorType)
}

public enum NoiHTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public enum NoiErrorType {
    case server
    case network
    case badParsing
    case badUrl
    case unknown
}

/**
Noi a easy way to make HTTP request

- Parameters:
    - Model:Your codable object.
*/
public struct Noi<Model: Codable> {

    public typealias NoiSuccessCompletionHandler = (_ response: Model) -> Void

    /**
    Create a request for a GET method.

    - Parameters:
        - delegate: The delegate that with manage any error.
        - path: The path inside your json to find your codable object.
        - headers: Headers for you request.
        - parameters: Your request parameters.
        - success: Success closure.

    - Throws: Use `NoiBaseDelegate` to execute the onNoiError function,
                and returns and `NoiErrorType` object

    - Returns: Your struct object of type `codable`.
    */
    public static func get(_ delegate: NoiDelegate?,
                           path: String, url: String,
                           headers: [String: String]? = nil,
                           parameters: [String: String]? = nil,
                           success successCallback: @escaping NoiSuccessCompletionHandler
    ) {
        self.noiRequest(delegate, method: .get,
                        path: path,
                        url: url,
                        headers: headers,
                        parameters: parameters,
                        success: successCallback)
    }

    /**
    Create a request for a POST method.

    - Parameters:
        - delegate: The delegate that with manage any error.
        - path: The path inside your json to find your codable object.
        - headers: Headers for you request.
        - parameters: Your request parameters.
        - success: Success closure.

    - Throws: Use `NoiBaseDelegate` to execute the onNoiError function,
                and returns and `NoiErrorType` object

    - Returns: Your struct object of type `codable`.
    */
    public static func post(_ delegate: NoiDelegate?,
                            path: String, url: String,
                            headers: [String: String]? = nil,
                            parameters: [String: String]? = nil,
                            success successCallback: @escaping NoiSuccessCompletionHandler
    ) {
        self.noiRequest(delegate, method: .post,
                        path: path,
                        url: url,
                        headers: headers,
                        parameters: parameters,
                        success: successCallback)
    }

    /**
    Create a request for a PUT method.

    - Parameters:
        - delegate: The delegate that with manage any error.
        - path: The path inside your json to find your codable object.
        - headers: Headers for you request.
        - parameters: Your request parameters.
        - success: Success closure.

    - Throws: Use `NoiBaseDelegate` to execute the onNoiError function,
                and returns and `NoiErrorType` object

    - Returns: Your struct object of type `codable`.
    */
    public static func put(_ delegate: NoiDelegate?,
                           path: String, url: String,
                           headers: [String: String]? = nil,
                           parameters: [String: String]? = nil,
                           success successCallback: @escaping NoiSuccessCompletionHandler
    ) {
        self.noiRequest(delegate, method: .put,
                        path: path,
                        url: url,
                        headers: headers,
                        parameters: parameters,
                        success: successCallback)
    }

    /**
    Create a request for a DELETE method.

    - Parameters:
        - delegate: The delegate that with manage any error.
        - path: The path inside your json to find your codable object.
        - headers: Headers for you request.
        - parameters: Your request parameters.
        - success: Success closure.

    - Throws: Use `NoiBaseDelegate` to execute the onNoiError function,
                and returns and `NoiErrorType` object

    - Returns: Your struct object of type `codable`.
    */
    public static func delete(_ delegate: NoiDelegate?,
                              path: String, url: String,
                              headers: [String: String]? = nil,
                              success successCallback: @escaping NoiSuccessCompletionHandler
    ) {
        self.noiRequest(delegate, method: .delete,
                        path: path,
                        url: url,
                        headers: headers,
                        success: successCallback)
    }

}

private extension Noi {
    static func noiRequest(_ delegate: NoiDelegate?,
                           method: NoiHTTPMethod,
                           path: String,
                           url: String,
                           headers: [String: String]? = nil,
                           parameters: [String: String]? = nil,
                           success successCallback: @escaping NoiSuccessCompletionHandler
     ) {

        guard let request = self.getRequestObject(method: method,
                                                  url: url,
                                                  parameters: parameters, headers: headers
            ) else {
                delegate?.onNoiError(.badUrl)
                return
        }

        var dataTask: URLSessionDataTask?
        let defaultSession = URLSession(configuration: .default)

        dataTask =
            defaultSession.dataTask(with: request) { data, response, error in
                defer {
                    dataTask = nil
                }
                if error != nil {
                    delegate?.onNoiError(.network)
                } else {
                    guard  let data = data, let response = response as? HTTPURLResponse else {
                        delegate?.onNoiError(.server)
                        return
                    }
                    if (response.statusCode >= 200 && response.statusCode <= 299) {
                        guard let model = self.getParsedModel(data, at: path) else {
                            delegate?.onNoiError(.badParsing)
                            return
                        }
                        successCallback(model)
                    } else {
                        delegate?.onNoiError(.unknown)
                    }
                }
        }
        dataTask?.resume()
    }

    static func getParsedModel(_ data: Data, at path: String) -> Model? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary

            if let dictAtPath = json?.value(forKeyPath: path) {
                let jsonData = try JSONSerialization.data(withJSONObject: dictAtPath,
                                                          options: .prettyPrinted)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let model =  try decoder.decode(Model.self, from: jsonData)
                return model
            } else {
                return nil
            }
        } catch let error {
            #if DEBUG
                print(error)
            #endif
            return nil
        }
    }

    static func getRequestObject(method: NoiHTTPMethod,
                                 url: String,
                                 parameters: [String: String]? = nil,
                                 headers: [String: String]? = nil
    ) -> URLRequest? {

        var bodyData: Data?
        var urlComponent = URLComponents(string: url)

        if method == .get {
             if let noiParameters = parameters {
                 for (key, value) in noiParameters {
                    let queryItem = URLQueryItem(name: key, value: "\(value)")
                    urlComponent?.queryItems?.append(queryItem)
                 }
             }
        } else {
            if let params = parameters, let jsonData = try? JSONSerialization.data(withJSONObject:
                params, options: []) {
                bodyData = jsonData
            }
        }

        guard let component = urlComponent, let noiUrl = component.url else {
            return nil
        }

        var request = URLRequest(url: noiUrl)
        request.httpMethod = method.rawValue
        request.httpBody =  bodyData
        request.allHTTPHeaderFields = headers

        return request
    }
}
