import 'package:flutter/material.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui_app_saif/widgets/color_resources.dart';
import 'package:ui_app_saif/widgets/fade_in.dart';
import 'package:ui_app_saif/widgets/side_menu.dart';
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

  FSBStatus drawerStatus = FSBStatus.FSB_CLOSE;

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
      color: ColorResources.Blue,
      icon: const Icon(FontAwesomeIcons.bars),
      onPressed: () {
        setState(() {
          drawerStatus = drawerStatus == FSBStatus.FSB_OPEN
              ? FSBStatus.FSB_CLOSE
              : FSBStatus.FSB_OPEN;
        });
      },
    );
    final signOutBtn = IconButton(
      icon: const Icon(FontAwesomeIcons.signOutAlt),
      color: ColorResources.Blue,
      onPressed: () => _goToLogin(context),
    );
    final title = Center(
      child: Text(
        'الصفحة الرئيسية',
        style: GoogleFonts.tajawal(color: ColorResources.Blue, fontSize: 24),
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
      ),
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
      backgroundColor: Colors.white,
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
    double iconSize = 32.0;

    return GridView.count(
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
        _buildButton(
          'بنك الاسئلة',
          "assets/images/questions_tran.png",
        ),
        _buildButton('امتحانات', "assets/images/exam_tran.png"),
        _buildButton('فيدوهات', "assets/images/video_tran.png"),
        _buildButton('ملفات', "assets/images/files_tran.png"),
        _buildButton(
          'رسائل',
          "assets/images/message_tran.png",
        ),
        _buildButton(
          'باركود',
          "assets/images/qr_tran.png",
        ),
        _buildButton(
          'سجلات',
          "assets/images/re_tran.png",
        ),
      ],
    );
  }

  Widget _buildButton(String text, String img) {
    return Container(
      margin: new EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: GestureDetector(
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(
                img,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                text,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: GoogleFonts.tajawal(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        onTap: () {},
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
          body: FoldableSidebarBuilder(
            drawerBackgroundColor: Colors.deepOrange,
            drawer: CustomDrawer(
              closeDrawer: () {
                setState(() {
                  drawerStatus = FSBStatus.FSB_CLOSE; // For Closing the Sidebar
                });
              },
            ),
            screenContents: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(.1),
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg_logo.png"),
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
                        Expanded(flex: 8, child: _buildDashboardGrid()),
                      ],
                    ),
                  ],
                )), // Your Screen Widget
            status: drawerStatus,
          ),

        ),
      ),
    );
  }
}

