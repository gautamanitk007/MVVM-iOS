//
//  API.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import Foundation

struct Resource<T>{
    let method:String
    let params:[String:Any]
    let urlEndPoint:String
    let parse:(Data) -> T?
}

struct ApiError{
    let statusCode:Int
    let message:String?
}


class API{
    let server:String
    var token:String?
    init(server:String) {
        self.server = server
    }
}

//MARK: - Private methods
extension API{
    private func request(_ endPoint:String,_ httpMethod:String,_ params:[String:Any]) -> URLRequest{
        let url = URL(string: self.server + "/" + endPoint)!
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        if let token = self.token {
            let bearer = "Bearer \(token)"
            request.addValue(bearer, forHTTPHeaderField: "Authorization")
        }else {
            if params.count > 0{
                let jsonData = try? JSONSerialization.data(withJSONObject: params)
                request.httpBody = jsonData
            }
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
}

//MARK: - Common methods
extension API {
    func load<T>(resource:Resource<T>,completion:@escaping(T?,ApiError?)->()){
        let request = self.request(resource.urlEndPoint, resource.method, resource.params)
        URLSession.shared.dataTask(with: request) { data, response, error in
            var sError : ApiError?
            if let resp = response as? HTTPURLResponse{
                sError = ApiError(statusCode: resp.statusCode, message: HTTPURLResponse.localizedString(forStatusCode: resp.statusCode))
            }
            DispatchQueue.main.async {
                if let data = data {
                    completion(resource.parse(data),sError)
                }else{
                    completion(nil,sError)
                }
            }
        }.resume()
    }
}
