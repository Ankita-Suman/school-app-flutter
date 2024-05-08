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
          'forgotPasswordText': 'Forgot Password',
          'rememberMe': 'Remember me',
          'signIn': 'SIGN IN',
          'home': 'Home',
          'homeWork': 'Homework',
          'timeTable': 'Time-Table',
          'calender': 'Calender',
          'viewProfile': 'View Profile',
          'academics': 'Academics',
          'others': 'Others',
          'noticeBoard': 'Notice Board',
          'viewAll': 'View All',
          'registerYourSelf': 'Register yourself on school portal',
          'passwordRequired': 'Password is required',
          'mobileNumberEmail': 'Mobile Number/Email',
          'resetPassword': 'RESET PASSWORD',
          'checkYouEmail': 'Check your email',
          'sendPassword': 'We have send password recovery instruction to your email',
          'enterMobileNumber': 'Enter your Mobile Number/Email account to reset  your password',
          'shouldBe6Characters':
          'The password must be at least 8 characters long with one uppercase letter, one lowercase letter, one digit and one special character. ',
        }
      };
}
