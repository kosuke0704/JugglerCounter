import SwiftUI
import WebKit

// MARK: - ブラウザ画面
struct BrowserView: View {
    @State private var currentURL: String = "https://www.google.com"
    @State private var urlString: String = "https://www.google.com"
    @State private var canGoBack = false
    @State private var canGoForward = false
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 下部ナビゲーションバー
                HStack(spacing: 12) {
                    Button {
                        NotificationCenter.default.post(name: NSNotification.Name("webViewGoBack"), object: nil)
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(canGoBack ? AppColors.accent : AppColors.textSecondary)
                    }
                    .disabled(!canGoBack)
                    
                    Button {
                        NotificationCenter.default.post(name: NSNotification.Name("webViewGoForward"), object: nil)
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(canGoForward ? AppColors.accent : AppColors.textSecondary)
                    }
                    .disabled(!canGoForward)
                    
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 14))
                            .foregroundStyle(AppColors.textSecondary)
                        
                        TextField("検索またはURL", text: $urlString)
                            .font(.system(size: 14))
                            .foregroundStyle(AppColors.textPrimary)
                            .autocapitalization(.none)
                            .keyboardType(.URL)
                            .submitLabel(.go)
                            .onSubmit { loadURL() }
                        
                        if !urlString.isEmpty {
                            Button {
                                urlString = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 14))
                                    .foregroundStyle(AppColors.textSecondary)
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.cardBackgroundLight))
                    
                    Button {
                        NotificationCenter.default.post(name: NSNotification.Name("webViewReload"), object: nil)
                    } label: {
                        Image(systemName: isLoading ? "xmark" : "arrow.clockwise")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(AppColors.accent)
                            .frame(width: 36, height: 36)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(AppColors.cardBackground)
                
                if isLoading {
                    ProgressView().progressViewStyle(.linear).tint(AppColors.accent)
                }
                
                WebView(
                    urlString: $currentURL,
                    canGoBack: $canGoBack,
                    canGoForward: $canGoForward,
                    isLoading: $isLoading,
                    currentURLString: $urlString
                )
            }
            .navigationTitle("ブラウザ")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(AppColors.cardBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .onAppear { urlString = currentURL }
    }
    
    private func loadURL() {
        var urlToLoad = urlString.trimmingCharacters(in: .whitespaces)
        if !urlToLoad.hasPrefix("http://") && !urlToLoad.hasPrefix("https://") {
            if urlToLoad.contains(".") && !urlToLoad.contains(" ") {
                urlToLoad = "https://" + urlToLoad
            } else {
                let encoded = urlToLoad.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                urlToLoad = "https://www.google.com/search?q=\(encoded)"
            }
        }
        currentURL = urlToLoad
    }
}

// MARK: - WebView
struct WebView: UIViewRepresentable {
    @Binding var urlString: String
    @Binding var canGoBack: Bool
    @Binding var canGoForward: Bool
    @Binding var isLoading: Bool
    @Binding var currentURLString: String
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        configuration.defaultWebpagePreferences = preferences
        configuration.websiteDataStore = WKWebsiteDataStore.default()
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        
        let systemVersion = UIDevice.current.systemVersion
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS \(systemVersion.replacingOccurrences(of: ".", with: "_")) like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.2 Mobile/15E148 Safari/604.1"
        
        NotificationCenter.default.addObserver(context.coordinator, selector: #selector(Coordinator.goBack), name: NSNotification.Name("webViewGoBack"), object: nil)
        NotificationCenter.default.addObserver(context.coordinator, selector: #selector(Coordinator.goForward), name: NSNotification.Name("webViewGoForward"), object: nil)
        NotificationCenter.default.addObserver(context.coordinator, selector: #selector(Coordinator.reload), name: NSNotification.Name("webViewReload"), object: nil)
        
        context.coordinator.webView = webView
        
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.setValue("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", forHTTPHeaderField: "Accept")
            webView.load(request)
        }
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let url = URL(string: urlString) else { return }
        let currentURL = webView.url?.absoluteString ?? ""
        let newURL = url.absoluteString
        if currentURL == newURL || webView.isLoading || context.coordinator.lastLoadedURL == newURL { return }
        context.coordinator.lastLoadedURL = newURL
        var request = URLRequest(url: url)
        request.setValue("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", forHTTPHeaderField: "Accept")
        webView.load(request)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        weak var webView: WKWebView?
        var lastLoadedURL: String = ""
        
        init(_ parent: WebView) { self.parent = parent }
        
        @objc func goBack() { webView?.goBack() }
        @objc func goForward() { webView?.goForward() }
        @objc func reload() {
            if parent.isLoading { webView?.stopLoading() } else { webView?.reload() }
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
            parent.canGoBack = webView.canGoBack
            parent.canGoForward = webView.canGoForward
            if let url = webView.url?.absoluteString {
                DispatchQueue.main.async { [weak self] in
                    if self?.parent.currentURLString != url { self?.parent.currentURLString = url }
                }
            }
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
        }
        
        deinit { NotificationCenter.default.removeObserver(self) }
    }
}
