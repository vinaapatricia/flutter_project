import 'package:flutter/material.dart';
import 'package:flutter_project/presentation/auth/pages/auto_login/google_auth.dart';
import 'package:flutter_project/presentation/cashier/pages/cashier_page.dart';
import 'package:flutter_project/configs/assets/app_images.dart';
import 'package:flutter_project/presentation/auth/components/snackbar.dart';
import 'package:flutter_project/presentation/auth/services/auth_method.dart';
import 'package:flutter_project/presentation/auth/components/button.dart';
import 'package:flutter_project/presentation/auth/components/text_field.dart';
import 'package:flutter_project/configs/theme/app_colors.dart';

import '../../login/pages/login.dart';
import 'continue_register.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isObscured = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    final formState = _formKey.currentState;
    if (formState != null) {
      formState.save();
      return formState.validate();
    }
    return false;
  }

  void registerUser() async {
    if (!_isFormValid) return;

    setState(() {
      isLoading = true;
    });

    String res = await AuthMethod().registerUser(
      email: emailController.text,
      password: passwordController.text,
      phone: phoneController.text,
      name: nameController.text,
      confirmPassword: confirmPasswordController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (res == "success") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ContinueRegisterPage(),
        ),
      );
    } else {
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Register POS account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Text(
                        'Welcome! Please register your account.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFieldInput(
                        prefixIcon: const Icon(Icons.person),
                        textEditingController: nameController,
                        hintText: 'ex. John Doe',
                        textInputType: TextInputType.name,
                        title: 'Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      TextFieldInput(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '+62',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                        textEditingController: phoneController,
                        hintText: 'ex. 9889-9870-9865',
                        textInputType: TextInputType.number,
                        title: 'Phone Number',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      TextFieldInput(
                        prefixIcon: const Icon(Icons.email_outlined),
                        textEditingController: emailController,
                        hintText: 'ex. yourname@gmail.com',
                        textInputType: TextInputType.emailAddress,
                        title: 'Email',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      TextFieldInput(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(AppImages.key_icon),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscured
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                        ),
                        textEditingController: passwordController,
                        hintText: 'Type your password here',
                        textInputType: TextInputType.text,
                        isPass: _isObscured,
                        title: 'Password',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      TextFieldInput(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(AppImages.key_icon),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscured
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                        ),
                        textEditingController: confirmPasswordController,
                        hintText: 'Confirm your password',
                        textInputType: TextInputType.text,
                        isPass: _isObscured,
                        title: 'Confirm Password',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AuthButton(
                        onTap: () {
                          if (_isFormValid) {
                            registerUser();
                          }
                        },
                        text: "Register",
                        color: _isFormValid ? AppColors.primary : Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      const Text('or'),
                      const SizedBox(height: 8),
                      AuthButton(
                        onTap: () async {
                          await FirebaseServices().signInWithGoogle();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CashierPage()));
                        },
                        text: "Sign Up with Google",
                        isOutlined: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Image.asset(AppImages.google_icon),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
