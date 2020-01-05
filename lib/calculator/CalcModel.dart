import 'package:flutter/material.dart';

import 'package:flutter_calc/calculator/state_keeper.dart';


////////////////////////////////////////////////////////////////////////////////
enum MathOp { NOOP, ADD, SUBTRACT, MULTIPLY, DIVIDE }

////////////////////////////////////////////////////////////////////////////////
class CalcModel extends ChangeNotifier {

  var displayText = '0';

  int operand;
  MathOp operation = MathOp.NOOP;
  StateKeeper stateKeeper = StateKeeper();


  String getDisplayText() => displayText.toString();
  //int _getDisplayValue() => int.parse(displayText);


  void _handle1stDigitAfterOperationChosen(int digit) {

    // kind of a special case.
    // One button press ago, user input the math operation.
    // we'd been showing them the first operand.
    // now we need to:
    // 1) move the current display value to this.operand
    // 2) make the digit they pressed the only thing in the display
    operand = int.parse(displayText);
    displayText = digit.toString();
  }


  void inputDigit(int digit) {

    switch(stateKeeper.getState()) {

      case CalcState.INITIAL:
      case CalcState.NEXT_OPERAND_BEGUN:
        {
          // default behavior
          if(displayText != "0") {
            displayText += digit.toString();
          }
          else {
            displayText = digit.toString();
          }
        }
        break;

      case CalcState.NEXT_OPERAND_AWAIT:
        _handle1stDigitAfterOperationChosen(digit);
        break;
    }

    stateKeeper.changeStateIfRequired(UserAction.INPUT_DIGIT);
    notifyListeners();
  }


  void backspace() {
    switch(stateKeeper.getState()) {

      case CalcState.INITIAL:
      case CalcState.NEXT_OPERAND_BEGUN:
        // default behavior
        {
          if(displayText.length > 1) {
            displayText = displayText.substring(0, displayText.length - 1);
          }
          else {
            displayText = '0';
          }
        }
        break;

      case CalcState.NEXT_OPERAND_AWAIT:
        _handle1stDigitAfterOperationChosen(0);
        break;
    }

    stateKeeper.changeStateIfRequired(UserAction.BACKSPACE);
    notifyListeners();
  }

  void clear() {

    displayText = "0";
    operand = null;
    operation = MathOp.NOOP;

    stateKeeper.changeStateIfRequired(UserAction.CLEAR);
    notifyListeners();
  }

  void equalz(){

    switch(stateKeeper.getState()) {

      case CalcState.NEXT_OPERAND_BEGUN:
        // calculate answer only when there's a 2nd operand
        displayText = _doTheMath().toString();
        operand = null;
        operation = MathOp.NOOP;
        notifyListeners();
        break;

      case CalcState.INITIAL:
      case CalcState.NEXT_OPERAND_AWAIT:
        // ignore
        break;
    }

    stateKeeper.changeStateIfRequired(UserAction.MATH_OP);
  }


  void mathOperation(MathOp calcOp){
    switch(stateKeeper.getState()) {

      case CalcState.INITIAL:

        operand = int.parse(displayText);
        break;

      case CalcState.NEXT_OPERAND_AWAIT:

        // kind of a strange case.  wouldn't expect user to press
        // operation key in this state.  but if they do, then make it
        // the operation.  captured at end of this method.
        break;

      case CalcState.NEXT_OPERAND_BEGUN:

        // ok, here's the interesting one.
        // we'll do the calculation for the current data.
        // and show the result.
        // set the operation to be whatever just pressed.
        // then changeStateIfRequired will change overall state back to NEXT_OPERAND_AWAIT
        operand = _doTheMath();
        displayText = operand.toString();
        break;
    }

    operation = calcOp; // this gets set for all states
    stateKeeper.changeStateIfRequired(UserAction.MATH_OP);
  }


  int _doTheMath(){

    int result;
    switch(operation){
      case MathOp.ADD:
        result = operand + int.parse(displayText);
        break;
      case MathOp.SUBTRACT:
        result =  operand - int.parse(displayText);
        break;
      case MathOp.MULTIPLY:
        result =  operand * int.parse(displayText);
        break;
      case MathOp.DIVIDE:
        result =  operand ~/ int.parse(displayText);
        break;
      case MathOp.NOOP:
        throw Exception("Illegal state. Shouldn't have been asked to doTheMath when operation is NOOP.");
        // todo: any recovery should call clear.
    }
    return result;
  }
}