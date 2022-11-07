import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int touchedIndex = -1;
  List<int> selectedSpots = [];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        color: const Color(0xff222222),
        child: ScatterChart(
          ScatterChartData(
            scatterSpots: makeScatterSpotListData(),
            minX: 0,
            maxX: 10,
            minY: 0,
            maxY: 10,

            // 図の枠線表示有無
            borderData: FlBorderData(
              show: true,
            ),

            // ガイドライン
            gridData: makeGridData(),

            // タイトル
            titlesData: FlTitlesData(
              show: false,
            ),
            showingTooltipIndicators: selectedSpots,

            //
            scatterTouchData: ScatterTouchData(
              enabled: true,
              handleBuiltInTouches: false,

              // TODO
              mouseCursorResolver:
                  (FlTouchEvent touchEvent, ScatterTouchResponse? response) {
                return response == null || response.touchedSpot == null
                    ? MouseCursor.defer
                    : SystemMouseCursors.click;
              },
              touchTooltipData: ScatterTouchTooltipData(
                  tooltipBgColor: Colors.black,
                  getTooltipItems: (ScatterSpot touchedBarSpot) {
                    return makeScatterTooltipItem(touchedBarSpot);
                  }),

              // TODO コールバック
              touchCallback:
                  (FlTouchEvent event, ScatterTouchResponse? touchResponse) {
                if (touchResponse == null ||
                    touchResponse.touchedSpot == null) {
                  return;
                }
                if (event is FlTapUpEvent) {
                  final sectionIndex = touchResponse.touchedSpot!.spotIndex;
                  setState(() {
                    if (selectedSpots.contains(sectionIndex)) {
                      selectedSpots.remove(sectionIndex);
                    } else {
                      selectedSpots.add(sectionIndex);
                    }
                  });
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  // 散布図のスポットデータリスト作成
  List<ScatterSpot> makeScatterSpotListData() {
    Color greyColor = Colors.grey;
    return [
      ScatterSpot(
        4,
        4,
        color: selectedSpots.contains(0) ? Colors.green : greyColor,
      ),
      ScatterSpot(
        2,
        5,
        color: selectedSpots.contains(1) ? Colors.yellow : greyColor,
        radius: 12,
      ),
      ScatterSpot(
        4,
        5,
        color: selectedSpots.contains(2) ? Colors.purpleAccent : greyColor,
        radius: 8,
      ),
      ScatterSpot(
        8,
        6,
        color: selectedSpots.contains(3) ? Colors.orange : greyColor,
        radius: 20,
      ),
      ScatterSpot(
        5,
        7,
        color: selectedSpots.contains(4) ? Colors.brown : greyColor,
        radius: 14,
      ),
      ScatterSpot(
        7,
        2,
        color: selectedSpots.contains(5) ? Colors.lightGreenAccent : greyColor,
        radius: 18,
      ),
      ScatterSpot(
        3,
        2,
        color: selectedSpots.contains(6) ? Colors.red : greyColor,
        radius: 36,
      ),
      ScatterSpot(
        2,
        8,
        color: selectedSpots.contains(7) ? Colors.tealAccent : greyColor,
        radius: 22,
      ),
    ];
  }

  // ガイドライン設定
  FlGridData makeGridData() {
    return FlGridData(
      show: true,
      drawHorizontalLine: true,
      checkToShowHorizontalLine: (value) => true,
      getDrawingHorizontalLine: (value) =>
          FlLine(color: Colors.white.withOpacity(0.1)),
      drawVerticalLine: true,
      checkToShowVerticalLine: (value) => true,
      getDrawingVerticalLine: (value) =>
          FlLine(color: Colors.white.withOpacity(0.1)),
    );
  }

  // TODO
  ScatterTooltipItem makeScatterTooltipItem(ScatterSpot touchedBarSpot) {
    return ScatterTooltipItem(
      'X: ',
      textStyle: TextStyle(
        height: 1.2,
        color: Colors.grey[100],
        fontStyle: FontStyle.italic,
      ),
      bottomMargin: 10,
      children: [
        TextSpan(
          text: '${touchedBarSpot.x.toInt()} \n',
          style: const TextStyle(
            color: Colors.white,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: 'Y: ',
          style: TextStyle(
            height: 1.2,
            color: Colors.grey[100],
            fontStyle: FontStyle.italic,
          ),
        ),
        TextSpan(
          text: touchedBarSpot.y.toInt().toString(),
          style: const TextStyle(
            color: Colors.white,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}