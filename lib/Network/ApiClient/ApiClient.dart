import 'dart:io';

import 'package:dio/dio.dart';
import 'package:klossr/Constant/constants.dart';
import 'package:klossr/Models/BlockListModel.dart';
import 'package:klossr/Models/UserInfoRequest.dart';
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
import 'package:retrofit/http.dart';

part 'ApiClient.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio) {
    dio.options = BaseOptions(receiveTimeout: 30000, connectTimeout: 30000);
    return _ApiClient(dio);
  }

  @POST("auth/register")
  Future<SignInDTO> signUp(@Part() String name, @Part() String username,
      @Part() String email, @Part() String password);

  @POST("auth/login")
  Future<SignInDTO> signIn(@Part() String username, @Part() String password,
      @Part() String device_token);

  @POST("user-update")
  Future<SignInDTO> updateUser(
    @Header("Authorization") String token,
    @Body() UserInfoRequestModel userInfo,
    // @Part() String name,
    // @Part() String username,
    // @Part() String email,
    // @Part() String age,
    // @Part() String about_me,
    // @Part() int ghost_mode,
    // @Part() int gender,
    // @Part() String intrested_in,
    // @Part() String password
  );

  @POST("user-near-location")
  Future<NearByUserDTO> getNearbyZones(
      @Header("Authorization") String token,
      @Part() String latitude,
      @Part() String longitude,
      @Part() String distance);

  @POST("friend-request")
  Future<SendRequestDTO> sendRequestToUsers(
      @Header("Authorization") String token, @Part() String user_id);

  @GET("requests")
  Future<ShowRequestDTO> showRequest(@Header("Authorization") String token);

  @POST("friend-request-accept")
  Future<RequestAcceptDTO> requestAccept(
      @Header("Authorization") String token, @Part() String user_id);

  @POST("friend-request-reject")
  Future<RequestRejectDTO> requestReject(
      @Header("Authorization") String token, @Part() String user_id);

  @GET("friends")
  Future<FriendsDTO> friends(@Header("Authorization") String token);

  @POST("unfriend")
  Future<UnFriendDTO> unFriend(
      @Header("Authorization") String token, @Part() String user_id);

  @POST("user-location")
  Future<RequestAcceptDTO> saveCLocation(@Header("Authorization") String token,
      @Part() double latitude, @Part() double longitude);

  @GET("gender-list")
  Future<GenderListDTO> genderList(@Header("Authorization") String token);

  @POST("gender-suggestion")
  Future<SuggestGenderDTO> suggestGender(
      @Header("Authorization") String token, @Part() String gender);

  @GET("user")
  Future<GetUserDTO> getUser(@Header("Authorization") String token);

  @POST("update-image")
  Future<SuggestGenderDTO> updateImage(
      @Header("Authorization") String token, @Part() File image);

  @POST("block")
  Future<BlockDTO> block(
      @Header("Authorization") String token, @Part() String block_user);

  @GET("block-list")
  Future<BlockListDTO> blockList(@Header("Authorization") String token);

  @POST("unblock")
  Future<unBlockDTO> unBlock(
      @Header("Authorization") String token, @Part() String unblock_user);

  @POST("report")
  Future<ReportDTO> report(@Header("Authorization") String token,
      @Part() String user_report, @Part() String message);

  @POST("ghost-mode")
  Future<GhostModeDTO> ghostMode(
      @Header("Authorization") String token, @Part() String mode);

  @POST("filter")
  Future<NearByUserDTO> applyFilter(
    @Header("Authorization") String token,
    @Part() String gender,
    @Part() int distance,
    @Part() int min_age,
    @Part() int max_age,
  );

  @POST("verify-eamil")
  Future<SuggestGenderDTO> verifyEmail(@Part() String email);

  @POST("verify-code")
  Future<VerifyCodeDTO> verifyCode(@Part() String verification_code);

  @POST("update-password")
  Future<SuggestGenderDTO> updatePassword(
      @Part() String remember_token, @Part() String password);
}
