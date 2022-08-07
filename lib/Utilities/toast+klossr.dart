import 'package:toast/toast.dart';
import 'package:flutter/material.dart';

showToast(String msg, context) {
  ToastContext().init(context);
  return Toast.show(msg,
      textStyle: TextStyle(color: Colors.white),
      duration: Toast.lengthLong,
      gravity: Toast.center);
}
