//
//  ViewController.swift
//  FuckingVPN
//
//  Created by Eduard Kanevskii on 17.08.2023.
//

import UIKit
import NetworkExtension

class ViewController: UIViewController {

    var providerManager: NETunnelProviderManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadProviderManager {
            self.configureVPN(serverAddress: "91.201.113.157", username: "computer", password: "C3mrc7d$")
        }
     }

    func loadProviderManager(completion:@escaping () -> Void) {
       NETunnelProviderManager.loadAllFromPreferences { (managers, error) in
           if error == nil {
               self.providerManager = managers?.first ?? NETunnelProviderManager()
               completion()
           }
       }
    }

    func configureVPN(serverAddress: String, username: String, password: String) {
//      guard let configData = self.readFile(path: "profile-620092417153600603.ovpn") else { return }
//        guard
//                      let configurationFileURL = Bundle.main.url(forResource: "profile-620092417153600603", withExtension: "ovpn"),
//                      let configData = try? Data(contentsOf: configurationFileURL)
//                      else {
//                          fatalError()
//                  }
        
        let configurationFile = Bundle.main.url(forResource: "profile-620092417153600603", withExtension: "ovpn")
        let configData = try! Data(contentsOf: configurationFile!)
        
      self.providerManager?.loadFromPreferences { error in
         if error == nil {
            let tunnelProtocol = NETunnelProviderProtocol()
            tunnelProtocol.username = username
            tunnelProtocol.serverAddress = serverAddress
            tunnelProtocol.providerBundleIdentifier = "kanevsky.Beast-VPN.FuckingVPN.FuckingNE" // bundle id of the network extension target
            tunnelProtocol.providerConfiguration = ["ovpn": configData, "username": username, "password": password]
            tunnelProtocol.disconnectOnSleep = false
            self.providerManager.protocolConfiguration = tunnelProtocol
            self.providerManager.localizedDescription = "Test-OpenVPN" // the title of the VPN profile which will appear on Settings
            self.providerManager.isEnabled = true
            self.providerManager.saveToPreferences(completionHandler: { (error) in
                  if error == nil  {
                     self.providerManager.loadFromPreferences(completionHandler: { (error) in
                         do {
                           try self.providerManager.connection.startVPNTunnel() // starts the VPN tunnel.
                         } catch let error {
                             print(error.localizedDescription)
                         }
                     })
                  }
            })
          }
       }
    }

    func readFile(path: String) -> Data? {
//        let fileManager = FileManager.default
//        do {
//            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//            let fileURL = documentDirectory.appendingPathComponent(path)
//            return try Data(contentsOf: fileURL, options: .uncached)
//        }
//        catch let error {
//            print(error.localizedDescription)
//        }
        
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentDirectory.appendingPathComponent(path)
            return try Data(contentsOf: fileURL, options: .uncached)
        }
        catch let error {
            print(error.localizedDescription)
        }
//        let contentString = try String(contentsOf: path)
        return nil
    }
}
