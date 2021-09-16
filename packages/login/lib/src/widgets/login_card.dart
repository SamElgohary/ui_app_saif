part of auth_card;

class _LoginCard extends StatefulWidget {
  _LoginCard(
      {Key? key,
        this.loadingController,
        required this.userValidator,
        required this.passwordValidator,
        required this.onSwitchRecoveryPassword,
        required this.userType,
        this.onSwitchAuth,
        this.onSubmitCompleted,
        this.hideForgotPasswordButton = false,
        this.hideSignUpButton = false,
        this.loginAfterSignUp = true,
        this.hideProvidersTitle = false})
      : super(key: key);

  final AnimationController? loadingController;
  final FormFieldValidator<String>? userValidator;
  final FormFieldValidator<String>? passwordValidator;
  final Function onSwitchRecoveryPassword;
  final Function? onSwitchAuth;
  final Function? onSubmitCompleted;
  final bool hideForgotPasswordButton;
  final bool hideSignUpButton;
  final bool loginAfterSignUp;
  final bool hideProvidersTitle;
  final LoginUserType userType;

  @override
  _LoginCardState createState() => _LoginCardState();
}

class _LoginCardState extends State<_LoginCard> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _FatherPhoneFocusNode = FocusNode();




  TextEditingController? _nameController;
  TextEditingController? _passController;
  TextEditingController? _confirmPassController;
  TextEditingController? _phoneController;
  TextEditingController? _fatherPhoneController;


  var _isLoading = false;
  var _isSubmitting = false;
  var _showShadow = true;

  /// switch between login and signup
  late AnimationController _loadingController;
  late AnimationController _switchAuthController;
  late AnimationController _postSwitchAuthController;
  late AnimationController _submitController;

  ///list of AnimationController each one responsible for a authentication provider icon
  List<AnimationController> _providerControllerList = <AnimationController>[];

  Interval? _nameTextFieldLoadingAnimationInterval;
  Interval? _passTextFieldLoadingAnimationInterval;
  Interval? _textButtonLoadingAnimationInterval;
  late Animation<double> _buttonScaleAnimation;

  bool get buttonEnabled => !_isLoading && !_isSubmitting;

  String chooseYear = 'اختار السنة الدراسية';
  String chooseCentr = 'اختار اسم السنتر';
  var genderType= '';


  @override
  void initState() {
    super.initState();

    final auth = Provider.of<Auth>(context, listen: false);
    _nameController = TextEditingController(text: auth.email);
    _passController = TextEditingController(text: auth.password);
    _phoneController = TextEditingController(text: auth.phone);
    _fatherPhoneController = TextEditingController(text: auth.fhatherPhone);
    _confirmPassController = TextEditingController(text: auth.confirmPassword);

    _loadingController = widget.loadingController ??
        (AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 1150),
          reverseDuration: Duration(milliseconds: 300),
        )..value = 1.0);

    _loadingController.addStatusListener(handleLoadingAnimationStatus);

    _switchAuthController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _postSwitchAuthController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    _submitController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _providerControllerList = auth.loginProviders
        .map(
          (e) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1000),
      ),
    )
        .toList();

    _nameTextFieldLoadingAnimationInterval = const Interval(0, .85);
    _passTextFieldLoadingAnimationInterval = const Interval(.15, 1.0);
    _textButtonLoadingAnimationInterval =
    const Interval(.6, 1.0, curve: Curves.easeOut);
    _buttonScaleAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _loadingController,
          curve: Interval(.4, 1.0, curve: Curves.easeOutBack),
        ));
  }

  void handleLoadingAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.forward) {
      setState(() => _isLoading = true);
    }
    if (status == AnimationStatus.completed) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _loadingController.removeStatusListener(handleLoadingAnimationStatus);
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _phoneFocusNode.dispose();
    _FatherPhoneFocusNode.dispose();

    _switchAuthController.dispose();
    _postSwitchAuthController.dispose();
    _submitController.dispose();

    _providerControllerList.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  void _switchAuthMode() {
    final auth = Provider.of<Auth>(context, listen: false);
    final newAuthMode = auth.switchAuth();

    if (newAuthMode == AuthMode.Signup) {
      _switchAuthController.forward();
    } else {
      _switchAuthController.reverse();
    }
  }

  Future<bool> _submit() async {
    // a hack to force unfocus the soft keyboard. If not, after change-route
    // animation completes, it will trigger rebuilding this widget and show all
    // textfields and buttons again before going to new route
    FocusScope.of(context).requestFocus(FocusNode());

    final messages = Provider.of<LoginMessages>(context, listen: false);

    if (!_formKey.currentState!.validate()) {
      return false;
    }

    _formKey.currentState!.save();
    await _submitController.forward();
    setState(() => _isSubmitting = true);
    final auth = Provider.of<Auth>(context, listen: false);
    String? error;

    if (auth.isLogin) {
      error = await auth.onLogin!(LoginData(
        name: auth.email,
        password: auth.password,
        phone: auth.phone,
        fatherPhone: auth.fhatherPhone,
        gender: auth.gender,
        academicYear: auth.academicYear,
        centerName: auth.centerName,
      ));
    } else {
      error = await auth.onSignup!(LoginData(
        name: auth.email,
        password: auth.password,
        phone: auth.phone,
        fatherPhone: auth.fhatherPhone,
        gender: auth.gender,
        academicYear: auth.academicYear,
        centerName: auth.centerName,
      ));
    }

    // workaround to run after _cardSizeAnimation in parent finished
    // need a cleaner way but currently it works so..
    Future.delayed(const Duration(milliseconds: 270), () {
      setState(() => _showShadow = false);
    });

    await _submitController.reverse();

    if (!DartHelper.isNullOrEmpty(error)) {
      showErrorToast(context, messages.flushbarTitleError, error!);
      Future.delayed(const Duration(milliseconds: 271), () {
        setState(() => _showShadow = true);
      });
      setState(() => _isSubmitting = false);
      return false;
    }

    if (auth.isSignup && !widget.loginAfterSignUp) {
      showSuccessToast(
          context, messages.flushbarTitleSuccess, messages.signUpSuccess);
      _switchAuthMode();
      setState(() => _isSubmitting = false);
      return false;
    }

    widget.onSubmitCompleted!();

    return true;
  }

  Future<bool> _loginProviderSubmit(
      {required AnimationController control,
        required ProviderAuthCallback callback}) async {
    await control.forward();

    String? error;

    error = await callback();

    // workaround to run after _cardSizeAnimation in parent finished
    // need a cleaner way but currently it works so..
    Future.delayed(const Duration(milliseconds: 270), () {
      setState(() => _showShadow = false);
    });

    await control.reverse();

    final messages = Provider.of<LoginMessages>(context, listen: false);

    if (!DartHelper.isNullOrEmpty(error)) {
      showErrorToast(context, messages.flushbarTitleError, error!);
      Future.delayed(const Duration(milliseconds: 271), () {
        setState(() => _showShadow = true);
      });
      return false;
    }

    widget.onSubmitCompleted!();

    return true;
  }

  Widget _buildUserField(
      double width,
      LoginMessages messages,
      Auth auth,
      ) {
    return AnimatedTextFormField(
      controller: _nameController,
      width: width,
      loadingController: _loadingController,
      interval: _nameTextFieldLoadingAnimationInterval,
      labelText: messages.userHint,
      autofillHints: [TextFieldUtils.getAutofillHints(widget.userType)],
      prefixIcon: Icon(FontAwesomeIcons.solidUserCircle),
      keyboardType: TextFieldUtils.getKeyboardType(widget.userType),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      },
      validator: widget.userValidator,
      onSaved: (value) => auth.email = value!,
    );
  }

  Widget _buildPasswordField(double width, LoginMessages messages, Auth auth) {
    return AnimatedPasswordTextFormField(
      animatedWidth: width,
      loadingController: _loadingController,
      interval: _passTextFieldLoadingAnimationInterval,
      labelText: messages.passwordHint,
      autofillHints:
      auth.isLogin ? [AutofillHints.password] : [AutofillHints.newPassword],
      controller: _passController,
      textInputAction:
      auth.isLogin ? TextInputAction.done : TextInputAction.next,
      focusNode: _passwordFocusNode,
      onFieldSubmitted: (value) {
        if (auth.isLogin) {
          _submit();
        } else {
          // SignUp
          FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
        }
      },
      validator: widget.passwordValidator,
      onSaved: (value) => auth.password = value!,
    );
  }

  Widget _buildConfirmPasswordField(
      double width, LoginMessages messages, Auth auth) {
    return AnimatedPasswordTextFormField(
      animatedWidth: width,
      enabled: auth.isSignup,
      loadingController: _loadingController,
      inertiaController: _postSwitchAuthController,
      inertiaDirection: TextFieldInertiaDirection.right,
      labelText: messages.confirmPasswordHint,
      controller: _confirmPassController,
      textInputAction: TextInputAction.done,
      focusNode: _confirmPasswordFocusNode,
      onFieldSubmitted: (value) => _submit(),
      validator: auth.isSignup
          ? (value) {
        if (value != _passController!.text) {
          return messages.confirmPasswordError;
        }
        return null;
      }
          : (value) => null,
      onSaved: (value) => auth.confirmPassword = value!,
    );
  }

  Widget _buildPhoneNumberField(double width, LoginMessages messages, Auth auth) {
    return AnimatedPhoneTextFormField(
      animatedWidth: width,
      enabled: true,
      loadingController: _loadingController,
      inertiaController: _postSwitchAuthController,
      inertiaDirection: TextFieldInertiaDirection.right,
      labelText: messages.phoneNumberHint,
      controller: _phoneController,
      textInputAction: TextInputAction.next,
      focusNode: _phoneFocusNode,
      keyboardType: TextInputType.phone,
      onFieldSubmitted: (value) => _submit(),
      validator: true
          ? (value) {
        if (value != _phoneController!.text) {
          return messages.phoneError;
        }
        return null;
      }
          : (value) => null,
      onSaved: (value) => auth.phone = value!,
    );
  }

  Widget _buildFatherPhoneNumberField(double width, LoginMessages messages, Auth auth) {
    return AnimatedPhoneTextFormField(
      animatedWidth: width,
      enabled: auth.isSignup,
      loadingController: _loadingController,
      inertiaController: _postSwitchAuthController,
      inertiaDirection: TextFieldInertiaDirection.right,
      labelText: messages.fatherPhoneNumberHint,
      controller: _fatherPhoneController,
      textInputAction: TextInputAction.next,
      focusNode: _FatherPhoneFocusNode,
      keyboardType: TextInputType.phone,
      onFieldSubmitted: (value) => _submit(),
      validator: auth.isSignup
          ? (value) {
        if (value != _fatherPhoneController!.text) {
          return messages.fatherPhoneError;
        }
        return null;
      }
          : (value) => null,
      onSaved: (value) => auth.fhatherPhone = value!,
    );
  }

  Widget _buildForgotPassword(ThemeData theme, LoginMessages messages) {
    return FadeIn(
      controller: _loadingController,
      fadeDirection: FadeDirection.bottomToTop,
      offset: .5,
      curve: _textButtonLoadingAnimationInterval,
      child: TextButton(
        onPressed: buttonEnabled
            ? () {
          // save state to populate email field on recovery card
          _formKey.currentState!.save();
          widget.onSwitchRecoveryPassword();
        }
            : null,
        child: Text(
          messages.forgotPasswordButton,
          style: theme.textTheme.bodyText2,
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget _buildSubmitButton(
      ThemeData theme, LoginMessages messages, Auth auth) {
    return ScaleTransition(
      scale: _buttonScaleAnimation,
      child: AnimatedButton(
        controller: _submitController,
        text: auth.isLogin ? messages.loginButton : messages.signupButton,
        onPressed: _submit,
      ),
    );
  }

  Widget _buildSwitchAuthButton(ThemeData theme, LoginMessages messages,
      Auth auth, LoginTheme loginTheme) {
    final calculatedTextColor =
    (theme.cardTheme.color!.computeLuminance() < 0.5)
        ? Colors.white
        : theme.primaryColor;
    return FadeIn(
      controller: _loadingController,
      offset: .5,
      curve: _textButtonLoadingAnimationInterval,
      fadeDirection: FadeDirection.topToBottom,
      child: MaterialButton(
        disabledTextColor: theme.primaryColor,
        onPressed: buttonEnabled ? _switchAuthMode : null,
        padding: loginTheme.authButtonPadding ??
            EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textColor: loginTheme.switchAuthTextColor ?? calculatedTextColor,
        child: AnimatedText(
          text: auth.isSignup ? messages.loginButton : messages.signupButton,
          textRotation: AnimatedTextRotation.down,
        ),
      ),
    );
  }

  Widget _buildProvidersLogInButton(ThemeData theme, LoginMessages messages,
      Auth auth, LoginTheme loginTheme) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: auth.loginProviders.map((loginProvider) {
          var index = auth.loginProviders.indexOf(loginProvider);
          return Padding(
            padding: loginTheme.providerButtonPadding ??
                const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
            child: ScaleTransition(
              scale: _buttonScaleAnimation,
              child: Column(
                children: [
                  AnimatedIconButton(
                    icon: loginProvider.icon,
                    controller: _providerControllerList[index],
                    tooltip: '',
                    onPressed: () => _loginProviderSubmit(
                      control: _providerControllerList[index],
                      callback: () {
                        return loginProvider.callback();
                      },
                    ),
                  ),
                  Text(loginProvider.label)
                ],
              ),
            ),
          );
        }).toList());
  }

  Widget _buildProvidersTitle(LoginMessages messages) {
    return ScaleTransition(
        scale: _buttonScaleAnimation,
        child: Row(children: <Widget>[
          Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(messages.providersTitle),
          ),
          Expanded(child: Divider()),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: true);
    final isLogin = auth.isLogin;
    final messages = Provider.of<LoginMessages>(context, listen: false);
    final loginTheme = Provider.of<LoginTheme>(context, listen: false);
    final theme = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;
    final cardWidth = isLogin ? 310.0 :370.0;
    const cardPadding = 16.0;
    final textFieldWidth =  isLogin ? 310.0 :370.0;
    final authForm = Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: cardPadding,
              right: cardPadding,
              top: cardPadding + 10,
            ),
            width: cardWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //phone
                _buildPhoneNumberField(textFieldWidth, messages, auth),
                SizedBox(height: 20),
                _buildPasswordField(textFieldWidth, messages, auth),
                SizedBox(height: 10),
              ],
            ),
          ),
          ExpandableContainer(
            backgroundColor: theme.accentColor,
            controller: _switchAuthController,
            initialState: isLogin
                ? ExpandableContainerState.shrunk
                : ExpandableContainerState.expanded,
            alignment: Alignment.topLeft,
            color: theme.cardTheme.color,
            width: cardWidth,
            padding: EdgeInsets.symmetric(
              horizontal: cardPadding,
              vertical: 10,
            ),
            onExpandCompleted: () => _postSwitchAuthController.forward(),
            child: _buildConfirmPasswordField(textFieldWidth, messages, auth),
          ),

          //phone
          ExpandableContainer(
            backgroundColor: theme.accentColor,
            controller: _switchAuthController,
            initialState: isLogin
                ? ExpandableContainerState.shrunk
                : ExpandableContainerState.expanded,
            alignment: Alignment.topLeft,
            color: theme.cardTheme.color,
            width: cardWidth,
            padding: EdgeInsets.symmetric(
              horizontal: cardPadding,
              vertical: 10,
            ),
            onExpandCompleted: () => _postSwitchAuthController.forward(),
            child: _buildUserField(textFieldWidth, messages, auth),
          ),



          ExpandableContainer(
            backgroundColor: theme.accentColor,
            controller: _switchAuthController,
            initialState: isLogin
                ? ExpandableContainerState.shrunk
                : ExpandableContainerState.expanded,
            alignment: Alignment.topLeft,
            color: theme.cardTheme.color,
            width: cardWidth,
            padding: EdgeInsets.symmetric(
              horizontal: cardPadding,
              vertical: 10,
            ),
            onExpandCompleted: () => _postSwitchAuthController.forward(),
            child: _buildFatherPhoneNumberField(textFieldWidth, messages, auth),
          ),

          ExpandableContainer(
            backgroundColor: theme.accentColor,
            controller: _switchAuthController,
            initialState: isLogin
                ? ExpandableContainerState.shrunk
                : ExpandableContainerState.expanded,
            alignment: Alignment.topLeft,
            color: theme.cardTheme.color,
            width: cardWidth,
            padding: EdgeInsets.symmetric(
              horizontal: cardPadding,
              vertical: 10,
            ),
            onExpandCompleted: () => _postSwitchAuthController.forward(),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap:(){
                    setState(() {
                      genderType = 'male';
                    });
                    auth.gender = genderType;
                  },
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Image.asset("assets/images/male.png",width: 64,height: 64,fit: BoxFit.cover,),

                      Text('ذكر`',style: TextStyle(
                          color: genderType == 'male'? Colors.orange:Colors.black,
                          decoration: TextDecoration.none,
                          fontFamily: 'Quicksand'
                      )),

                    ],
                  ),
                ),
                SizedBox(width: 64,),
                GestureDetector(
                  onTap:(){
                    setState(() {
                      genderType = 'famale';
                    });
                    auth.gender = genderType;
                  },
                  child:   Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Image.asset("assets/images/famale.png",width: 64,height: 64,fit: BoxFit.cover,),

                      Text('انثى',style: TextStyle(
                          color: genderType == 'famale'? Colors.orange:Colors.black,
                          decoration: TextDecoration.none,
                          fontFamily: 'Quicksand'
                      ),
                      )

                    ],
                  ),
                )
              ],
            ),
          ),

          ExpandableContainer(
            backgroundColor: theme.accentColor,
            controller: _switchAuthController,
            initialState: isLogin
                ? ExpandableContainerState.shrunk
                : ExpandableContainerState.expanded,
            alignment: Alignment.topLeft,
            color: theme.cardTheme.color,
            width: cardWidth,
            padding: EdgeInsets.symmetric(
              horizontal: cardPadding,
              vertical: 10,
            ),
            onExpandCompleted: () => _postSwitchAuthController.forward(),
            child: GestureDetector(
              onTap: (){
                debugPrint('academic year is pressed');
                FocusScope.of(context).requestFocus(new FocusNode());

               showBoxDialogYear(context,'اختار السنة الدراسية',auth);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xfff5f5f5),
                  // border: Border.all(
                  //   color: Colors.black,
                  //   width: 0,
                  // ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 12),
                        child: Text(chooseYear,style: TextStyle(
                            color:Colors.black,
                            decoration: TextDecoration.none,
                            fontFamily: 'Quicksand'
                        ),),
                      ),
                    ),
                    Container(
                      child: Icon(Icons.arrow_drop_down),
                    ),
                  ],
                ),
              ),
            ),
          ),

          ExpandableContainer(
            backgroundColor: theme.accentColor,
            controller: _switchAuthController,
            initialState: isLogin
                ? ExpandableContainerState.shrunk
                : ExpandableContainerState.expanded,
            alignment: Alignment.topLeft,
            color: theme.cardTheme.color,
            width: cardWidth,
            padding: EdgeInsets.symmetric(
              horizontal: cardPadding,
              vertical: 10,
            ),
            onExpandCompleted: () => _postSwitchAuthController.forward(),
            child: GestureDetector(
              onTap: (){

                debugPrint('cnter is pressed');
                FocusScope.of(context).requestFocus(new FocusNode());
              showBoxDialogCenter(context,'اختار اسم السنتر',auth);

              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xfff5f5f5),
                  // border: Border.all(
                  //   color: Colors.black,
                  //   width: 0,
                  // ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 12),
                        child: Text(chooseCentr,style: TextStyle(
                            color:Colors.black,
                            decoration: TextDecoration.none,
                            fontFamily: 'Quicksand'
                        ),),
                      ),
                    ),
                    Container(
                      child: Icon(Icons.arrow_drop_down),
                    ),
                  ],
                ),
              ),
            ),
          ),


          Container(
            padding: Paddings.fromRBL(cardPadding),
            width: cardWidth,
            child: Column(
              children: <Widget>[
                !widget.hideForgotPasswordButton
                    ? _buildForgotPassword(theme, messages)
                    : SizedBox.fromSize(
                  size: Size.fromHeight(16),
                ),
                _buildSubmitButton(theme, messages, auth),
                !widget.hideSignUpButton
                    ? _buildSwitchAuthButton(theme, messages, auth, loginTheme)
                    : SizedBox.fromSize(
                  size: Size.fromHeight(10),
                ),
                auth.loginProviders.isNotEmpty && !widget.hideProvidersTitle
                    ? _buildProvidersTitle(messages)
                    : Container(),
                _buildProvidersLogInButton(theme, messages, auth, loginTheme),
              ],
            ),
          ),
        ],
      ),
    );



    return FittedBox(
      child: Card(
        elevation: _showShadow ? theme.cardTheme.elevation : 0,
        child: authForm,
      ),
    );
  }

  Future<Null> showBoxDialogYear(BuildContext context,String title, Auth auth) async {

    // show the dialog
    String returnVal = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            title: Text(title,
              style:GoogleFonts.tajawal(color: Colors.redAccent[100]),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,),
            content: Container(
              // height: 150.0, // Change as per your requirement
              width: 100.0,
              height: 200,// Change as per your requirement
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 6,
                itemBuilder: (BuildContext context, int i) {
                  return GestureDetector(
                    onTap: ()  async {
                      setState(() {
                        chooseYear = 'السنة الدراسية $i';
                      });
                      Navigator.pop(context, 'true');
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical:8.0),
                          child: Text('السنة الدراسية $i',
                            style:GoogleFonts.tajawal(color: Colors.black),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Colors.black26,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            actions: <Widget>[

            ],
          );
        });

    if (returnVal == 'true') {
      auth.academicYear = chooseYear;
    }else {

      // Navigator.pop(context, 'false');
    }
  }

  Future<Null> showBoxDialogCenter(BuildContext context,String title, Auth auth) async {

    // show the dialog
    String returnVal = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            title: Text(title,
              style:GoogleFonts.tajawal(color: Colors.redAccent[100]),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,),
            content: Container(
              // height: 150.0, // Change as per your requirement
              width: 100.0,
              height: 200,// Change as per your requirement
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 19,
                itemBuilder: (BuildContext context, int i) {
                  return GestureDetector(
                    onTap: ()  async {
                      setState(() {
                        chooseCentr = 'اسم السنتر $i';
                      });
                      Navigator.pop(context, 'true');
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical:8.0),
                          child: Text('اسم السنتر $i',
                            style:GoogleFonts.tajawal(color: Colors.black),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Colors.black26,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            actions: <Widget>[

            ],
          );
        });

    if (returnVal == 'true') {
      auth.centerName = chooseCentr;

    }else {

      // Navigator.pop(context, 'false');
    }
  }

}
