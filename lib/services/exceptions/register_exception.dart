import 'package:flutter/services.dart';

class RegisterException extends PlatformException{

  RegisterException(PlatformException exception) : super(code: exception.code, message: exception.message, details: exception.details);
}