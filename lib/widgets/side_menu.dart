import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:ui_app_saif/screens/profile_screen.dart';
import 'package:ui_app_saif/screens/subscribtion.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatelessWidget {
  final Function closeDrawer;

  const CustomDrawer({Key? key, required this.closeDrawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double iconSize = 32.0;

    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Container(
      color: Colors.white,
      width: mediaQuery.size.width * 0.60,
      height: mediaQuery.size.height,
      child: Column(
        children: <Widget>[
          Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey.withAlpha(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/images/logo.png",
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("د/ مصطفى شبايك")
                ],
              )),
          ListTile(
            onTap: () {
              debugPrint("Tapped Profile");
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
            leading: Icon(Icons.person),
            title: Text(
              "الملف الشخصى",
            ),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {
              debugPrint("subscription settings");

              Navigator.of(context).push(MaterialPageRoute(builder: (context) => PinCodeVerificationScreen(),
              ));

            },
            leading: Icon(Icons.refresh),
            title: Text("تجديد الاشتراك الشهري"),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {
              debugPrint("phone pressed");
              launch("tel://01033003504");

            },
            leading: Icon(Icons.phone_android),
            title: Text("للتواصل عبر الهاتف"),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {
              debugPrint("Tapped Share");

              if (Platform.isIOS) {
                Share.share(
                    'https://apps.apple.com');
              } else {
                Share.share(
                    'https://play.google.com/store/apps');
              }
            },
            leading: Icon(Icons.share),
            title: Text("مشاركة التطبيق"),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {
              debugPrint("تسجيل خروج");
            },
            leading: Icon(Icons.exit_to_app),
            title: Text("تسجيل الخروج"),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:16.0),
                  child: GestureDetector(
                    onTap: (){
                      _launchInBrowser('https://www.facebook.com/');
                    },
                    child:  Image.asset(
                      "assets/images/facebook.png",
                      width: iconSize,
                      height: iconSize,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:16.0),
                  child: GestureDetector(
                    onTap: () async {
                      String phone = "+20 10 33 003504";
                      String message = "مرحبا رساله ترحييب ونص تجريبي";

                      var whatsappUrl = '';

                      whatsappUrl = "whatsapp://send?phone=$phone&text=$message";
                      await canLaunch(whatsappUrl)
                          ? launch(whatsappUrl)
                          : debugPrint('Error');

                    },
                    child:  Image.asset(
                      "assets/images/whatsapp.png",
                      width: iconSize,
                      height: iconSize,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:16.0),
                  child: GestureDetector(
                    onTap: (){
                      _launchInBrowser('https://www.youtube.com/');
                    },
                    child:  Image.asset(
                      "assets/images/youtube.png",
                      width: iconSize,
                      height: iconSize,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
