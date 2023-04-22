//
//  WaterService.swift
//  GetThirsty
//
//  Created by Matt Reiley on 4/17/23.
//

import Foundation

struct Water: Codable {
    var totalDailyWaterOz: Int?
    var caffeineIntake: Int?
    var actualWtOz: Int?
    var lastIntake: Date?
    var userID: String?
    var isPremium: Bool?
    var height: Int?
    var weight: Int?
    var age: Int?
    var gender: String?
    var userLive: Bool
}

struct WaterResponse: Codable {
    let success: Bool
    let water: Water
    
}

class WaterService {
    func getWater(token: String, completion:@escaping (Water) -> ()) {
        let url = URL(string: "http://localhost:3000/water")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        request.httpMethod = "GET"
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
                




        
        
        

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
                let response = try JSONDecoder().decode(WaterResponse.self, from: data)
                completion(response.water)


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
    
    func getWaterNon() -> Water {
        let decoder  = JSONDecoder()
        let water = UserDefaults.standard.object(forKey: "water")
        if(water != nil) {
            return try! decoder.decode(Water.self, from: UserDefaults.standard.object(forKey: "water") as! Data)
        } else {
            return Water(userLive: false)
        }

        

    }
    func getLastIntake() -> Date {
        let decoder  = JSONDecoder()
        let water = UserDefaults.standard.object(forKey: "water")
        if(water != nil) {
           let wat = try! decoder.decode(Water.self, from: UserDefaults.standard.object(forKey: "water") as! Data)
            return wat.lastIntake ?? Date()
        } else {
            return Date()
        }

        

    }
    
    func updateWater(water: Water) {
        let encoder = JSONEncoder()
        let waterEn = try! encoder.encode(water)
        print(waterEn)
        try! UserDefaults.standard.set(waterEn, forKey: "water")

    }
    func getRid() {
        DispatchQueue.main.async {
            UserDefaults.standard.removeObject(forKey:"water")
            UserDefaults.standard.removeObject(forKey:"token")
            
        }
        print(UserDefaults.standard.object(forKey: "water") as Any)
    }
    
    func calculateDailyWaterIntake(height: Int, weight: Int, age: Int, gender: String, caffeineIntake: Int) -> Int {
        
        var waterIntake: Int = 0
        
        // Convert weight to kilograms
        let weightInKg = Double(weight) / 2.20462
        
        // Convert height to centimeters
        let heightInCm = Double(height) * 2.54
        
        // Calculate base water intake based on weight
        waterIntake += Int(weightInKg / 2)
        
        // Adjust water intake based on height
        if heightInCm < 150 {
            waterIntake -= 8
        } else if heightInCm < 180 {
            print("Height")
            waterIntake += 0
        } else {
            waterIntake += 8
        }
        
        // Adjust water intake based on age
        if age < 30 {
            waterIntake += 0
            print("Age")
        } else if age < 55 {
            waterIntake += 4
        } else {
            waterIntake += 8
        }
        
        // Adjust water intake based on gender
        if gender == "Female" {
            waterIntake -= 4
            
        } else {
            waterIntake += 0
            print("Gender")
        }
        
        
        
        // Adjust water intake based on caffeine intake
        let caffeineOunces = (Double(caffeineIntake) / 100.0) * 8
        waterIntake += Int(caffeineOunces)
        print("Caffeine " + String(caffeineOunces))

        return waterIntake
    }

}
