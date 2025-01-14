
// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:aplikasi_omah/admin/dashboard.dart';
import 'package:aplikasi_omah/kurir/kurir_home.dart';
import 'package:aplikasi_omah/pages/home.dart';
import 'package:aplikasi_omah/util/fire_auth.dart';
import 'package:aplikasi_omah/util/role_manage.dart';
import 'package:aplikasi_omah/util/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();

  late String email;
  late String password;

  final focusEmail = FocusNode();
  final focusPassword = FocusNode();

  bool isProcess = false;

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String? page = await RoleManager.getUserRole(user.uid);
      switch (page) {
        case 'home':
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Home(user: user)));
          break;
        case 'admin':
          // Navigator.of(context).pushReplacementNamed('admin_screen');
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Dashboard(Admin: user)));
          break;
        case 'kurir':
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => KurirHome(kurir: user)));
          break;
        default:
      }
    }
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/1.jpg',
                            height: 200,
                          ),
                          const SizedBox(height: 40),
                          const Text(
                            'LOGIN',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Form(
                            key: formKey,
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  focusNode: focusEmail,
                                  validator: (value) =>
                                      Validator.validateEmail(email: value),
                                  onChanged: (value) {
                                    email = value;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.5),
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  obscureText: true,
                                  focusNode: focusPassword,
                                  validator: (value) =>
                                      Validator.validatePassword(
                                          password: value),
                                  onChanged: (value) => password = value,
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.5),
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, 'register_screen');
                            },
                            child: const Text(
                              'Belum punya akun?',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          isProcess
                              ? const CircularProgressIndicator()
                              : SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    onPressed: () async {
                                      focusEmail.unfocus();
                                      focusPassword.unfocus();
                                      try {
                                        if (formKey.currentState!.validate()) {
                                          setState(() {
                                            isProcess = true;
                                          });

                                          final user = await FireAuth
                                              .signInUsingEmailPassword(
                                                  email: email,
                                                  password: password);
                                          setState(() {
                                            isProcess = false;
                                          });

                                          if (user != null) {
                                            String? page =
                                                await RoleManager.getUserRole(
                                                    user.uid);
                                            switch (page) {
                                              case 'home':
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Home(
                                                                    user:
                                                                        user)));
                                                break;
                                              case 'admin':
                                                Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Dashboard(Admin: user)));
                                                // MaterialPageRoute(builder: (context) => Home(user: user));
                                                break;
                                              case 'kurir':
                                                Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => KurirHome(kurir: user)));
                                                // MaterialPageRoute(builder: (context) => Home(user: user));

                                                break;
                                              default:
                                            }
                                          }
                                        }
                                      } catch (e) {
                                        // ignore: avoid_print
                                        print(e);
                                      }
                                    },
                                    child: const Text(
                                      'Masuk',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),

      backgroundColor: const Color(0xFFE7F0FA), // Light blue background color
    );
  }
}
