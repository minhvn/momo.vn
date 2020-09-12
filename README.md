# momo_vn

## Getting Started
* Need register your application at momo business home page : https://business.momo.vn, detail: https://developers.momo.vn/#/home?id=t%c3%a0i-kho%e1%ba%a3n-doanh-nghi%e1%bb%87p
* Download testapp, test account at: https://developers.momo.vn/#/docs/testing_information

### 1. Android set up:
* Step 1: Request Internet permission at  ```AndroidManifest.xml``` file:
```xml
<uses-permission android:name="android.permission.INTERNET" />
```

### 2. iOS set up:
* Step 1: Update ```Info.plist``` file  as below:
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLName</key>
    <string></string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>partnerSchemeId</string>
    </array>
  </dict>
</array>
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>momo</string>
</array>
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```

* Step 2: Define call back url for momo  at ```AppDelegate.swift ``` file:
```swift
import momo_vn
```
```swift
override func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        MoMoPayment.handleOpenUrl(url: url, sourceApp: sourceApplication!)
        return true
    }

override func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        MoMoPayment.handleOpenUrl(url: url, sourceApp: "")
        return true
    }
```

### See more setup at: https://developers.momo.vn/#/

## Usage
* Import

```Dart
import 'package:momo_vn/momo_vn.dart';
```
* Init
```Dart
 void initState() {
    super.initState();
    _momoPay = MomoVn();
    _momoPay.on(MomoVn.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _momoPay.on(MomoVn.EVENT_PAYMENT_ERROR, _handlePaymentError);
    initPlatformState();
  }
```
* Create data Object
```Dart
MomoPaymentInfo options = MomoPaymentInfo(
    merchantname: "Tên đối tác",
    merchantcode: 'Mã đối tác',
    appScheme: "1221212",
    amount: 6000000000,
    orderId: '12321312',
    orderLabel: 'Label để hiển thị Mã giao dịch',
    merchantnamelabel: "Tiêu đề tên cửa hàng",
    fee: 0,
    description: 'Mô tả chi tiết',
    username: 'Định danh user (id/email/...)',
    partner: 'merchant',
    extra: "{\"key1\":\"value1\",\"key2\":\"value2\"}",
    isTestMode: true
);
```
*  Open MoMo application
```Dart
try {
    _momoPay.open(options);
  } catch (e) {
    debugPrint(e);
  }
```

* Get result
```Dart
void _setState() {
    _payment_status = 'Đã chuyển thanh toán';
    if (_momoPaymentResult.isSuccess) {
      _payment_status += "\nTình trạng: Thành công.";
      _payment_status += "\nSố điện thoại: " + _momoPaymentResult.phonenumber;
      _payment_status += "\nExtra: " + _momoPaymentResult.extra;
      _payment_status += "\nToken: " + _momoPaymentResult.token;
    }
    else {
      _payment_status += "\nTình trạng: Thất bại.";
      _payment_status += "\nExtra: " + _momoPaymentResult.extra;
      _payment_status += "\nMã lỗi: " + _momoPaymentResult.status.toString();
    }
  }
  void _handlePaymentSuccess(PaymentResponse response) {
    setState(() {
      _momoPaymentResult = response;
      _setState();
    });
    Fluttertoast.showToast(msg: "THÀNH CÔNG: " + response.phonenumber, timeInSecForIos: 4);
  }

  void _handlePaymentError(PaymentResponse response) {
    setState(() {
      _momoPaymentResult = response;
      _setState();
    });
    Fluttertoast.showToast(msg: "THẤT BẠI: " + response.message.toString(), timeInSecForIos: 4);
  }
```