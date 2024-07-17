// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $PressDataTableTable extends PressDataTable
    with TableInfo<$PressDataTableTable, PressDataTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PressDataTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _temperatureMeta =
      const VerificationMeta('temperature');
  @override
  late final GeneratedColumn<int> temperature = GeneratedColumn<int>(
      'temperature', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _humidityMeta =
      const VerificationMeta('humidity');
  @override
  late final GeneratedColumn<int> humidity = GeneratedColumn<int>(
      'humidity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _o2Meta = const VerificationMeta('o2');
  @override
  late final GeneratedColumn<int> o2 = GeneratedColumn<int>(
      'o2', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _vacMeta = const VerificationMeta('vac');
  @override
  late final GeneratedColumn<int> vac = GeneratedColumn<int>(
      'vac', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _n2oMeta = const VerificationMeta('n2o');
  @override
  late final GeneratedColumn<int> n2o = GeneratedColumn<int>(
      'n2o', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _airPressureMeta =
      const VerificationMeta('airPressure');
  @override
  late final GeneratedColumn<int> airPressure = GeneratedColumn<int>(
      'airPressure', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _co2Meta = const VerificationMeta('co2');
  @override
  late final GeneratedColumn<int> co2 = GeneratedColumn<int>(
      'co2', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _o22Meta = const VerificationMeta('o22');
  @override
  late final GeneratedColumn<int> o22 = GeneratedColumn<int>(
      'o22', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _DeviceNoMeta =
      const VerificationMeta('DeviceNo');
  @override
  late final GeneratedColumn<String> DeviceNo = GeneratedColumn<String>(
      'DeviceNo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recordedAtMeta =
      const VerificationMeta('recordedAt');
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
      'recorded_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        temperature,
        humidity,
        o2,
        vac,
        n2o,
        airPressure,
        co2,
        o22,
        DeviceNo,
        recordedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'press_data_table';
  @override
  VerificationContext validateIntegrity(Insertable<PressDataTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('temperature')) {
      context.handle(
          _temperatureMeta,
          temperature.isAcceptableOrUnknown(
              data['temperature']!, _temperatureMeta));
    } else if (isInserting) {
      context.missing(_temperatureMeta);
    }
    if (data.containsKey('humidity')) {
      context.handle(_humidityMeta,
          humidity.isAcceptableOrUnknown(data['humidity']!, _humidityMeta));
    } else if (isInserting) {
      context.missing(_humidityMeta);
    }
    if (data.containsKey('o2')) {
      context.handle(_o2Meta, o2.isAcceptableOrUnknown(data['o2']!, _o2Meta));
    } else if (isInserting) {
      context.missing(_o2Meta);
    }
    if (data.containsKey('vac')) {
      context.handle(
          _vacMeta, vac.isAcceptableOrUnknown(data['vac']!, _vacMeta));
    } else if (isInserting) {
      context.missing(_vacMeta);
    }
    if (data.containsKey('n2o')) {
      context.handle(
          _n2oMeta, n2o.isAcceptableOrUnknown(data['n2o']!, _n2oMeta));
    } else if (isInserting) {
      context.missing(_n2oMeta);
    }
    if (data.containsKey('airPressure')) {
      context.handle(
          _airPressureMeta,
          airPressure.isAcceptableOrUnknown(
              data['airPressure']!, _airPressureMeta));
    } else if (isInserting) {
      context.missing(_airPressureMeta);
    }
    if (data.containsKey('co2')) {
      context.handle(
          _co2Meta, co2.isAcceptableOrUnknown(data['co2']!, _co2Meta));
    } else if (isInserting) {
      context.missing(_co2Meta);
    }
    if (data.containsKey('o22')) {
      context.handle(
          _o22Meta, o22.isAcceptableOrUnknown(data['o22']!, _o22Meta));
    } else if (isInserting) {
      context.missing(_o22Meta);
    }
    if (data.containsKey('DeviceNo')) {
      context.handle(_DeviceNoMeta,
          DeviceNo.isAcceptableOrUnknown(data['DeviceNo']!, _DeviceNoMeta));
    } else if (isInserting) {
      context.missing(_DeviceNoMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
          _recordedAtMeta,
          recordedAt.isAcceptableOrUnknown(
              data['recorded_at']!, _recordedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PressDataTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PressDataTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      temperature: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}temperature'])!,
      humidity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}humidity'])!,
      o2: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}o2'])!,
      vac: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}vac'])!,
      n2o: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}n2o'])!,
      airPressure: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}airPressure'])!,
      co2: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}co2'])!,
      o22: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}o22'])!,
      DeviceNo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}DeviceNo'])!,
      recordedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}recorded_at']),
    );
  }

  @override
  $PressDataTableTable createAlias(String alias) {
    return $PressDataTableTable(attachedDatabase, alias);
  }
}

class PressDataTableData extends DataClass
    implements Insertable<PressDataTableData> {
  final int id;
  final int temperature;
  final int humidity;
  final int o2;
  final int vac;
  final int n2o;
  final int airPressure;
  final int co2;
  final int o22;
  final String DeviceNo;
  final DateTime? recordedAt;
  const PressDataTableData(
      {required this.id,
      required this.temperature,
      required this.humidity,
      required this.o2,
      required this.vac,
      required this.n2o,
      required this.airPressure,
      required this.co2,
      required this.o22,
      required this.DeviceNo,
      this.recordedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['temperature'] = Variable<int>(temperature);
    map['humidity'] = Variable<int>(humidity);
    map['o2'] = Variable<int>(o2);
    map['vac'] = Variable<int>(vac);
    map['n2o'] = Variable<int>(n2o);
    map['airPressure'] = Variable<int>(airPressure);
    map['co2'] = Variable<int>(co2);
    map['o22'] = Variable<int>(o22);
    map['DeviceNo'] = Variable<String>(DeviceNo);
    if (!nullToAbsent || recordedAt != null) {
      map['recorded_at'] = Variable<DateTime>(recordedAt);
    }
    return map;
  }

  PressDataTableCompanion toCompanion(bool nullToAbsent) {
    return PressDataTableCompanion(
      id: Value(id),
      temperature: Value(temperature),
      humidity: Value(humidity),
      o2: Value(o2),
      vac: Value(vac),
      n2o: Value(n2o),
      airPressure: Value(airPressure),
      co2: Value(co2),
      o22: Value(o22),
      DeviceNo: Value(DeviceNo),
      recordedAt: recordedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(recordedAt),
    );
  }

  factory PressDataTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PressDataTableData(
      id: serializer.fromJson<int>(json['id']),
      temperature: serializer.fromJson<int>(json['temperature']),
      humidity: serializer.fromJson<int>(json['humidity']),
      o2: serializer.fromJson<int>(json['o2']),
      vac: serializer.fromJson<int>(json['vac']),
      n2o: serializer.fromJson<int>(json['n2o']),
      airPressure: serializer.fromJson<int>(json['airPressure']),
      co2: serializer.fromJson<int>(json['co2']),
      o22: serializer.fromJson<int>(json['o22']),
      DeviceNo: serializer.fromJson<String>(json['DeviceNo']),
      recordedAt: serializer.fromJson<DateTime?>(json['recordedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'temperature': serializer.toJson<int>(temperature),
      'humidity': serializer.toJson<int>(humidity),
      'o2': serializer.toJson<int>(o2),
      'vac': serializer.toJson<int>(vac),
      'n2o': serializer.toJson<int>(n2o),
      'airPressure': serializer.toJson<int>(airPressure),
      'co2': serializer.toJson<int>(co2),
      'o22': serializer.toJson<int>(o22),
      'DeviceNo': serializer.toJson<String>(DeviceNo),
      'recordedAt': serializer.toJson<DateTime?>(recordedAt),
    };
  }

  PressDataTableData copyWith(
          {int? id,
          int? temperature,
          int? humidity,
          int? o2,
          int? vac,
          int? n2o,
          int? airPressure,
          int? co2,
          int? o22,
          String? DeviceNo,
          Value<DateTime?> recordedAt = const Value.absent()}) =>
      PressDataTableData(
        id: id ?? this.id,
        temperature: temperature ?? this.temperature,
        humidity: humidity ?? this.humidity,
        o2: o2 ?? this.o2,
        vac: vac ?? this.vac,
        n2o: n2o ?? this.n2o,
        airPressure: airPressure ?? this.airPressure,
        co2: co2 ?? this.co2,
        o22: o22 ?? this.o22,
        DeviceNo: DeviceNo ?? this.DeviceNo,
        recordedAt: recordedAt.present ? recordedAt.value : this.recordedAt,
      );
  PressDataTableData copyWithCompanion(PressDataTableCompanion data) {
    return PressDataTableData(
      id: data.id.present ? data.id.value : this.id,
      temperature:
          data.temperature.present ? data.temperature.value : this.temperature,
      humidity: data.humidity.present ? data.humidity.value : this.humidity,
      o2: data.o2.present ? data.o2.value : this.o2,
      vac: data.vac.present ? data.vac.value : this.vac,
      n2o: data.n2o.present ? data.n2o.value : this.n2o,
      airPressure:
          data.airPressure.present ? data.airPressure.value : this.airPressure,
      co2: data.co2.present ? data.co2.value : this.co2,
      o22: data.o22.present ? data.o22.value : this.o22,
      DeviceNo: data.DeviceNo.present ? data.DeviceNo.value : this.DeviceNo,
      recordedAt:
          data.recordedAt.present ? data.recordedAt.value : this.recordedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PressDataTableData(')
          ..write('id: $id, ')
          ..write('temperature: $temperature, ')
          ..write('humidity: $humidity, ')
          ..write('o2: $o2, ')
          ..write('vac: $vac, ')
          ..write('n2o: $n2o, ')
          ..write('airPressure: $airPressure, ')
          ..write('co2: $co2, ')
          ..write('o22: $o22, ')
          ..write('DeviceNo: $DeviceNo, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, temperature, humidity, o2, vac, n2o,
      airPressure, co2, o22, DeviceNo, recordedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PressDataTableData &&
          other.id == this.id &&
          other.temperature == this.temperature &&
          other.humidity == this.humidity &&
          other.o2 == this.o2 &&
          other.vac == this.vac &&
          other.n2o == this.n2o &&
          other.airPressure == this.airPressure &&
          other.co2 == this.co2 &&
          other.o22 == this.o22 &&
          other.DeviceNo == this.DeviceNo &&
          other.recordedAt == this.recordedAt);
}

class PressDataTableCompanion extends UpdateCompanion<PressDataTableData> {
  final Value<int> id;
  final Value<int> temperature;
  final Value<int> humidity;
  final Value<int> o2;
  final Value<int> vac;
  final Value<int> n2o;
  final Value<int> airPressure;
  final Value<int> co2;
  final Value<int> o22;
  final Value<String> DeviceNo;
  final Value<DateTime?> recordedAt;
  const PressDataTableCompanion({
    this.id = const Value.absent(),
    this.temperature = const Value.absent(),
    this.humidity = const Value.absent(),
    this.o2 = const Value.absent(),
    this.vac = const Value.absent(),
    this.n2o = const Value.absent(),
    this.airPressure = const Value.absent(),
    this.co2 = const Value.absent(),
    this.o22 = const Value.absent(),
    this.DeviceNo = const Value.absent(),
    this.recordedAt = const Value.absent(),
  });
  PressDataTableCompanion.insert({
    this.id = const Value.absent(),
    required int temperature,
    required int humidity,
    required int o2,
    required int vac,
    required int n2o,
    required int airPressure,
    required int co2,
    required int o22,
    required String DeviceNo,
    this.recordedAt = const Value.absent(),
  })  : temperature = Value(temperature),
        humidity = Value(humidity),
        o2 = Value(o2),
        vac = Value(vac),
        n2o = Value(n2o),
        airPressure = Value(airPressure),
        co2 = Value(co2),
        o22 = Value(o22),
        DeviceNo = Value(DeviceNo);
  static Insertable<PressDataTableData> custom({
    Expression<int>? id,
    Expression<int>? temperature,
    Expression<int>? humidity,
    Expression<int>? o2,
    Expression<int>? vac,
    Expression<int>? n2o,
    Expression<int>? airPressure,
    Expression<int>? co2,
    Expression<int>? o22,
    Expression<String>? DeviceNo,
    Expression<DateTime>? recordedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (temperature != null) 'temperature': temperature,
      if (humidity != null) 'humidity': humidity,
      if (o2 != null) 'o2': o2,
      if (vac != null) 'vac': vac,
      if (n2o != null) 'n2o': n2o,
      if (airPressure != null) 'airPressure': airPressure,
      if (co2 != null) 'co2': co2,
      if (o22 != null) 'o22': o22,
      if (DeviceNo != null) 'DeviceNo': DeviceNo,
      if (recordedAt != null) 'recorded_at': recordedAt,
    });
  }

  PressDataTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? temperature,
      Value<int>? humidity,
      Value<int>? o2,
      Value<int>? vac,
      Value<int>? n2o,
      Value<int>? airPressure,
      Value<int>? co2,
      Value<int>? o22,
      Value<String>? DeviceNo,
      Value<DateTime?>? recordedAt}) {
    return PressDataTableCompanion(
      id: id ?? this.id,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      o2: o2 ?? this.o2,
      vac: vac ?? this.vac,
      n2o: n2o ?? this.n2o,
      airPressure: airPressure ?? this.airPressure,
      co2: co2 ?? this.co2,
      o22: o22 ?? this.o22,
      DeviceNo: DeviceNo ?? this.DeviceNo,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (temperature.present) {
      map['temperature'] = Variable<int>(temperature.value);
    }
    if (humidity.present) {
      map['humidity'] = Variable<int>(humidity.value);
    }
    if (o2.present) {
      map['o2'] = Variable<int>(o2.value);
    }
    if (vac.present) {
      map['vac'] = Variable<int>(vac.value);
    }
    if (n2o.present) {
      map['n2o'] = Variable<int>(n2o.value);
    }
    if (airPressure.present) {
      map['airPressure'] = Variable<int>(airPressure.value);
    }
    if (co2.present) {
      map['co2'] = Variable<int>(co2.value);
    }
    if (o22.present) {
      map['o22'] = Variable<int>(o22.value);
    }
    if (DeviceNo.present) {
      map['DeviceNo'] = Variable<String>(DeviceNo.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PressDataTableCompanion(')
          ..write('id: $id, ')
          ..write('temperature: $temperature, ')
          ..write('humidity: $humidity, ')
          ..write('o2: $o2, ')
          ..write('vac: $vac, ')
          ..write('n2o: $n2o, ')
          ..write('airPressure: $airPressure, ')
          ..write('co2: $co2, ')
          ..write('o22: $o22, ')
          ..write('DeviceNo: $DeviceNo, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$PressDataDb extends GeneratedDatabase {
  _$PressDataDb(QueryExecutor e) : super(e);
  $PressDataDbManager get managers => $PressDataDbManager(this);
  late final $PressDataTableTable pressDataTable = $PressDataTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [pressDataTable];
}

typedef $$PressDataTableTableCreateCompanionBuilder = PressDataTableCompanion
    Function({
  Value<int> id,
  required int temperature,
  required int humidity,
  required int o2,
  required int vac,
  required int n2o,
  required int airPressure,
  required int co2,
  required int o22,
  required String DeviceNo,
  Value<DateTime?> recordedAt,
});
typedef $$PressDataTableTableUpdateCompanionBuilder = PressDataTableCompanion
    Function({
  Value<int> id,
  Value<int> temperature,
  Value<int> humidity,
  Value<int> o2,
  Value<int> vac,
  Value<int> n2o,
  Value<int> airPressure,
  Value<int> co2,
  Value<int> o22,
  Value<String> DeviceNo,
  Value<DateTime?> recordedAt,
});

class $$PressDataTableTableTableManager extends RootTableManager<
    _$PressDataDb,
    $PressDataTableTable,
    PressDataTableData,
    $$PressDataTableTableFilterComposer,
    $$PressDataTableTableOrderingComposer,
    $$PressDataTableTableCreateCompanionBuilder,
    $$PressDataTableTableUpdateCompanionBuilder> {
  $$PressDataTableTableTableManager(
      _$PressDataDb db, $PressDataTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PressDataTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PressDataTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> temperature = const Value.absent(),
            Value<int> humidity = const Value.absent(),
            Value<int> o2 = const Value.absent(),
            Value<int> vac = const Value.absent(),
            Value<int> n2o = const Value.absent(),
            Value<int> airPressure = const Value.absent(),
            Value<int> co2 = const Value.absent(),
            Value<int> o22 = const Value.absent(),
            Value<String> DeviceNo = const Value.absent(),
            Value<DateTime?> recordedAt = const Value.absent(),
          }) =>
              PressDataTableCompanion(
            id: id,
            temperature: temperature,
            humidity: humidity,
            o2: o2,
            vac: vac,
            n2o: n2o,
            airPressure: airPressure,
            co2: co2,
            o22: o22,
            DeviceNo: DeviceNo,
            recordedAt: recordedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int temperature,
            required int humidity,
            required int o2,
            required int vac,
            required int n2o,
            required int airPressure,
            required int co2,
            required int o22,
            required String DeviceNo,
            Value<DateTime?> recordedAt = const Value.absent(),
          }) =>
              PressDataTableCompanion.insert(
            id: id,
            temperature: temperature,
            humidity: humidity,
            o2: o2,
            vac: vac,
            n2o: n2o,
            airPressure: airPressure,
            co2: co2,
            o22: o22,
            DeviceNo: DeviceNo,
            recordedAt: recordedAt,
          ),
        ));
}

class $$PressDataTableTableFilterComposer
    extends FilterComposer<_$PressDataDb, $PressDataTableTable> {
  $$PressDataTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get temperature => $state.composableBuilder(
      column: $state.table.temperature,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get humidity => $state.composableBuilder(
      column: $state.table.humidity,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get o2 => $state.composableBuilder(
      column: $state.table.o2,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get vac => $state.composableBuilder(
      column: $state.table.vac,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get n2o => $state.composableBuilder(
      column: $state.table.n2o,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get airPressure => $state.composableBuilder(
      column: $state.table.airPressure,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get co2 => $state.composableBuilder(
      column: $state.table.co2,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get o22 => $state.composableBuilder(
      column: $state.table.o22,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get DeviceNo => $state.composableBuilder(
      column: $state.table.DeviceNo,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get recordedAt => $state.composableBuilder(
      column: $state.table.recordedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$PressDataTableTableOrderingComposer
    extends OrderingComposer<_$PressDataDb, $PressDataTableTable> {
  $$PressDataTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get temperature => $state.composableBuilder(
      column: $state.table.temperature,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get humidity => $state.composableBuilder(
      column: $state.table.humidity,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get o2 => $state.composableBuilder(
      column: $state.table.o2,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get vac => $state.composableBuilder(
      column: $state.table.vac,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get n2o => $state.composableBuilder(
      column: $state.table.n2o,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get airPressure => $state.composableBuilder(
      column: $state.table.airPressure,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get co2 => $state.composableBuilder(
      column: $state.table.co2,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get o22 => $state.composableBuilder(
      column: $state.table.o22,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get DeviceNo => $state.composableBuilder(
      column: $state.table.DeviceNo,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get recordedAt => $state.composableBuilder(
      column: $state.table.recordedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $PressDataDbManager {
  final _$PressDataDb _db;
  $PressDataDbManager(this._db);
  $$PressDataTableTableTableManager get pressDataTable =>
      $$PressDataTableTableTableManager(_db, _db.pressDataTable);
}
