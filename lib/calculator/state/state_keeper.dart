
////////////////////////////////////////////////////////////////////////////////
enum CalcState { INITIAL, // blank slate
  NEXT_OPERAND_AWAIT, // brief state. user maybe pressed numbers, then an operation
  NEXT_OPERAND_BEGUN,  // typed in >= 1 digit of next operand
}

////////////////////////////////////////////////////////////////////////////////
enum UserAction { INPUT_DIGIT, MATH_OP, EQUALS, CLEAR, BACKSPACE }

////////////////////////////////////////////////////////////////////////////////
class TransitionPlan {

  CalcState _currentState;
  UserAction _action;
  CalcState _nextState;

  TransitionPlan(this._currentState, this._action, this._nextState);

  bool matches(CalcState state, UserAction action) {
    return ((_currentState==state) && (this._action==action));
  }
}

////////////////////////////////////////////////////////////////////////////////

class StateKeeper {

  CalcState _calcState = CalcState.INITIAL;

  final _transitions = <TransitionPlan>[

    TransitionPlan(CalcState.INITIAL, UserAction.CLEAR, CalcState.INITIAL),
    TransitionPlan(CalcState.INITIAL, UserAction.BACKSPACE, CalcState.INITIAL),
    TransitionPlan(CalcState.INITIAL, UserAction.MATH_OP, CalcState.NEXT_OPERAND_AWAIT),
    TransitionPlan(CalcState.INITIAL, UserAction.EQUALS, CalcState.INITIAL),
    TransitionPlan(CalcState.INITIAL, UserAction.INPUT_DIGIT, CalcState.INITIAL),

    TransitionPlan(CalcState.NEXT_OPERAND_AWAIT, UserAction.CLEAR, CalcState.INITIAL),
    TransitionPlan(CalcState.NEXT_OPERAND_AWAIT, UserAction.BACKSPACE, CalcState.NEXT_OPERAND_BEGUN), // same as entering 0
    TransitionPlan(CalcState.NEXT_OPERAND_AWAIT, UserAction.MATH_OP, CalcState.NEXT_OPERAND_AWAIT), // ignore (or replace operation)
    TransitionPlan(CalcState.NEXT_OPERAND_AWAIT, UserAction.EQUALS, CalcState.NEXT_OPERAND_AWAIT),  // because no 2nd operand yet
    TransitionPlan(CalcState.NEXT_OPERAND_AWAIT, UserAction.INPUT_DIGIT, CalcState.NEXT_OPERAND_BEGUN),

    TransitionPlan(CalcState.NEXT_OPERAND_BEGUN, UserAction.CLEAR, CalcState.INITIAL),
    TransitionPlan(CalcState.NEXT_OPERAND_BEGUN, UserAction.BACKSPACE, CalcState.NEXT_OPERAND_BEGUN),
    TransitionPlan(CalcState.NEXT_OPERAND_BEGUN, UserAction.MATH_OP, CalcState.NEXT_OPERAND_AWAIT), // do calc, then change state
    TransitionPlan(CalcState.NEXT_OPERAND_BEGUN, UserAction.EQUALS, CalcState.INITIAL), // do calc, then change state
    TransitionPlan(CalcState.NEXT_OPERAND_BEGUN, UserAction.INPUT_DIGIT, CalcState.NEXT_OPERAND_BEGUN),
  ].toList(growable: false);

  CalcState getState() { return _calcState; }

  CalcState changeStateIfRequired(UserAction action){

    // todo: how prove this filter can only return exactly one transition?
    _calcState = _transitions.firstWhere((t) => (t.matches(_calcState, action)))._nextState;
    return _calcState;
  }

}
