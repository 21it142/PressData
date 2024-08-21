import 'package:drift/drift.dart';
//import 'package:pressdata/data/entity/press_data_entity.dart';

class ErrorTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get DeviceNo => text().named('DeviceNo')();
  TextColumn get parameter => text().named('parameter')();
  TextColumn get logValue => text().named('log_value')();
  IntColumn get minValue => integer().named('min_value')();
  IntColumn get maxValue => integer().named('max_value')();
 // IntColumn get parametervalues => integer().named('')();
  DateTimeColumn get recordedAt => dateTime().nullable()();
}
