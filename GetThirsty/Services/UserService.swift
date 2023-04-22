//
//  UserService.swift
//  GetThirsty
//
//  Created by Matt Reiley on 4/14/23.
//

import Foundation

struct User : Codable {
    let id: UUID = UUID()
    let username: String
    let token: String
}

class UserService {
    func register( username: String, password: String, height: Int, weight:Int, age: Int, gender: String, caffeine: Int) {

            let url = URL(string: "http://localhost:3000/user/register")!
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")

            request.httpMethod = "POST"
        let postString = ["username": username, "password": password, "height": height,
                          "weight":weight, "age": age, "gender": gender, "caffeineIntake": caffeine] as [String : Any]
            

            
            let jsonData = try? JSONSerialization.data(withJSONObject: postString)
            
            request.httpBody = jsonData



            
            
            

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    error == nil
                else {                                                               // check for fundamental networking error
                    print("error", error ?? URLError(.badServerResponse))
                    return
                }
                
                guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                    print("statusCode should be 2xx, but is \(response.statusCode)")
                    print("response = \(response)")
                    return
                }
                
                // do whatever you want with the `data`, e.g.:
                
                do {


                } catch {
                    print(error) // parsing error
                    
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("responseString = \(responseString)")
                    } else {
                        print("unable to parse response as string")
                    }
                }
            }
            
            
        task.resume()
        
           
    }
    
    struct LoginResponse: Codable {
        let message : String
        let token : String
    }
    
    func login(username: String, password: String) {
print("jhsafasd")
            let url = URL(string: "http://localhost:3000/user/login")!
            var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")

            request.httpMethod = "POST"

        let postString = ["username": username, "password": password] as [String : Any]

        
        let jsonData = try? JSONSerialization.data(withJSONObject: postString)
        
        request.httpBody = jsonData
            

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    error == nil
                else {                                                               // check for fundamental networking error
                    print("error", error ?? URLError(.badServerResponse))
                    return
                }
                
                guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                    print("statusCode should be 2xx, but is \(response.statusCode)")
                    print("response = \(response)")
                    return
                }
                
                // do whatever you want with the `data`, e.g.:
                
                do {
                    
                    DispatchQueue.main.async {
                        UserDefaults.standard.removeObject(forKey:"token")
                    }
                    
                    let response = try JSONDecoder().decode(LoginResponse.self, from: data)
                    // Access Shared Defaults Object
                    print(response)
                    let userDefaults = UserDefaults.standard

                    // Write/Set Value

                    
                    userDefaults.set(response.token, forKey: "token")
                  

                } catch {
                    print(error) // parsing error
                    
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("responseString = \(responseString)")
                    } else {
                        print("unable to parse response as string")
                    }
                }
            }
            
            
        task.resume()
        
           
    }
    func loginNonPrem(username: String, password: String) {
//        let encoder = JSONEncoder()
//        if let encoded = try? encoder.encode(user) {
//            UserDefaults.standard.set(encoded, forKey: "user")
//        }
        createToken(password: password)

        
    }

}
