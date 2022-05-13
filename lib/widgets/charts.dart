import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:icu_controller/models/live_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Charts extends StatefulWidget {
  final int? patientNumber;
  final double? height;
  Charts({Key? key, required this.patientNumber, required this.height})
      : super(key: key);

  @override
  State<Charts> createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  List<LiveData> tempData = <LiveData>[];
  List<LiveData> humData = <LiveData>[];
  ChartSeriesController? _tempController;
  ChartSeriesController? _humController;
  late ZoomPanBehavior _zoomPanBehavior;
  Timer? tempTimer;
  Timer? humTimer;
  int tempTime = 0;
  int humTime = 0;
  List<LiveData> tempList = <LiveData>[];
  List<LiveData> humList = <LiveData>[];
  List<LiveData> fixedTempList = [
    LiveData(10, 53),
    LiveData(11, 72),
    LiveData(12, 86),
    LiveData(13, 52),
    LiveData(14, 94),
    LiveData(15, 92),
    LiveData(16, 86),
    LiveData(17, 72),
    LiveData(18, 97),
    LiveData(19, 36),
    LiveData(20, 26),
    LiveData(21, 94),
    LiveData(22, 93),
    LiveData(23, 53),
    LiveData(24, 72),
    LiveData(25, 86),
    LiveData(26, 52),
    LiveData(27, 94),
    LiveData(28, 86),
    LiveData(29, 72),
    LiveData(30, 97),
    LiveData(31, 36),
  ];
  List<LiveData> fixedhumList = [
    LiveData(10, 53),
    LiveData(11, 72),
    LiveData(12, 86),
    LiveData(13, 52),
    LiveData(14, 94),
    LiveData(15, 92),
    LiveData(16, 86),
    LiveData(17, 72),
    LiveData(18, 97),
    LiveData(19, 36),
    LiveData(20, 26),
    LiveData(21, 94),
    LiveData(22, 93),
    LiveData(23, 53),
    LiveData(24, 72),
    LiveData(25, 86),
    LiveData(26, 52),
    LiveData(27, 94),
    LiveData(28, 86),
    LiveData(29, 72),
    LiveData(30, 97),
    LiveData(31, 36),
  ];

  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
        // Enables pinch zooming
        enablePinching: true);
    super.initState();
  }

  @override
  void dispose() {
    tempTimer?.cancel();
    humTimer?.cancel();
    super.dispose();
  }

  void _updateTempData(Timer timer) async {
    if (widget.patientNumber == 0 || widget.patientNumber == 1) {
      String url = 'https://toto3.pythonanywhere.com/Get_4Readings/';
      var response = await http.get(Uri.parse(url));
      var data = json.decode(response.body);
      var y;
      if (widget.patientNumber == 0) {
        y = data[0];
      } else {
        y = data[2];
      }
      print('temp is $y');
      setState(() {
        tempList.add(
          LiveData(
            tempTime++,
            double.parse(y),
          ),
        );
      });
    }
    _tempController?.updateDataSource(
        addedDataIndex: tempList.length - 1, removedDataIndex: 0);
  }

  void _updatehumData(Timer timer) async {
    if (widget.patientNumber == 0 || widget.patientNumber == 1) {
      String url = 'https://toto3.pythonanywhere.com/Get_4Readings/';
      var response = await http.get(Uri.parse(url));
      var data = json.decode(response.body);
      var y;
      if (widget.patientNumber == 0) {
        y = data[1];
      } else {
        y = data[3];
      }
      print('hum is $y');
      setState(() {
        humList.add(
          LiveData(
            humTime++,
            double.parse(y),
          ),
        );
      });
    }
    _humController?.updateDataSource(
        addedDataIndex: humList.length - 1, removedDataIndex: 0);
  }

  Future<void> _postTempSpeedUp() async {
    String url = 'https://meirr.pythonanywhere.com/PostRate/';
    var response = await http.post(
      Uri.parse(url),
      body: {'rate': '1'},
    );
    print(response.body);
  }

  Future<void> _posthumSpeedUp() async {
    String url = 'https://meirr.pythonanywhere.com/PostRate/';
    var response = await http.post(
      Uri.parse(url),
      body: {'rate': '0'},
    );
    print(response.body);
  }

  void _startTempData() {
    tempTimer = Timer.periodic(Duration(seconds: 1), _updateTempData);
  }

  void _starthumData() {
    humTimer = Timer.periodic(Duration(seconds: 1), _updatehumData);
  }

  void _pausehumData() {
    humTimer?.cancel();
  }

  void _pauseTempData() {
    tempTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: [
              Container(
                height: widget.height! * 0.5,
                child: SfCartesianChart(
                  zoomPanBehavior: _zoomPanBehavior,
                  title: ChartTitle(
                    text: 'TEMPREATURE',
                    textStyle: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  series: <LineSeries<LiveData, num>>[
                    LineSeries<LiveData, num>(
                        dataSource: (widget.patientNumber == 0 ||
                                widget.patientNumber == 1)
                            ? tempList
                            : fixedTempList,
                        xValueMapper: (LiveData dataList, _) => dataList.x,
                        yValueMapper: (LiveData dataList, _) => dataList.y,
                        onRendererCreated:
                            (ChartSeriesController chartSeriesController) =>
                                _tempController = chartSeriesController),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: _startTempData,
                  ),
                  IconButton(
                    icon: Icon(Icons.pause),
                    onPressed: _pauseTempData,
                  ),
                  IconButton(
                    icon: Icon(Icons.run_circle_outlined),
                    onPressed: _postTempSpeedUp,
                  ),
                ],
              )
            ],
          ),
          Column(
            children: [
              Container(
                height: widget.height! * 0.5,
                child: SfCartesianChart(
                  zoomPanBehavior: _zoomPanBehavior,
                  title: ChartTitle(
                    text: 'HUMIDITY',
                    textStyle: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  series: <LineSeries<LiveData, num>>[
                    LineSeries<LiveData, num>(
                        dataSource: (widget.patientNumber == 0 ||
                                widget.patientNumber == 1)
                            ? humList
                            : fixedhumList,
                        xValueMapper: (LiveData dataList, _) => dataList.x,
                        yValueMapper: (LiveData dataList, _) => dataList.y,
                        onRendererCreated:
                            (ChartSeriesController chartSeriesController) =>
                                _humController = chartSeriesController),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: _starthumData,
                  ),
                  IconButton(
                    icon: Icon(Icons.pause),
                    onPressed: _pausehumData,
                  ),
                  IconButton(
                    icon: Icon(Icons.run_circle_outlined),
                    onPressed: _posthumSpeedUp,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
