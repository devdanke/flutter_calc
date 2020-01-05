import 'package:flutter/material.dart';

////////////////////////////////////////////////////////////////////////////////
class NumericDisplayArea extends StatelessWidget {

  final String displayText;

  NumericDisplayArea(this.displayText);

  Widget build(BuildContext context) {

    return Container(
        margin: const EdgeInsets.only(top:30, bottom: 30),
        decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
        child: SizedBox(
            height: 50.0,
            child: Container(
                padding: EdgeInsets.only(left: 5, right: 5),
                color: Colors.white,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(displayText,
                        style:
                        TextStyle(fontSize: 40.0, color: Colors.black)
                    )
                )
            )
        )
    );
  }
}