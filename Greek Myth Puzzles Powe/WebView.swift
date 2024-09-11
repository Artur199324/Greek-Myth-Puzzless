import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    var onPageStarted: ((URL?) -> Void)?
    var onPageFinished: ((URL?) -> Void)?
    var onProgressChanged: ((Double) -> Void)?
    @Binding var webView: WKWebView?
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.addObserver(context.coordinator, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.load(URLRequest(url: url))
        self.webView = webView
        context.coordinator.webView = webView // Устанавливаем ссылку на webView в координаторе
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onPageStarted: onPageStarted, onPageFinished: onPageFinished, onProgressChanged: onProgressChanged)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var onPageStarted: ((URL?) -> Void)?
        var onPageFinished: ((URL?) -> Void)?
        var onProgressChanged: ((Double) -> Void)?
        weak var webView: WKWebView? // Добавляем слабую ссылку на webView
        
        init(onPageStarted: ((URL?) -> Void)?, onPageFinished: ((URL?) -> Void)?, onProgressChanged: ((Double) -> Void)?) {
            self.onPageStarted = onPageStarted
            self.onPageFinished = onPageFinished
            self.onProgressChanged = onProgressChanged
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            onPageStarted?(webView.url)
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            onPageFinished?(webView.url)
        }
        
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == #keyPath(WKWebView.estimatedProgress), let webView = object as? WKWebView {
                onProgressChanged?(webView.estimatedProgress)
            }
        }
        
        deinit {
            webView?.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
        }
    }
}
