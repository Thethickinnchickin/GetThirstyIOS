//
//  Token.swift
//  GetThirsty
//
//  Created by Matt Reiley on 4/19/23.
//

import Foundation
import BCrypt

func createToken(password: String) {
    do {
        let salt = try BCrypt.Salt()
        let hashed = try BCrypt.Hash(password, salt: salt)
        print("Hashed result is: \(hashed)")
    }
    catch {
        print("An error occured: \(error)")
    }
}

func check(password: String) {
    do {

        let hashed = try BCrypt.Check("Gay", hashed: "")
        print("Hashed result is: \(hashed)")
    }
    catch {
        print("An error occured: \(error)")
    }
}
