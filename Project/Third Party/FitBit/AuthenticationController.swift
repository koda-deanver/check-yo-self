//********************************************************************
//  AuthenticationController.swift
//  Check Yo Self
//  Added by Phil on 12/2016
//
//  Description: Authenticate Fitbit
//
//  Credit to Ryan LaSante
//********************************************************************

import SafariServices
import Foundation

protocol AuthenticationProtocol {
    func authorizationDidFinish(_ success: Bool)
}

class AuthenticationController: NSObject, SFSafariViewControllerDelegate {
	let clientID = "2287ZF"
	let clientSecret = "23ddfde5e5b4afa2aab9dfa27c7d0634"
	let baseURL = URL(string: "https://www.fitbit.com/oauth2/authorize")
	static let redirectURI = "devicesscreen://"
	let defaultScope = "heartrate"

	var authorizationVC: SFSafariViewController?
	var delegate: AuthenticationProtocol?
	var authenticationToken: String?

	init(delegate: AuthenticationProtocol?) {
		self.delegate = delegate
		super.init()
		NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "fitbit-launched"), object: nil, queue: nil, using: { [weak self] (notification: Notification) in
			// Parse and extract token
			let success: Bool
			if let token = AuthenticationController.extractToken(notification, key: "#access_token") {
				self?.authenticationToken = token
				NSLog("You have successfully authorized")
				success = true
			} else {
				print("There was an error extracting the access token from the authentication response.")
				success = false
			}

			self?.authorizationVC?.dismiss(animated: true, completion: {
				self?.delegate?.authorizationDidFinish(success)
			})
		})
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: Public API

	public func login(fromParentViewController viewController: UIViewController) {
		guard let url = URL(string: "https://www.fitbit.com/oauth2/authorize?response_type=token&client_id="+clientID+"&redirect_uri="+AuthenticationController.redirectURI+"&scope="+defaultScope+"&expires_in=604800") else {
			NSLog("Unable to create authentication URL")
			return
		}

		let authorizationViewController = SFSafariViewController(url: url)
		authorizationViewController.delegate = self
		authorizationVC = authorizationViewController
		viewController.present(authorizationViewController, animated: true, completion: nil)
	}

	public static func logout() {
		// TODO
	}

	private static func extractToken(_ notification: Notification, key: String) -> String? {
		guard let url = notification.userInfo?[UIApplicationLaunchOptionsKey.url] as? URL else {
			NSLog("notification did not contain launch options key with URL")
			return nil
		}

		// Extract the access token from the URL
		let strippedURL = url.absoluteString.replacingOccurrences(of: AuthenticationController.redirectURI, with: "")
		return self.parametersFromQueryString(strippedURL)[key]
	}

	// TODO: this method is horrible and could be an extension and use some functional programming
	private static func parametersFromQueryString(_ queryString: String?) -> [String: String] {
		var parameters = [String: String]()
		if (queryString != nil) {
			let parameterScanner: Scanner = Scanner(string: queryString!)
			var name:NSString? = nil
			var value:NSString? = nil
			while (parameterScanner.isAtEnd != true) {
				name = nil;
				parameterScanner.scanUpTo("=", into: &name)
				parameterScanner.scanString("=", into:nil)
				value = nil
				parameterScanner.scanUpTo("&", into:&value)
				parameterScanner.scanString("&", into:nil)
				if (name != nil && value != nil) {
					parameters[name!.removingPercentEncoding!]
						= value!.removingPercentEncoding!
				}
			}
		}
		return parameters
	}

	// MARK: SFSafariViewControllerDelegate

	func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
		delegate?.authorizationDidFinish(false)
	}
}
