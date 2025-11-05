import Foundation
import AuthenticationServices
import Combine

class SocialMediaAuthManager: NSObject, ObservableObject {
    enum Platform: String, CaseIterable {
        case facebook = "Facebook"
        case instagram = "Instagram"
        case youtube = "YouTube"
        case tiktok = "TikTok"
        case twitch = "Twitch"
        case twitter = "Twitter"
        
        var authURL: String {
            switch self {
            case .facebook:
                return "https://www.facebook.com/v18.0/dialog/oauth"
            case .instagram:
                return "https://api.instagram.com/oauth/authorize"
            case .youtube:
                return "https://accounts.google.com/o/oauth2/v2/auth"
            case .tiktok:
                return "https://www.tiktok.com/auth/authorize"
            case .twitch:
                return "https://id.twitch.tv/oauth2/authorize"
            case .twitter:
                return "https://twitter.com/i/oauth2/authorize"
            }
        }
        
        var streamingURL: String {
            switch self {
            case .facebook:
                return "rtmps://live-api-s.facebook.com:443/rtmp/"
            case .youtube:
                return "rtmp://a.rtmp.youtube.com/live2"
            case .twitch:
                return "rtmp://live.twitch.tv/app"
            case .tiktok:
                return "rtmp://push.tiktok.com/rtmp/"
            case .instagram:
                return "rtmps://live-upload.instagram.com:443/rtmp/"
            case .twitter:
                return "rtmp://live.twitter.com/rtmp/"
            }
        }
    }
    
    struct Credentials: Codable {
        let platform: String
        let accessToken: String
        let streamKey: String
        let expiresAt: Date?
    }
    
    @Published var authenticatedPlatforms: [Platform: Credentials] = [:]
    
    private var authSession: ASWebAuthenticationSession?
    private let credentialsKey = "com.illadvised.credentials"
    
    override init() {
        super.init()
        loadCredentials()
    }
    
    func authenticate(platform: Platform, completion: @escaping (Result<Credentials, Error>) -> Void) {
        let clientID = getClientID(for: platform)
        let redirectURI = "illadvised://oauth-callback"
        let scope = getScope(for: platform)
        
        var components = URLComponents(string: platform.authURL)
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: scope)
        ]
        
        guard let url = components?.url else {
            completion(.failure(AuthError.invalidURL))
            return
        }
        
        authSession = ASWebAuthenticationSession(url: url, callbackURLScheme: "illadvised") { [weak self] callbackURL, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let callbackURL = callbackURL,
                  let code = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false)?
                    .queryItems?
                    .first(where: { $0.name == "code" })?
                    .value else {
                completion(.failure(AuthError.noAuthorizationCode))
                return
            }
            
            self?.exchangeCodeForToken(code: code, platform: platform, completion: completion)
        }
        
        authSession?.presentationContextProvider = self
        authSession?.prefersEphemeralWebBrowserSession = false
        authSession?.start()
    }
    
    func disconnect(platform: Platform) {
        authenticatedPlatforms.removeValue(forKey: platform)
        saveCredentials()
    }
    
    func getStreamURL(for platform: Platform) -> String? {
        guard let credentials = authenticatedPlatforms[platform] else { return nil }
        return platform.streamingURL
    }
    
    func getStreamKey(for platform: Platform) -> String? {
        return authenticatedPlatforms[platform]?.streamKey
    }
    
    private func exchangeCodeForToken(code: String, platform: Platform, completion: @escaping (Result<Credentials, Error>) -> Void) {
        let credentials = Credentials(
            platform: platform.rawValue,
            accessToken: code,
            streamKey: "",
            expiresAt: Date().addingTimeInterval(3600)
        )
        
        DispatchQueue.main.async {
            self.authenticatedPlatforms[platform] = credentials
            self.saveCredentials()
            completion(.success(credentials))
        }
    }
    
    private func getClientID(for platform: Platform) -> String {
        return "YOUR_\(platform.rawValue.uppercased())_CLIENT_ID"
    }
    
    private func getScope(for platform: Platform) -> String {
        switch platform {
        case .facebook, .instagram:
            return "publish_video"
        case .youtube:
            return "https://www.googleapis.com/auth/youtube.upload"
        case .twitch:
            return "channel:manage:broadcast"
        case .tiktok:
            return "video.upload"
        case .twitter:
            return "tweet.write"
        }
    }
    
    private func saveCredentials() {
        let encoder = JSONEncoder()
        let credentialsArray = authenticatedPlatforms.values.map { $0 }
        if let data = try? encoder.encode(credentialsArray) {
            UserDefaults.standard.set(data, forKey: credentialsKey)
        }
    }
    
    private func loadCredentials() {
        guard let data = UserDefaults.standard.data(forKey: credentialsKey),
              let credentialsArray = try? JSONDecoder().decode([Credentials].self, from: data) else {
            return
        }
        
        for credential in credentialsArray {
            if let platform = Platform(rawValue: credential.platform) {
                authenticatedPlatforms[platform] = credential
            }
        }
    }
}

extension SocialMediaAuthManager: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
}

enum AuthError: Error {
    case invalidURL
    case noAuthorizationCode
    case tokenExchangeFailed
}
