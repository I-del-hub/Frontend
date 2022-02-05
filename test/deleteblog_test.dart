import 'package:blogapp/NetworkHandler.dart';
import 'package:blogapp/Pages/SinInPage.dart';
import 'package:blogapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
void main() {
  test('Wrong user name and password canot login', () async {
    // ignore: todo
    // TODO: Implement test

   
    NetworkHandler networkHandler = NetworkHandler();
    print("hello");
    var result = await networkHandler.delete1("/blogPost/delete/621e31a5ee8a473134404d4e");
    print(result.statusCode);
    expect(result.statusCode, 200);
  });
}
