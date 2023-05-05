//
//  Notif.swift
//  GetThirsty
//
//  Created by Matt Reiley on 5/4/23.
//

import SwiftUI


struct Notif: View {
    @State private var notificationsEnabled = WaterService().getNotif()
    
    var body: some View {
        VStack {
            Toggle(isOn: $notificationsEnabled) {
                Text("Enable Notifications")
            }
            .padding()
            
            Button(action: {
                // TODO: Implement code to handle saving notification settings

                DispatchQueue.main.async {
                    WaterService().updateNotif(notifON: self.notificationsEnabled)
                    self.notificationsEnabled = WaterService().getNotif()
                    // second
                    if(self.notificationsEnabled == true) {
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        let content = UNMutableNotificationContent()
                        content.title = "Congrats you've completed your goal"
                        content.subtitle = "Thirsty Hoe"
                        content.sound = UNNotificationSound.default
                        
                        
                        
                        for i in stride(from: 8, to: 23, by: 2)  {

                            DispatchQueue.main.async {
                                var dateComponents = DateComponents()
                                dateComponents.hour = i
                                dateComponents.minute = 0
                                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

                                // Create the notification request
                                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                                UNUserNotificationCenter.current().add(request)
                            }

                        }
                        



                        // show this notification five seconds from now

                        
//                        let date = Date(timeIntervalSinceNow: 60)
//                        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: tenAM), repeats: false)
//                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                        // add our notification request
                        
                        
                    } else {
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    }

                }
                
            }) {
                Text("Save")
                    .padding()
            }
        }
        .onAppear{
            self.notificationsEnabled = WaterService().getNotif()
        }
        .navigationBarTitle("Notification Settings")
    }
}
