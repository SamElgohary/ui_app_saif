import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui_app_saif/widgets/change_pass_dilog.dart';
import 'package:ui_app_saif/widgets/color_resources.dart';
import 'package:ui_app_saif/widgets/fade_in.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return  Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0, // This removes the shadow from all App Bars.
        backgroundColor: Colors.white,
        //backgroundColor: mainColor,
        title: Center(
          child: Text('الصفحه الشخصيه',
            style: GoogleFonts.tajawal(color: ColorResources.Blue, fontSize: 24),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,),
        ),
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage("assets/images/bg_logo.png"),
              fit: BoxFit.cover,
            ),
          ),
        child:  SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 73),
            child: Column(
              children: [

                Container(
                  height: height * 0.43,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double innerHeight = constraints.maxHeight;
                      double innerWidth = constraints.maxWidth;
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: innerHeight * 0.72,
                              width: innerWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.grey[700],
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 80,
                                  ),

                                  Text(
                                    'سيف الدين احمد',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.tajawal(fontSize: 24,color: Colors.white,fontWeight: FontWeight.bold),
                                  ),


                                  Text(
                                    'الصف الاول الثانوي',
                                      style: GoogleFonts.tajawal(fontSize: 18,color: ColorResources.Orange)
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [

                                      Container(
                                        width: 150,
                                        child:    Column(
                                          children: [
                                            Text(
                                                'الاشتراك الشهرى',
                                                style: GoogleFonts.tajawal(fontSize: 18,color: Colors.white)
                                            ),
                                            Text(
                                                '24',
                                                style: GoogleFonts.tajawal(fontSize: 18,color: ColorResources.Orange)
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 32,
                                          vertical: 8,
                                        ),
                                        child: Container(
                                          height: 50,
                                          width: 3,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(100),
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                     Container(
                                       width: 150,
                                       child:  Column(
                                         children: [
                                           Text(
                                               'عدد النقاط',
                                               style: GoogleFonts.tajawal(fontSize: 18,color: Colors.white)
                                           ),
                                           Text(
                                               '2',
                                               style: GoogleFonts.tajawal(fontSize: 18,color: ColorResources.Orange)
                                           ),
                                         ],
                                       ),
                                     ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                child: Image.asset(
                                  'assets/images/male.png',
                                  width: innerWidth * 0.45,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ),


                        ],
                      );
                    },
                  ),
                ),

                Container(
                  height: height * 0.5,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [

                        Text(
                          '',
                          style: TextStyle(
                            color: Color.fromRGBO(39, 105, 171, 1),
                            fontSize: 27,
                            fontFamily: 'Nunito',
                          ),
                        ),
                        Divider(
                          thickness: 2.5,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                       _buildPhone('01033003504', 'رقم الهاتف',  Icon(Icons.phone_android, color: ColorResources.Orange,),),
                        SizedBox(
                          height: 10,
                        ),
                        _buildPhone('01001136518', 'رقم هاتف ولي الامر',  Icon(Icons.phone_android, color: ColorResources.Orange,),),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          child: Container(
                            height: 75.0,
                            decoration: BoxDecoration(
                              color: Colors.grey[700],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color:  ColorResources.Orange,
                                width: 2.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal:8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [


                                  Text(
                                      'اعادة تعين كلمة المرور',
                                      style: GoogleFonts.tajawal(fontSize: 18,color: ColorResources.Orange)
                                  ),


                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            showDialog(context: context, builder: (BuildContext context) {return AdvanceCustomAlert();});
                          },),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),

    );
  }

  Widget _buildPhone(String phoneNum, String PhoneText, Icon icon) {
    return  Container(
      height: 75.0,
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Text(
                phoneNum,
                style: GoogleFonts.tajawal(fontSize: 16,color: Colors.white)
            ),

            SizedBox(width: 8,),

            Text(
                ':',
                style: GoogleFonts.tajawal(fontSize: 18,color: ColorResources.Orange)
            ),

            Text(
                PhoneText,
                style: GoogleFonts.tajawal(fontSize: 18,color: ColorResources.Orange)
            ),
            SizedBox(width: 8,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:4.0),
              child: icon,
            ) ,

          ],
        ),
      ),
    );
  }

}