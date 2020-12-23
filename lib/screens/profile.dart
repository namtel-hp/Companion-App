import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../color_constants.dart';
import '../models/student.dart';
import '../services/database.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_textfield.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/profile';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Student student;
  final String uid = FirebaseAuth.instance.currentUser.uid;

  bool _isLoading = true;

  TextEditingController nameController = TextEditingController();
  String nameErrorMessage = "";
  bool validityName = true;

  @override
  void initState() {
    getStudent();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> getStudent() async {
    student = await DatabaseService.getStudent(uid);
    setState(() {
      nameController.text = student.name;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: CustomAppBar(
                leading: IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.chevronLeft,
                    size: 30,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: 'Profile',
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(
                  bottom: 20, left: 20, right: 20, top: 10),
              child: Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProfileTile(
                        title: student.name,
                        icon: FontAwesomeIcons.solidUser,
                        trailing: FontAwesomeIcons.pen,
                        trailingOnTap: () async {
                          await buildShowDialog(context);
                        },
                      ),
                      ProfileTile(
                        title: student.email,
                        icon: FontAwesomeIcons.solidEnvelope,
                      ),
                      ProfileTile(
                        title: student.college,
                        icon: FontAwesomeIcons.school,
                      ),
                      ProfileTile(
                        title: student.usn,
                        icon: FontAwesomeIcons.solidIdBadge,
                      ),
                      ProfileTile(
                        title: student.branch,
                        icon: FontAwesomeIcons.bookReader,
                      ),
                      ProfileTile(
                        title: 'Contests Participated',
                        icon: FontAwesomeIcons.certificate,
                        trailing: FontAwesomeIcons.chevronRight,
                        onTap: () {},
                      ),
                      ProfileTile(
                        title: 'Contests Won',
                        icon: FontAwesomeIcons.trophy,
                        trailing: FontAwesomeIcons.chevronRight,
                        onTap: () {},
                      ),
                      const SizedBox(height: 20),
                      MaterialButton(
                        height: MediaQuery.of(context).size.height * 0.06,
                        minWidth: MediaQuery.of(context).size.width * 0.6,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () async {},
                        color: Theme.of(context).accentColor,
                        child: const Text(
                          "Reset Password?",
                          textScaleFactor: 1.4,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Future<void> buildShowDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            color: Theme.of(context).backgroundColor,
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  controller: nameController,
                  title: 'Name',
                  validity: validityName,
                  errorMessage: nameErrorMessage,
                  obscureText: false,
                  iconData: FontAwesomeIcons.solidUser,
                ),
                const SizedBox(height: 20),
                MaterialButton(
                  height: MediaQuery.of(context).size.height * 0.06,
                  minWidth: MediaQuery.of(context).size.width * 0.6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () async {
                    setState(() {
                      validityName = isValidName(nameController.text.trim());
                    });
                    if (validityName) {
                      setState(() {
                        _isLoading = true;
                      });
                      Navigator.pop(context);

                      await DatabaseService.updateName(
                        id: uid,
                        name: nameController.text.trim(),
                      );

                      await getStudent();
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  color: Theme.of(context).accentColor,
                  child: const Text(
                    "Update",
                    textScaleFactor: 1.4,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool isValidName(String name) {
    if (name.length < 3) {
      nameErrorMessage = 'Name too short';
      return false;
    } else {
      return true;
    }
  }
}

class ProfileTile extends StatelessWidget {
  const ProfileTile(
      {Key key,
      @required this.title,
      @required this.icon,
      this.onTap,
      this.trailing,
      this.trailingOnTap})
      : super(key: key);

  final String title;
  final IconData icon;
  final Function onTap;
  final IconData trailing;
  final Function trailingOnTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(hashCode),
      leading: Icon(
        icon,
        color: Theme.of(context).accentColor,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: kTextColor,
          letterSpacing: 1.3,
        ),
      ),
      trailing: IconButton(
        onPressed: () => trailingOnTap(),
        icon: Icon(
          trailing,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}