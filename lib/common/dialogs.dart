
import 'package:flutter/material.dart';
import 'package:user/screens/loginScreen.dart';

// showDialog(
// context: context,
// builder: (_) => MyDialog(okFunction: (){
//
// Navigator.pop(context);
// },),
// );

class MyDialog extends StatelessWidget {
  VoidCallback okFunction;
   MyDialog({Key? key, required this.okFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(20.0)), //this right here
      child: Container(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'What do you want to remember?'),
              ),
              SizedBox(
                width: 320.0,
                child: RaisedButton(
                  onPressed: okFunction,
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: const Color(0xFF1BC0C5),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
