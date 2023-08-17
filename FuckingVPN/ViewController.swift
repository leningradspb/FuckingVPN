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
            loadProviderManager {
                ///  "127.0.0.1"
                self.configureVPN(serverAddress: "192.145.124.3", username: "", password: "")
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
          providerManager?.loadFromPreferences { error in
             if error == nil {
                let tunnelProtocol = NETunnelProviderProtocol()
                 
                 let configData = tunnelProtocol.providerConfiguration
                 
                 
                 
                tunnelProtocol.username = username
                tunnelProtocol.serverAddress = serverAddress
                tunnelProtocol.providerBundleIdentifier = "kanevsky.Beast-VPN.FuckingVPN"
                tunnelProtocol.providerConfiguration = ["ovpn": "configData", "username": username, "password": password]
                tunnelProtocol.disconnectOnSleep = false
                self.providerManager.protocolConfiguration = tunnelProtocol
                self.providerManager.localizedDescription = "Light VPN"
                self.providerManager.isEnabled = true
                self.providerManager.saveToPreferences(completionHandler: { (error) in
                      if error == nil  {
                         self.providerManager.loadFromPreferences(completionHandler: { (error) in
                             do {
                               try self.providerManager.connection.startVPNTunnel()
                             } catch let error {
                                 print(error.localizedDescription)
                             }
                         })
                      }
                })
              }
           }
        }

}

