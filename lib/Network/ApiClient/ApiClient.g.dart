// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ApiClient.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _ApiClient implements ApiClient {
  _ApiClient(this._dio, {this.baseUrl=""}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl = 'https://api.klosrr.com/api/v1/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<SignInDTO> signUp(name, username, email, password) async {
    ArgumentError.checkNotNull(name, 'name');
    ArgumentError.checkNotNull(username, 'username');
    ArgumentError.checkNotNull(email, 'email');
    ArgumentError.checkNotNull(password, 'password');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    if (name != null) {
      _data.fields.add(MapEntry('name', name));
    }
    if (username != null) {
      _data.fields.add(MapEntry('username', username));
    }
    if (email != null) {
      _data.fields.add(MapEntry('email', email));
    }
    if (password != null) {
      _data.fields.add(MapEntry('password', password));
    }
    final _result = await _dio.request<Map<String, dynamic>>('${baseUrl}auth/register',
        queryParameters: queryParameters,

        options: Options(
            method: 'POST',

            headers: <String, dynamic>{},
            extra: _extra,
           ),
        data: _data);
    final value = SignInDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SignInDTO> signIn(username, password, deviceToken) async {

    ArgumentError.checkNotNull(username, 'username');
    ArgumentError.checkNotNull(password, 'password');
    ArgumentError.checkNotNull(deviceToken, 'device_token');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    if (username != null) {
      print("username true");
      print(username);
      _data.fields.add(MapEntry('username', username));
    }
    if (password != null) {
      print("password true");
      print(password);
      _data.fields.add(MapEntry('password', password));
    }
    if (deviceToken != null) {
      print("device_token true");
      print(deviceToken);

      _data.fields.add(MapEntry('device_token',deviceToken));
    }
    print("_data");
    FormData formData = FormData.fromMap({
     "username":username,
      "password":password,
      "device_token":deviceToken
    });

    print(_data);
    final _result = await Dio().request<Map<String, dynamic>>('https://api.klosrr.com/api/v1/auth/login',
        queryParameters: queryParameters,
        options: Options(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
         ),
        data:_data);
    print("_result");
    print(_result.data);
    final value = SignInDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SignInDTO> updateUser(token, userInfo) async {
    ArgumentError.checkNotNull(token, 'token');
    ArgumentError.checkNotNull(userInfo, 'userInfo');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(userInfo.toJson() );
    final _result = await _dio.request<Map<String, dynamic>>('${baseUrl}user-update',
        queryParameters: queryParameters,
        options:Options(
            method: 'POST',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
          ),
        data: _data);
    final value = SignInDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<NearByUserDTO> getNearbyZones(
      token, latitude, longitude, distance) async {
    ArgumentError.checkNotNull(token, 'token');
    ArgumentError.checkNotNull(latitude, 'latitude');
    ArgumentError.checkNotNull(longitude, 'longitude');
    ArgumentError.checkNotNull(distance, 'distance');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    if (latitude != null) {
      _data.fields.add(MapEntry('latitude', latitude));
    }
    if (longitude != null) {
      _data.fields.add(MapEntry('longitude', longitude));
    }
    if (distance != null) {
      _data.fields.add(MapEntry('distance', distance));
    }
    final _result = await _dio.request<Map<String, dynamic>>(
        '${baseUrl}user-near-location',
        queryParameters: queryParameters,
        options: Options(
            method: 'POST',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
        ),
        data: _data);
    final value = NearByUserDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SendRequestDTO> sendRequestToUsers(token, user_id) async {
    ArgumentError.checkNotNull(token, 'token');
    ArgumentError.checkNotNull(user_id, 'user_id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    if (user_id != null) {
      _data.fields.add(MapEntry('user_id', user_id));
    }
    final _result = await _dio.request<Map<String, dynamic>>('${baseUrl}friend-request',
        queryParameters: queryParameters,
        options:Options(
            method: 'POST',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
        ),
        data: _data);
    final value = SendRequestDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ShowRequestDTO> showRequest(token) async {
    ArgumentError.checkNotNull(token, 'token');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('${baseUrl}requests',
        queryParameters: queryParameters,
        options: Options(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
           ),
        data: _data);
    final value = ShowRequestDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<RequestAcceptDTO> requestAccept(token, user_id) async {
    ArgumentError.checkNotNull(token, 'token');
    ArgumentError.checkNotNull(user_id, 'user_id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    if (user_id != null) {
      _data.fields.add(MapEntry('user_id', user_id));
    }
    final _result = await _dio.request<Map<String, dynamic>>(
        '${baseUrl}friend-request-accept',
        queryParameters: queryParameters,
        options: Options(
            method: 'POST',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
           ),
        data: _data);
    final value = RequestAcceptDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<RequestRejectDTO> requestReject(token, user_id) async {
    ArgumentError.checkNotNull(token, 'token');
    ArgumentError.checkNotNull(user_id, 'user_id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    if (user_id != null) {
      _data.fields.add(MapEntry('user_id', user_id));
    }
    final _result = await _dio.request<Map<String, dynamic>>(
        '${baseUrl}friend-request-reject',
        queryParameters: queryParameters,
        options: Options(
            method: 'POST',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
         ),
        data: _data);
    final value = RequestRejectDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<FriendsDTO> friends(token) async {
    ArgumentError.checkNotNull(token, 'token');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('${baseUrl}friends',
        queryParameters: queryParameters,
        options: Options(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            ),
        data: _data);
    final value = FriendsDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<UnFriendDTO> unFriend(token, user_id) async {
    ArgumentError.checkNotNull(token, 'token');
    ArgumentError.checkNotNull(user_id, 'user_id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    if (user_id != null) {
      _data.fields.add(MapEntry('user_id', user_id));
    }
    final _result = await _dio.request<Map<String, dynamic>>('${baseUrl}unfriend',
        queryParameters: queryParameters,
        options: Options(
            method: 'POST',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            ),
        data: _data);
    final value = UnFriendDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<RequestAcceptDTO> saveCLocation(token, latitude, longitude) async {
    ArgumentError.checkNotNull(token, 'token');
    ArgumentError.checkNotNull(latitude, 'latitude');
    ArgumentError.checkNotNull(longitude, 'longitude');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    if (latitude != null) {
      _data.fields.add(MapEntry('latitude', latitude.toString()));
    }
    if (longitude != null) {
      _data.fields.add(MapEntry('longitude', longitude.toString()));
    }
    final _result = await _dio.request<Map<String, dynamic>>('${baseUrl}user-location',
        queryParameters: queryParameters,
        options: Options(
            method: 'POST',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
          ),
        data: _data);
    final value = RequestAcceptDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GenderListDTO> genderList(token) async {
    ArgumentError.checkNotNull(token, 'token');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('${baseUrl}gender-list',
        queryParameters: queryParameters,
        options:Options(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
           ),
        data: _data);
    final value = GenderListDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SuggestGenderDTO> suggestGender(token, gender) async {
    ArgumentError.checkNotNull(token, 'token');
    ArgumentError.checkNotNull(gender, 'gender');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    if (gender != null) {
      _data.fields.add(MapEntry('gender', gender));
    }
    final _result = await _dio.request<Map<String, dynamic>>(
        '${baseUrl}gender-suggestion',
        queryParameters: queryParameters,
        options: Options(
            method: 'POST',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
           ),
        data: _data);
    final value = SuggestGenderDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetUserDTO> getUser(token) async {
    ArgumentError.checkNotNull(token, 'token');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('${baseUrl}user',
        queryParameters: queryParameters,
        options: Options(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
          ),
        data: _data);
    final value = GetUserDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SuggestGenderDTO> updateImage(token, image) async {
    ArgumentError.checkNotNull(token, 'token');
    ArgumentError.checkNotNull(image, 'image');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    _data.files.add(MapEntry(
        'image',
        MultipartFile.fromFileSync(image.path,
            filename: image.path.split(Platform.pathSeparator).last)));
    final _result = await _dio.request<Map<String, dynamic>>('${baseUrl}update-image',
        queryParameters: queryParameters,
        options: Options(
            method: 'POST',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            ),
        data: _data);
    final value = SuggestGenderDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BlockDTO> block(token, block_user) async {
    ArgumentError.checkNotNull(token, 'token');
    ArgumentError.checkNotNull(block_user, 'block_user');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    if (block_user != null) {
      _data.fields.add(MapEntry('block_user', block_user));
    }
    final _result = await _dio.request<Map<String, dynamic>>('${baseUrl}block',
        queryParameters: queryParameters,
        options:Options(
            method: 'POST',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
           ),
        data: _data);
    final value = BlockDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BlockListDTO> blockList(token) async {
    ArgumentError.checkNotNull(token, 'token');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('${baseUrl}block-list',
        queryParameters: queryParameters,
        options: Options(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            ),
        data: _data);
    final value = BlockListDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<unBlockDTO> unBlock(token, unblock_user) async {
    ArgumentError.checkNotNull(token, 'token');
    ArgumentError.checkNotNull(unblock_user, 'unblock_user');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    if (unblock_user != null) {
      _data.fields.add(MapEntry('unblock_user', unblock_user));
    }
    final _result = await _dio.request<Map<String, dynamic>>('${baseUrl}unblock',
        queryParameters: queryParameters,
        options: Options(
            method: 'POST',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
           ),
        data: _data);
    final value = unBlockDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ReportDTO> report(token, user_report, message) async {
    ArgumentError.checkNotNull(token, 'token');
    ArgumentError.checkNotNull(user_report, 'user_report');
    ArgumentError.checkNotNull(message, 'message');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    if (user_report != null) {
      _data.fields.add(MapEntry('user_report', user_report));
    }
    if (message != null) {
      _data.fields.add(MapEntry('message', message));
    }
    final _result = await _dio.request<Map<String, dynamic>>('${baseUrl}report',
        queryParameters: queryParameters,
        options: Options(
            method: 'POST',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            ),
        data: _data);
    final value = ReportDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GhostModeDTO> ghostMode(token, mode) async {
    ArgumentError.checkNotNull(token, 'token');
    ArgumentError.checkNotNull(mode, 'mode');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    if (mode != null) {
      _data.fields.add(MapEntry('mode', mode));
    }
    final _result = await _dio.request<Map<String, dynamic>>('${baseUrl}ghost-mode',
        queryParameters: queryParameters,
        options: Options(
            method: 'POST',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            ),
        data: _data);
    final value = GhostModeDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<NearByUserDTO> applyFilter(
      token, gender, distance, min_age, max_age) async {
    ArgumentError.checkNotNull(token, 'token');
    ArgumentError.checkNotNull(gender, 'gender');
    ArgumentError.checkNotNull(distance, 'distance');
    ArgumentError.checkNotNull(min_age, 'min_age');
    ArgumentError.checkNotNull(max_age, 'max_age');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    if (gender != null) {
      _data.fields.add(MapEntry('gender', gender));
    }
    if (distance != null) {
      _data.fields.add(MapEntry('distance', distance.toString()));
    }
    if (min_age != null) {
      _data.fields.add(MapEntry('min_age', min_age.toString()));
    }
    if (max_age != null) {
      _data.fields.add(MapEntry('max_age', max_age.toString()));
    }
    final _result = await _dio.request<Map<String, dynamic>>('${baseUrl}filter',
        queryParameters: queryParameters,
        options:Options(
            method: 'POST',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
          ),
        data: _data);
    final value = NearByUserDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SuggestGenderDTO> verifyEmail(email) async {
    ArgumentError.checkNotNull(email, 'email');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    if (email != null) {
      _data.fields.add(MapEntry('email', email));
    }
    final _result = await _dio.request<Map<String, dynamic>>('${baseUrl}verify-eamil',
        queryParameters: queryParameters,
        options: Options(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            ),
        data: _data);
    final value = SuggestGenderDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<VerifyCodeDTO> verifyCode(verification_code) async {
    ArgumentError.checkNotNull(verification_code, 'verification_code');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    if (verification_code != null) {
      _data.fields.add(MapEntry('verification_code', verification_code));
    }
    final _result = await _dio.request<Map<String, dynamic>>('${baseUrl}verify-code',
        queryParameters: queryParameters,
        options: Options(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
        ),
        data: _data);
    final value = VerifyCodeDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SuggestGenderDTO> updatePassword(remember_token, password) async {
    ArgumentError.checkNotNull(remember_token, 'remember_token');
    ArgumentError.checkNotNull(password, 'password');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    if (remember_token != null) {
      _data.fields.add(MapEntry('remember_token', remember_token));
    }
    if (password != null) {
      _data.fields.add(MapEntry('password', password));
    }
    final _result = await _dio.request<Map<String, dynamic>>('${baseUrl}update-password',
        queryParameters: queryParameters,
        options: Options(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            ),
        data: _data);
    final value = SuggestGenderDTO.fromJson(_result.data!);
    return value;
  }
}
