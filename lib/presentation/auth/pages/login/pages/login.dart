import 'package:flutter/material.dart';
import 'package:flutter_project/presentation/auth/components/snackbar.dart';
import 'package:flutter_project/presentation/auth/pages/register/pages/register_pages.dart';
import 'package:flutter_project/presentation/auth/services/auth_method.dart';
import 'package:flutter_project/presentation/cashier/pages/cashier_page.dart';
import '../../../../../configs/assets/app_images.dart';
import '../../../../../configs/theme/app_colors.dart';
import '../../../../../data/contents/login_contents.dart';
import '../../../components/button.dart';
import '../../../components/text_field.dart';
import '../../auto_login/google_auth.dart';
import 'continue_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscured = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneOrEmailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    passwordController.dispose();
    phoneOrEmailController.dispose();
    super.dispose();
  }

  bool get isPhone {
    final text = phoneOrEmailController.text;
    return RegExp(r'^\d+$').hasMatch(text);
  }

  void loginUser() async {
    final formState = _formKey.currentState;
    if (formState != null && formState.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        String res = await AuthMethod().loginUser(
          email: phoneOrEmailController.text,
          password: passwordController.text,
        );

        if (res == "success") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const ContinueLoginPage(),
            ),
          );
        } else {
          showSnackBar(context, res);
        }
      } catch (e) {
        showSnackBar(context, 'Login failed. Please try again.');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
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
        child: SizedBox(
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
                        loginTitle,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Text(
                        loginSubtitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFieldInput(
                        prefixIcon: isPhone
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0),
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
                              )
                            : const Icon(Icons.email_outlined),
                        textEditingController: phoneOrEmailController,
                        hintText: isPhone ? phoneHintText : emailHintText,
                        textInputType: isPhone
                            ? TextInputType.phone
                            : TextInputType.emailAddress,
                        title: isPhone ? 'Phone Number' : 'Email',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '$emptyFieldError${isPhone ? 'phone number' : 'email'}';
                          }
                          if (!isPhone &&
                              !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return invalidEmailError;
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
                        hintText: passwordHintText,
                        textInputType: TextInputType.text,
                        isPass: _isObscured,
                        title: 'Password',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return emptyPasswordError;
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
                        onTap: loginUser,
                        text: "Login",
                        color: isLoading ? Colors.grey : null,
                      ),
                      const SizedBox(height: 16),
                      const Text('or'),
                      const SizedBox(height: 16),
                      AuthButton(
                        onTap: () async {
                          await FirebaseServices().signInWithGoogle();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CashierPage()));
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
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(dontHaveAccountText),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RegisterPage(),
                              ),
                            );
                          },
                          child: const Text(
                            registerText,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
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
