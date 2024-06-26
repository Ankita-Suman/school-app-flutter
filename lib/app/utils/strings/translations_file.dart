import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TranslationsFile extends Translations {
  /// List of locales used in the application
  static const listOfLocales = <Locale>[
    Locale('en'),
  ];

  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'appName': 'SchoolApp',
          'shouldBeTwoOrLessThanForty':
          'Full name should be minimum 2 and maximum of 40 characters.',
          'pleaseEnterFullName': 'Please enter full name.',
          'pleaseEnterValidEmail': 'Please enter valid email.',
          'pleaseEnterEmail': 'Please enter email.',
          'password': 'Password',
          'forgotPassword': 'Forgot Password?',
          'rememberMe': 'Remember me',
          'signIn': 'SIGN IN',
          'home': 'Home',
          'homeWork': 'Homework',
          'timeTable': 'Time-Table',
          'calender': 'Calender',
          'passwordRequired': 'Password is required',
          'mobileNumberEmail': 'Mobile Number/Email',
          'shouldBe6Characters':
          'The password must be at least 8 characters long with one uppercase letter, one lowercase letter, one digit and one special character. ',
        }
      };
}
