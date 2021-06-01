//
//  API.swift
//  TrackingApp
//
//  Created by Gautam Kumar Singh on 28/5/21.
//

import Foundation

struct Resource<T>{
    let method:String
    let token:String
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
    init(server:String) {
        self.server = server
    }
}

//MARK: - Private methods
extension API{
    
    private func genericRequest(_ endPoint:String,_ httpMethod:String) -> URLRequest{
        let url = URL(string: self.server + "/" + endPoint)!
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    private func loginRequest(_ endPoint:String,_ httpMethod:String,_ params:[String:Any]) -> URLRequest{
        var request = self.genericRequest(endPoint, httpMethod)
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        return request
    }
    private func request(_ endPoint:String,_ httpMethod:String,_ params:[String:Any],_ token:String) -> URLRequest{
        var request = self.genericRequest(endPoint, httpMethod)
        if params.count > 0 {
            request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        }
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

//MARK: - Common methods
extension API {
    func load<T>(resource:Resource<T>,completion:@escaping(T?,ApiError?)->()){
        var request : URLRequest
        if resource.token.count > 0 {
            request = self.request(resource.urlEndPoint, resource.method, resource.params,resource.token)
        }else{
            request = self.loginRequest(resource.urlEndPoint, resource.method, resource.params)
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            var sError : ApiError?
            if let resp = response as? HTTPURLResponse{
                sError = ApiError(statusCode: resp.statusCode, message: HTTPURLResponse.localizedString(forStatusCode: resp.statusCode))
            }
            DispatchQueue.main.async {
                if let data = data {
                    //let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: [])
                   //print(jsonResponse)
                    completion(resource.parse(data),sError)
                }else{
                    if let err = sError {
                        completion(nil,err)
                    }else{
                        completion(nil,ApiError(statusCode: -1009, message: error?.localizedDescription))
                    }
                }
            }
        }.resume()
    }
}
