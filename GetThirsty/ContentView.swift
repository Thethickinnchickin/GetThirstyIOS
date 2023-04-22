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
                        .foregroundColor(.black)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.white, Color.blue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        
                       
                    }

                    


                    Button("Reset") {
                        WaterService().getRid()
                        self.response = WaterService().getWaterNon()
            
                    }
                    Text("GetThirsty").font(.custom("DancingScript-Regular", size: 46)).foregroundColor(Color.blue)

                    
                    VStack {
                        HStack {
                            Text("Add Caffeine:")
                            Text("\(caffeineAdd)").foregroundColor(Color.blue)
                            Text("mg")

                        }
                        .font(.custom("Righteous-Regular", size: 35))
                            .fontWeight(.bold)
                            .padding()

                        
                        HStack {
                            Button(action: {
                                caffeineAdd -= 1
                            }) {
                                Image(systemName: "minus.rectangle")
                                    .foregroundColor(.blue)
                                    .font(.largeTitle)
                            }
                            .padding()
                            
                            Button(action: {
                                caffeineAdd += 1
                            }) {
                                Image(systemName: "plus.rectangle")
                                    .foregroundColor(.blue)
                                    .font(.largeTitle)
                            }
                            .padding()
                        }
                        if caffeineAdd > 0 {
                            Button(action: {
                                addCaf()
                            }, label: {
                                HStack {
                                    Text("Add").font(.custom("Righteous-Regular", size: 35))
                                    Image(systemName: "plus.app.fill")
                                        .foregroundColor(Color.blue)
                                        .font(.largeTitle)

                                }

                                
                            })
                        }

                    }
                    VStack {
                        HStack {
                            Text("Add Water: ")
                            Text("\(waterAdd)").foregroundColor(Color.blue)
                                
                            Text("Oz")
                        }
                        .font(.custom("Righteous-Regular", size: 35))
                            .fontWeight(.bold)
                            .padding()
                        
                        HStack {
                            Button(action: {
                                
                                waterAdd -= 1
                            }) {
                                Image(systemName: "minus.rectangle")
                                    .foregroundColor(.blue)
                                    .font(.largeTitle)
                            }
                            .padding()
                            
                            Button(action: {
                                waterAdd += 1
                            }) {
                                Image(systemName: "plus.rectangle")
                                    .foregroundColor(.blue)
                                    .font(.largeTitle)
                            }
                            .padding()

                        }
                        HStack {
                            if waterAdd > 0 {
                                Button(action: {
                                    addWater()
                                }, label: {
                                    HStack {
                                        Text("Add").font(.custom("Righteous-Regular", size: 35))
                                        Image(systemName: "plus.app.fill")
                                            .foregroundColor(Color.blue)
                                            .font(.largeTitle)

                                    }

                                    
                                })
                               
            
                            }
                        }
                    }
                    Spacer()
                    if self.isUpdating {
                        Text("Updating")
                    } else {
                        VStack {
              
                            Text("Drink Up")
                            HStack {
                                Text("Only")
                                Text(String((response.totalDailyWaterOz ?? 0) - (response.actualWtOz ?? 0)) ).foregroundColor(Color.blue)
                                Text("Oz")
                                Text("Left")
                            }
                            
                            
                        }.font(.custom("Righteous-Regular", size: 46))
                        Spacer()
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
            


        }.onAppear {
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
    
    public func backButton() {
        DispatchQueue.main.async {
            updateData()
        }

        
    }
    
    public func addInfo() {
        let water : Water = Water(totalDailyWaterOz: WaterService().calculateDailyWaterIntake(height: self.height, weight: self.weight, age: self.age, gender: self.gender, caffeineIntake: 0), caffeineIntake: 0,
                                  actualWtOz: 0,
                                  lastIntake: yesterday(),
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
    func yesterday() -> Date {
        let yesterdayDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        return yesterdayDate
    }
    
    public func addCaf() {
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
    public func addWater() {
        self.isUpdating = true
        let age : Int = self.response.age ?? 0
        let height : Int = self.response.height ?? 0
        let weight : Int = self.response.weight ?? 0

        let caffeineIntake : Int = self.response.caffeineIntake ?? 0
        let data : Int = WaterService().calculateDailyWaterIntake(height: height, weight: weight, age: age, gender: gender, caffeineIntake: (caffeineIntake))

        
        let water : Water = Water(totalDailyWaterOz: data,
                                  
                                  caffeineIntake: (self.response.caffeineIntake ?? 0),
                                  actualWtOz: (self.response.actualWtOz ?? 0) + waterAdd,
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
        self.waterAdd = 0
        self.plusImg = "plus.app.fill"
        self.isUpdating = false
    }
    
    
    public func updateData() {
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
