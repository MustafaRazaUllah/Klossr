import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  Future<bool> isExists(String inputString) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var check = prefs.getString(inputString);
    return check == null ? false : true;
  }

  setUserInfo(token, name, username, email, age, ghost_mode, about_me, latitude,
      longitude, password, image) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    prefs.setString('name', name);
    prefs.setString('username', username);
    prefs.setString('email', email);
    prefs.setInt('age', age);
    prefs.setBool('ghost_mode', ghost_mode);
    prefs.setString('about_me', about_me);
    // prefs.setString('gender', gender);
    // prefs.setString('intrested_in', intrested_in);
    prefs.setDouble('latitude', latitude != null ? latitude : 0.0);
    prefs.setDouble('longitude', longitude != null ? longitude : 0.0);
    prefs.setString('pass', password);
    prefs.setString("image", image);
  }

  setUserId(id) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('id', id);
  }

  setUserYu(id) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('yu', id);
  }

  messageClear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("yu");
  }

  Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    var _userId = prefs.getString('id');
    return _userId!;
  }

  Future<String> getUserYu() async {
    final prefs = await SharedPreferences.getInstance();
    var _userId = prefs.getString('yu');
    return _userId!;
  }

  Logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    var _userToken = prefs.getString('token');
    return _userToken;
  }

  setName(name) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
  }

  Future<String> getName() async {
    final prefs = await SharedPreferences.getInstance();
    var _name = prefs.getString('name');
    return _name!;
  }

  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    var _name = prefs.getString('username');
    return _name!;
  }

  Future<String> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    var _email = prefs.getString('email');
    return _email!;
  }

  setFirebaseToken(token) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('FCMToken', token);
  }

  Future<String> getFirebaseToken() async {
    final prefs = await SharedPreferences.getInstance();
    var _token = prefs.getString('FCMToken');
    print(_token);
    return _token!;
  }

  setImage(image) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('image', image);
    print("Update Images User " + await prefs.getString('image').toString());
  }

  getImage() async {
    final prefs = await SharedPreferences.getInstance();
    var _image = prefs.getString('image');
    print("_image");
    print(_image);
    return _image;
  }

  setAge(age) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt('age', age);
  }

  Future<int> getAge() async {
    final prefs = await SharedPreferences.getInstance();
    var _age = prefs.getInt('age');

    if (_age != null) {
      return _age;
    } else {
      return 18;
    }
  }

  setGhostMode(mode) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('ghost_mode', mode);
  }

  Future<bool> getGhostMode() async {
    final prefs = await SharedPreferences.getInstance();
    var _ghostMode = prefs.getBool('ghost_mode');
    return _ghostMode!;
  }

  setAboutMe(aboutMe) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('about_me', aboutMe);
  }

  Future<String> getAboutMe() async {
    final prefs = await SharedPreferences.getInstance();
    var _aboutMe = prefs.getString('about_me');
    return _aboutMe!;
  }

  setGender(gender) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('gender', gender);
  }

  Future<String> getGender() async {
    final prefs = await SharedPreferences.getInstance();
    var _gender = prefs.getString('gender');

    if (_gender != null) {
      return _gender;
    } else {
      return "Female";
    }
  }

  setInterestedIn(interestedIn) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('intrested_in', interestedIn);
  }

  Future<String> getInterestedIn() async {
    final prefs = await SharedPreferences.getInstance();
    var _interestedIn = prefs.getString('intrested_in');
    return _interestedIn!;
  }

  setLatitude(lat) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', lat);
  }

  Future<double> getLatitude() async {
    final prefs = await SharedPreferences.getInstance();
    var _lat = prefs.getDouble('latitude');

    if (_lat != null) {
      return _lat;
    } else {
      return 0.0;
    }
  }

  setLongitude(long) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setDouble('longitude', long);
  }

  Future<double> getLongitude() async {
    final prefs = await SharedPreferences.getInstance();
    var _long = prefs.getDouble('longitude');

    if (_long != null) {
      return _long;
    } else {
      return 0.0;
    }
  }

  setPassword(pass) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('pass', pass);
  }

  Future<String> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    var _pass = prefs.getString('pass');
    return _pass!;
  }
}
