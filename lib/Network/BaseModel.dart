
import 'ServerError.dart';

class BaseModel<T> {
  ServerError ? _error;
  T ? data;
  int ? statusCode ;
  setException(ServerError error) {
    _error = error;
  statusCode = error.getErrorCode();
  print("status Code $statusCode");
  }
   setStatusCode(int value) {
    statusCode = value;
  }

  setData(T data) {
    this.data = data;
  }
  get getException {
    return _error;
  }
}