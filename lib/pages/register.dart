import 'package:aplikasi_omah/util/fire_auth.dart';
import 'package:aplikasi_omah/util/validator.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final registerFormKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController roleController = TextEditingController();

  final focusName = FocusNode();
  final focusEmail = FocusNode();
  final focusPassword = FocusNode();
  final focusConfirmPassword = FocusNode();
  final focusRole = FocusNode();

  bool isProccess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                    'REGISTER',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Form(
                    key: registerFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          validator: (value) =>
                              Validator.validateName(name: value),
                          decoration: InputDecoration(
                            hintText: 'Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) =>
                              Validator.validateEmail(email: value),
                          decoration: InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          validator: (value) =>
                              Validator.validatePassword(password: value),
                          decoration: InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          validator: (value) =>
                              Validator.validatePassword(password: value),
                          decoration: InputDecoration(
                            hintText: 'Konfirmasi Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
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
                      Navigator.pushNamed(context, 'login_screen');
                    },
                    child: const Text(
                      'Sudah punya akun?',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  isProccess
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                isProccess = true;
                              });
                              try {
                                if (registerFormKey.currentState!.validate()) {
                                  final newUser =
                                      await FireAuth.registerUsingEmailPassword(
                                          name: nameController.text,
                                          email: emailController.text,
                                          password: passwordController.text);
                                  
                                  setState(() {
                                    isProccess = false;
                                  });

                                  // ignore: unnecessary_null_comparison
                                  if (newUser != null) {
                                    Navigator.of(context).pushNamedAndRemoveUntil('login_screen', ModalRoute.withName('/'));
                                  }
                                }
                              } catch (e) {
                                print(e);
                              }
                            },
                            child: const Text(
                              'Daftar',
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
      ),
      backgroundColor: const Color(0xFFE7F0FA), // Light blue background color
    );
  }
}
