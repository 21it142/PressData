import 'package:drift/drift.dart';

class PressDataTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get temperature => integer().named('temperature')();
  IntColumn get humidity => integer().named('humidity')();
  IntColumn get o2 => integer().named('o2')();
  IntColumn get vac => integer().named('vac')();
  IntColumn get n2o => integer().named('n2o')();
  IntColumn get airPressure => integer().named('airPressure')();
  IntColumn get co2 => integer().named('co2')();
  IntColumn get o22 => integer().named('o22')();
  TextColumn get DeviceNo => text().named('DeviceNo')();
  DateTimeColumn get recordedAt => dateTime().nullable()();
}
