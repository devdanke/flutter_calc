import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:flutter_calc/calculator/CalcModel.dart';
import 'package:flutter_calc/calculator/NumericDisplayArea.dart';


////////////////////////////////////////////////////////////////////////////////
class CalculatorScreen extends StatelessWidget {

  Widget build(BuildContext context) {

    final body = Container(
      decoration: BoxDecoration(color: Colors.grey[300]),
      child: ChangeNotifierProvider(
        create: (context) => CalcModel(),
        child: Column(
          children: <Widget>[
            Consumer<CalcModel>(
                builder: (context, calcModel, child) {
                  return NumericDisplayArea(calcModel.getDisplayText());
                }),
            ButtonArea()
          ],
        ),
      ),
      //backgroundColor: Colors.white60,
    );

    return Scaffold(
      appBar: AppBar(
          title: Text("Calculisious"),
          centerTitle: true,
      ),
      body: body
    );
  }

}

////////////////////////////////////////////////////////////////////////////////
class ButtonArea extends StatelessWidget {

  final btnTextSize = 25.0;
  final numColor = Colors.white;
  final mathColor = Colors.blue;
  final editColor = Colors.blueGrey;
  final gridColor = Colors.black;


  CalcModel calcModel(BuildContext context) => Provider.of<CalcModel>(context, listen: false);

  void _backspaceHandler(BuildContext context) => calcModel(context).backspace();
  void _clearHandler(BuildContext context) => calcModel(context).clear();
  void _calculateHandler(BuildContext context) => calcModel(context).equalz();
  void _inputDigitHandler(BuildContext context, int digit) => calcModel(context).inputDigit(digit);
  void _inputMathOpHandler(BuildContext context,MathOp operation) => calcModel(context).mathOperation(operation);

  TableCell _spacer() => TableCell(child: Container());

  TableCell _numBtn(BuildContext context, int n) {
    final txt = Text("$n", style: TextStyle(fontSize: btnTextSize));
    final btn = FlatButton(child: txt, onPressed: () => _inputDigitHandler(context,n));
    final coloredBtn = Container(child: btn, decoration: BoxDecoration(color: numColor));
    return TableCell(child: coloredBtn );
  }

  TableCell _mathOpBtn(BuildContext context, String opChar, MathOp mathOp) {
    final txt = Text(opChar, style: TextStyle(fontSize: btnTextSize));
    final btn = FlatButton(child: txt, onPressed: () => _inputMathOpHandler(context, mathOp));
    final coloredBtn = Container(child: btn, decoration: BoxDecoration(color: mathColor));
    return TableCell(child: coloredBtn );
  }

  TableCell _equalsBtn(BuildContext context) {
    final txt = Text("=", style: TextStyle(fontSize: btnTextSize));
    final btn = FlatButton(child: txt, onPressed: () => _calculateHandler(context));
    final coloredBtn = Container(child: btn, decoration: BoxDecoration(color: mathColor));
    return TableCell(child: coloredBtn );
  }

  TableCell _clearBtn(BuildContext context) {
    final txt = Text("C", style: TextStyle(fontSize: btnTextSize));
    final btn = FlatButton(child: txt, onPressed: () => _clearHandler(context));
    final coloredBtn = Container(child: btn, decoration: BoxDecoration(color: editColor));
    return TableCell(child: coloredBtn );
  }

  TableCell _backspaceBtn(BuildContext context) {
    final txt = Text("<", style: TextStyle(fontSize: btnTextSize));
    final btn = FlatButton(child: txt, onPressed: () => _backspaceHandler(context));
    final coloredBtn = Container(child: btn, decoration: BoxDecoration(color: editColor));
    return TableCell(child: coloredBtn );
  }

  Widget build(BuildContext context) {

    final table = Table(
      border: TableBorder.all(color: gridColor),

      children: <TableRow>[

        TableRow(
          children: <Widget>[
            _spacer(),
            _backspaceBtn(context),
            _clearBtn(context),
            _mathOpBtn(context, "+", MathOp.ADD)
          ],
    ),

        TableRow(children: <Widget>[
          _numBtn(context, 1),
          _numBtn(context, 2),
          _numBtn(context, 3),
          _mathOpBtn(context, "-", MathOp.SUBTRACT),
        ]),

        TableRow(children: <Widget>[
          _numBtn(context, 4),
          _numBtn(context, 5),
          _numBtn(context, 6),
          _mathOpBtn(context, "*", MathOp.MULTIPLY),
        ]),

        TableRow(children: <Widget>[
          _numBtn(context, 7),
          _numBtn(context, 8),
          _numBtn(context, 9),
          _mathOpBtn(context, "/", MathOp.DIVIDE),
        ]),

        TableRow(children: <Widget>[
          _spacer(),
          _numBtn(context, 0),
          _spacer(),
          _equalsBtn(context),
        ])

      ],
    );

    return Container(child: table);
  }
}

