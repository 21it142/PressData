import 'package:flutter/material.dart';
//import 'package:get/get.dart';
import 'package:pressdata/screens/main_page.dart';

class Setting1 extends StatefulWidget {
  Setting1({
    super.key,
  
  });


  @override
  State<Setting1> createState() => _Setting1State();
}

class Product {
  String name;
  int portNumber; // Change type to String

  Product({required this.name, required this.portNumber});
}

class _Setting1State extends State<Setting1> {
  bool isMuted = false;

  void toggleMute() {
    setState(() {
      isMuted = !isMuted;
    });
  }

  late List<Product> products;

  @override
  void initState() {
    super.initState();
    // Initialize all products with port number as "NC"
    products = [
      Product(name: 'O2', portNumber: 0),
      Product(name: 'VAC', portNumber: 0),
      Product(name: 'N2O', portNumber: 0),
      Product(name: 'Air', portNumber: 0),
      Product(name: 'CO2', portNumber: 0),
      Product(name: 'O2(2)', portNumber: 0),
    ];
  }

  void _incrementPort(int index) {
    setState(() {
      // Check if the current port number is already assigned to another product
      if (products[index].portNumber < 6) {
        int currentPortNumber = products[index].portNumber;
        bool isPortAssigned =
            products.any((product) => product.portNumber == currentPortNumber);

        // If the current port number is not assigned or it's the last port number (6), don't increment
        if (!isPortAssigned || currentPortNumber == 6) {
          return;
        }

        // Find the next available port number
        int nextPortNumber = currentPortNumber + 1;
        while (
            products.any((product) => product.portNumber == nextPortNumber)) {
          nextPortNumber++;
          if (nextPortNumber > 6) {
            // If nextPortNumber exceeds 6, break the loop
            nextPortNumber = currentPortNumber;
            break;
          }
        }

        // Assign the next available port number
        products[index].portNumber = nextPortNumber;
      }
    });
  }

  void _decrementPort(int index) {
    setState(() {
      // Check if the current port number is already assigned to another product
      int currentPortNumber = products[index].portNumber;
      bool isPortAssigned =
          products.any((product) => product.portNumber == currentPortNumber);

      // If the current port number is not assigned or it's the first port number (0), don't decrement
      if (!isPortAssigned || currentPortNumber == 0) {
        return;
      }

      // Find the previous available port number
      int previousPortNumber = currentPortNumber - 1;
      while (
          products.any((product) => product.portNumber == previousPortNumber)) {
        previousPortNumber--;
        if (previousPortNumber < 0) break;
      }

      // Assign the previous available port number
      products[index].portNumber =
          previousPortNumber >= 0 ? previousPortNumber : 0;
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
                  builder: (context) => Dashboard(
                 
                  ),
                ),
              );
            },
            icon: Icon(Icons.arrow_back_outlined)),
        title: Center(
          child: Text(
            "Port Settings",
            style: TextStyle(fontWeight: FontWeight.bold),
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
      body: Column(
        children: [
          Expanded(
            child: Container(
              height: double.infinity,
              child: GridView.count(
                mainAxisSpacing: 8,
                crossAxisSpacing: 50,
                crossAxisCount: 2,
                childAspectRatio: 9 / 2,
                children: [
                  for (int i = 0; i < products.length; i++)
                    _buildProductCard(products[i], i),
                ],
              ),
            ),
          ),
          IconButton(
            icon: isMuted ? Icon(Icons.volume_off) : Icon(Icons.volume_up),
            iconSize: 48,
            onPressed: () {
              toggleMute();
              // Perform mute/unmute actions here
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product, int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Card(
        child: ListTile(
          title: Text(
            product.name,
            style: TextStyle(fontSize: 30),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.remove,
                  size: 35,
                ),
                onPressed: () {
                  _decrementPort(index);
                },
              ),
              Text(
                '${product.portNumber}',
                style: TextStyle(fontSize: 35),
              ),
              IconButton(
                icon: Icon(
                  Icons.add,
                  size: 35,
                ),
                onPressed: () {
                  _incrementPort(index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
