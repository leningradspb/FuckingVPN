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
//    let provider = PacketTunnelProvider()

        override func viewDidLoad() {
            super.viewDidLoad()
            loadProviderManager {
                ///  "127.0.0.1"
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
            guard
                          let configurationFileURL = Bundle.main.url(forResource: "profile-620092417153600603", withExtension: "ovpn"),
                          let configurationFileContent = try? Data(contentsOf: configurationFileURL)
                          else {
                              fatalError()
                      }
          providerManager?.loadFromPreferences { error in
             if error == nil {
                let tunnelProtocol = NETunnelProviderProtocol()
                 
//                 let configData = tunnelProtocol.providerConfiguration
                 
                 
                 
                tunnelProtocol.username = username
                tunnelProtocol.serverAddress = serverAddress
                 
//                 tunnelProtocol.providerBundleIdentifier = "kanevsky.Beast-VPN.FuckingVPN"
                tunnelProtocol.providerBundleIdentifier = "kanevsky.Beast-VPN.FuckingVPN.FuckingNE"
//                 tunnelProtocol.providerConfiguration = ["username": username, "password": password]
                tunnelProtocol.providerConfiguration = ["ovpn": configurationFileContent, "username": username, "password": password]
                tunnelProtocol.disconnectOnSleep = false
                self.providerManager.protocolConfiguration = tunnelProtocol
                self.providerManager.localizedDescription = "Govno VPN"
                self.providerManager.isEnabled = true
                self.providerManager.saveToPreferences(completionHandler: { (error) in
                      if error == nil  {
                          self.providerManager.loadFromPreferences(completionHandler: { (error) in
                              if error == nil {
                                  do {
//                                      let options: [String : NSObject] = [
//                                          "username": "computer" as NSString,
//                                          "password": "C3mrc7d$" as NSString
//                                      ]
//                                      try self.providerManager.connection.startVPNTunnel(options: options)
                                      try self.providerManager.connection.startVPNTunnel()
//                                      self.provider.startTunnel(options: nil) { error in //this  called here not in network extension
//                                          if error != nil {
//                                              print(error!)
//                                          }else {
//                                              
//                                          }
//                                      }
                                      print(self.providerManager.connection.status.rawValue)
                                  } catch let error {
                                      print(error.localizedDescription)
                                  }
                              }else {
                                  print(error!.localizedDescription)
                              }
                          })
                          print(self.providerManager.connection.status.rawValue)
//                         self.providerManager.loadFromPreferences(completionHandler: { (error) in
//                             do {
////                               try self.providerManager.connection.startVPNTunnel()
//                                 try self.providerManager
//                             } catch let error {
//                                 print(error.localizedDescription)
//                             }
//                         })
                      }
                })
              }
           }
        }

}

