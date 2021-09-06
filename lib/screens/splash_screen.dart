import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:ui_app_saif/widgets/color_resources.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return SplashScreenView(
      navigateRoute: LoginScreen(),
      duration: 3000,
      imageSize: 350,
      imageSrc: "assets/images/logof.gif",
      text: "",
      textType: TextType.ColorizeAnimationText,
      textStyle: TextStyle(
        fontSize: 40.0,
      ),
      colors: [
        ColorResources.Blue,
        ColorResources.Beige,
        ColorResources.Orange,
        ColorResources.RedSummer,
      ],
      backgroundColor: ColorResources.RedSummer,
    );
  }
}
