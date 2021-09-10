import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_login/theme.dart';
import 'package:flutter_login/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui_app_saif/widgets/animated_numeric_text.dart';
import 'package:ui_app_saif/widgets/color_resources.dart';
import 'package:ui_app_saif/widgets/fade_in.dart';
import 'package:ui_app_saif/widgets/round_button.dart';

import '../constants.dart';
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
      child: Text('الصفحة الرئيسية',
        style:GoogleFonts.tajawal(color: Colors.redAccent[100],fontSize: 24),
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
        childAspectRatio: .9,
        // crossAxisSpacing: 5,
      crossAxisCount: 2,
      controller: new ScrollController(keepScrollOffset: false),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      // Generate 100 Widgets that display their index in the List
          children: [
            _buildButton('بنك الاسئلة', Icon(FontAwesomeIcons.question,color: iconColor,size: iconSize),),
            _buildButton('ملفات', Icon(FontAwesomeIcons.file,color: iconColor,size: iconSize),),
            _buildButton('امتحانات', Icon(FontAwesomeIcons.tasks,color: iconColor,size: iconSize),),
            _buildButton('فيدوهات', Icon(FontAwesomeIcons.fileVideo,color: iconColor,size: iconSize),),
            _buildButton('رسائل', Icon(Icons.messenger,color: iconColor,size: iconSize),),
            _buildButton('باركود', Icon(FontAwesomeIcons.qrcode,color: iconColor,size: iconSize),),

          ],
    );
  }


  Widget _buildButton(String text, Icon icon) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          color:  ColorResources.Beige,
          border: Border.all(
            color: ColorResources.Orange,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            SizedBox(height:12),
            Text(text,style: GoogleFonts.tajawal(color: ColorResources.RedOrange,fontSize: 16),)
          ],
        ),
      ),
    );
  }

  // Widget _buildDebugButtons() {
  //   const textStyle = TextStyle(fontSize: 12, color: Colors.white);
  //
  //   return Positioned(
  //     bottom: 0,
  //     right: 0,
  //     child: Row(
  //       children: <Widget>[
  //         MaterialButton(
  //           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //           color: Colors.red,
  //           onPressed: () => _loadingController!.value == 0
  //               ? _loadingController!.forward()
  //               : _loadingController!.reverse(),
  //           child: Text('loading', style: textStyle),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
