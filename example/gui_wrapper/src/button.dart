import 'base/win_control.dart';


class Button extends WinControl{
  Button({
    String text = 'Button',
    int x = 10,
    int y = 10,

}) : super(
    className: 'BUTTON',
    text: text,
    x: x,
    y: y,
    width: 100,
    height: 22,
  ) ;

}
