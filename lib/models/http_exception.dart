import 'package:flutter/semantics.dart';

class HttpException implements Exception{
  final String msg;
  HttpException(this.msg);

  @override
  String toString(){
    return msg;
  }
}

