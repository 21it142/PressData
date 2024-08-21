import 'package:drift/drift.dart';
import 'package:pressdata/data/entity/device_values.dart';
import 'dart:io';
import 'package:pressdata/data/entity/press_data_entity.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:pressdata/models/distinct_data.dart';
part 'db.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'pressdata.sqlite'));
    print("File Path --> ${path.join(dbFolder.path, 'pressdata.sqlite')}");

    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [PressDataTable, ErrorTable])
class PressDataDb extends _$PressDataDb {
  PressDataDb() : super(_openConnection());

  @override
  int get schemaVersion => 2;
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) {
          return m.createAll(); // Create all tables
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from == 1) {
            await m.createTable(pressDataTable);
            await m.createTable(errorTable);
          }
        },
      );

  // Get data for a specific day
  Future<List<PressDataTableData>> getDataForDay(
      DateTime date, String serialNo) async {
    final start = _startOfDay(date);
    final end = _endOfDay(date);

    return (select(pressDataTable)
          ..where((tbl) => tbl.recordedAt.isBetweenValues(start, end))
          ..where((tbl) => tbl.DeviceNo.equals(serialNo)))
        .get();
  }

  DateTime _startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime _endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  Future<List<PressDataTableData>> getDataForDateRange(
      DateTime startDate, DateTime endDate, String serial) async {
    final start = _startOfDay(startDate);
    final end = _endOfDay(endDate);

    return (select(pressDataTable)
          ..where((tbl) => tbl.recordedAt.isBetweenValues(start, end))
          ..where((tbl) => tbl.DeviceNo.equals(serial)))
        .get();
  }

  Future<List<PressDataTableData>> getDataForMonth(
      DateTime start, DateTime end, String serialNo) async {
    print("Start and end $start  wefefvefve $end");
    return (select(pressDataTable)
          ..where((tbl) => tbl.recordedAt.isBetweenValues(start, end))
          ..where((tbl) => tbl.DeviceNo.equals(serialNo)))
        .get();
  }

  Future<List<DistinctData>> getDistinctSerialAndLocationDaily(
      DateTime date) async {
    final start = _startOfDay(date);
    final end = _endOfDay(date);

    final query = selectOnly(pressDataTable, distinct: true)
      ..addColumns([pressDataTable.DeviceNo, pressDataTable.LocationID])
      ..where(pressDataTable.recordedAt.isBetweenValues(start, end));

    final result = await query.get();

    return result.map((row) {
      return DistinctData(
        serialNo: row.read(pressDataTable.DeviceNo)!,
        locationNo: row.read(pressDataTable.LocationID)!,
      );
    }).toList();
  }

  Future<List<DistinctData>> getDistinctSerialAndLocationweekly(
      DateTime startofweek, endofweek) async {
    final start = _startOfDay(startofweek);
    final end = _endOfDay(endofweek);

    final query = selectOnly(pressDataTable, distinct: true)
      ..addColumns([pressDataTable.DeviceNo, pressDataTable.LocationID])
      ..where(pressDataTable.recordedAt.isBetweenValues(start, end));

    final result = await query.get();

    return result.map((row) {
      return DistinctData(
        serialNo: row.read(pressDataTable.DeviceNo)!,
        locationNo: row.read(pressDataTable.LocationID)!,
      );
    }).toList();
  }

  Future<List<DistinctData>> getDistinctSerialAndLocationMonthly(
      DateTime startDate, endDate) async {
    final start = _startOfDay(startDate);
    final end = _endOfDay(endDate);

    final query = selectOnly(pressDataTable, distinct: true)
      ..addColumns([pressDataTable.DeviceNo, pressDataTable.LocationID])
      ..where(pressDataTable.recordedAt.isBetweenValues(start, end));

    final result = await query.get();

    return result.map((row) {
      return DistinctData(
        serialNo: row.read(pressDataTable.DeviceNo)!,
        locationNo: row.read(pressDataTable.LocationID)!,
      );
    }).toList();
  }

  Future<List<DistinctErrorData>> getDistinctErrorTypes(
      DateTime startdate, endDate) async {
    final start = _startOfDay(startdate);
    final end = _endOfDay(endDate);

    final query = selectOnly(pressDataTable, distinct: true)
      ..addColumns([
        pressDataTable.temp_error,
        pressDataTable.n2o_error,
        pressDataTable.humi_error,
        pressDataTable.o2_1_error,
        pressDataTable.co2_error,
        pressDataTable.air_error,
        pressDataTable.o2_2_error,
        pressDataTable.vac_error,
      ])
      ..where(pressDataTable.recordedAt.isBetweenValues(start, end));

    final result = await query.get();

    // Extract distinct error values
    final errorTypes = <String>{};
    for (final row in result) {
      errorTypes.add(row.read(pressDataTable.temp_error)!);
      errorTypes.add(row.read(pressDataTable.n2o_error)!);
      errorTypes.add(row.read(pressDataTable.humi_error)!);
      errorTypes.add(row.read(pressDataTable.o2_1_error)!);
      errorTypes.add(row.read(pressDataTable.co2_error)!);
      errorTypes.add(row.read(pressDataTable.air_error)!);
      errorTypes.add(row.read(pressDataTable.o2_2_error)!);
      errorTypes.add(row.read(pressDataTable.vac_error)!);
    }

    return errorTypes.map((errorType) {
      return DistinctErrorData(errorType: errorType);
    }).toList();
  }

  DateTime _startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  DateTime _endOfMonth(DateTime date) {
    final nextMonth = date.month == 12
        ? DateTime(date.year + 1, 1, 1)
        : DateTime(date.year, date.month + 1, 1);
    return nextMonth.subtract(const Duration(seconds: 1));
  }

  // Insert data into the ErrorTable
  Future<int> insertErrorData(ErrorTableCompanion entity) {
    return into(errorTable).insert(entity);
  }

  Future<List<ErrorTableData>> getErrorDataForSingleDay(DateTime date) async {
    final start = _startOfDay(date);
    final end = _endOfDay(date);

    return (select(errorTable)
          ..where((tbl) => tbl.recordedAt.isBetweenValues(start, end)))
        .get();
  }

  // Retrieve all data from the ErrorTable
  Future<List<ErrorTableData>> getAllErrorData() {
    return select(errorTable).get();
  }

  // Retrieve data for a specific parameter
  Future<List<ErrorTableData>> getErrorDataForParameter(String parameter) {
    return (select(errorTable)..where((tbl) => tbl.parameter.equals(parameter)))
        .get();
  }

  // Retrieve data for a specific day
  Future<List<ErrorTableData>> getErrorDataForDay(
      DateTime date, String serialNo) async {
    final start = _startOfDay(date);
    final end = _endOfDay(date);
    print(start);
    print(end);
    return (select(errorTable)
          ..where((tbl) => tbl.recordedAt.isBetweenValues(start, end))
          ..where((tbl) => tbl.DeviceNo.equals(serialNo)))
        .get();
  }

  Future<List<ErrorTableData>> getErrorDataForWeek(
      DateTime startOfWeek, DateTime endOfweek, String serialNo) async {
    // final start = _startOfDay(startOfWeek);
    // final end =
    //     _endOfWeek(startOfWeek); // Custom function to calculate end of the week
    final start = _startOfDay(startOfWeek);
    final end = _endOfDay(endOfweek);
    print("Hello->>$startOfWeek");
    return (select(errorTable)
          ..where((tbl) => tbl.recordedAt.isBetweenValues(start, end))
          ..where((tbl) => tbl.DeviceNo.equals(serialNo)))
        .get();
  }

  DateTime _endOfWeek(DateTime date) {
    return DateTime(date.year, date.month, date.day + 6, 23, 59, 59);
  }

  Future<List<ErrorTableData>> getErrorDataForMonth(
      DateTime startDate, endDate, String serialno) async {
    return (select(errorTable)
          ..where((tbl) => tbl.recordedAt.isBetweenValues(startDate, endDate))
          ..where((tbl) => tbl.DeviceNo.equals(serialno)))
        .get();
  }

  // Update an error record
  Future<bool> updateErrorData(ErrorTableCompanion entity) {
    return update(errorTable).replace(entity);
  }

  // Delete an error record
  Future<int> deleteErrorData(int id) {
    return (delete(errorTable)..where((tbl) => tbl.id.equals(id))).go();
  }

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
