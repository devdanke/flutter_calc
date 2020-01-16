/*
strictly for the calculation math model.
does not hold data for display purposes.
trying to keep this focused and simple.
 */
import 'package:flutter/material.dart';

import 'package:flutter_calc/calculator/state/state_enums.dart';
import 'package:flutter_calc/calculator/state/listeners.dart';
import 'package:flutter_calc/calculator/state/transition_mappings.dart';

const OP_CANNOT_BE_NULL = "op cannot be null";


class MathStateModel extends ChangeNotifier {

  MyState _state;
  MyOp _op;
  int _op1;
  int _op2;

  final ChangeListener _listener;
  final Transitions _transitions = Transitions();

  MathStateModel(this._listener){
    _initVars();
  }

  MyState getState() { return _state; }

  MyState inputOp(MyOp op){

    // maybe boiler plate: begin
    if(op == null) {
      throw OP_CANNOT_BE_NULL;
    }

    final nextState = _transitions.nextState(_state, MyAction.op);
    if(nextState == MyState.undefined) {
      throw Exception("no transition found from current state for inputting operator.");
    }
    // maybe boiler plate: end

    if(_setState(nextState)){
      _setOp(op);
    }
    return getState();
  }


  void inputBackspace(){ }

  void inputClear(){ }

  void inputEqual(){ }

  void inputDigit(){ }


  void _setOp1(int newVal){
    if(_op1 != newVal){
      _op1 = newVal;
      _listener.op1Changed(newVal);
    }
  }

  void _setOp2(int newVal){
    if(_op2 != newVal){
      _op2 = newVal;
      _listener.op2Changed(newVal);
    }
  }

  void _setOp(MyOp newVal){
    if(_op != newVal){
      _op = newVal;
      _listener.opChanged(newVal);
    }
  }

  bool _setState(MyState newVal){
    if(_state != newVal){
      _state = newVal;
      _listener.stateChanged(newVal);
      return true;
    }
    return false;
  }

  // Events needed?
  void _initVars(){

    _state = MyState.init;
    _op = null;
    _op1 = null;
    _op2 = null;
  }

}