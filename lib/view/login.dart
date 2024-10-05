import 'package:flutter/material.dart';
import 'package:a_salon/view/home.dart';
import 'package:a_salon/view/register.dart';
import 'package:a_salon/component/form_component.dart';

class LoginView extends StatefulWidget {
  final Map<String, dynamic>? loginData;
  final Map<String, dynamic>? profileData;

  const LoginView({super.key, this.loginData, this.profileData,});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 31, 63),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/logo putih.jpg',
                width: 300,
              ),
              const Text(
                "MASUK",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
              inputForm((p0) {
                if (p0 == null || p0.isEmpty) {
                  return "username tidak boleh kosong";
                }
                return null;
              },
                  controller: usernameController,
                  hintTxt: "Username",
                  helperTxt: "Inputkan User yang telah didaftar",
                  iconData: Icons.person),
              inputForm((p0) {
                if (p0 == null || p0.isEmpty) {
                  return "password kosong";
                }
                return null;
              },
                  password: true,
                  controller: passwordController,
                  hintTxt: "Password",
                  helperTxt: "Inputkan Passwrod",
                  iconData: Icons.password),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (widget.loginData != null &&
                            widget.loginData!['username'] == usernameController.text &&
                            widget.loginData!['password'] == passwordController.text) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => HomeView(profileData: widget.profileData,)));
                          } else {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Password Salah'),
                                content: TextButton(
                                    onPressed: () => pushRegister(context),
                                    child: const Text('Daftar Disini !!')),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'OK'),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Login')),
                  TextButton(
                      onPressed: () {
                        Map<String, dynamic> formData = {};
                        formData['username'] = usernameController.text;
                        formData['password'] = passwordController.text;
                        pushRegister(context);
                      },
                      child: const Text('Belum punya akun ?')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  void pushRegister(BuildContext context) {
    Navigator.push(
      context,MaterialPageRoute(builder: (_) => const RegisterView(),),);
  }
}