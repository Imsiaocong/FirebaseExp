//
//  Server.swift
//  FirebaseLogin
//
//  Created by Di Wang on 2017/2/4.
//  Copyright © 2017年 Di Wang. All rights reserved.
//

import Firebase

class Server {
    enum AuthResponse {
        case success
        case failure(String)
    }
    
    var auth: FIRAuth? {
        return FIRAuth.auth()
    }
    
    func login(withEmail email: String, password: String, completion: @escaping (AuthResponse) -> ()) {
        guard let auth = Server().auth else { return completion(.failure("Couldn't even get \"FIRAuth.auth()\"! This is a Firebase problem. Better contact their developer support team.")) }
        auth.signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(.failure(error.localizedDescription))
            } else {
                completion(.success)
            }
        }
    }
    
    func createUser(withEmail email: String, password: String, completion: @escaping (AuthResponse) ->()){
        guard let auth = Server().auth else { return completion(.failure("Couldn't even get \"FIRAuth.auth()\"! This is a Firebase problem. Better contact their developer support team.")) }
        auth.createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(.failure(error.localizedDescription))
            } else {
                completion(.success)
            }
        }
    }
}


