import UIKit
import CoreLocation
import SystemConfiguration.CaptiveNetwork
import Reachability
import Flutter
import NetworkExtension


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate,CLLocationManagerDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
      let controler : FlutterViewController = window?.rootViewController as! FlutterViewController
      let METHOD_CHANNEL_NAME_SSID = "org/eurotronic/smartLiving/ssid"
      let wifiNameChannel = FlutterMethodChannel(name: METHOD_CHANNEL_NAME_SSID, binaryMessenger: controler.binaryMessenger)
      wifiNameChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result : @escaping FlutterResult) -> Void in
          switch call.method{
          case "getSsidName":
              let data  = self.determineSsidName();
              print("getSsidName:")
              print(data)
              result(data)
              break
          default:
              result(FlutterMethodNotImplemented)
              break
          }
      })
      
      let METHOD_CHANNEL_NAME_MAC = "org/eurotronic/smartLiving/mac"
      let macAdressChannel = FlutterMethodChannel(name: METHOD_CHANNEL_NAME_MAC, binaryMessenger: controler.binaryMessenger)
      macAdressChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result : @escaping FlutterResult) -> Void in
          switch call.method{
          case "getMacAdress":
              let data  = self.determineMacAdress();
              result(data)
              break
          default:
              result(FlutterMethodNotImplemented)
              break
          }
      })
      
      let METHOD_CHANNEL_NAME_WIFI = "org/eurotronic/smartLiving/wificonnect"
      let wifiAdressChannel = FlutterMethodChannel(name: METHOD_CHANNEL_NAME_WIFI, binaryMessenger: controler.binaryMessenger)
      wifiAdressChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result : @escaping FlutterResult) -> Void in
          switch call.method{
          case "connectToWiFi":
          
              self.connectToWiFi(completionHandler: {status in
                  return result(status);
              });

              break
          default:
              print("else Inside new invoked ethid\(call.method)" );
              result(FlutterMethodNotImplemented)
              break
          }
      })
      
      let METHOD_CHANNEL_NAME_WIFI_DISCONNECT = "org/eurotronic/smartLiving/wifidisconnect"
      let wifiChannel = FlutterMethodChannel(name: METHOD_CHANNEL_NAME_WIFI_DISCONNECT, binaryMessenger: controler.binaryMessenger)
      wifiChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result : @escaping FlutterResult) -> Void in
          switch call.method{
          case "disconnectFromWiFi":
              self.disconnectFromWiFi();
              result(FlutterMethodNotImplemented)

              break
          default:
              print("else Inside new invoked ethid");
              result(FlutterMethodNotImplemented)
              break
          }
      })

      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
   
    private func determineSsidName() -> String
    {
        print("Wifi is connected.")
        var locationManager = CLLocationManager()
        let reachability = try! Reachability()
        print(reachability.connection)
        if reachability.connection == .wifi  || reachability.connection == .cellular{
            print("determineSsidName")
            if #available(iOS 13.0, *) {
                let status = CLLocationManager.authorizationStatus()
                print(status)
                if status == .authorizedWhenInUse || status == .authorizedAlways{
                    print("authorizedWhenInUse")
                    let wifiInfo: [String : Any] = getConnectedWifiInfo()
                    if wifiInfo.count > 0 {
                        print(wifiInfo["BSSID"] as! String)
                        return wifiInfo["SSID"] as! String
                    }
                    
                    else{
                        return "";
                    }
                    
                }

                else {
                    print("authorizedWhenInUse NO-NO-NO")
                    locationManager.delegate = self
                    locationManager.requestWhenInUseAuthorization()
                }
            }
        }
        //Rufe hier den native code auf, um die ssid unter ios zu ermitteln, pruefe, wie aktuelle ios app das macht und führe den gleichen code hier aus!!!
        return "";
    }
    
    private func determineMacAdress() -> String
    {
        var locationManager = CLLocationManager()
            print("Wifi is connected.")
            if #available(iOS 13.0, *) {
                let status = CLLocationManager.authorizationStatus()
                if status == .authorizedWhenInUse || status == .authorizedAlways {
                    print("authorizedWhenInUse")
                    let wifiInfo: [String : Any] = getConnectedWifiInfo()
                    if wifiInfo.count > 0 {
                        return wifiInfo["BSSID"] as! String;
                    }else{
                        return "";
                    }
                } else {
                    print("authorizedWhenInUse NO-NO-NO")
                    locationManager.delegate = self
                    locationManager.requestWhenInUseAuthorization()
                }
            }
        //Rufe hier den native code auf, um die ssid unter ios zu ermitteln, pruefe, wie aktuelle ios app das macht und führe den gleichen code hier aus!!!
        return "";
    }
    
    func getConnectedWifiInfo() -> [String: Any] {
        print("getConnectedWifiInfo")
        if let ifs = CFBridgingRetain( CNCopySupportedInterfaces()) as? [String],
            let ifName = ifs.first as CFString?,
            let info = CFBridgingRetain( CNCopyCurrentNetworkInfo((ifName))) as? [String: Any] {
            print("return info: getConnectedWifiInfo")
            print(info)
            return info
        }
        print("getConnectedWifiInfo return empty list")
        return [:]
    }
    

    
    func connectToWiFi(completionHandler: @escaping (Int) -> Void) {
        var configuration = NEHotspotConfiguration.init(ssid: "Comet WiFi", passphrase: "11223344", isWEP: false);
        configuration.joinOnce = true;
        NEHotspotConfigurationManager.shared.apply(configuration) { (error) in
            
            if let error = error {
                if error.localizedDescription == "already associated." {
                    completionHandler(2) // Already associated
                } else {
                    completionHandler(0) // Other error
                }
            } else {
                var configuration = NEHotspotConfiguration.init(ssid: "", passphrase: "", isWEP: false);

                completionHandler(1) // Success
            }
        }
    }
    
    func disconnectFromWiFi() {
        print("Disconnecting from wifi");
        let configurationManager = NEHotspotConfigurationManager.shared
        configurationManager.removeConfiguration(forSSID: "Comet WiFi")
    }
    
}
