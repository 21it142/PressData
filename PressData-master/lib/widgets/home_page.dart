// import 'package:flutter/material.dart';
// import 'package:pressdata/widgets/shared_prefrences.dart';

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   late TextEditingController nameController;
//   late TextEditingController ageController;
//   HomePageData homePageData = HomePageData();

//   @override
//   void initState() {
//     nameController = TextEditingController();
//     ageController = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     nameController.dispose();
//     ageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text('Storing data in shared pref as JSON'),
//               const HeightSpacer(myHeight: 25.0),
//               buildTextField(nameController, 'Your name'),
//               const HeightSpacer(myHeight: 25.0),
//               buildTextField(ageController, 'Your age'),
//               const HeightSpacer(myHeight: 25.0),
//               saveButton(),
//               const HeightSpacer(myHeight: 25.0),
//               ElevatedButton(
//                 onPressed: () => homePageData.getJsonData(),
//                 child: const Text('Retrieve Data'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildTextField(TextEditingController controller, String labelText) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         focusedBorder: OutlineInputBorder(
//           borderSide: const BorderSide(color: Colors.blue),
//           borderRadius: BorderRadius.circular(5.5),
//         ),
//         enabledBorder: const OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue),
//         ),
//         prefixIcon: const Icon(Icons.person, color: Colors.blue),
//         filled: true,
//         fillColor: Colors.blue[50],
//         labelText: labelText,
//         labelStyle: const TextStyle(color: Colors.blue),
//       ),
//     );
//   }

//   Widget saveButton() {
//     return ElevatedButton(
//       onPressed: () async {
//         Map<String, dynamic> dataStore = {
//           'name': nameController.text,
//           'age': int.parse(ageController.text),
//         };

//         await homePageData.saveJsonData(dataStore);
//         nameController.clear();
//         ageController.clear();
//       },
//       child: const Text('Save Data'),
//     );
//   }
// }

// class HeightSpacer extends StatelessWidget {
//   final double myHeight;

//   const HeightSpacer({Key? key, required this.myHeight}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(height: myHeight);
//   }
// }

// class WidthSpacer extends StatelessWidget {
//   final double myWidth;

//   const WidthSpacer({Key? key, required this.myWidth}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(width: myWidth);
//   }
// }
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void hello() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'doggie_database.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  // Define a function that inserts dogs into the database
  Future<void> insertDog(Dog dog) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<Dog>> dogs() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all the dogs.
    final List<Map<String, Object?>> dogMaps = await db.query('dogs');

    // Convert the list of each dog's fields into a list of `Dog` objects.
    return [
      for (final {
            'id': id as int,
            'name': name as String,
            'age': age as int,
          } in dogMaps)
        Dog(id: id, name: name, age: age),
    ];
  }

  Future<void> updateDog(Dog dog) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      'dogs',
      dog.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [dog.id],
    );
  }

  Future<void> deleteDog(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'dogs',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [1],
    );
  }

  // Create a Dog and add it to the dogs table
  var fido = Dog(
    id: 0,
    name: 'Fido',
    age: 35,
  );

  var Lido = Dog(
    id: 1,
    name: 'Fido',
    age: 63,
  );
  await insertDog(Lido);
  var wido = Dog(
    id: 2,
    name: 'Fido',
    age: 63,
  );
  await insertDog(wido);
  // Now, use the method above to retrieve all the dogs.
  print(await dogs()); // Prints a list that include Fido.

  // Update Fido's age and save it to the database.
  fido = Dog(
    id: 2,
    name: fido.name,
    age: fido.age + 7,
  );

  await updateDog(fido);
  fido = Dog(
    id: 1,
    name: fido.name,
    age: fido.age + 17,
  );
  await updateDog(fido);
  // Print the updated results.
  print(await dogs()); // Prints Fido with age 42.

  // Delete Fido from the database.
  await deleteDog(fido.id);

  // Print the list of dogs (empty).
  print(await dogs());
}

class Dog {
  final int id;
  final String name;
  final int age;

  Dog({
    required this.id,
    required this.name,
    required this.age,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}
