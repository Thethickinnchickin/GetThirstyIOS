//
//  WaterService.swift
//  GetThirsty
//
//  Created by Matt Reiley on 4/17/23.
//


import Foundation
import UserNotifications

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
    func getWater() -> Water{
        let decoder  = JSONDecoder()
        let water = UserDefaults.standard.object(forKey: "water")
        if(water != nil) {
            var thing : Water  = try! decoder.decode(Water.self, from: UserDefaults.standard.object(forKey: "water") as! Data)
            if !compareDates(date1: thing.lastIntake!) {
                DispatchQueue.main.async {
                    self.updateWater(water: thing)
                }
                return thing
            } else {
                DispatchQueue.main.async {
                    thing.lastIntake = Date()
                    thing.actualWtOz = 0
                    thing.caffeineIntake = 0
                    self.updateWater(water: thing)
                }
                return thing
            }
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
        do {
            UserDefaults.standard.set(waterEn, forKey: "water")
        }
        
    }

    func updateNotif(notifON: Bool) {
        let encoder = JSONEncoder()
        let notifEn = try! encoder.encode(notifON)
        do {
            UserDefaults.standard.set(notifEn, forKey: "notif")
        }
    }

    func getNotif() -> Bool {
        let decoder  = JSONDecoder()
        let water = UserDefaults.standard.bool(forKey: "notif")
        
        if(water) {
            let notif = try! decoder.decode(Bool.self, from: UserDefaults.standard.object(forKey: "notif") as! Data)
            return notif
        } else {
            return false
        }
    }

    // Check if the user has authorized notifications or not
    func checkNotificationAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            let isAuthorized = settings.authorizationStatus == .authorized
            completion(isAuthorized)
        }
    }

    // Get today's date as string
    func todayString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: Date())
    }

    // Get date as string
    func dateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }

    //returns false if date is later than today
    //returns true if date os earlier
    func compareDates(date1: Date) -> Bool {
        let calendar = Calendar.current
        let date2 = Date()

        let day1 = calendar.component(.day, from: date1)
        let day2 = calendar.component(.day, from: date2)

        if day1 == day2 {
            // the two dates have the same day
            print("SAMEEEE")
           return false
        } else if day1 > day2 {
            // date1 is later in the month than date2
            return false
        } else {
            // date2 is later in the month than date1
            return true
        }
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
