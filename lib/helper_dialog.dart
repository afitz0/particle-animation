import 'package:flutter/material.dart';

class HelperDialog extends StatelessWidget {
  final String text;

  const HelperDialog({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.info_outline),
      onPressed: () => showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              actions: <Widget>[
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
              content: Text(text),
            );
          }),
    );
  }
}
