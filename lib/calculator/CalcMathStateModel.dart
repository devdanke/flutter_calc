/*
strictly for the calculation math model.
does not hold data for display purposes.
trying to keep this focused and simply.

 */
import 'package:flutter/material.dart';

enum MyOp { add, sub, mult, div }
enum MyState { init, buildOp1, buildOp2, error }
enum MyAction { bs, clr, eq, num, oflow, op}

/*
Simple holder of trigger actions and resulting state.
Could be restructured to be faster.
 */
class Transition {

  final List<MyAction> actions;
  final MyState nextState;

  Transition(this.actions, this.nextState);
}

final transitions = <MyState,List<Transition>>{

  MyState.init : [
    Transition([MyAction.num], MyState.buildOp1),
    Transition([MyAction.bs, MyAction.clr, MyAction.eq], MyState.init),
    Transition([MyAction.op], MyState.buildOp2),
  ],

  MyState.buildOp1 : [
    Transition([MyAction.op], MyState.buildOp2),
    Transition([MyAction.eq,MyAction.clr,MyAction.bs,MyAction.num], MyState.buildOp1),
    Transition([MyAction.oflow], MyState.error),
  ],

  MyState.buildOp2 : [
    Transition([MyAction.eq], MyState.buildOp1),
    Transition([MyAction.clr], MyState.init),
    Transition([MyAction.oflow], MyState.error),
    Transition([MyAction.bs,MyAction.op,MyAction.num], MyState.buildOp2),
  ],

  MyState.error : [
    Transition([MyAction.clr], MyState.init),
    Transition([MyAction.eq,MyAction.bs,MyAction.num, MyAction.oflow, MyAction.op], MyState.error),
  ],
};

class Op1ChangeListener {
  void changed(int newVal){}
}

class Op2ChangeListener {
  void changed(int newVal){}
}

class OpChangeListener {
  void changed(MyOp newVal){}
}

class StateChangeListener {
  void changed(MyState newVal){}
}

class CalcMathStateModel extends ChangeNotifier {

  MyState _state;
  MyOp _op;
  int _op1;
  int _op2;

  final Op1ChangeListener _op1ChangeListener;
  final Op2ChangeListener _op2ChangeListener;
  final OpChangeListener _opChangeListener;
  final StateChangeListener _stateChangeListener;

  final Map<MyState,List<Transition>> _transitions;

  CalcMathStateModel(this._transitions, this._op1ChangeListener,
      this._op2ChangeListener, this._opChangeListener, this._stateChangeListener){

    _initVars();
  }


  void inputOp(MyOp op){

    List<Transition> transitions = _transitions[_state];
    final transition = transitions.firstWhere((t) => t.actions.contains(op));
    if(_setState(transition.nextState)){
      _setOp(op);
    }
  }

  void inputBackspace(){ }

  void inputClear(){ }

  void inputEqual(){ }

  void inputDigit(){  }


  bool _setOp1(int newVal){
    if(_op1 != newVal){
      _op1 = newVal;
      _op1ChangeListener.changed(newVal);
      return true;
    }
    return false;
  }

  bool _setOp2(int newVal){
    if(_op2 != newVal){
      _op2 = newVal;
      _op2ChangeListener.changed(newVal);
      return true;
    }
    return false;
  }

  bool _setOp(MyOp newVal){
    if(_op != newVal){
      _op = newVal;
      _opChangeListener.changed(newVal);
      return true;
    }
    return false;
  }

  bool _setState(MyState newVal){
    if(_state != newVal){
      _state = newVal;
      _stateChangeListener.changed(newVal);
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