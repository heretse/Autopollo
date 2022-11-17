//
//  ContentView.swift
//  Autopollo
//
//  Created by Winston Hsieh on 2022/10/2.
//

import SwiftUI
import WebKit
import Combine

struct ContentView: View {
    let url: String
    
    let userDefaults = UserDefaults.standard

    var body: some View {
        NavigationView {
            WebView(urlPath: url)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .edgesIgnoringSafeArea(.all)
                .toolbar {
                    Button("Reset") {
                        userDefaults.removeObject(forKey: DefaultsKeys.companyCode)
                        userDefaults.removeObject(forKey: DefaultsKeys.employeeNo)
                        userDefaults.removeObject(forKey: DefaultsKeys.password)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            Darwin.exit(0)
                        }
                    }
                }
        }
    }
}

enum NavigationPage: Int {
    case Logouted   = 0
    case Loggin     = 1
    case Attendance = 3
}

struct WebView: UIViewRepresentable {
    var urlPath: String?
    let navigationHelper = WebViewHelper()

    func makeUIView(context: Context) -> WKWebView {
        let wkWebView = WKWebView()
        
        wkWebView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36"
        
        wkWebView.navigationDelegate = navigationHelper
    
        WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: Date(timeIntervalSince1970: 0), completionHandler: {})
        
        return wkWebView
    }

    func updateUIView(_ uiView : WKWebView , context : Context) {
        if let response = urlPath {
            if let url = URL(string: response){
                let request = URLRequest(url: url)

                uiView.load(request)
            }
        }
    }
    
    class WebViewHelper: NSObject, WKNavigationDelegate {
        var count: Int = 0
        var exit: Int = 0
        
        var cancellable1: AnyCancellable?
        var cancellable2: AnyCancellable?
        var cancellable3: AnyCancellable?
        var cancellable4: AnyCancellable?
        var cancellable5: AnyCancellable?
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("webview didFinishNavigation")
            print("count = \(count)")
            if count == NavigationPage.Logouted.rawValue {
                self.cancellable1 = Timer.publish(every: 1, on: .main, in: .default)
                    .autoconnect()
                    .sink {[weak self] (_) in
                        webView.evaluateJavaScript("document.querySelector('.Message-title-button').click();"
                        ) { _, error in
                            if (error == nil) {
                                self?.cancellable1?.cancel()
                            }
                        }
                    }
            } else if count == NavigationPage.Loggin.rawValue {
                
                self.cancellable2 = Timer.publish(every: 1, on: .main, in: .default)
                    .autoconnect()
                    .sink {[weak self] (_) in
                        let userDefaults = UserDefaults.standard
                        
                        let insertValue = """
                        document.querySelector('[name="companyCode"]').focus();
                        document.querySelector('[name="companyCode"]').value = '\(userDefaults.string(forKey: DefaultsKeys.companyCode) ?? "")';
                        document.querySelector('[name="employeeNo"]').focus();
                        document.querySelector('[name="employeeNo"]').value = '\(userDefaults.string(forKey: DefaultsKeys.employeeNo) ?? "")';
                        document.querySelector('[name="password"]').focus();
                        document.querySelector('[name="password"]').value = '\(userDefaults.string(forKey: DefaultsKeys.password) ?? "")';
                        document.querySelector('.submit-btn').focus();
                        document.querySelector('.submit-btn').click();
                        """
                        webView.evaluateJavaScript(insertValue
                        ) { _, error in
                            if (error == nil) {
                                self?.cancellable2?.cancel()
                            }
                        }
                    }
            } else if count == NavigationPage.Attendance.rawValue {
                self.cancellable3 = Timer.publish(every: 1, on: .main, in: .default)
                    .autoconnect()
                    .sink {[weak self] (_) in
                        webView.evaluateJavaScript("document.querySelector('.punch-window-button-work').click();"
                        ) { _, error in
                            print(error ?? "")
                            if (error == nil) {
                                self?.cancellable3?.cancel()
                                self?.cancellable4 = Timer.publish(every: 1, on: .main, in: .default)
                                    .autoconnect()
                                    .sink {[weak self] (_) in
                                        webView.evaluateJavaScript("document.querySelector('.button.filled.buttonText:not(.punch-window-button-work)').click();"
                                        ) { _, error in
                                            print(error ?? "")
                                            if (error == nil) {
                                                self?.cancellable4?.cancel()
                                            }
                                        }
                                    }
                                self?.cancellable5 = Timer.publish(every: 3, on: .main, in: .default)
                                    .autoconnect()
                                    .sink {[weak self] (_) in
                                        self?.cancellable3?.cancel()
                                        self?.cancellable4?.cancel()
                                        self?.cancellable5?.cancel()
                                        Darwin.exit(0)
                                    }
                            }
                        }
                    }
            }
            self.count += 1
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("didStartProvisionalNavigation")
        }

        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            print("webviewDidCommit")
        }

        func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            print("didReceiveAuthenticationChallenge")
            completionHandler(.performDefaultHandling, nil)
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(url: "https://apollo.mayohr.com/ta?id=webpunch")
    }
}
