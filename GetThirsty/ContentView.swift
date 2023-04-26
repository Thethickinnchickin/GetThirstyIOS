//
//  ContentView.swift
//  GetThirsty
//
//  Created by Matt Reiley on 4/13/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var decoder = JSONDecoder()
    @State var response: Water = WaterService().getWaterNon()

    @State private var caffeineAdd = 0
    @State private var amountLeft = 0
    @State private var waterAdd = 0
    @State private var height: Int = 0
    @State private var weight: Int = 0
    @State private var age: Int = 0
    @State private var gender: String = "Male"
    @State private var isUpdating : Bool = false
    @State private var intake : Date = WaterService().getLastIntake()
    @State private var isLoading : Bool = true
    @State private var plusImg : String = "plus.app.fill"


    
    
    @State var flag = false

    var body: some View {



        NavigationStack {
            if isLoading {
                Text("GetThirsty")
                    .font(.custom("DancingScript-Regular", size: 46))
                    .foregroundColor(Color.blue)
                    .onAppear {
                        let baseAnimation = Animation.easeIn(duration: 2.0)

                    
                    withAnimation(baseAnimation) {
                        self.isLoading = false
                    }

                }
            } else {
  
                
                if response.userLive {
                    VStack {
                        // Top bar with the date
                        HStack {
                            Spacer()
                            Text(todayString())
                                .font(.custom("Righteous-Regular", size: 46))
                            Spacer()
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 0.4627, green: 0.8392, blue: 1.0), Color.blue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        
                       
                    }
                    VStack {
                        
                        Button("Reset") {
                            WaterService().getRid()
                            self.response = WaterService().getWaterNon()

                        }
         
                    
                        Text("GetThirsty").font(.custom("DancingScript-Regular", size: 46)).foregroundColor(Color.white)
                        Spacer()
                        
                        VStack {
                            HStack {
                                Text("Add Caffeine:")
                                Text("\(caffeineAdd)")
                                    .font(.custom("Righteous-Regular", size: 50))
                                    .foregroundColor(Color(red: 0.4, green: 0.26, blue: 0.13))
                                Text("mg")

                            }
                            .foregroundColor(Color.white)
                            .font(.custom("Righteous-Regular", size: 35))
                                .fontWeight(.bold)

                            
                            HStack {
                                HStack {
                                    Button(action: {
                                        if(caffeineAdd > 10) {
                                            caffeineAdd -= 10
                                        }
                                        
                                    }) {
                                        VStack {
                                            Text("-10")
                                            Image(systemName: "minus.rectangle")
                                                .foregroundColor(.blue)
                                                .font(.largeTitle)
                                        }

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
                                                .foregroundColor(.blue)
                                                .font(.largeTitle)
                                        }
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
                                        Image(systemName: "plus.app.fill")
                                            .foregroundColor(Color.white)
                                            .font(.largeTitle)

                                    }

                                    
                                })
                            }

                        }
                        Spacer()
                        VStack {
                            HStack {
                                Text("Add Water: ")
                                Text("\(waterAdd)")
                                    .font(.custom("Righteous-Regular", size: 50))
                                    .foregroundColor(Color.blue)
                                    
                                Text("Oz")
                            }
                            .foregroundColor(Color.white)
                            .font(.custom("Righteous-Regular", size: 35))
                                .fontWeight(.bold)
                         
                            
                            HStack {
                                Button(action: {
                                    if(waterAdd > 10) {
                                        waterAdd -= 10
                                    }
                                    
                                }) {
                                    VStack {
                                        Text("-10")
                                        Image(systemName: "minus.rectangle")
                                            .foregroundColor(.blue)
                                            .font(.largeTitle)
                                    }

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

                            }
                            if waterAdd > 0 && (response.totalDailyWaterOz ?? 0) - (response.actualWtOz ?? 0) > 0 {
                                Button(action: {
                                    addWater()
                                }, label: {
                                    HStack {
                                        Text("Add").font(.custom("Righteous-Regular", size: 25))
                                        Image(systemName: "plus.app.fill")
                                            .foregroundColor(Color.white)
                                            .font(.largeTitle)

                                    }

                                    
                                })
                            }
                            Spacer()
                        }
                    
                    }
                    .frame(width: 900.0, height: 580.0)
                    .background(Color.black)

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
                        
                        VStack {
                            Spacer()
                            Text("Complete")
                                .foregroundColor(Color(.sRGB, red: 1.0, green: 0.84, blue: 0.0, opacity: 1.0))
                            HStack {
                                Spacer()
                                Text("You Thirsty")
                                    .font(.custom("RubikWetPaint-Regular", size: 26))
                                    .foregroundColor(Color.blue)
                                
                                
                                Spacer()
                            }
                            Spacer()
                            
                            
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
                        
                        
                    }

                    
                } else {
                    VStack {
                            Text("Enter your information:")
                                .font(.headline)
                                .padding(.bottom, 20)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Height (in cm):")
                                    TextField("Enter height", value: $height, formatter: NumberFormatter())
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .keyboardType(.numberPad)
                                }
                                
                                HStack {
                                    Text("Weight (in kg):")
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
                            
                            Button(action: {
                                // Perform action after button is tapped
                                addInfo()
                            }, label: {
                                Text("Save")
                                    .frame(width: 120, height: 40)
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .cornerRadius(20)
                            })
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white)
                        .edgesIgnoringSafeArea(.all)
                        .navigationBarTitle("", displayMode: .inline)
                        
                
                }
            }
                


        }
        
        .onAppear {
            if compareDates(date1: self.intake) {
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
        
    

    }
    
    func backButton() {
        DispatchQueue.main.async {
            updateData()
        }

        
    }
    
    func CheckingDate() {
        if compareDates(date1: self.intake) {
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
        }

        self.response = WaterService().getWaterNon()
        
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
            self.response = WaterService().getWaterNon()
        }
        self.caffeineAdd = 0

    }
    func addWater() {
        let actuWater : Int = (self.response.actualWtOz ?? 0) + waterAdd
        
        self.isUpdating = true
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
        self.isUpdating = false
    }
    
    
    func updateData() {
        self.isUpdating = true
        self.response = WaterService().getWaterNon()
        self.isUpdating = false
    }
    

    
    func todayString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: Date())
    }
    func dateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
    func compareDates(date1: Date) -> Bool {
        let calendar = Calendar.current
        let date2 = Date()

        let day1 = calendar.component(.day, from: date1)
        let day2 = calendar.component(.day, from: date2)

        if day1 == day2 {
            // the two dates have the same day
           return false
        } else if day1 > day2 {
            // date1 is later in the month than date2
            return false
        } else {
            // date2 is later in the month than date1
            return true
        }
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
