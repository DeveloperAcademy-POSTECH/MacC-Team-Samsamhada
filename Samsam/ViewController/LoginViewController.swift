//
//  LoginViewController.swift
//  Samsam
//
//  Created by 김민택 on 2022/10/18.
//

import AuthenticationServices
import UIKit

class LoginViewController: UIViewController {
    
    // MARK: = Property
    
    let loginService: LoginAPI = LoginAPI(apiService: APIService())
    
    // MARK: - View
    
    private lazy var authorizationButton: ASAuthorizationAppleIDButton = {
        $0.addTarget(self, action: #selector(login), for: .touchUpInside)
        return $0
    }(ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .whiteOutline))
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        attribute()
        layout()
    }
    
    // MARK: - Method
    
    private func attribute() {
        view.backgroundColor = .white
    }
    
    private func layout() {
        self.view.addSubview(authorizationButton)
        
        authorizationButton.anchor(
            left: view.safeAreaLayoutGuide.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.safeAreaLayoutGuide.rightAnchor,
            paddingLeft: 16,
            paddingBottom: 16,
            paddingRight: 16,
            height: 50
        )
    }
    
    @objc private func login() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    private func requestLogin(LoginDTO: LoginDTO) {
        Task{
            do {
                let response = try await self.loginService.startAppleLogin(LoginDTO: LoginDTO)
                if let data = response {
                    guard let userIdentifier = data.userIdentifier,
                          let workerID = data.workerID
                    else {return}
                    UserDefaults.standard.setValue(userIdentifier, forKey: "userIdentifier")
                    UserDefaults.standard.setValue(workerID, forKey: "workerID")
                }
                self.navigationController?.pushViewController(PhoneNumViewController(), animated: true)
            } catch NetworkError.serverError {
            } catch NetworkError.encodingError {
            } catch NetworkError.clientError(_) {
            }
        }
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {

            let userIdentifier = appleIDCredential.user
            let userFirstName = appleIDCredential.fullName?.givenName
            let userLastName = appleIDCredential.fullName?.familyName
            let userEmail = appleIDCredential.email
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userIdentifier) { (credentialState, error) in
                switch credentialState {
                case .authorized:
                    DispatchQueue.main.async {
                        let loginDTO = LoginDTO(userIdentifier: userIdentifier,
                                                lastName:userLastName ?? nil,
                                                firstName: userFirstName ?? nil,
                                                email: userEmail ?? nil)
                        self.requestLogin(LoginDTO: loginDTO)
                    }
                    break
                case .revoked:
                    break
                case .notFound:
                    break
                default:
                    break
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
