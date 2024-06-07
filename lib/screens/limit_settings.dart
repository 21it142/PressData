import 'package:flutter/material.dart';
import 'package:pressdata/screens/main_page.dart';

class LimitSettings extends StatefulWidget {
  LimitSettings(
      {super.key,
      required this.title,
      required this.card_color,
      required this.subtitle,
      required this.Font_color});
  String title;
  String subtitle;
  Color card_color;
  Color Font_color;
  @override
  State<LimitSettings> createState() => _LimitSettingsState();
}

class _LimitSettingsState extends State<LimitSettings> {
  int maxLimit = 0;
  int minLimit = 0;

  void updateMaxLimit(double value) {
    setState(() {
      maxLimit = (value.clamp(1.0, double.infinity) - 1.0).toInt() + 1;
    });
  }

  void updateMinLimit(double value) {
    setState(() {
      minLimit = (value.clamp(0.0, maxLimit.toDouble() - 1.0)).toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(134, 248, 255, 1),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Dashboard(),
                ),
              );
            },
            icon: Icon(Icons.arrow_back_outlined)),
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
                            style: TextStyle(
                                fontSize: 31, color: widget.Font_color),
                          ),
                          Text(
                            "Maximum Limit",
                            style: TextStyle(
                                fontSize: 10, color: widget.Font_color),
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
                            style: TextStyle(
                                fontSize: 31, color: widget.Font_color),
                          ),
                          Text(
                            "Minimum Limit",
                            style: TextStyle(
                                fontSize: 10, color: widget.Font_color),
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
