import 'package:flutter_calc/calculator/state/state_enums.dart';

/*
Simple holder of trigger actions and resulting state.
Could be restructured to be faster.
 */
class Transition {

  final List<MyAction> actions;
  final MyState nextState;

  Transition(this.actions, this.nextState);
}

class Transitions {

  final _mappings = <MyState,List<Transition>>{

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

  MyState nextState(MyState curState, MyAction action){

    return _mappings[curState]
        ?.firstWhere((t) => t.actions.contains(action))
        ?.nextState ?? MyState.undefined;
  }

}
