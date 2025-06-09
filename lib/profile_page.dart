import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:my_cst2335_lab/data_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {
  late String name;
  late DataRepository repository;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();

  @override
  void initState() {
    super.initState();
    repository = DataRepository();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await repository.loadData(_prefs);

    setState(() {
      name = DataRepository.loginName;
      _firstNameController.text = repository.firstName;
      _lastNameController.text = repository.lastName;
      _phoneController.text = repository.phoneNumber;
      _emailController.text = repository.email;
    });

    Future.delayed(Duration.zero, () {
      var snackBar = SnackBar(content: Text("Welcome $name"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  Future<void> _saveData() async {
    await repository.saveData(_prefs);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile Page")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome Back $name",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // First Name Field
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                hintText: "Enter your first name",
                border: OutlineInputBorder(),
                labelText: "First Name",
              ),
              onChanged: (value) => _saveData(),
            ),
            SizedBox(height: 15),

            // Last Name Field
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                hintText: "Enter your last name",
                border: OutlineInputBorder(),
                labelText: "Last Name",
              ),
              onChanged: (value) => _saveData(),
            ),
            SizedBox(height: 15),

            // Phone Number Field with buttons
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Enter your phone number",
                      border: OutlineInputBorder(),
                      labelText: "Phone Number",
                    ),
                    onChanged: (value) => _saveData(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.phone),
                  onPressed: () => _launchUrl('tel:${_phoneController.text}'),
                ),
                IconButton(
                  icon: Icon(Icons.message),
                  onPressed: () => _launchUrl('sms:${_phoneController.text}'),
                ),
              ],
            ),
            SizedBox(height: 15),

            // Email Field with button
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Enter your email address",
                      border: OutlineInputBorder(),
                      labelText: "Email Address",
                    ),
                    onChanged: (value) => _saveData(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.mail),
                  onPressed:
                      () => _launchUrl('mailto:${_emailController.text}'),
                ),
              ],
            ),

            Spacer(),
            Center(
              child: ElevatedButton(
                child: Text("Go Back"),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text('Error'),
              content: Text('This URL scheme is not supported on your device.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
      );
    }
  }
}
