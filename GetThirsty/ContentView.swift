//
//  ContentView.swift
//  GetThirsty
//
//  Created by Matt Reiley on 4/13/23.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var response: Water = WaterService().getWater()
    @State private var caffeineAdd = 0
    @State private var amountLeft = 0
    @State private var waterAdd = 0
    @State private var height: Int = 0
    @State private var weight: Int = 0
    @State private var age: Int = 0
    @State private var gender: String = "Male"
    @State private var intake : Date = WaterService().getLastIntake()
    @State private var notifsEn : Bool = false
    @State private var isLoading : Bool = true
    @State private var plusImg : String = "plus.app.fill"
    @State private var isEditing: Bool = false

    var body: some View {
        NavigationStack {
            if isLoading {
                Text("GetThirsty")
                    // Set the custom font and size for the text
                    .font(.custom("DancingScript-Regular", size: 46))
                    // Set the text color to a light blue color
                    .foregroundColor(Color(red: 0.4627, green: 0.8392, blue: 1.0))
                    // When the view appears, run an animation to set `isLoading` to false
                    .onAppear {
                        // Define the easing animation with a duration of 2 seconds
                        let baseAnimation = Animation.easeIn(duration: 2.0)
                        // Animate the `isLoading` variable with the easing animation
                        withAnimation(baseAnimation) {
                            self.isLoading = false
                        }
                    }

            } else {
                VStack {

                    // The HStack defines a layout with two VStacks and some buttons.
                    HStack {
                        
                        // The first VStack has a HStack with a button that requests permission for notifications or displays a NavigationLink and a button.
                        VStack{
                            HStack {
                                if notifsEn == false {
                                    Button("Request Permission") {

                                        // This block of code requests permission for notifications and prints "All set!" if successful or an error message if unsuccessful.
                                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                            if success {
                                                print("All set!")
                                            } else if let error = error {
                                                print(error.localizedDescription)
                                            }
                                        }
                                    }
                                } else {
                                    Spacer()
                                    NavigationLink(destination: Notif()) {
                                        Image(systemName: "checkmark.seal")
                                            .font(.title)
                                    }
                                    Button(action: {
                                        self.isEditing = true
                                    }) {
                                        Image(systemName: "person.crop.circle")
                                            .font(.title)
                                    }
                                }
                            }
                            
                            // This block of code displays the current date as a string using a custom font.
                            Text(WaterService().todayString())
                                .font(.custom("Righteous-Regular", size: 46))
                        }
                        
                        Spacer()
                    }
                    
                    // This block of code sets the text color to white and adds a gradient background to the HStack.
                    .foregroundColor(.white)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(red: 0.4627, green: 0.8392, blue: 1.0), Color.blue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                }

                
                if !response.userLive || isEditing {

                    VStack {
                        HStack {
                            Spacer()
                            // Back button
                            Button(action: {
                                // Add any desired action here
                                self.isEditing = false
                            }) {
                                HStack {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 14, weight: .semibold))
                                    Text("Back")
                                        .font(.system(size: 14, weight: .semibold))
                                    Spacer()
                                }
                            }
                        }
                        // App name
                        Text("GetThirsty")
                            .font(.custom("DancingScript-Regular", size: 46))
                            .foregroundColor(Color.blue)
                            .padding()
                        // Form title
                        Text("Enter your information:")
                            .font(.headline)
                            .padding(.bottom, 20)
                        // Form fields
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Height (in inches):")
                                TextField("Enter height", value: $height, formatter: NumberFormatter())
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                            }
                            HStack {
                                Text("Weight (in lbs):")
                                TextField("Enter weight", value: $weight, formatter: NumberFormatter())
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                            }
                            HStack {
                                Text("Age:")
                                TextField("Enter age", value: $age, formatter: NumberFormatter())
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                            }
                            HStack {
                                Text("Gender:")
                                Picker(selection: $gender, label: Text("Gender")) {
                                    Text("Male").tag("Male")
                                    Text("Female").tag("Female")
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                        // Save button
                        Button(action: {
                            // Perform action after button is tapped
                            DispatchQueue.main.async {
                                addInfo()
                            }
                            print(self.response)

                            self.isEditing = false
                        }, label: {
                            VStack {
                                // Warning message
                                Text("Warning: Your drinking data will be reset for the day if you change your info.")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 12))
                                // Save button label
                                Text("Save")
                                    .frame(width: 120, height: 40)
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .cornerRadius(20)
                            }
                        })
                        Spacer()
                    }
                    // Set the frame and background of the VStack
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .edgesIgnoringSafeArea(.all)
                    .navigationBarTitle("", displayMode: .inline)
                    Spacer()

                    
                } else {

                    
                    VStack {
                        // Top bar with the date
                        Text("GetThirsty").font(.custom("DancingScript-Regular", size: 46)).foregroundColor(Color.blue)
                            .padding()
           
                        
                        VStack {
                            HStack {
                                Text("Add Caffeine:")
                                Text("\(caffeineAdd)")
                                    .font(.custom("Righteous-Regular", size: 50))
                                    .foregroundColor(Color(red: 0.91, green: 0.69, blue: 0.51))
                                Text("mg")

                            }
                            .foregroundColor(Color.black)
                            .font(.custom("Righteous-Regular", size: 35))
                                .fontWeight(.bold)

                            
                            HStack {
                                HStack {
                                    Button(action: {
                                        if(caffeineAdd >= 10) {
                                            caffeineAdd -= 10
                                        }
                                        
                                    }) {
                                        VStack {
                                            Text("-10")
                                            Image(systemName: "minus.rectangle")
                                                
                                                .font(.largeTitle)
                                        }
                                        .foregroundColor(.red)

                                    }
                                    .padding()
                                    Button(action: {
                                        if(caffeineAdd > 0) {
                                            caffeineAdd -= 1
                                        }
                                        
                                    }) {
                                        VStack {
                                            Text("-1")
                                            Image(systemName: "minus.rectangle")
                                                .font(.largeTitle)
                                        }
                                        .foregroundColor(.red)
                                    }
                                    .padding()

                                }

                                HStack {
                                    Button(action: {
                                        caffeineAdd += 1
                                    }) {
                                        VStack {
                                            Text("+1")
                                            Image(systemName: "plus.rectangle")
                                                .foregroundColor(.blue)
                                                .font(.largeTitle)
                                        }
                                    }
                                    .padding()
                                    Button(action: {
                                        caffeineAdd += 10
                                    }) {
                                        VStack {
                                            Text("+10")
                                            Image(systemName: "plus.rectangle")
                                                .foregroundColor(.blue)
                                                .font(.largeTitle)
                                        }

                                    }
                                    .padding()
                                }

                            }
                            if caffeineAdd > 0 {
                                Button(action: {
                                    addCaf()
                                }, label: {
                                    HStack {
                                        Text("Add").font(.custom("Righteous-Regular", size: 25))
                                        Image(systemName: "cup.and.saucer.fill")

                                            .font(.largeTitle)

                                    }.foregroundColor(Color(red: 0.91, green: 0.69, blue: 0.51))

                                    
                                })
                            }

                        }
                        //Spacer()
                        VStack {
                            HStack {
                                Text("Add Water: ")
                                Text("\(waterAdd)")
                                    .font(.custom("Righteous-Regular", size: 50))
                                    .foregroundColor(Color.blue)
                                    
                                Text("Oz")
                            }
                            .foregroundColor(Color.black)
                            .font(.custom("Righteous-Regular", size: 35))
                                .fontWeight(.bold)
                         
                            
                            HStack {
                                Button(action: {
                                    if(waterAdd >= 10) {
                                        waterAdd -= 10
                                    }
                                    
                                }) {
                                    VStack {
                                        Text("-10")
                                        Image(systemName: "minus.rectangle")
                                            .font(.largeTitle)
                                    } .foregroundColor(.red)

                                }
                                .padding()
                                Button(action: {
                                    if(waterAdd > 0) {
                                        waterAdd -= 1
                                    }
                                    
                                }) {
                                    VStack {
                                        Text("-1")
                                        Image(systemName: "minus.rectangle")
                                            .font(.largeTitle)
                                    } .foregroundColor(.red)
                                }
                                .padding()
              
                                Button(action: {
                                    
                                    if (response.totalDailyWaterOz ?? 0) - ((response.actualWtOz ?? 0) + waterAdd + 1) >= 0 {
                                        waterAdd += 1
                                    }
                                   
                                    
                                    
                                }) {
                                    VStack {
                                        Text("+1")
                                        Image(systemName: "plus.rectangle")
                                            .foregroundColor(.blue)
                                            .font(.largeTitle)
                                    }
                                }
                                .padding()
  
                                Button(action: {

                                    if (response.totalDailyWaterOz ?? 0) - ((response.actualWtOz ?? 0) + waterAdd + 10) >= 0 {
                                        waterAdd += 10
                                    }
                                   
                                    
                                    
                                    
                                }) {
                                    VStack {
                                        Text("+10")
                                        Image(systemName: "plus.rectangle")
                                            .foregroundColor(.blue)
                                            .font(.largeTitle)
                                    }

                                }
                                .padding()


                            }
                            if waterAdd > 0 && (response.totalDailyWaterOz ?? 0) - (response.actualWtOz ?? 0) > 0 {
                                Button(action: {
                                    addWater()
                                }, label: {
                                    HStack {
                                        Text("Add").font(.custom("Righteous-Regular", size: 25))
                                        Image(systemName: "drop.fill")
                                            .font(.largeTitle)

                                    }.foregroundColor(Color.blue).padding()

                                    
                                })
                            }
                        }
                    
                    }
                    //Background
                    .frame(width: 900.0)
                    .background(Color.white)
                    .onAppear {
                        self.response = WaterService().getWater()
                    }
                    Spacer()
                    
                    if(response.totalDailyWaterOz ?? 0) - (response.actualWtOz ?? 0) > 0 {
                        HStack {
                            Spacer()
                            VStack {
                                Text("Water(oz)")
                                Text(String((response.actualWtOz ?? 0)))
                            }.font(.custom("Righteous-Regular", size: 16))
                            VStack {

                                Text("Drink Up")
                                HStack {
                                    Spacer()
                                    Text("Only")
                                    Text(String((response.totalDailyWaterOz ?? 0) - (response.actualWtOz ?? 0)) ).foregroundColor(Color.white)
                                    Text("oz")
                                    Text("Left")
                                    Spacer()
                                }
                                
                                
                            }
                            VStack {
                                Text("Caffeine(mg)")
                                Text(String((response.caffeineIntake ?? 0)))
                            }.font(.custom("Righteous-Regular", size: 16))
                            
                            Spacer()
                        

                    }
                        .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(red: 0.4627, green: 0.8392, blue: 1.0), Color.blue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                        .frame(alignment: .center)
                    .font(.custom("Righteous-Regular", size: 26))
                        
                    
                    } else {
                        
                        VStack{
                            Text("Complete")
                                .foregroundColor(Color(.sRGB, red: 1.0, green: 0.84, blue: 0.0, opacity: 1.0))
                            HStack {
                                Spacer()
                                Text("You Thirsty")
                                    .font(.custom("RubikWetPaint-Regular", size: 26))
                                    .foregroundColor(Color.blue)
                                
                                
                                Spacer()
                            }
                        }
                            

                           
                            
                            
                        
                        .padding()
                        .background(
                            LinearGradient(
                                
                                gradient: Gradient(colors: [Color.green, Color(.sRGB, red: 0.56, green: 0.93, blue: 0.56, opacity: 1.0)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                                
                                
                            )
                        )
                        .font(.custom("Righteous-Regular", size: 46))
                        .onAppear {
                            // second
                            let content = UNMutableNotificationContent()
                            content.title = "Congrats you've completed your goal"
                            content.subtitle = "Thirsty Hoe"
                            content.sound = UNNotificationSound.default
                            

                            // show this notification five seconds from now
                            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60 * 120, repeats: true)

                            
                            let date = Date(timeIntervalSinceNow: 60)
                            let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date), repeats: false)
                            let request = UNNotificationRequest(identifier: "completed", content: content, trigger: trigger)

                            // add our notification request
                            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                            UNUserNotificationCenter.current().add(request)
                        }
                        .onDisappear{
                            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                        }
                        
                        
                        
                    }
        
                        
                
                }
    
            }
                


        }
        
        .onAppear {

            if WaterService().compareDates(date1: self.intake) {
                self.response.caffeineIntake = 0
                self.response.actualWtOz = 0
                self.intake = Date()
                self.response.lastIntake = Date()
            }
            
            DispatchQueue.main.async {
                WaterService().updateWater(water: self.response)
                updateData()
                WaterService().checkNotificationAuthorization { isAuthorized in
                    if isAuthorized {
                        // Notifications are authorized
                        self.notifsEn = true
                    } else {
                        // Notifications are not authorized
                        self.notifsEn = false
                    }
                }
            }
        }
        
    

    }
    
    
    

    
    func CheckingDate() {
        if WaterService().compareDates(date1: self.intake) {
            self.response.caffeineIntake = 0
            self.response.actualWtOz = 0
            self.intake = Date()
            self.response.lastIntake = Date()
        }
        
        DispatchQueue.main.async {
            WaterService().updateWater(water: self.response)
            updateData()
        }
    }
    
    func addInfo() {
        let water : Water = Water(totalDailyWaterOz: WaterService().calculateDailyWaterIntake(height: self.height, weight: self.weight, age: self.age, gender: self.gender, caffeineIntake: 0), caffeineIntake: 0,
                                  actualWtOz: 0,
                                  lastIntake: Date(),
                                  isPremium: false,
                                  height: self.height,
                                  weight: self.weight,
                                  age: self.age,
                                  gender: self.gender,
                                  userLive: true)
        DispatchQueue.main.async {
            WaterService().updateWater(water: water)
            self.response = WaterService().getWater()
        }

        
        
    }
    


    func addCaf() {
        let age : Int = self.response.age ?? 0
        let height : Int = self.response.height ?? 0
        let weight : Int = self.response.weight ?? 0

        let caffeineIntake : Int = self.response.caffeineIntake ?? 0
        let data : Int = WaterService().calculateDailyWaterIntake(height: height, weight: weight, age: age, gender: gender, caffeineIntake: (caffeineIntake + caffeineAdd))
        
        let water : Water = Water(totalDailyWaterOz: data,
                                  caffeineIntake: (self.response.caffeineIntake ?? 0) + caffeineAdd,
                                  actualWtOz: self.response.actualWtOz,
                                  lastIntake: self.intake,
                                  isPremium: false,
                                  height: self.response.height,
                                  weight: self.response.weight,
                                  age: self.response.age,
                                  gender: self.response.gender,
                                  userLive: true)
        DispatchQueue.main.async {
            WaterService().updateWater(water: water)
            self.response = WaterService().getWater()
        }
        self.caffeineAdd = 0

    }
    func addWater() {
        let actuWater : Int = (self.response.actualWtOz ?? 0) + waterAdd
        let age : Int = self.response.age ?? 0
        let height : Int = self.response.height ?? 0
        let weight : Int = self.response.weight ?? 0
        let caffeineIntake : Int = self.response.caffeineIntake ?? 0
        let data : Int = WaterService().calculateDailyWaterIntake(height: height, weight: weight, age: age, gender: gender, caffeineIntake: (caffeineIntake))
        let water : Water = Water(totalDailyWaterOz: data,
                                  caffeineIntake: (self.response.caffeineIntake ?? 0),
                                  actualWtOz: actuWater,
                                  lastIntake: self.intake,
                                  isPremium: false,
                                  height: self.response.height,
                                  weight: self.response.weight,
                                  age: self.response.age,
                                  gender: self.response.gender,
                                  userLive: true)
        
        DispatchQueue.main.async {

            WaterService().updateWater(water: water)
            CheckingDate()
            updateData()
        }
        self.waterAdd = 0
        self.plusImg = "plus.app.fill"
    }
    
    
    func updateData() {
        self.response = WaterService().getWater()
    }
    

    

    func getWaterLeft() -> Int {
        return (response.totalDailyWaterOz ?? 0) - (response.actualWtOz ?? 0)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
