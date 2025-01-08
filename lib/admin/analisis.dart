import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalysisPage extends StatefulWidget {
  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  // Static sample data
  List<Map<String, dynamic>> data = [
    {'month': 1, 'total_orders': 100, 'service_name': 'Service A', 'usage_percentage': 40.0},
    {'month': 2, 'total_orders': 120, 'service_name': 'Service B', 'usage_percentage': 30.0},
    {'month': 3, 'total_orders': 140, 'service_name': 'Service C', 'usage_percentage': 50.0},
    {'month': 4, 'total_orders': 160, 'service_name': 'Service D', 'usage_percentage': 60.0},
  ];

  LineChartData lineChartData() {
    return LineChartData(
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(show: true),
      borderData: FlBorderData(show: true),
      lineBarsData: [
        LineChartBarData(
          spots: data.map((item) => FlSpot(item['month'].toDouble(), item['total_orders'].toDouble())).toList(),
          isCurved: true,
          color: Colors.blue,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );
  }

  PieChartData pieChartData() {
    return PieChartData(
      sections: data.map((item) {
        return PieChartSectionData(
          value: item['usage_percentage'].toDouble(),
          title: '${item['service_name']}',
          color: Colors.green,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Data Analysis')),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(
              'Line Chart: Total Orders per Month',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 250,
            child: LineChart(lineChartData()),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(
              'Pie Chart: Service Usage Percentage',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 250,
            child: PieChart(pieChartData()),
          ),
        ],
      ),
    );
  }
}
