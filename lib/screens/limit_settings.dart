import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LimitSettings extends StatefulWidget {
  LimitSettings(
      {super.key,
      required this.title,
      required this.card_color,
      required this.subtitle});
  String title;
  String subtitle;
  Color card_color;
  @override
  State<LimitSettings> createState() => _LimitSettingsState();
}

class _LimitSettingsState extends State<LimitSettings> {
  int maxLimit = 0;
  int minLimit = 0;

  @override
  void initState() {
    loadData();
    // TODO: implement initState
    super.initState();
  }

  void loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      maxLimit = prefs.getInt('maxLimit') ?? 0;
      minLimit = prefs.getInt('minLimit') ?? 0;
    });
  }

  void updateMaxLimit(double value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      maxLimit = (value.clamp(1.0, double.infinity) - 1.0).toInt() + 1;
      prefs.setInt('maxLimit', maxLimit);
    });
  }

  void updateMinLimit(double value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      minLimit = (value.clamp(0.0, maxLimit.toDouble() - 1.0)).toInt();
      prefs.setInt('minLimit', minLimit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(134, 248, 255, 1),
      appBar: AppBar(
        leading:
            IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_outlined)),
        title: Center(
          child: Column(
            children: [
              Text(
                "${widget.title} Limit Settings",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "${widget.subtitle}",
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
        ),
        backgroundColor: Color.fromRGBO(134, 248, 255, 1),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0), // Adjust the height as needed
          child: Container(
            color: Colors.black, // Change this to the desired border color
            height: 4.0, // Height of the bottom border
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text("O2", style: TextStyle(fontSize: 20)),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      updateMaxLimit(maxLimit.toDouble() - 1.0);
                      // product.minLimit = (product.minLimit > 0) ? product.minLimit - 1 : 0;
                      // onChanged();
                    },
                  ),
                  Container(
                    height: 80,
                    width: 150,
                    child: Card(
                      color: widget.card_color,
                      child: Column(
                        children: [
                          Text(
                            '${maxLimit}',
                            style: TextStyle(fontSize: 31),
                          ),
                          Text(
                            "Maximum Limit",
                            style: TextStyle(fontSize: 10),
                          )
                        ],
                      ),
                      margin: EdgeInsets.all(10),
                    ),
                  ), //${product.minLimit}
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      updateMaxLimit(maxLimit.toDouble() + 1.0);
                      // product.minLimit++;
                      // onChanged();
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      updateMinLimit(minLimit.toDouble() - 1.0);
                      // product.maxLimit = (product.maxLimit > 0) ? product.maxLimit - 1 : 0;
                      // onChanged();
                    },
                  ),
                  Container(
                    height: 80,
                    width: 150,
                    child: Card(
                      color: widget.card_color,
                      child: Column(
                        children: [
                          Text(
                            '${minLimit}',
                            style: TextStyle(fontSize: 31),
                          ),
                          Text(
                            "Minimum Limit",
                            style: TextStyle(fontSize: 10),
                          )
                        ],
                      ),
                      margin: EdgeInsets.all(10),
                    ),
                  ), //${product.maxLimit}
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      updateMinLimit(minLimit.toDouble() + 1.0);
                      // product.maxLimit++;
                      // onChanged();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
