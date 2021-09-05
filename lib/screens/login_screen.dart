import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ui_app_saif/widgets/color_resources.dart';
import '../constants.dart';
import '../custom_route.dart';
import '../users.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/auth';

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  Future<String?> _loginUser(LoginData data) {
    return Future.delayed(loginTime).then((_) {
      if (!mockUsers.containsKey(data.name)) {
        return 'User not exists';
      }
      if (mockUsers[data.name] != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      if (!mockUsers.containsKey(name)) {
        return 'User not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Directionality(
      textDirection: TextDirection.rtl,
      child:  FlutterLogin(
        logo: 'assets/images/logo.png',
        logoTag: Constants.logoTag,
        titleTag: Constants.titleTag,
        navigateBackAfterRecovery: true,
        hideForgotPasswordButton: true,
        // loginProviders: [
        //   LoginProvider(
        //     icon: FontAwesomeIcons.google,
        //     label: 'جوجل',
        //     callback: () async {
        //       print('start google sign in');
        //       await Future.delayed(loginTime);
        //       print('stop google sign in');
        //       return '';
        //     },
        //   ),
        //   LoginProvider(
        //     icon: FontAwesomeIcons.facebook,
        //     label: 'فيسبوك',
        //     callback: () async {
        //       print('start linkdin sign in');
        //       await Future.delayed(loginTime);
        //       print('stop linkdin sign in');
        //       return '';
        //     },
        //   ),
        //
        // ],
        // hideProvidersTitle: false,
        // loginAfterSignUp: false,
        // hideForgotPasswordButton: true,
        // hideSignUpButton: true,
        // disableCustomPageTransformer: true,
        messages: LoginMessages(
            userHint: 'الاسم رباعى بالعربى',
            passwordHint: 'ادخل الرقم السرى',
            confirmPasswordHint: 'تأكيد الرقم السرى',
            phoneNumberHint: 'ادخل رقم الهاتف',
            loginButton: 'تسجيل الدخول',
            signupButton: 'تسجيل',
            forgotPasswordButton: 'نسيت كلمة المرور',
            recoverPasswordButton: 'مساعدة',
            goBackButton: 'رجوع',
            confirmPasswordError: 'غير متطابق',
            recoverPasswordIntro: 'خطأ',
            recoverPasswordDescription: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
            recoverPasswordSuccess: 'تم تغير الرقم السري بنجاح',
            flushbarTitleError: 'خطأ',
            flushbarTitleSuccess: 'تم',
            providersTitle: 'الدخول بواسطة',
            phoneError: 'برجاء ادخال رقم الهاتف',
            fatherPhoneError: 'برجاء ادخال رقم هاتف ولي الامر',
          fatherPhoneNumberHint: 'ادخل رقم هاتف ولي الامر'
        ),
        theme: LoginTheme(
          primaryColor: ColorResources.RedSummer,
          accentColor:ColorResources.Orange,
          errorColor: Colors.deepOrange,
          pageColorLight: ColorResources.RedSummer,
          pageColorDark: ColorResources.RedSummer,
          titleStyle: TextStyle(
            color: Colors.white,
            fontFamily: 'Quicksand',
            letterSpacing: 4,
          ),
          // beforeHeroFontSize: 50,
          // afterHeroFontSize: 20,
          bodyStyle: TextStyle(
            fontStyle: FontStyle.italic,
            decoration: TextDecoration.underline,
          ),

          buttonStyle: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),


        ),
        userValidator: (value) {
          if (value!.isEmpty) {
            return "برجاء ادخال الاسم";
          }
          return null;
        },
        passwordValidator: (value) {
          if (value!.isEmpty) {
            return 'برجاء ادخال الرقم السرى';
          }
          return null;
        },
        onLogin: (loginData) {
          print('Login info');
          print('Name: ${loginData.name}');
          print('Password: ${loginData.password}');
          return _loginUser(loginData);
        },
        onSignup: (loginData) {
          print('Signup info');
          print('Name: ${loginData.name}');
          print('Password: ${loginData.password}');
          return _loginUser(loginData);
        },
        onSubmitAnimationCompleted: () {
          // Navigator.of(context).pushReplacement(FadePageRoute(
          //   builder: (context) => DashboardScreen(),
          // ));
        },
        onRecoverPassword: (name) {
          print('Recover password info');
          print('Name: $name');
          return _recoverPassword(name);
          // Show new password dialog
        },
        showDebugButtons: false,
      ),
    );
  }
}
