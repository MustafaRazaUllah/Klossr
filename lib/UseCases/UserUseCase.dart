import 'dart:io';

import 'package:dio/dio.dart';
import 'package:klossr/Models/BlockListModel.dart';
import 'package:klossr/Models/UserInfoRequest.dart';
import 'package:klossr/Network/ApiClient/ApiClient.dart';
import 'package:klossr/Network/BaseModel.dart';
import 'package:klossr/Network/DTOs/BlockDTO.dart';
import 'package:klossr/Network/DTOs/BlockListDTO.dart';
import 'package:klossr/Network/DTOs/GenderListDTO.dart';
import 'package:klossr/Network/DTOs/GetUserDTO.dart';
import 'package:klossr/Network/DTOs/GhostModeDTO.dart';
import 'package:klossr/Network/DTOs/NearByUserDTO.dart';
import 'package:klossr/Network/DTOs/ReportDTO.dart';
import 'package:klossr/Network/DTOs/RequestAcceptDTO.dart';
import 'package:klossr/Network/DTOs/RequestRejectDTO.dart';
import 'package:klossr/Network/DTOs/FriendsDTO.dart';
import 'package:klossr/Network/DTOs/SendRequestDTO.dart';
import 'package:klossr/Network/DTOs/ShowRequestDTO.dart';
import 'package:klossr/Network/DTOs/SignInDTO.dart';
import 'package:klossr/Network/DTOs/SignUpDTO.dart';
import 'package:klossr/Network/DTOs/SuggestGenderDTO.dart';
import 'package:klossr/Network/DTOs/UnFriendDTO.dart';
import 'package:klossr/Network/DTOs/VerifyCodeDTO.dart';
import 'package:klossr/Network/DTOs/unBlockDTO.dart';
import 'package:klossr/Network/ServerError.dart';
import 'package:klossr/SessionManager/SessionManager.dart';

class UserUseCase {
  Dio dio = Dio();
  ApiClient? apiClient;
  UserUseCase() {
    dio = Dio();
    apiClient = ApiClient(dio);
  }

  Future<BaseModel<SignInDTO>> signUp(
      String name, String username, String email, String password, String fcm, String deviceID) async {
    SignInDTO? response;
    try {
      print("Enter in response of SignUp");

      response = await apiClient?.signUp(name, username, email, password, fcm, deviceID);
      print("response of SignUp");
      print(response);
    } catch (error, stacktrace) {
      print("response: $response");
      print("Exception occured: $stacktrace");
      if (error is DioError)
        return BaseModel()..setException(ServerError.withError(error: error));
      else {
        print("json mapping error. check data types");
      }
    }

    return BaseModel()
      ..setStatusCode(200)
      ..data = response;
  }

  Future<BaseModel<SignInDTO>> signIn(
      String userName, String password, String token, String deviceID) async {
    SignInDTO? response;
    try {
      response = await apiClient?.signIn(userName.trim(), password, token, deviceID);
    } catch (error, stacktrace) {
      print("Exception occured: $stacktrace");
      if (error is DioError)
        return BaseModel()..setException(ServerError.withError(error: error));
      else {
        print("json mapping error. check data types");
      }
    }
    return BaseModel()
      ..setStatusCode(200)
      ..data = response!;
  }

  Future<BaseModel<SignInDTO>> updateUserInfo(
      UserInfoRequestModel userInfo,) async {
    SignInDTO? response;
    try {
      String _token = await SessionManager().getUserToken();
      String token = "Bearer $_token";

      print("Access Token =>> " + token);

      response = await apiClient!.updateUser(token, userInfo, );
    } catch (error, stacktrace) {
      print("Exception occured: $stacktrace");
      if (error is DioError)
        return BaseModel()..setException(ServerError.withError(error: error));
      else {
        print("json mapping error. check data types");
      }
    }
    return BaseModel()
      ..setStatusCode(200)
      ..data = response;
  }

  Future<BaseModel<NearByUserDTO>> getNearbyZones(
      String lat, String long) async {
    NearByUserDTO? response;
    try {
      String _token = await SessionManager().getUserToken();
      String token = "Bearer $_token";
      print(token);
      response = await apiClient?.getNearbyZones(token, lat, long, "200000");
    } catch (error, stacktrace) {
      print("Exception occured: $stacktrace");
      if (error is DioError)
        return BaseModel()..setException(ServerError.withError(error: error));
      else {
        print("json mapping error. check data types");
      }
    }
    return BaseModel()
      ..setStatusCode(200)
      ..data = response!;
  }

  Future<BaseModel<RequestAcceptDTO>> saveCurrentLocation(
      double lat, double long) async {
    RequestAcceptDTO? response;
    try {
      String _token = await SessionManager().getUserToken();
      String token = "Bearer $_token";
      print(token);
      response = await apiClient?.saveCLocation(token, lat, long);
    } catch (error, stacktrace) {
      print("Exception occured: $stacktrace");
      if (error is DioError)
        return BaseModel()..setException(ServerError.withError(error: error));
      else {
        print("json mapping error. check data types");
      }
    }
    return BaseModel()
      ..setStatusCode(200)
      ..data = response!;
  }

  Future<BaseModel<SendRequestDTO>> sendRequest(String user_id) async {
    SendRequestDTO? response;
    try {
      String _token = await SessionManager().getUserToken();
      String token = "Bearer $_token";
      print(token);
      response = await apiClient?.sendRequestToUsers(token, user_id);
    } catch (error, stacktrace) {
      print("Exception occuredddd: $stacktrace");
      if (error is DioError)
        return BaseModel()..setException(ServerError.withError(error: error));
      else {
        print("json mapping error. check data types");
      }
    }
    return BaseModel()
      ..setStatusCode(200)
      ..data = response!;
  }

  Future<BaseModel<ShowRequestDTO>> showRequest() async {
    ShowRequestDTO? response;
    try {
      String _token = await SessionManager().getUserToken();
      String token = "Bearer $_token";
      print(token);
      response = (await apiClient?.showRequest(
        token,
      ));

      // print("this is the id $id");
    } catch (error, stacktrace) {
      print("Exception occuredddd: $stacktrace");
      if (error is DioError)
        return BaseModel()..setException(ServerError.withError(error: error));
      else {
        print("json mapping error. check data types");
      }
    }
    return BaseModel()
      ..setStatusCode(200)
      ..data = response!;
  }

  Future<BaseModel<RequestAcceptDTO>> requestAccept(String user_id) async {
    RequestAcceptDTO? response;
    try {
      String _token = await SessionManager().getUserToken();
      String token = "Bearer $_token";
      print(token);
      response = await apiClient?.requestAccept(token, user_id);
      print("this is the response $response");
    } catch (error, stacktrace) {
      print("Exception occuredddd: $stacktrace");
      if (error is DioError)
        return BaseModel()..setException(ServerError.withError(error: error));
      else {
        print("json mapping error. check data types");
      }
    }
    return BaseModel()
      ..setStatusCode(200)
      ..data = response!;
  }

  Future<BaseModel<RequestRejectDTO>> requestReject(String user_id) async {
    RequestRejectDTO? response;
    try {
      String _token = await SessionManager().getUserToken();
      String token = "Bearer $_token";
      print(token);
      response = await apiClient?.requestReject(token, user_id);
      print("this is the response $response");
    } catch (error, stacktrace) {
      print("Exception occuredddd: $stacktrace");
      if (error is DioError)
        return BaseModel()..setException(ServerError.withError(error: error));
      else {
        print("json mapping error. check data types");
      }
    }
    return BaseModel()
      ..setStatusCode(200)
      ..data = response!;
  }

  Future<BaseModel<FriendsDTO>> friends() async {
    FriendsDTO? response;
    try {
      String _token = await SessionManager().getUserToken();
      String token = "Bearer $_token";
      print(token);
      response = (await apiClient?.friends(token));

      print("this is the token from requests $token");
    } catch (error, stacktrace) {
      print("Exception occuredddd: $stacktrace");
      if (error is DioError)
        return BaseModel()..setException(ServerError.withError(error: error));
      else {
        print("json mapping error. check data types");
      }
    }
    return BaseModel()
      ..setStatusCode(200)
      ..data = response!;
  }

  Future<BaseModel<UnFriendDTO>> unFriend(String user_id) async {
    UnFriendDTO? response;
    // try {
    String _token = await SessionManager().getUserToken();
    String token = "Bearer $_token";
    print("Token ==>>" + token.toString());
    print("User ID" + user_id.toString());
    response = await apiClient?.unFriend(token, user_id);
    print("Json Response ==>>");
    print(response.toString());
    // } catch (error, stacktrace) {
    //   print("Exception occuredddd: $stacktrace");
    //   if (error is DioError)
    //     return BaseModel()..setException(ServerError.withError(error: error));
    //   else {
    //     print("json mapping error. check data types");
    //   }
    // }
    return BaseModel()
      ..setStatusCode(200)
      ..data = response!;
  }

  Future<BaseModel<GenderListDTO>> genderList() async {
    GenderListDTO? response;
    try {
      String _token = await SessionManager().getUserToken();
      String token = "Bearer $_token";
      print(token);
      response = await apiClient?.genderList(token);
    } catch (error, stacktrace) {
      print("Exception occuredddd: $stacktrace");
      if (error is DioError)
        return BaseModel()..setException(ServerError.withError(error: error));
      else {
        print("json mapping error. check data types");
      }
    }
    return BaseModel()
      ..setStatusCode(200)
      ..data = response!;
  }

  Future<BaseModel<SuggestGenderDTO>> suggestGender(String gender) async {
    SuggestGenderDTO? response;
    try {
      String _token = await SessionManager().getUserToken();
      String token = "Bearer $_token";
      print(token);
      response = await apiClient?.suggestGender(token, gender);
    } catch (error, stacktrace) {
      print("Exception occuredddd: $stacktrace");
      if (error is DioError)
        return BaseModel()..setException(ServerError.withError(error: error));
      else {
        print("json mapping error. check data types");
      }
    }
    return BaseModel()
      ..setStatusCode(200)
      ..data = response!;
  }

  Future<BaseModel<GetUserDTO>> getUserDetail() async {
    GetUserDTO? response;
    try {
      String _token = await SessionManager().getUserToken();
      String token = "Bearer $_token";
      print(token);
      response = await apiClient?.getUser(token);
    } catch (error, stacktrace) {
      print("Exception occuredddd: $stacktrace");
      if (error is DioError)
        return BaseModel()..setException(ServerError.withError(error: error));
      else {
        print("json mapping error. check data types");
      }
    }
    return BaseModel()
      ..setStatusCode(200)
      ..data = response!;
  }

  Future<BaseModel<SuggestGenderDTO>> updateImage(File imageFile) async {
    SuggestGenderDTO? response;
    try {
      String _token = await SessionManager().getUserToken();
      String token = "Bearer $_token";
      print(token);
      print(imageFile);
      response = await apiClient?.updateImage(token, imageFile);
    } catch (error, stacktrace) {
      print("Exception occured: $stacktrace");
      if (error is DioError)
        return BaseModel()..setException(ServerError.withError(error: error));
      else {
        print("json mapping error. check data types");
      }
    }
    return BaseModel()
      ..setStatusCode(200)
      ..data = response!;
  }

  Future<BaseModel<BlockDTO>> block(String block_user) async {
    BlockDTO? response;
    try {
      String _token = await SessionManager().getUserToken();
      String token = "Bearer $_token";
      print(token);
      response = await apiClient?.block(token, block_user);
    } catch (error, stacktrace) {
      print("Exception occuredddd: $stacktrace");
      if (error is DioError)
        return BaseModel()..setException(ServerError.withError(error: error));
      else {
        print("json mapping error. check data types");
      }
    }
    return BaseModel()
      ..setStatusCode(200)
      ..data = response!;
  }

  Future<BaseModel<BlockListDTO>> blockList() async {
    BlockListDTO? response;
    try {
      String _token = await SessionManager().getUserToken();
      String token = "Bearer $_token";
      print(token);
      response = (await apiClient?.blockList(token));

      // print("this is the id $id");
    } catch (error, stacktrace) {
      print("Exception occuredddd: $stacktrace");
      if (error is DioError)
        return BaseModel()..setException(ServerError.withError(error: error));
      else {
        print("json mapping error. check data types");
      }
    }
    return BaseModel()
      ..setStatusCode(200)
      ..data = response!;
  }

  Future<BaseModel<unBlockDTO>> unBlock(String unblock_user) async {
    unBlockDTO? response;
    try {
      String _token = await SessionManager().getUserToken();
      String token = "Bearer $_token";
      print(token);
      response = await apiClient?.unBlock(token, unblock_user);
    } catch (error, stacktrace) {
      print("Exception occuredddd: $stacktrace");
      if (error is DioError)
        return BaseModel()..setException(ServerError.withError(error: error));
      else {
        print("json mapping error. check data types");
      }
    }
    return BaseModel()
      ..setStatusCode(200)
      ..data = response!;
  }

  Future<BaseModel<ReportDTO>> report(
      String user_report, String message) async {
    ReportDTO? response;
    try {
      String _token = await SessionManager().getUserToken();
      String token = "Bearer $_token";
      print(token);
      response = await apiClient?.report(token, user_report, message);
    } catch (error, stacktrace) {
      print("Exception occuredddd: $stacktrace");
      if (error is DioError)
        return BaseModel()..setException(ServerError.withError(error: error));
      else {
        print("json mapping error. check data types");
      }
    }
    return BaseModel()
      ..setStatusCode(200)
      ..data = response!;
  }

  Future<BaseModel<GhostModeDTO>> ghostMode(String mode) async {
    GhostModeDTO? response;
    try {
      String _token = await SessionManager().getUserToken();
      String token = "Bearer $_token";
      print(token);
      response = (await apiClient?.ghostMode(token, mode));
    } catch (error, stacktrace) {
      print("Exception occuredddd: $stacktrace");
      if (error is DioError)
        return BaseModel()..setException(ServerError.withError(error: error));
      else {
        print("json mapping error. check data types");
      }
    }
    return BaseModel()
      ..setStatusCode(200)
      ..data = response!;
  }

  Future<BaseModel<NearByUserDTO>> applyFilter(
      String gender, int distance, int minAge, int maxAge) async {
    NearByUserDTO? response;
    try {
      String _token = await SessionManager().getUserToken();
      String token = "Bearer $_token";
      print(token);
      response =
          await apiClient?.applyFilter(token, gender, distance, minAge, maxAge);
    } catch (error, stacktrace) {
      print("Exception occuredddd: $stacktrace");
      if (error is DioError)
        return BaseModel()..setException(ServerError.withError(error: error));
      else {
        print("json mapping error. check data types");
      }
    }
    return BaseModel()
      ..setStatusCode(200)
      ..data = response!;
  }

  Future<BaseModel<SuggestGenderDTO>> verifyEmail(String email) async {
    SuggestGenderDTO? response;
    try {
      // String _token = await SessionManager().getUserToken();
      // String token = "Bearer $_token";
      // print(token);
      response = await apiClient?.verifyEmail(email);
    } catch (error, stacktrace) {
      print("Exception occuredddd: $stacktrace");
      if (error is DioError)
        return BaseModel()..setException(ServerError.withError(error: error));
      else {
        print("json mapping error. check data types");
      }
    }
    return BaseModel()
      ..setStatusCode(200)
      ..data = response!;
  }

  Future<BaseModel<VerifyCodeDTO>> verifyCode(String code) async {
    print("object=============>>>>>>>>>+++++++++>>>>>>");
    print(code);
    VerifyCodeDTO? response;
    try {
      response = (await apiClient?.verifyCode(code))!;
      // print("==========4=4=4==4==4=4==4=4" + response.message.toString());
    } catch (error, stacktrace) {
      print("Exception occuredddd: $stacktrace");
      if (error is DioError)
        return BaseModel()..setException(ServerError.withError(error: error));
      else {
        print("json mapping error. check data types");
      }
    }
    return BaseModel()
      ..setStatusCode(200)
      ..data = response;
  }

  Future<BaseModel<SuggestGenderDTO>> updatePassword(
      String password, String token) async {
    print(token);
    print(password);
    SuggestGenderDTO? response;
    try {
      // String _token = await SessionManager().getUserToken();
      // String token = "Bearer $_token";
      // print(token);
      response = await apiClient?.updatePassword(token, password);
    } catch (error, stacktrace) {
      print("Exception occuredddd: $stacktrace");
      if (error is DioError)
        return BaseModel()..setException(ServerError.withError(error: error));
      else {
        print("json mapping error. check data types");
      }
    }
    return BaseModel()
      ..setStatusCode(200)
      ..data = response;
  }
}
