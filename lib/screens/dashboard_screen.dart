import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui_app_saif/widgets/color_resources.dart';
import 'package:ui_app_saif/widgets/fade_in.dart';
import '../transition_route_observer.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin, TransitionRouteAware {
  Future<bool> _goToLogin(BuildContext context) {
    return Navigator.of(context)
        .pushReplacementNamed('/')
        // we dont want to pop the screen, just replace it completely
        .then((_) => false);
  }

  final routeObserver = TransitionRouteObserver<PageRoute?>();
  static const headerAniInterval = Interval(.1, .3, curve: Curves.easeOut);
  late Animation<double> _headerScaleAnimation;
  AnimationController? _loadingController;


  @override
  void initState() {
    super.initState();

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    );

    _headerScaleAnimation =
        Tween<double>(begin: .6, end: 1).animate(CurvedAnimation(
      parent: _loadingController!,
      curve: headerAniInterval,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(
        this, ModalRoute.of(context) as PageRoute<dynamic>?);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _loadingController!.dispose();
    super.dispose();
  }

  @override
  void didPushAfterTransition() => _loadingController!.forward();

  AppBar _buildAppBar(ThemeData theme) {
    final menuBtn = IconButton(
      color: theme.accentColor,
      icon: const Icon(FontAwesomeIcons.bars),
      onPressed: () {},
    );
    final signOutBtn = IconButton(
      icon: const Icon(FontAwesomeIcons.signOutAlt),
      color: theme.accentColor,
      onPressed: () => _goToLogin(context),
    );
    final title = Center(
      child: Text('الصفحة الرئيسية',style:GoogleFonts.tajawal(color: Colors.redAccent[100],fontSize: 24),
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,),
    );

    return AppBar(
      leading: FadeIn(
        controller: _loadingController,
        offset: .3,
        curve: headerAniInterval,
        fadeDirection: FadeDirection.startToEnd,
        child: menuBtn,
      ),
      actions: <Widget>[
        FadeIn(
          controller: _loadingController,
          offset: .3,
          curve: headerAniInterval,
          fadeDirection: FadeDirection.endToStart,
          child: signOutBtn,
        ),
      ],
      title: title,
      backgroundColor: theme.primaryColor.withOpacity(.1),
      elevation: 0,
      textTheme: theme.accentTextTheme,
      iconTheme: theme.accentIconTheme,
    );
  }

  // Widget _buildHeader(ThemeData theme) {
  //   final primaryColor =
  //       Colors.primaries.where((c) => c == theme.primaryColor).first;
  //   final accentColor =
  //       Colors.primaries.where((c) => c == theme.accentColor).first;
  //   final linearGradient = LinearGradient(colors: [
  //     primaryColor.shade800,
  //     primaryColor.shade200,
  //   ]).createShader(Rect.fromLTWH(0.0, 0.0, 418.0, 78.0));
  //
  //   return ScaleTransition(
  //     scale: _headerScaleAnimation,
  //     child: FadeIn(
  //       controller: _loadingController,
  //       curve: headerAniInterval,
  //       fadeDirection: FadeDirection.bottomToTop,
  //       offset: .5,
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: <Widget>[
  //               Text(
  //                 '\$',
  //                 style: theme.textTheme.headline3!.copyWith(
  //                   fontWeight: FontWeight.w300,
  //                   color: accentColor.shade400,
  //                 ),
  //               ),
  //               SizedBox(width: 5),
  //               // AnimatedNumericText(
  //               //   initialValue: 14,
  //               //   targetValue: 3467.87,
  //               //   curve: Interval(0, .5, curve: Curves.easeOut),
  //               //   controller: _loadingController!,
  //               //   style: theme.textTheme.headline3!.copyWith(
  //               //     foreground: Paint()..shader = linearGradient,
  //               //   ),
  //               // ),
  //             ],
  //           ),
  //           // Text('Account Balance', style: theme.textTheme.caption),
  //         ],
  //       ),
  //     ),
  //   );
  // }


  Widget _buildDashboardGrid() {

    Color iconColor = ColorResources.RedOrange;
      double  iconSize = 32.0;

    return
      GridView.count(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 8,
        ),
        childAspectRatio: .8,
        // crossAxisSpacing: 5,
      crossAxisCount: 2,
      controller: new ScrollController(keepScrollOffset: false),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      // Generate 100 Widgets that display their index in the List
          children: [
            _buildButton('بنك الاسئلة',"https://www.edu2ksa.com/wp-content/uploads/2018/05/%D8%A8%D9%86%D9%83-%D8%A7%D9%84%D8%A7%D8%B3%D8%A6%D9%84%D8%A9-%D9%84%D9%85%D9%88%D8%A7%D8%AF-%D8%A7%D9%84%D8%B5%D9%81-%D8%A7%D9%84%D8%AB%D8%A7%D9%84%D8%AB-%D8%A7%D9%84%D8%A7%D8%A8%D8%AA%D8%AF%D8%A7%D8%A6%D9%8A-%D8%A7%D9%84%D9%81%D8%B5%D9%84-%D8%A7%D9%84%D8%AB%D8%A7%D9%86%D9%8A.jpg",),
            _buildButton('ملفات', "https://www.europarl.europa.eu/resources/library/images/20190612PHT54317/20190612PHT54317-ml.jpg"),
            _buildButton('امتحانات', "https://www.minia.edu.eg/images/nurse/nurse2020-08-042102381.jpg"),
            _buildButton('فيدوهات',"https://img.freepik.com/free-photo/online-live-video-marketing-concept_12892-37.jpg?size=626&ext=jpg&ga=GA1.2.1937627297.1630454400"),
            _buildButton('رسائل', "https://www.lifewire.com/thmb/IS4gxtmhvYTokbYCcm4ygOUBX50=/1920x1200/filters:fill(auto,1)/how-to-fix-the-unknown-message-not-found-on-iphone-error-849e332f4e9241db9cb80ef9ddb63e01.jpg",),
            _buildButton('باركود', "https://me.kaspersky.com/content/ar-ae/images/repository/isc/2020/9910/a-guide-to-qr-codes-and-how-to-scan-qr-codes-1.jpg",),

          ],
    );
  }


  Widget _buildButton(String text, String img) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          color:  ColorResources.Beige,
          border: Border.all(
            color: ColorResources.Orange,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          color: Colors.white,
          margin: new EdgeInsets.symmetric(
            horizontal: 3.0,
            vertical: 3.0,
          ),
          child: GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.5),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(1.0),
                    color: Colors.white
                ),

                child: Stack(children: [
                  Image.network(img,fit: BoxFit.cover,width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(1.0),
                        color: Colors.black38
                    ),),
                  Align(alignment:  Alignment.center,
                    child: Text(
                      text,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 3.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                        decoration: TextDecoration.none,
                        fontSize: 18,
                        fontFamily: "WorkSansMedium",
                        color: Colors.white,
                      ),
                    ),)
                ],),

              ),
            ),
            onTap: () {

            },

          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () => _goToLogin(context),
      child: SafeArea(
        child: Scaffold(
          appBar: _buildAppBar(theme),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(.1),
              image: DecorationImage(
                image: AssetImage("assets/images/bg_b.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    // Expanded(
                    //   flex: 2,
                    //   child: _buildHeader(theme),
                    // ),
                    Expanded(
                      flex: 8,
                      child:  _buildDashboardGrid()
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }


}

