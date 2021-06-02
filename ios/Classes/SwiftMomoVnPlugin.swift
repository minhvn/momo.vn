import Flutter
import UIKit

public class SwiftMomoVnPlugin: NSObject, FlutterPlugin {
  private static var CHANNEL_NAME = "momo_vn";
  var momoFlutterResult: FlutterResult? = nil

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: CHANNEL_NAME, binaryMessenger: registrar.messenger())
    let instance = SwiftMomoVnPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
        case "open":
            self.initMoMoChanel(call: call, result: result);
            break;
        case "resync":
            break
        default:
            print("no method")
            result(FlutterMethodNotImplemented)
    }
  }
  private func initMoMoChanel (call: FlutterMethodCall, result: @escaping FlutterResult) {
    self.momoFlutterResult = result
    NotificationCenter.default.addObserver(self, selector: #selector(self.NoficationCenterTokenStartRequest), name:NSNotification.Name(rawValue: "NoficationCenterTokenStartRequest"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.NoficationCenterTokenReceived), name:NSNotification.Name(rawValue: "NoficationCenterTokenReceived"), object: nil)
    let options = call.arguments as! NSMutableDictionary
    MoMoPayment.createPaymentInformation(info: options)
    MoMoPayment.requestToken()
  }

  /*
   * NOTIFICATION HANDLER
   */
  @objc func NoficationCenterTokenStartRequest(notif: NSNotification) {
  }
  @objc func NoficationCenterTokenReceived(notif: NSNotification) {
    print("::MoMoPay Log::Received Token Replied::\(notif.object!)")
    let response:NSMutableDictionary = notif.object! as! NSMutableDictionary
    let _statusStr = "\(response["status"] as! String)"
    if (_statusStr == "0") {
        self.momoFlutterResult?([
            "isSuccess" : true,
            "status" : 0,
            "token" : response["data"],
            "phoneNumber" : response["phonenumber"],
            "extra" : response["extra"]
        ])
      }
      else{
          self.momoFlutterResult?([
              "isSuccess" : false,
              "status" : response["status"],
              "phoneNumber" : response["phonenumber"],
              "extra" : response["extra"]
          ])
      }
  }

}
