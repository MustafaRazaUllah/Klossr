

import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';


showToast(String msg, context){
  ToastContext().init(context);
  return Toast.show(msg, textStyle: TextStyle(),
      duration: Toast.lengthLong, gravity: Toast.bottom);
}