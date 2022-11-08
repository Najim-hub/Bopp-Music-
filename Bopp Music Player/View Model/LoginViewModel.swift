//
//  LoginViewModel.swift
//  Apple_Signin (iOS)


import SwiftUI
// Needed Cryptokit...
import CryptoKit
import AuthenticationServices
// Firebase...
import Firebase



class LoginViewModel: ObservableObject{
    
    @Published var nonce = ""
    @AppStorage("log_status") var log_Status = true
    
    @EnvironmentObject var viewModel: AuthenticationViewModel

    
    
    func authenticate(credential: ASAuthorizationAppleIDCredential){
        
        // getting Token....
        guard let token = credential.identityToken else{
            print("error with firebase")
            
            return
        }
        
        if let authorizationCode = credential.authorizationCode, let codeString = String(data: authorizationCode, encoding: .utf8) {
                      
              let url = URL(string: "https://us-central1-bopp-15e3c.cloudfunctions.net/getRefreshToken?code=\(codeString)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "https://apple.com")!
                    
                let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                    
                    if let data = data {
                        let refreshToken = String(data: data, encoding: .utf8) ?? ""
                        print(refreshToken)
                        UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
                        UserDefaults.standard.synchronize()
                    }
                }
              task.resume()
              
          }

        // Token String...
        guard let tokenString = String(data: token, encoding: .utf8) else{
            print("error with Token")
            return
        }
        
        
        
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString,rawNonce: nonce)
        
        Auth.auth().signIn(with: firebaseCredential) { (result, err) in
            
            if let error = err{
                print(error.localizedDescription)
                return
            }
            
            @AppStorage("JWt_client_secret") var client_secret: String = ""
           @AppStorage("apltoken") var apple_token: String = ""
            
            client_secret = self.nonce
            apple_token = tokenString
          
            // User Successfully Logged Into Firebase...
            print("Logged In Success")
            // Directing User TO Home Page....
            withAnimation(.easeInOut){
                self.log_Status = true
            }
        }
    }
    
    func removeAccount() {
      let token = UserDefaults.standard.string(forKey: "refreshToken")

      if let token = token {
        
          let url = URL(string: "https://YOUR-URL.cloudfunctions.net/revokeToken?refresh_token=\(token)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "https://apple.com")!
                
          let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard data != nil else { return }
          }
                
          task.resume()
          
      }
      //Delete other information from the database...
        viewModel.signOut()
        
        deleteAppleAccount()
    }
    
    func deleteAppleAccount() {
        
            @AppStorage("JWt_client_secret") var client_secret: String = ""
            @AppStorage("apltoken") var apple_token: String = ""
        @AppStorage("apltoken") var  apple_typeToken: String = "access_token"

        print("Method called")

            let url = URL(string: "https://appleid.apple.com/auth/revoke")!
        
           var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!

        components.queryItems = [
            URLQueryItem(name: "client_secret", value: client_secret),
            URLQueryItem(name: "client_id", value: Bundle.main.bundleIdentifier),
            URLQueryItem(name: "token", value: apple_token)
        ]

       
           let query = components.url!.query
            
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
      
        
        // convert parameters to Data and assign dictionary to httpBody of request
        request.httpBody =  Data(query!.utf8)
      
        
            let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
                    guard
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

                    
                if let error = error {
                    print(error)
                }else{
                    print("successfully revoked user account")
                }
            }
            task.resume()
        }

}



// helpers for Apple Login With Firebase...



 func sha256(_ input: String) -> String {
  let inputData = Data(input.utf8)
  let hashedData = SHA256.hash(data: inputData)
  let hashString = hashedData.compactMap {
    return String(format: "%02x", $0)
  }.joined()

  return hashString
}

 func randomNonceString(length: Int = 32) -> String {
  precondition(length > 0)
  let charset: Array<Character> =
      Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
  var result = ""
  var remainingLength = length

  while remainingLength > 0 {
    let randoms: [UInt8] = (0 ..< 16).map { _ in
      var random: UInt8 = 0
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
      if errorCode != errSecSuccess {
        fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
      }
      return random
    }

    randoms.forEach { random in
      if remainingLength == 0 {
        return
      }

      if random < charset.count {
        result.append(charset[Int(random)])
        remainingLength -= 1
      }
    }
  }

  return result
}
