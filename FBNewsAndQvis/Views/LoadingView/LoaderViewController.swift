import UIKit
import SwiftUI
import OneSignalFramework
import AppsFlyerLib

class LoadingSplash: UIViewController {

    let loadingLabel = UILabel()
    let loadingImage = UIImageView()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupFlow()
    }

    private func setupUI() {
        print("start setupUI")
        view.addSubview(loadingImage)
        loadingImage.image = UIImage(resource: .cupWin)

        view.addSubview(activityIndicator)
        
        loadingImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingImage.topAnchor.constraint(equalTo: view.topAnchor),
            loadingImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupFlow() {
        activityIndicator.startAnimating()

        if let savedURL = UserDefaults.standard.string(forKey: "finalAppsflyerURL") {
            print("✅ Using existing AppsFlyer data")
            appsFlyerDataReady()
        } else {
            print("⌛ Waiting for AppsFlyer data...")

            NotificationCenter.default.addObserver(
                self,
                selector: #selector(appsFlyerDataReady),
                name: Notification.Name("AppsFlyerDataReceived"),
                object: nil
            )

            // Таймаут на случай, если данные так и не придут
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                if UserDefaults.standard.string(forKey: "finalAppsflyerURL") == nil {
                    print("⚠️ Timeout waiting for AppsFlyer. Proceeding with fallback.")
                    self.appsFlyerDataReady()
                }
            }
        }
    }

    @objc private func appsFlyerDataReady() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("AppsFlyerDataReceived"), object: nil)
        proceedWithFlow()
    }

    private func proceedWithFlow() {
        
        CheckURLService.checkURLStatus { is200 in
            DispatchQueue.main.async { [self] in
                if is200 {
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.restrictRotation = .all
                    }
                    let link = self.generateTrackingLink()
                    activityIndicator.stopAnimating()
                    let vc = WebviewVC(url: URL(string: link)!)
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                } else {
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.restrictRotation = .portrait
                    }
                    activityIndicator.stopAnimating()
                        let swiftUIView = ContentView()
                        let hostingController = UIHostingController(rootView: swiftUIView)
                        hostingController.modalPresentationStyle = .fullScreen
                        self.present(hostingController, animated: true)
                }
            }
        }
    }
    
    func generateTrackingLink() -> String {
        let base = "https://penaltylegends.store/6kh1J875"
        if let savedURL = UserDefaults.standard.string(forKey: "finalAppsflyerURL") {
            let full = base + savedURL
            print("✅ Generated tracking link: \(full)")
            return full
        } else {
            print("⚠️ AppsFlyer data not available, returning base URL only")
            return base
        }
    }
}


extension AppDelegate: AppsFlyerLibDelegate {
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable: Any]) {
        guard let data = conversionInfo as? [String: Any] else { return }
        print("📦 AppsFlyer data received: \(data)")

        let appsflyerID = AppsFlyerLib.shared().getAppsFlyerUID()
        
        let isOrganic = (data["af_status"] as? String)?.lowercased() == "organic"
        let rawCampaign = isOrganic ? "organic" : (data["campaign"] as? String ?? "")
        
        var campaign = rawCampaign
        var sub1 = ""
        var sub2 = ""
        var sub3 = ""
        var sub4 = ""
        var sub5 = ""
        var sub6 = ""

        if !isOrganic {
            let parts = rawCampaign.components(separatedBy: "_")
            
            if parts.count >= 2 {
                campaign = parts[0]
                
                sub1 = parts.indices.contains(1) ? parts[1] : ""
                sub2 = parts.indices.contains(2) ? parts[2] : ""
                sub3 = parts.indices.contains(3) ? parts[3] : ""
                sub4 = parts.indices.contains(4) ? parts[4] : ""
                sub5 = parts.indices.contains(5) ? parts[5] : ""
                sub6 = parts.indices.contains(6) ? parts[6] : ""
            }
        }

        
        let finalURL = """
        ?appsflyer_id=\(appsflyerID)&campaign=\(campaign)&sub1=\(sub1)&sub2=\(sub2)&sub3=\(sub3)&sub4=\(sub4)&sub5=\(sub5)&sub6=\(sub6)
        """

        print("✅ Final URL: \(finalURL)")
        UserDefaults.standard.set(finalURL, forKey: "finalAppsflyerURL")
        NotificationCenter.default.post(name: Notification.Name("AppsFlyerDataReceived"), object: nil)
    }

    func onConversionDataFail(_ error: Error) {
        print("❌ Conversion data error: \(error.localizedDescription)")
    }
}

