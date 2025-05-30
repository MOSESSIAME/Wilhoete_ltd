import 'package:flutter/material.dart';

void main() {
  runApp(AluminiumCuttingApp());
}

/// Main application widget
class AluminiumCuttingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: LandingPage(),
    );
  }
}

/// Landing page with options for different panel types
class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade800, Colors.green.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome to Aluminium Cutting-Sheet Generator",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Select an option to continue",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 40),
              buildNavigationButton(context, "2-Panel Slider", "2-Panel"),
              SizedBox(height: 20),
              buildNavigationButton(context, "3-Panel Slider", "3-Panel"),
              SizedBox(height: 20),
              buildNavigationButton(context, "Casement", "Casement"),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNavigationButton(BuildContext context, String title, String panelType) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      ),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CuttingSheetCalculator(panelType: panelType)),
      ),
      child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}

class CuttingSheetCalculator extends StatefulWidget {
  final String panelType;
  CuttingSheetCalculator({required this.panelType});

  @override
  _CuttingSheetCalculatorState createState() => _CuttingSheetCalculatorState();
}

class _CuttingSheetCalculatorState extends State<CuttingSheetCalculator> {
  final TextEditingController widthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  List<Map<String, dynamic>> result = [];

  void calculateCuttingSizes() {
    int width = int.tryParse(widthController.text) ?? 0;
    int height = int.tryParse(heightController.text) ?? 0;

    if (width <= 0 || height <= 0) {
      setState(() {
        result = [{"Section": "Error", "Size": "Invalid input", "Qty": "-"}];
      });
      return;
    }

    setState(() {
      result = [];
      if (widget.panelType == "2-Panel") {
        int wheelsash = (width - 170) ~/ 2;
        result = [
          {"Section": "Top", "Size": width - 60, "Qty": 1},
          {"Section": "Bottom", "Size": width - 20, "Qty": 1},
          {"Section": "Jamb", "Size": height, "Qty": 2},
          {"Section": "Lockstyle", "Size": height - 30, "Qty": 2},
          {"Section": "Interlock", "Size": height - 30, "Qty": 2},
          {"Section": "Wheelsash", "Size": wheelsash, "Qty": 4},
          {"Section": "Glass Size", "Size": "${wheelsash + 15} x ${height - 85}", "Qty": 2},
          {"Section": "Fly-Screen", "Size": "${wheelsash + 90} x ${height + 18}", "Qty": 2},
        ];
      } else if (widget.panelType == "3-Panel") {
        int wheelsash = (width - 255) ~/ 3;
        result = [
          {"Section": "Top", "Size": width - 90, "Qty": 1},
          {"Section": "Bottom", "Size": width - 30, "Qty": 1},
          {"Section": "Jamb", "Size": height, "Qty": 2},
          {"Section": "Lockstyle", "Size": height - 30, "Qty": 3},
          {"Section": "Interlock", "Size": height - 30, "Qty": 3},
          {"Section": "Wheelsash", "Size": wheelsash, "Qty": 6},
          {"Section": "Glass Size", "Size": "${wheelsash + 15} x ${height - 85}", "Qty": 3},
          {"Section": "Fly-Screen", "Size": "${wheelsash + 90} x ${height + 18}", "Qty": 3},
        ];
      } else {
        result = [{"Section": "Info", "Size": "Coming soon", "Qty": "-"}];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.panelType} Generator"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: widthController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Width (mm)", border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Height (mm)", border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: calculateCuttingSizes,
              child: Text("Generate"),
            ),
            SizedBox(height: 20),
            result.isNotEmpty
                ? Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    columnSpacing: 30,
                    headingRowColor: MaterialStateColor.resolveWith((states) => Colors.green.shade200),
                    border: TableBorder.all(color: Colors.grey),
                    columns: [
                      DataColumn(label: Text("Section")),
                      DataColumn(label: Text("Size (mm)")),
                      DataColumn(label: Text("Qty")),
                    ],
                    rows: result.map((row) => DataRow(cells: [
                      DataCell(Text(row["Section"].toString())),
                      DataCell(Text(row["Size"].toString())),
                      DataCell(Text(row["Qty"].toString())),
                    ])).toList(),
                  ),
                ),
              ),
            )
                : Center(child: Text("Enter values and click Generate to see results.")),
          ],
        ),
      ),
    );
  }
}
