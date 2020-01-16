import 'package:flutter_calc/calculator/state/listeners.dart';
import 'package:flutter_calc/calculator/state/math_state_model.dart';
import 'package:flutter_calc/calculator/state/state_enums.dart';
import "package:test/test.dart";

void main() {

  group("inputOp", () {

    MathStateModel m = MathStateModel(ChangeListener());

    test("from init, input non-null op", () {
      m.inputOp(MyOp.add);
      expect(m.getState(), equals(MyState.buildOp2));
    });
/*
    test("from init, input null op", () {
      expect(m.inputOp(null), throwsA(equals(OP_CANNOT_BE_NULL)));
    });

 */
  });

}
