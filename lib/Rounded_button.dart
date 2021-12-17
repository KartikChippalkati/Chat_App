import 'package:flutter/material.dart';

/*Remember this
this is called Refactoring
i have refactored this below class from the welcome Screen in order to keep the welcome screen code neat and clean

Refacoring is done when we ahve the repeated code or the same code with very littele changes

so to refactor the code first we go to Flutter Outline and select the code which we want to refactor from the screen and press the right
button and seect the Extract the widget . Now create the final variables and constructors to add or change the desired value so that this class can be used
in various place or screen and add desired properties and complete the class in the "return" widget

Later create another dart file and copy this classs to that file and make import operations



*/

class RoundedButton extends StatelessWidget {
  final Color colour;
  final String text;
  final Function onPressed;

  RoundedButton(
      {@required this.colour, @required this.text, @required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: () {
            onPressed();
          },
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
