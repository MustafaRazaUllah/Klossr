

import 'package:get/get.dart';
import 'package:klossr/SessionManager/SessionManager.dart';

class NotificationViewModel extends GetxController{
  var isValid=false.obs;

  check() async {
    if(await SessionManager().isExists('yu')){
      isValid.value=true;
    }else{
      isValid.value=false;
    }

  }

}