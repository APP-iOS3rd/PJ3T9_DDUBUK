//
//  AuthViewModel.swift
//  Ddubuk
//
//  Created by 박호건 on 2/17/24.
//

import Foundation
import Firebase

class AuthViewModel: ObservableObject {
    @Published var userSession: Firebase.User?
    func signIn(email: String, password: String, completion: @escaping (Result<Firebase.User, Error>) -> Void) {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let user = result?.user {
                    self.userSession = user
                    completion(.success(user))
                } else if let error = error {
                    completion(.failure(error))
                }
            }
        }
    
    func signUp(email: String, password: String, completion: @escaping (Result<Firebase.User, Error>) -> Void) {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let user = result?.user {
                    self.userSession = user
                    completion(.success(user))
                } else if let error = error {
                    completion(.failure(error))
                }
            }
        }
    
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
            do {
                try Auth.auth().signOut()
                self.userSession = nil
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    
    func changePassword(currentPassword: String, newPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
            guard let user = Auth.auth().currentUser else {
                completion(.failure(AuthError.notLoggedIn))
                return
            }

            let credential = EmailAuthProvider.credential(withEmail: user.email!, password: currentPassword)

            // Reauthenticate user with current password
            user.reauthenticate(with: credential) { _, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                // Change password
                user.updatePassword(to: newPassword) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }
    
    func deleteAccount(completion: @escaping (Result<Void, Error>) -> Void) {
            Auth.auth().currentUser?.delete { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }

    enum AuthError: Error {
        case notLoggedIn
    }
