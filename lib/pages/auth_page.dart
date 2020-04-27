import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:toys/models/user.dart';
import 'package:toys/services/auth.dart';
import 'package:toys/services/datastore.dart';
import 'package:toys/styles/custom.dart';
import 'package:toys/widgets/appbar.dart';
import 'package:toys/widgets/gesture_button.dart';
import 'package:toys/widgets/loading.dart';

final GoogleSignIn _googleSignIn = new GoogleSignIn();

class AuthPage extends StatefulWidget {
  final VoidCallback loginCallback;
  final Datastore datastore;
  final BaseAuth auth;
  AuthPage({this.auth, this.datastore, this.loginCallback});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isNew = false, isLoading = false;
  String _username, _password, _email;
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: isNew ? 'Sign up' : 'Login'),
      body: isLoading
          ? circularProgress(context)
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Form(
                key: formKey,
                child: ListView(children: [
                  isNew
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildUsername(),
                        )
                      : Container(),
                  _buildEmail(),
                  SizedBox(height: 16),
                  _buildPassword(),
                  SizedBox(height: 24),
                  _authActions(),
                  SizedBox(height: 32),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(!isNew
                        ? 'Not have an account ? '
                        : 'Already have an account ? '),
                    GestureButton(
                        text: !isNew ? 'Sign up' : 'Login',
                        onPressed: () {
                          setState(() {
                            isNew = !isNew;
                          });
                        })
                  ]),
                  isNew ? Container() : buildGoogleContainer(context)
                ]),
              ),
            ),
    );
  }

  Future<void> _googleLogin(BuildContext context) async {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text('Logging in'),
    ));

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    AuthResult userDetails =
        await FirebaseAuth.instance.signInWithCredential(credential);

    DocumentSnapshot doc = await Firestore.instance
        .collection("users")
        .document(userDetails.user.uid)
        .get();

    // User details = new User(
    //   doc.data['uid'],
    //   doc.data['displayName'],
    //   doc.data['email'],
    //   doc.data['address'],
    //   doc.data['city'],
    //   doc.data['state'],
    //   doc.data['photoUrl'],
    //   doc.data['loginType'],
    //   doc.data['role'],
    // );
    User details = User.fromMap(doc.data);

    if (!doc.exists) {
      Firestore.instance
          .collection("users")
          .document(userDetails.user.uid)
          .setData({
        "uid": userDetails.user.uid,
        "displayName": userDetails.user.displayName,
        "email": userDetails.user.email,
        "photoUrl": userDetails.user.photoUrl,
        "address": "",
        "city": "",
        "state": "",
        "logintype": "google",
        "role": "user"
      }).catchError((onError) => print(onError));
    }

    // setState(() {
    //   isAuth = true;
    //   authResult = userDetails;
    // });
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => MyHomePage(
    //               details: details,
    //             )));
  }

  Container buildGoogleContainer(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 16),
          Center(child: Text("OR")),
          SizedBox(height: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: RaisedButton(
                color: Color(0xffECECEC),
                elevation: 0,
                onPressed: () => _googleLogin(context),
                child: Stack(
                  children: <Widget>[
                    Text(
                      "LOGIN USING ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 90),
                      child: Image.asset(
                        'assets/images/G.png',
                        width: 13,
                      ),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      String userId = '';
      try {
        if (!isNew) {
          userId = await widget.auth.signIn(_email, _password);
          print("UserId: $userId");
        } else {
          userId = await widget.auth.signUp(_email, _password);
          widget.datastore.addUserData(User(
            uid: userId,
            email: _email,
            username: _username,
          ));
          print("Signed Up Successfull: $userId");
        }
        if (userId != null && userId.length > 0) {
          widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          formKey.currentState.reset();
        });
      }
    }
  }

  Widget _authActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        isNew
            ? PrimaryButton(
                text: "Sign up",
                buttonColor: Colors.black,
                textColor: Colors.white,
                onPressed: () {
                  validateAndSubmit();
                })
            : PrimaryButton(
                text: "Login",
                buttonColor: Colors.black,
                textColor: Colors.white,
                onPressed: () {
                  validateAndSubmit();
                }),
        !isNew
            ? GestureButton(text: "Forgot Password ?", onPressed: () {})
            : Container()
      ],
    );
  }

  Widget _buildUsername() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Username",
          style: Custom().inputLabelTextStyle,
        ),
        SizedBox(height: 4),
        Container(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
          child: TextFormField(
            maxLines: 1,
            style: Custom().inputTextStyle,
            keyboardType: TextInputType.emailAddress,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: 'yourname'),
            controller: userNameController,
            validator: (value) =>
                value.isEmpty ? 'Username can\'t be empty' : null,
            onSaved: (value) => _username = value.trim(),
          ),
        )
      ],
    );
  }

  //Email TextField
  Widget _buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Email Address",
          style: Custom().inputLabelTextStyle,
        ),
        SizedBox(height: 4),
        Container(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
          child: TextFormField(
            controller: emailController,
            maxLines: 1,
            style: Custom().inputTextStyle,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'you@gmail.com'),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Email is Required';
              }

              if (!RegExp(
                      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                  .hasMatch(value)) {
                return 'Please enter a valid email Address';
              }

              return null;
            },
            onSaved: (String value) {
              _email = value;
            },
          ),
        ),
      ],
    );
  }

  //Password TextField
  Widget _buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Password",
          style: Custom().inputLabelTextStyle,
        ),
        SizedBox(height: 4),
        Container(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
          child: TextFormField(
            keyboardType: TextInputType.visiblePassword,
            style: Custom().inputTextStyle,
            obscureText: true,
            maxLines: 1,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'your password'),
            controller: passwordController,
            validator: (value) {
              if (value.isEmpty)
                return 'Passwords can\'t be empty';
              else if (value.length < 6)
                return 'Passwords should be atleast 6 characters';
              else
                return null;
            },
            onSaved: (value) => _password = value.trim(),
          ),
        )
      ],
    );
  }
}
