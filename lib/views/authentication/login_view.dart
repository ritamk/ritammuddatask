import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ritammuddatask/controllers/auth_controller.dart';
import 'package:ritammuddatask/controllers/shared_pref.dart';
import 'package:ritammuddatask/shared/shared.dart';
import 'package:ritammuddatask/views/home/home_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _hidePassword = true;
  bool _submitting = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _passFocus = FocusNode();
  final TextEditingController _passController = TextEditingController();
  final FocusNode _mailFocus = FocusNode();
  final TextEditingController _mailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            focusNode: _mailFocus,
            controller: _mailController,
            decoration:
                authTextInputDecoration("Email", Icons.mail, null, context),
            validator: (value) => mailValidator(value),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (val) =>
                FocusScopeNode().requestFocus(_passFocus),
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            focusNode: _passFocus,
            controller: _passController,
            obscureText: _hidePassword,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(20.0),
              fillColor: Theme.of(context).colorScheme.onInverseSurface,
              filled: true,
              prefixIcon: const Icon(Icons.key),
              suffixIcon: IconButton(
                onPressed: () => setState(() => _hidePassword = !_hidePassword),
                icon: Icon(
                  _hidePassword ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).colorScheme.inverseSurface,
                ),
              ),
              labelText: "Password",
              labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.inverseSurface),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: textFieldBorder(false, 30.0),
              focusedBorder: textFieldBorder(false, 30.0),
              errorBorder: textFieldBorder(false, 30.0),
              errorStyle: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            validator: (value) => passValidator(value),
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (val) async {
              FocusScopeNode().unfocus();
              await loginAction();
            },
          ),
          const SizedBox(height: 20.0),
          FilledButton(
            onPressed: () => loginAction(),
            child: !_submitting
                ? const Text(
                    "Log in",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  )
                : CupertinoActivityIndicator(
                    color: Theme.of(context).colorScheme.background,
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> loginAction() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _submitting = true);
      final String? uid = await AuthController()
          .signInWithMailPass(
        _mailController.text.trim(),
        _passController.text.trim(),
      )
          .onError((error, stackTrace) {
        Fluttertoast.showToast(msg: error.toString());
        return null;
      });

      if (uid != null) {
        if (uid.runtimeType == String) {
          setState(() => _submitting = false);
          await LocalSharedPref.setUid(uid);
          await LocalSharedPref.setLoggedIn(true).whenComplete(() =>
              Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(builder: (context) => const HomeView()),
                  (route) => false));
        }
      }
    }
  }

  String? mailValidator(String? value) {
    if (value!.isEmpty) {
      return "Please enter your email";
    } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
      return "Please enter a email";
    }
    return null;
  }

  String? passValidator(String? value) {
    if (value!.length < 6) {
      return "Password must have atleast 6 characters";
    }
    return null;
  }

  @override
  void dispose() {
    _mailController.dispose();
    _mailFocus.dispose();
    _passController.dispose();
    _passFocus.dispose();
    super.dispose();
  }
}
