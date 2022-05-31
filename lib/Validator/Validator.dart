class Validator {
  Validator();

  bool isNameTrue(String fname) {
    if (fname.isEmpty) {
      return false;
    }
    if (fname.length <= 2) {
      return false;
    }

    if (fname.length > 20) {
      return false;
    } else
      return true;
  }

  bool isEmailTrue(String email) {
    if (email.trim().isEmpty) {
      return false;
    }
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email.trim())) {
      return false;
    } else
      return true;
  }

  bool isPasswordTrue(String s) {
    if (s.isEmpty) {
      return false;
    }
    if (s.length < 8) {
      return false;
    } else
      return true;
  }

  bool isTextTrue(String fname) {
    if (fname.isEmpty) {
      return false;
    }
    if (fname.length <= 2) {
      return false;
    } else
      return true;
  }

  bool isUsernameTrue(String username) {
    if (username.trim().isEmpty) {
      return false;
    } else
      return true;
  }
}
