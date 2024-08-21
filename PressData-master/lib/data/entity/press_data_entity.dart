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
  TextColumn get LocationID => text().named('LocationID')();
  IntColumn get Temp_min => integer().named('Temp_min')();
  IntColumn get Temp_max => integer().named('Temp_max')();
  IntColumn get Humi_min => integer().named('Humi_min')();
  IntColumn get Humi_max => integer().named('Humi_max')();
  IntColumn get O2_1_min => integer().named('O2_1_min')();
  IntColumn get O2_1_max => integer().named('O2_1_max')();
  IntColumn get n2o_min => integer().named('n2o_min')();
  IntColumn get n2o_max => integer().named('n2o_max')();
  IntColumn get o2_2_min => integer().named('o2_2_min')();
  IntColumn get o2_2_max => integer().named('o2_2_max')();
  IntColumn get air_min => integer().named('air_min')();
  IntColumn get air_max => integer().named('air_max')();
  IntColumn get co2_min => integer().named('co2_min')();
  IntColumn get co2_max => integer().named('co2_max')();
  IntColumn get vac_min => integer().named('vac_min')();
  IntColumn get vac_max => integer().named('vac_max')();
  TextColumn get temp_error => text().named('temp_error')();
  TextColumn get n2o_error => text().named('n2o_error')();
  TextColumn get humi_error => text().named('humi_error')();
  TextColumn get o2_1_error => text().named('o2_1_error')();
  TextColumn get co2_error => text().named('co2_error')();
  TextColumn get air_error => text().named('air_error')();
  TextColumn get o2_2_error => text().named('o2_2_error')();
  TextColumn get vac_error => text().named('vac_error')();

  DateTimeColumn get recordedAt => dateTime().nullable()();
}
