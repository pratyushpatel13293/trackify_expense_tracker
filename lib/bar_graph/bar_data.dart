import 'package:trackify/bar_graph/indiviual_bar.dart';

class BarData{
  final double sunAmount;
  final double monAmount;
  final double tuesAmount;
  final double wedAmount;
  final double thusAmount;
  final double friAmount;
  final double satAmount;


  BarData({
    required this.monAmount,
    required this.tuesAmount,
    required this.wedAmount,
    required this.thusAmount,
    required this.friAmount,
    required this.satAmount,
    required this.sunAmount,
});

  List<indiviualBar> barData = [];

  //initialize bar data
  void intializeBarData(){

    barData=[
    // Bar Graph data for Sunday
    indiviualBar(x: 0, y: sunAmount),

    // Bar Graph data for monday
    indiviualBar(x: 1, y: monAmount),

    // Bar Graph data for tuesday
    indiviualBar(x: 2, y: tuesAmount),

    // Bar Graph data for wednesday
    indiviualBar(x: 3, y: wedAmount),

    // Bar Graph data for thursday
    indiviualBar(x: 4, y: thusAmount),

    // Bar Graph data for friday
    indiviualBar(x: 5, y: friAmount),

    // Bar Graph data for saturday
    indiviualBar(x: 6, y: satAmount),
  ];
  }
}