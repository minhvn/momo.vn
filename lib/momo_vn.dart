import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:eventify/eventify.dart';

class MomoVn {
  // Response codes from platform
  static const _CODE_PAYMENT_SUCCESS = 0; //User xác nhận thanh toán thành công
  static const _CODE_PAYMENT_TIMEOUT = 5; // Hết thời gian thực hiện giao dịch (Timeout transaction)
  static const _CODE_PAYMENT_CANCEL = 6; // Người dùng huỷ thanh toán
  static const _CODE_PAYMENT_ERROR = 7; // Lỗi Không xác định

  // Event names
  static const EVENT_PAYMENT_SUCCESS = 'payment.success';
  static const EVENT_PAYMENT_ERROR = 'payment.error';


  static const MethodChannel _channel = const MethodChannel('momo_vn');

  EventEmitter _eventEmitter;

  MomoVn() {
    _eventEmitter = new EventEmitter();
  }

  /// Opens checkout
  void open(MomoPaymentInfo options) async {
    PaymentResponse validationResult = _validateOptions(options);
    if (!validationResult.isSuccess) {
      _handleResult({
        'type': _CODE_PAYMENT_ERROR,
        'data': validationResult
      });
      return;
    }
    var response = await _channel.invokeMethod('open', options.toJson());
    _handleResult({'data': response, 'type': response['status']});
  }

  /// Handles checkout response from platform
  void _handleResult(Map<dynamic, dynamic> response) {
    String eventName;
    dynamic payload;
    payload = PaymentResponse.fromMap(response['data']) ;
    switch (response['type']) {
      case _CODE_PAYMENT_SUCCESS:
        eventName = EVENT_PAYMENT_SUCCESS;
        break;
      case _CODE_PAYMENT_TIMEOUT:
      case _CODE_PAYMENT_CANCEL:
        eventName = EVENT_PAYMENT_ERROR;
        break;
      default:
        eventName = EVENT_PAYMENT_ERROR;
        payload = PaymentResponse(false, _CODE_PAYMENT_ERROR, '', '', 'Lỗi không xác định', '', '');
    }
    _eventEmitter.emit(eventName, null, payload);
  }

  void on(String event, Function handler) {
    EventCallback cb = (event, cont) {
      handler(event.eventData);
    };
    _eventEmitter.on(event, null, cb);
  }

  void clear() {
    _eventEmitter.clear();
  }

  /// Validate payment options
  static PaymentResponse _validateOptions(MomoPaymentInfo options) {
    bool error = false;
    String mes = '';
    if (options.merchantcode == '' || options.merchantcode == null) {
      mes = 'merchantcode is required. Please check if key is present in options.';
    }
    if (options.merchantname == null || options.merchantname.isEmpty) {
      mes = 'merchantcode is required. Please check if key is present in options.';
    }
    if (options.partner == null || options.partner.isEmpty) {
      mes = 'merchantcode is required. Please check if key is present in options.';
    }
    if (Platform.isIOS && (options.appScheme == null || options.appScheme.isEmpty)) {
      mes = 'appScheme is required. Please check if key is present in options.';
    }
    if (options.amount == null || options.amount < 0) {
      mes = 'amount is required. Please check if key is present in options.';
    }
    if (options.description == null || options.description.isEmpty) {
      mes = 'description is required. Please check if key is present in options.';
    }
    if (error) {
      return PaymentResponse(false, 7, '', '', mes, '', '');
    }
    return PaymentResponse(true, 0, '', '', '', '', '');
  }
}

class PaymentResponse {
  bool isSuccess;
  int status;
  String token;
  String phonenumber;
  String data;
  String message;
  String extra;

  PaymentResponse(this.isSuccess, this.status, this.token, this.phonenumber, this.message, this.data, this.extra);

  static PaymentResponse fromMap(Map<dynamic, dynamic> map) {
    return new PaymentResponse(
      map['isSuccess'],
      map['status'] != null ? int.parse(map['status'].toString()) : null,
      map['token'] != null ? map['token'] as String: null,
      map['phonenumber'] != null ? map['phonenumber'] as String : null,
      map['message'] != null ? map['message'] as String: null,
      map['data'] != null ? map['data'] as String: null,
      map['extra'] != null ? map['extra'] as String: null
    );
  }
}

class MomoPaymentInfo {
  String partner;
  String appScheme;
  String merchantname;
  String merchantcode;
  String merchantnamelabel;

  double amount;
  double fee;
  String description;
  String extra;
  String username;
  String orderId;
  String orderLabel;

  bool isTestMode;

  MomoPaymentInfo({
    this.appScheme,
    this.merchantname,
    this.merchantcode,
    this.amount,
    this.orderId,
    this.orderLabel,
    this.partner,
    this.merchantnamelabel,
    this.fee,
    this.description,
    this.username,
    this.extra,
    this.isTestMode = false,
  }) : assert(
      merchantname != null &&
      merchantname.isNotEmpty &&
      merchantcode != null &&
      merchantcode.isNotEmpty &&
      amount != null &&
      amount > 0 &&
      orderId != null &&
      orderId.isNotEmpty &&
      orderLabel != null &&
      orderLabel.isNotEmpty &&
      partner != null &&
      partner.isNotEmpty
  );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      "merchantname": this.merchantname,
      "merchantcode": this.merchantcode,
      "amount": this.amount,
      "orderId": this.orderId,
      "orderLabel": this.orderLabel,
      "partner": this.partner,
      "fee": this.fee ?? 0,
      "isTestMode": isTestMode ?? true,
    };
    if (Platform.isIOS) {
      json["appScheme"] = appScheme;
    }
    if (description != null) {
      json["description"] = description;
    }
    if (username != null) {
      json["username"] = username;
    }
    if (merchantnamelabel != null) {
      json["merchantnamelabel"] = merchantnamelabel;
    }
    if (extra != null) {
      json["extra"] = extra;
    }
    return json;
  }
}

