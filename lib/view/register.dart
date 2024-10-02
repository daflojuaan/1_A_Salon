import 'package:flutter/material.dart';
// import 'package:a_salon/view/login.dart';
import 'package:a_salon/component/form_component.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController notelpController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255,0,31,63),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              inputForm(((p0) {
                if (p0 == null || p0.isEmpty) {
                  return "Nama Tidak Boleh Kosong";
                }
                return null;
              }),
                  controller: namaController,
                  hintTxt: "Nama",
                  helperTxt: "Gabriel Hazel Irza Adhiputra",
                  iconData: Icons.person_2),
              inputForm(((p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Username Tidak Boleh Kosong';
                }
                if (p0.toLowerCase() == 'anjing') {
                  return 'Tidak Boleh menggunakan kata kasar';
                }
                return null;
              }),
                  controller: usernameController,
                  hintTxt: "Username",
                  helperTxt: "Hazelnutlatte300404",
                  iconData: Icons.person),
              inputForm(((p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Enail tidak boleh kosong';
                }
                if (!p0.contains('@')) {
                  return 'Email harus menggunakan @';
                }
                return null;
              }),
                  controller: emailController,
                  hintTxt: "Email",
                  helperTxt: "hazel@gmail.com",
                  iconData: Icons.email),
              inputForm(((p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Password tidak boleh kosong';
                }
                if (p0.length < 5) {
                  return 'Password minimal 5 digit';
                }
                return null;
              }),
                  controller: passwordController,
                  hintTxt: "Password",
                  helperTxt: "passwordHazel@1234",
                  iconData: Icons.password,
                  password: true),
              inputForm(((p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Nomor Telepon tidak boleh kosong';
                }
                return null;
              }),
                  controller: notelpController,
                  hintTxt: "No Telp",
                  helperTxt: "082123456789",
                  iconData: Icons.phone_android),
              inputForm(
                ((p0) {
                  if (p0 == null || p0.isEmpty)
                  {
                    return "Jenis Kelamin tidak boleh kosong";
                  }
                  if (p0.toLowerCase() != "laki-laki" || p0.toLowerCase() != "Perempuan")
                  {
                    return "Jenis Kelamin hanya laki-laki dan perempuan";
                  }
                }),
                  controller: genderController,
                  hintTxt: "Jenis Kelamin",
                  helperTxt: "Laki-laki / Perempuan",
                  iconData: Icons.boy),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Map<String, dynamic> formData = {};
                      formData['username'] = usernameController.text;
                      formData['password'] = passwordController.text;

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => RegisterView(
                                  // data: formData,
                                  )));
                    }
                  },
                  child: const Text('Register'))
            ],
          ),
        ),
      ),
    );
  }
}
