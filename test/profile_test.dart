import 'package:blogapp/NetworkHandler.dart';

import 'package:blogapp/Pages/SinInPage.dart';

import 'package:blogapp/main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Wrong user name and password canot login', () async {

    // TODO: Implement test
    Map<String, String> data = {
                    "name": 'jiji1234567',               
                    "profession": 'backend developer',
                    "DOB": '01/02/2020',
                    "titleline": 'Hello',
                    "about": 'Great',
                  };
    
    NetworkHandler networkHandler = NetworkHandler();
    print("hello");
    var result = await networkHandler.post2("/profile/add", data);

    print(result.statusCode);

    expect(result.statusCode, 200);
  });
}
