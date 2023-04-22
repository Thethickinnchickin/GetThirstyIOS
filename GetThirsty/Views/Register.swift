//
//  Register.swift
//  GetThirsty
//
//  Created by Matt Reiley on 4/14/23.
//

import SwiftUI

struct Register: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var username = ""
    @State private var password = ""
    @State private var height = 0
    @State private var weight = 0
    @State private var age = 0
    @State private var caffeine = 0
    @State private var gender = ""
    @State private var Genders = ["male", "female"]

    enum Gender: String, CaseIterable {
        case male = "Male"
        case female = "Female"
    }

    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(.blue)
                .padding(.top, 100)


            Text("Create Account")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)

            TextField("Username", text: $username)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)

            SecureField("Password", text: $password)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)
            HStack {
                VStack {
                    Text("Height").font(.subheadline)
                    Text("Selected Number: \(height)").font(.subheadline)
                    
                    Picker("Pick a Number", selection: $height) {
                        ForEach(0...99, id: \.self) { height in
                            Text("\(height)")
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    .frame(width: 100, height: 50)
                }
                
                VStack {
                    Text("Weight").font(.subheadline)
                    Text("Selected Number: \(weight)").font(.subheadline)
                    
                    Picker("Pick a Number", selection: $weight) {
                        ForEach(0...500, id: \.self) { weight in
                            Text("\(weight)")
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    .frame(width: 100, height: 50)
                }

                VStack {
                    Text("Age").font(.subheadline)
                    Text("Selected Number: \(age)").font(.subheadline)
                    
                    Picker("Pick a Number", selection: $age) {
                        ForEach(0...99, id: \.self) { age in
                            Text("\(age)")
                        }
                    }
           
  
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    .frame(width: 100, height: 50)
                }
                
                VStack {
                    Text("Caffeine per day").font(.subheadline)
                    Text("Selected Number: \(caffeine)").font(.subheadline)
                    
                    Picker("Pick a Number", selection: $caffeine) {
                        ForEach(0...999, id: \.self) { caffeine in
                            Text("\(caffeine)")
                        }
                    }
           
  
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    .frame(width: 100, height: 50)
                }
 
 
                

            }

            Picker("Gender", selection: $gender) {
                ForEach(Genders, id: \.self) { gender in
                    Text("\(gender)")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)

            Button(action: {
                UserService().register(username: self.username, password: self.password, height: self.height, weight: self.weight, age: self.age, gender: self.gender, caffeine: self.caffeine)
                
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Create Account")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            Spacer()
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .edgesIgnoringSafeArea(.all)
        
    }
    

}

struct RegistrationPage_Previews: PreviewProvider {
    static var previews: some View {
        Register()
    }
}
