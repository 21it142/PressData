import 'package:drift/drift.dart';
import 'dart:io';
import 'package:pressdata/data/entity/press_data_entity.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
part 'db.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'pressdata.sqlite'));
    print("File Path --> ${path.join(dbFolder.path, 'pressdata.sqlite')}");

    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [PressDataTable])
class PressDataDb extends _$PressDataDb {
  PressDataDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  //Insert data into the PressData table
  // Insert data into the PressData table
  Future<int> insertPressData(PressDataTableCompanion entity) {
    return into(pressDataTable).insert(entity);
  }

  // Retrieve all data from the PressData table
  Future<List<PressDataTableData>> getAllPressData() {
    return select(pressDataTable).get();
  }

  // Delete all data from the PressData table
  Future<void> deleteAllData() async {
    await delete(pressDataTable).go();
  }
}
