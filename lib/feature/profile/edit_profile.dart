import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/constants/images.dart';
import '../../utils/theme/theme_container.dart';
import '../../utils/validators/validator.dart';
import '../../utils/widget/button.dart';
import '../../utils/widget/textfield.dart';
import '../auth/widget/intro_appbar.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const IntroAppbar(titleText: 'Edit Profile'),
      body: ThemeContainer(
        child: SingleChildScrollView(
          child: KeyboardDismissOnTap(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: height * 0.15,
                ),
                SizedBox(
                  height: height * 0.3,
                  width: width,
                  child: Center(
                    child: Image.asset(Images.logo, height: height * 0.25),
                  ),
                ),
                MyTextField(
                  hintText: "Full Name",
                  validator: (value) =>
                      InputValidators.validateEmpty("Name", value),
                  controller: userProvider.fullNameText,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                ),
                MyTextField(
                  hintText: 'Phone Number',
                  controller: userProvider.phoneNumberText,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  validator: (value) =>
                      InputValidators.validatePhoneNumber(value),
                ),
                SizedBox(height: height * 0.02),
                Button().mainButton('Save', context, () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  userProvider.updateUser().whenComplete(() {
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  });
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
