import 'package:flutter/material.dart';

class CustomElevated extends StatelessWidget {
  final btnTitle;
  final btnSelected;
  final Function onPress;
  const CustomElevated({Key key, this.btnTitle, this.btnSelected, this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      child: Text(btnTitle),
      style: ElevatedButton.styleFrom(
        primary: btnSelected == btnTitle
            ? Colors.blue.withOpacity(0.8)
            : Colors.black54.withOpacity(0.5),
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }
}
