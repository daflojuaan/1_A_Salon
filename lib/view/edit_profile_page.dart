import 'package:flutter/material.dart';
import 'user.dart';
import 'package:a_salon/database/database_helper.dart';

class EditProfilePage extends StatefulWidget {
  final User user;

  const EditProfilePage({super.key, required this.user});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String _selectedGender = 'Laki-laki';

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
    _selectedGender = widget.user.gender;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    final updatedUser = User(
      id: widget.user.id,
      username: _usernameController.text,
      password: widget.user.password,
      email: _emailController.text,
      phone: _phoneController.text,
      gender: _selectedGender,
    );

    await DatabaseHelper().updateUser(updatedUser);
    Navigator.pop(context, updatedUser);
  }

  void _confirmSaveChanges() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFFC107),
          title: const Text("KONFIRMASI"),
          content: const Text("Yakin Ingin Mengubah Data?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: const Text(
                "BATAL",
                style: TextStyle(color: Color(0xFF6A9AB0)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                _saveChanges(); // Panggil fungsi simpan perubahan
              },
              child: const Text(
                "IYA",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInputFieldWithIcon(
                    _usernameController,
                    'Username',
                    Icons.person,
                    'Inputkan username baru',
                  ),
                  const SizedBox(height: 16),
                  _buildInputFieldWithIcon(
                    _emailController,
                    'Email',
                    Icons.email,
                    'Inputkan email baru',
                  ),
                  const SizedBox(height: 16),
                  _buildInputFieldWithIcon(
                    _phoneController,
                    'Nomor Telepon',
                    Icons.phone,
                    'Inputkan nomor telepon baru',
                  ),
                  const SizedBox(height: 16),
                  _buildGenderDropdown(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _confirmSaveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A9AB0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Simpan Perubahan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputFieldWithIcon(
    TextEditingController controller,
    String labelText,
    IconData icon,
    String hintText,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFF001F3F),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(color: Colors.white),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
        ),
        trailing: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFF001F3F),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButton<String>(
        isExpanded: true,
        value: _selectedGender,
        onChanged: (String? newValue) {
          setState(() {
            _selectedGender = newValue!;
          });
        },
        items: <String>['Laki-laki', 'Perempuan']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Row(
              children: [
                Icon(
                  value == 'Laki-laki' ? Icons.male : Icons.female,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Text(
                  value,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        }).toList(),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        dropdownColor: const Color(0xFF001F3F),
        underline: const SizedBox(),
      ),
    );
  }
}