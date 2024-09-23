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
  static const VerificationMeta _LocationIDMeta =
      const VerificationMeta('LocationID');
  @override
  late final GeneratedColumn<String> LocationID = GeneratedColumn<String>(
      'LocationID', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _Temp_minMeta =
      const VerificationMeta('Temp_min');
  @override
  late final GeneratedColumn<int> Temp_min = GeneratedColumn<int>(
      'Temp_min', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _Temp_maxMeta =
      const VerificationMeta('Temp_max');
  @override
  late final GeneratedColumn<int> Temp_max = GeneratedColumn<int>(
      'Temp_max', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _Humi_minMeta =
      const VerificationMeta('Humi_min');
  @override
  late final GeneratedColumn<int> Humi_min = GeneratedColumn<int>(
      'Humi_min', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _Humi_maxMeta =
      const VerificationMeta('Humi_max');
  @override
  late final GeneratedColumn<int> Humi_max = GeneratedColumn<int>(
      'Humi_max', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _O2_1_minMeta =
      const VerificationMeta('O2_1_min');
  @override
  late final GeneratedColumn<int> O2_1_min = GeneratedColumn<int>(
      'O2_1_min', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _O2_1_maxMeta =
      const VerificationMeta('O2_1_max');
  @override
  late final GeneratedColumn<int> O2_1_max = GeneratedColumn<int>(
      'O2_1_max', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _n2o_minMeta =
      const VerificationMeta('n2o_min');
  @override
  late final GeneratedColumn<int> n2o_min = GeneratedColumn<int>(
      'n2o_min', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _n2o_maxMeta =
      const VerificationMeta('n2o_max');
  @override
  late final GeneratedColumn<int> n2o_max = GeneratedColumn<int>(
      'n2o_max', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _o2_2_minMeta =
      const VerificationMeta('o2_2_min');
  @override
  late final GeneratedColumn<int> o2_2_min = GeneratedColumn<int>(
      'o2_2_min', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _o2_2_maxMeta =
      const VerificationMeta('o2_2_max');
  @override
  late final GeneratedColumn<int> o2_2_max = GeneratedColumn<int>(
      'o2_2_max', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _air_minMeta =
      const VerificationMeta('air_min');
  @override
  late final GeneratedColumn<int> air_min = GeneratedColumn<int>(
      'air_min', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _air_maxMeta =
      const VerificationMeta('air_max');
  @override
  late final GeneratedColumn<int> air_max = GeneratedColumn<int>(
      'air_max', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _co2_minMeta =
      const VerificationMeta('co2_min');
  @override
  late final GeneratedColumn<int> co2_min = GeneratedColumn<int>(
      'co2_min', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _co2_maxMeta =
      const VerificationMeta('co2_max');
  @override
  late final GeneratedColumn<int> co2_max = GeneratedColumn<int>(
      'co2_max', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _vac_minMeta =
      const VerificationMeta('vac_min');
  @override
  late final GeneratedColumn<int> vac_min = GeneratedColumn<int>(
      'vac_min', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _vac_maxMeta =
      const VerificationMeta('vac_max');
  @override
  late final GeneratedColumn<int> vac_max = GeneratedColumn<int>(
      'vac_max', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _temp_errorMeta =
      const VerificationMeta('temp_error');
  @override
  late final GeneratedColumn<String> temp_error = GeneratedColumn<String>(
      'temp_error', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _n2o_errorMeta =
      const VerificationMeta('n2o_error');
  @override
  late final GeneratedColumn<String> n2o_error = GeneratedColumn<String>(
      'n2o_error', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _humi_errorMeta =
      const VerificationMeta('humi_error');
  @override
  late final GeneratedColumn<String> humi_error = GeneratedColumn<String>(
      'humi_error', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _o2_1_errorMeta =
      const VerificationMeta('o2_1_error');
  @override
  late final GeneratedColumn<String> o2_1_error = GeneratedColumn<String>(
      'o2_1_error', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _co2_errorMeta =
      const VerificationMeta('co2_error');
  @override
  late final GeneratedColumn<String> co2_error = GeneratedColumn<String>(
      'co2_error', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _air_errorMeta =
      const VerificationMeta('air_error');
  @override
  late final GeneratedColumn<String> air_error = GeneratedColumn<String>(
      'air_error', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _o2_2_errorMeta =
      const VerificationMeta('o2_2_error');
  @override
  late final GeneratedColumn<String> o2_2_error = GeneratedColumn<String>(
      'o2_2_error', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _vac_errorMeta =
      const VerificationMeta('vac_error');
  @override
  late final GeneratedColumn<String> vac_error = GeneratedColumn<String>(
      'vac_error', aliasedName, false,
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
        LocationID,
        Temp_min,
        Temp_max,
        Humi_min,
        Humi_max,
        O2_1_min,
        O2_1_max,
        n2o_min,
        n2o_max,
        o2_2_min,
        o2_2_max,
        air_min,
        air_max,
        co2_min,
        co2_max,
        vac_min,
        vac_max,
        temp_error,
        n2o_error,
        humi_error,
        o2_1_error,
        co2_error,
        air_error,
        o2_2_error,
        vac_error,
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
    if (data.containsKey('LocationID')) {
      context.handle(
          _LocationIDMeta,
          LocationID.isAcceptableOrUnknown(
              data['LocationID']!, _LocationIDMeta));
    } else if (isInserting) {
      context.missing(_LocationIDMeta);
    }
    if (data.containsKey('Temp_min')) {
      context.handle(_Temp_minMeta,
          Temp_min.isAcceptableOrUnknown(data['Temp_min']!, _Temp_minMeta));
    } else if (isInserting) {
      context.missing(_Temp_minMeta);
    }
    if (data.containsKey('Temp_max')) {
      context.handle(_Temp_maxMeta,
          Temp_max.isAcceptableOrUnknown(data['Temp_max']!, _Temp_maxMeta));
    } else if (isInserting) {
      context.missing(_Temp_maxMeta);
    }
    if (data.containsKey('Humi_min')) {
      context.handle(_Humi_minMeta,
          Humi_min.isAcceptableOrUnknown(data['Humi_min']!, _Humi_minMeta));
    } else if (isInserting) {
      context.missing(_Humi_minMeta);
    }
    if (data.containsKey('Humi_max')) {
      context.handle(_Humi_maxMeta,
          Humi_max.isAcceptableOrUnknown(data['Humi_max']!, _Humi_maxMeta));
    } else if (isInserting) {
      context.missing(_Humi_maxMeta);
    }
    if (data.containsKey('O2_1_min')) {
      context.handle(_O2_1_minMeta,
          O2_1_min.isAcceptableOrUnknown(data['O2_1_min']!, _O2_1_minMeta));
    } else if (isInserting) {
      context.missing(_O2_1_minMeta);
    }
    if (data.containsKey('O2_1_max')) {
      context.handle(_O2_1_maxMeta,
          O2_1_max.isAcceptableOrUnknown(data['O2_1_max']!, _O2_1_maxMeta));
    } else if (isInserting) {
      context.missing(_O2_1_maxMeta);
    }
    if (data.containsKey('n2o_min')) {
      context.handle(_n2o_minMeta,
          n2o_min.isAcceptableOrUnknown(data['n2o_min']!, _n2o_minMeta));
    } else if (isInserting) {
      context.missing(_n2o_minMeta);
    }
    if (data.containsKey('n2o_max')) {
      context.handle(_n2o_maxMeta,
          n2o_max.isAcceptableOrUnknown(data['n2o_max']!, _n2o_maxMeta));
    } else if (isInserting) {
      context.missing(_n2o_maxMeta);
    }
    if (data.containsKey('o2_2_min')) {
      context.handle(_o2_2_minMeta,
          o2_2_min.isAcceptableOrUnknown(data['o2_2_min']!, _o2_2_minMeta));
    } else if (isInserting) {
      context.missing(_o2_2_minMeta);
    }
    if (data.containsKey('o2_2_max')) {
      context.handle(_o2_2_maxMeta,
          o2_2_max.isAcceptableOrUnknown(data['o2_2_max']!, _o2_2_maxMeta));
    } else if (isInserting) {
      context.missing(_o2_2_maxMeta);
    }
    if (data.containsKey('air_min')) {
      context.handle(_air_minMeta,
          air_min.isAcceptableOrUnknown(data['air_min']!, _air_minMeta));
    } else if (isInserting) {
      context.missing(_air_minMeta);
    }
    if (data.containsKey('air_max')) {
      context.handle(_air_maxMeta,
          air_max.isAcceptableOrUnknown(data['air_max']!, _air_maxMeta));
    } else if (isInserting) {
      context.missing(_air_maxMeta);
    }
    if (data.containsKey('co2_min')) {
      context.handle(_co2_minMeta,
          co2_min.isAcceptableOrUnknown(data['co2_min']!, _co2_minMeta));
    } else if (isInserting) {
      context.missing(_co2_minMeta);
    }
    if (data.containsKey('co2_max')) {
      context.handle(_co2_maxMeta,
          co2_max.isAcceptableOrUnknown(data['co2_max']!, _co2_maxMeta));
    } else if (isInserting) {
      context.missing(_co2_maxMeta);
    }
    if (data.containsKey('vac_min')) {
      context.handle(_vac_minMeta,
          vac_min.isAcceptableOrUnknown(data['vac_min']!, _vac_minMeta));
    } else if (isInserting) {
      context.missing(_vac_minMeta);
    }
    if (data.containsKey('vac_max')) {
      context.handle(_vac_maxMeta,
          vac_max.isAcceptableOrUnknown(data['vac_max']!, _vac_maxMeta));
    } else if (isInserting) {
      context.missing(_vac_maxMeta);
    }
    if (data.containsKey('temp_error')) {
      context.handle(
          _temp_errorMeta,
          temp_error.isAcceptableOrUnknown(
              data['temp_error']!, _temp_errorMeta));
    } else if (isInserting) {
      context.missing(_temp_errorMeta);
    }
    if (data.containsKey('n2o_error')) {
      context.handle(_n2o_errorMeta,
          n2o_error.isAcceptableOrUnknown(data['n2o_error']!, _n2o_errorMeta));
    } else if (isInserting) {
      context.missing(_n2o_errorMeta);
    }
    if (data.containsKey('humi_error')) {
      context.handle(
          _humi_errorMeta,
          humi_error.isAcceptableOrUnknown(
              data['humi_error']!, _humi_errorMeta));
    } else if (isInserting) {
      context.missing(_humi_errorMeta);
    }
    if (data.containsKey('o2_1_error')) {
      context.handle(
          _o2_1_errorMeta,
          o2_1_error.isAcceptableOrUnknown(
              data['o2_1_error']!, _o2_1_errorMeta));
    } else if (isInserting) {
      context.missing(_o2_1_errorMeta);
    }
    if (data.containsKey('co2_error')) {
      context.handle(_co2_errorMeta,
          co2_error.isAcceptableOrUnknown(data['co2_error']!, _co2_errorMeta));
    } else if (isInserting) {
      context.missing(_co2_errorMeta);
    }
    if (data.containsKey('air_error')) {
      context.handle(_air_errorMeta,
          air_error.isAcceptableOrUnknown(data['air_error']!, _air_errorMeta));
    } else if (isInserting) {
      context.missing(_air_errorMeta);
    }
    if (data.containsKey('o2_2_error')) {
      context.handle(
          _o2_2_errorMeta,
          o2_2_error.isAcceptableOrUnknown(
              data['o2_2_error']!, _o2_2_errorMeta));
    } else if (isInserting) {
      context.missing(_o2_2_errorMeta);
    }
    if (data.containsKey('vac_error')) {
      context.handle(_vac_errorMeta,
          vac_error.isAcceptableOrUnknown(data['vac_error']!, _vac_errorMeta));
    } else if (isInserting) {
      context.missing(_vac_errorMeta);
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
      LocationID: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}LocationID'])!,
      Temp_min: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}Temp_min'])!,
      Temp_max: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}Temp_max'])!,
      Humi_min: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}Humi_min'])!,
      Humi_max: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}Humi_max'])!,
      O2_1_min: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}O2_1_min'])!,
      O2_1_max: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}O2_1_max'])!,
      n2o_min: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}n2o_min'])!,
      n2o_max: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}n2o_max'])!,
      o2_2_min: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}o2_2_min'])!,
      o2_2_max: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}o2_2_max'])!,
      air_min: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}air_min'])!,
      air_max: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}air_max'])!,
      co2_min: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}co2_min'])!,
      co2_max: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}co2_max'])!,
      vac_min: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}vac_min'])!,
      vac_max: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}vac_max'])!,
      temp_error: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}temp_error'])!,
      n2o_error: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}n2o_error'])!,
      humi_error: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}humi_error'])!,
      o2_1_error: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}o2_1_error'])!,
      co2_error: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}co2_error'])!,
      air_error: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}air_error'])!,
      o2_2_error: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}o2_2_error'])!,
      vac_error: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}vac_error'])!,
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
  final String LocationID;
  final int Temp_min;
  final int Temp_max;
  final int Humi_min;
  final int Humi_max;
  final int O2_1_min;
  final int O2_1_max;
  final int n2o_min;
  final int n2o_max;
  final int o2_2_min;
  final int o2_2_max;
  final int air_min;
  final int air_max;
  final int co2_min;
  final int co2_max;
  final int vac_min;
  final int vac_max;
  final String temp_error;
  final String n2o_error;
  final String humi_error;
  final String o2_1_error;
  final String co2_error;
  final String air_error;
  final String o2_2_error;
  final String vac_error;
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
      required this.LocationID,
      required this.Temp_min,
      required this.Temp_max,
      required this.Humi_min,
      required this.Humi_max,
      required this.O2_1_min,
      required this.O2_1_max,
      required this.n2o_min,
      required this.n2o_max,
      required this.o2_2_min,
      required this.o2_2_max,
      required this.air_min,
      required this.air_max,
      required this.co2_min,
      required this.co2_max,
      required this.vac_min,
      required this.vac_max,
      required this.temp_error,
      required this.n2o_error,
      required this.humi_error,
      required this.o2_1_error,
      required this.co2_error,
      required this.air_error,
      required this.o2_2_error,
      required this.vac_error,
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
    map['LocationID'] = Variable<String>(LocationID);
    map['Temp_min'] = Variable<int>(Temp_min);
    map['Temp_max'] = Variable<int>(Temp_max);
    map['Humi_min'] = Variable<int>(Humi_min);
    map['Humi_max'] = Variable<int>(Humi_max);
    map['O2_1_min'] = Variable<int>(O2_1_min);
    map['O2_1_max'] = Variable<int>(O2_1_max);
    map['n2o_min'] = Variable<int>(n2o_min);
    map['n2o_max'] = Variable<int>(n2o_max);
    map['o2_2_min'] = Variable<int>(o2_2_min);
    map['o2_2_max'] = Variable<int>(o2_2_max);
    map['air_min'] = Variable<int>(air_min);
    map['air_max'] = Variable<int>(air_max);
    map['co2_min'] = Variable<int>(co2_min);
    map['co2_max'] = Variable<int>(co2_max);
    map['vac_min'] = Variable<int>(vac_min);
    map['vac_max'] = Variable<int>(vac_max);
    map['temp_error'] = Variable<String>(temp_error);
    map['n2o_error'] = Variable<String>(n2o_error);
    map['humi_error'] = Variable<String>(humi_error);
    map['o2_1_error'] = Variable<String>(o2_1_error);
    map['co2_error'] = Variable<String>(co2_error);
    map['air_error'] = Variable<String>(air_error);
    map['o2_2_error'] = Variable<String>(o2_2_error);
    map['vac_error'] = Variable<String>(vac_error);
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
      LocationID: Value(LocationID),
      Temp_min: Value(Temp_min),
      Temp_max: Value(Temp_max),
      Humi_min: Value(Humi_min),
      Humi_max: Value(Humi_max),
      O2_1_min: Value(O2_1_min),
      O2_1_max: Value(O2_1_max),
      n2o_min: Value(n2o_min),
      n2o_max: Value(n2o_max),
      o2_2_min: Value(o2_2_min),
      o2_2_max: Value(o2_2_max),
      air_min: Value(air_min),
      air_max: Value(air_max),
      co2_min: Value(co2_min),
      co2_max: Value(co2_max),
      vac_min: Value(vac_min),
      vac_max: Value(vac_max),
      temp_error: Value(temp_error),
      n2o_error: Value(n2o_error),
      humi_error: Value(humi_error),
      o2_1_error: Value(o2_1_error),
      co2_error: Value(co2_error),
      air_error: Value(air_error),
      o2_2_error: Value(o2_2_error),
      vac_error: Value(vac_error),
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
      LocationID: serializer.fromJson<String>(json['LocationID']),
      Temp_min: serializer.fromJson<int>(json['Temp_min']),
      Temp_max: serializer.fromJson<int>(json['Temp_max']),
      Humi_min: serializer.fromJson<int>(json['Humi_min']),
      Humi_max: serializer.fromJson<int>(json['Humi_max']),
      O2_1_min: serializer.fromJson<int>(json['O2_1_min']),
      O2_1_max: serializer.fromJson<int>(json['O2_1_max']),
      n2o_min: serializer.fromJson<int>(json['n2o_min']),
      n2o_max: serializer.fromJson<int>(json['n2o_max']),
      o2_2_min: serializer.fromJson<int>(json['o2_2_min']),
      o2_2_max: serializer.fromJson<int>(json['o2_2_max']),
      air_min: serializer.fromJson<int>(json['air_min']),
      air_max: serializer.fromJson<int>(json['air_max']),
      co2_min: serializer.fromJson<int>(json['co2_min']),
      co2_max: serializer.fromJson<int>(json['co2_max']),
      vac_min: serializer.fromJson<int>(json['vac_min']),
      vac_max: serializer.fromJson<int>(json['vac_max']),
      temp_error: serializer.fromJson<String>(json['temp_error']),
      n2o_error: serializer.fromJson<String>(json['n2o_error']),
      humi_error: serializer.fromJson<String>(json['humi_error']),
      o2_1_error: serializer.fromJson<String>(json['o2_1_error']),
      co2_error: serializer.fromJson<String>(json['co2_error']),
      air_error: serializer.fromJson<String>(json['air_error']),
      o2_2_error: serializer.fromJson<String>(json['o2_2_error']),
      vac_error: serializer.fromJson<String>(json['vac_error']),
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
      'LocationID': serializer.toJson<String>(LocationID),
      'Temp_min': serializer.toJson<int>(Temp_min),
      'Temp_max': serializer.toJson<int>(Temp_max),
      'Humi_min': serializer.toJson<int>(Humi_min),
      'Humi_max': serializer.toJson<int>(Humi_max),
      'O2_1_min': serializer.toJson<int>(O2_1_min),
      'O2_1_max': serializer.toJson<int>(O2_1_max),
      'n2o_min': serializer.toJson<int>(n2o_min),
      'n2o_max': serializer.toJson<int>(n2o_max),
      'o2_2_min': serializer.toJson<int>(o2_2_min),
      'o2_2_max': serializer.toJson<int>(o2_2_max),
      'air_min': serializer.toJson<int>(air_min),
      'air_max': serializer.toJson<int>(air_max),
      'co2_min': serializer.toJson<int>(co2_min),
      'co2_max': serializer.toJson<int>(co2_max),
      'vac_min': serializer.toJson<int>(vac_min),
      'vac_max': serializer.toJson<int>(vac_max),
      'temp_error': serializer.toJson<String>(temp_error),
      'n2o_error': serializer.toJson<String>(n2o_error),
      'humi_error': serializer.toJson<String>(humi_error),
      'o2_1_error': serializer.toJson<String>(o2_1_error),
      'co2_error': serializer.toJson<String>(co2_error),
      'air_error': serializer.toJson<String>(air_error),
      'o2_2_error': serializer.toJson<String>(o2_2_error),
      'vac_error': serializer.toJson<String>(vac_error),
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
          String? LocationID,
          int? Temp_min,
          int? Temp_max,
          int? Humi_min,
          int? Humi_max,
          int? O2_1_min,
          int? O2_1_max,
          int? n2o_min,
          int? n2o_max,
          int? o2_2_min,
          int? o2_2_max,
          int? air_min,
          int? air_max,
          int? co2_min,
          int? co2_max,
          int? vac_min,
          int? vac_max,
          String? temp_error,
          String? n2o_error,
          String? humi_error,
          String? o2_1_error,
          String? co2_error,
          String? air_error,
          String? o2_2_error,
          String? vac_error,
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
        LocationID: LocationID ?? this.LocationID,
        Temp_min: Temp_min ?? this.Temp_min,
        Temp_max: Temp_max ?? this.Temp_max,
        Humi_min: Humi_min ?? this.Humi_min,
        Humi_max: Humi_max ?? this.Humi_max,
        O2_1_min: O2_1_min ?? this.O2_1_min,
        O2_1_max: O2_1_max ?? this.O2_1_max,
        n2o_min: n2o_min ?? this.n2o_min,
        n2o_max: n2o_max ?? this.n2o_max,
        o2_2_min: o2_2_min ?? this.o2_2_min,
        o2_2_max: o2_2_max ?? this.o2_2_max,
        air_min: air_min ?? this.air_min,
        air_max: air_max ?? this.air_max,
        co2_min: co2_min ?? this.co2_min,
        co2_max: co2_max ?? this.co2_max,
        vac_min: vac_min ?? this.vac_min,
        vac_max: vac_max ?? this.vac_max,
        temp_error: temp_error ?? this.temp_error,
        n2o_error: n2o_error ?? this.n2o_error,
        humi_error: humi_error ?? this.humi_error,
        o2_1_error: o2_1_error ?? this.o2_1_error,
        co2_error: co2_error ?? this.co2_error,
        air_error: air_error ?? this.air_error,
        o2_2_error: o2_2_error ?? this.o2_2_error,
        vac_error: vac_error ?? this.vac_error,
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
      LocationID:
          data.LocationID.present ? data.LocationID.value : this.LocationID,
      Temp_min: data.Temp_min.present ? data.Temp_min.value : this.Temp_min,
      Temp_max: data.Temp_max.present ? data.Temp_max.value : this.Temp_max,
      Humi_min: data.Humi_min.present ? data.Humi_min.value : this.Humi_min,
      Humi_max: data.Humi_max.present ? data.Humi_max.value : this.Humi_max,
      O2_1_min: data.O2_1_min.present ? data.O2_1_min.value : this.O2_1_min,
      O2_1_max: data.O2_1_max.present ? data.O2_1_max.value : this.O2_1_max,
      n2o_min: data.n2o_min.present ? data.n2o_min.value : this.n2o_min,
      n2o_max: data.n2o_max.present ? data.n2o_max.value : this.n2o_max,
      o2_2_min: data.o2_2_min.present ? data.o2_2_min.value : this.o2_2_min,
      o2_2_max: data.o2_2_max.present ? data.o2_2_max.value : this.o2_2_max,
      air_min: data.air_min.present ? data.air_min.value : this.air_min,
      air_max: data.air_max.present ? data.air_max.value : this.air_max,
      co2_min: data.co2_min.present ? data.co2_min.value : this.co2_min,
      co2_max: data.co2_max.present ? data.co2_max.value : this.co2_max,
      vac_min: data.vac_min.present ? data.vac_min.value : this.vac_min,
      vac_max: data.vac_max.present ? data.vac_max.value : this.vac_max,
      temp_error:
          data.temp_error.present ? data.temp_error.value : this.temp_error,
      n2o_error: data.n2o_error.present ? data.n2o_error.value : this.n2o_error,
      humi_error:
          data.humi_error.present ? data.humi_error.value : this.humi_error,
      o2_1_error:
          data.o2_1_error.present ? data.o2_1_error.value : this.o2_1_error,
      co2_error: data.co2_error.present ? data.co2_error.value : this.co2_error,
      air_error: data.air_error.present ? data.air_error.value : this.air_error,
      o2_2_error:
          data.o2_2_error.present ? data.o2_2_error.value : this.o2_2_error,
      vac_error: data.vac_error.present ? data.vac_error.value : this.vac_error,
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
          ..write('LocationID: $LocationID, ')
          ..write('Temp_min: $Temp_min, ')
          ..write('Temp_max: $Temp_max, ')
          ..write('Humi_min: $Humi_min, ')
          ..write('Humi_max: $Humi_max, ')
          ..write('O2_1_min: $O2_1_min, ')
          ..write('O2_1_max: $O2_1_max, ')
          ..write('n2o_min: $n2o_min, ')
          ..write('n2o_max: $n2o_max, ')
          ..write('o2_2_min: $o2_2_min, ')
          ..write('o2_2_max: $o2_2_max, ')
          ..write('air_min: $air_min, ')
          ..write('air_max: $air_max, ')
          ..write('co2_min: $co2_min, ')
          ..write('co2_max: $co2_max, ')
          ..write('vac_min: $vac_min, ')
          ..write('vac_max: $vac_max, ')
          ..write('temp_error: $temp_error, ')
          ..write('n2o_error: $n2o_error, ')
          ..write('humi_error: $humi_error, ')
          ..write('o2_1_error: $o2_1_error, ')
          ..write('co2_error: $co2_error, ')
          ..write('air_error: $air_error, ')
          ..write('o2_2_error: $o2_2_error, ')
          ..write('vac_error: $vac_error, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
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
        LocationID,
        Temp_min,
        Temp_max,
        Humi_min,
        Humi_max,
        O2_1_min,
        O2_1_max,
        n2o_min,
        n2o_max,
        o2_2_min,
        o2_2_max,
        air_min,
        air_max,
        co2_min,
        co2_max,
        vac_min,
        vac_max,
        temp_error,
        n2o_error,
        humi_error,
        o2_1_error,
        co2_error,
        air_error,
        o2_2_error,
        vac_error,
        recordedAt
      ]);
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
          other.LocationID == this.LocationID &&
          other.Temp_min == this.Temp_min &&
          other.Temp_max == this.Temp_max &&
          other.Humi_min == this.Humi_min &&
          other.Humi_max == this.Humi_max &&
          other.O2_1_min == this.O2_1_min &&
          other.O2_1_max == this.O2_1_max &&
          other.n2o_min == this.n2o_min &&
          other.n2o_max == this.n2o_max &&
          other.o2_2_min == this.o2_2_min &&
          other.o2_2_max == this.o2_2_max &&
          other.air_min == this.air_min &&
          other.air_max == this.air_max &&
          other.co2_min == this.co2_min &&
          other.co2_max == this.co2_max &&
          other.vac_min == this.vac_min &&
          other.vac_max == this.vac_max &&
          other.temp_error == this.temp_error &&
          other.n2o_error == this.n2o_error &&
          other.humi_error == this.humi_error &&
          other.o2_1_error == this.o2_1_error &&
          other.co2_error == this.co2_error &&
          other.air_error == this.air_error &&
          other.o2_2_error == this.o2_2_error &&
          other.vac_error == this.vac_error &&
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
  final Value<String> LocationID;
  final Value<int> Temp_min;
  final Value<int> Temp_max;
  final Value<int> Humi_min;
  final Value<int> Humi_max;
  final Value<int> O2_1_min;
  final Value<int> O2_1_max;
  final Value<int> n2o_min;
  final Value<int> n2o_max;
  final Value<int> o2_2_min;
  final Value<int> o2_2_max;
  final Value<int> air_min;
  final Value<int> air_max;
  final Value<int> co2_min;
  final Value<int> co2_max;
  final Value<int> vac_min;
  final Value<int> vac_max;
  final Value<String> temp_error;
  final Value<String> n2o_error;
  final Value<String> humi_error;
  final Value<String> o2_1_error;
  final Value<String> co2_error;
  final Value<String> air_error;
  final Value<String> o2_2_error;
  final Value<String> vac_error;
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
    this.LocationID = const Value.absent(),
    this.Temp_min = const Value.absent(),
    this.Temp_max = const Value.absent(),
    this.Humi_min = const Value.absent(),
    this.Humi_max = const Value.absent(),
    this.O2_1_min = const Value.absent(),
    this.O2_1_max = const Value.absent(),
    this.n2o_min = const Value.absent(),
    this.n2o_max = const Value.absent(),
    this.o2_2_min = const Value.absent(),
    this.o2_2_max = const Value.absent(),
    this.air_min = const Value.absent(),
    this.air_max = const Value.absent(),
    this.co2_min = const Value.absent(),
    this.co2_max = const Value.absent(),
    this.vac_min = const Value.absent(),
    this.vac_max = const Value.absent(),
    this.temp_error = const Value.absent(),
    this.n2o_error = const Value.absent(),
    this.humi_error = const Value.absent(),
    this.o2_1_error = const Value.absent(),
    this.co2_error = const Value.absent(),
    this.air_error = const Value.absent(),
    this.o2_2_error = const Value.absent(),
    this.vac_error = const Value.absent(),
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
    required String LocationID,
    required int Temp_min,
    required int Temp_max,
    required int Humi_min,
    required int Humi_max,
    required int O2_1_min,
    required int O2_1_max,
    required int n2o_min,
    required int n2o_max,
    required int o2_2_min,
    required int o2_2_max,
    required int air_min,
    required int air_max,
    required int co2_min,
    required int co2_max,
    required int vac_min,
    required int vac_max,
    required String temp_error,
    required String n2o_error,
    required String humi_error,
    required String o2_1_error,
    required String co2_error,
    required String air_error,
    required String o2_2_error,
    required String vac_error,
    this.recordedAt = const Value.absent(),
  })  : temperature = Value(temperature),
        humidity = Value(humidity),
        o2 = Value(o2),
        vac = Value(vac),
        n2o = Value(n2o),
        airPressure = Value(airPressure),
        co2 = Value(co2),
        o22 = Value(o22),
        DeviceNo = Value(DeviceNo),
        LocationID = Value(LocationID),
        Temp_min = Value(Temp_min),
        Temp_max = Value(Temp_max),
        Humi_min = Value(Humi_min),
        Humi_max = Value(Humi_max),
        O2_1_min = Value(O2_1_min),
        O2_1_max = Value(O2_1_max),
        n2o_min = Value(n2o_min),
        n2o_max = Value(n2o_max),
        o2_2_min = Value(o2_2_min),
        o2_2_max = Value(o2_2_max),
        air_min = Value(air_min),
        air_max = Value(air_max),
        co2_min = Value(co2_min),
        co2_max = Value(co2_max),
        vac_min = Value(vac_min),
        vac_max = Value(vac_max),
        temp_error = Value(temp_error),
        n2o_error = Value(n2o_error),
        humi_error = Value(humi_error),
        o2_1_error = Value(o2_1_error),
        co2_error = Value(co2_error),
        air_error = Value(air_error),
        o2_2_error = Value(o2_2_error),
        vac_error = Value(vac_error);
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
    Expression<String>? LocationID,
    Expression<int>? Temp_min,
    Expression<int>? Temp_max,
    Expression<int>? Humi_min,
    Expression<int>? Humi_max,
    Expression<int>? O2_1_min,
    Expression<int>? O2_1_max,
    Expression<int>? n2o_min,
    Expression<int>? n2o_max,
    Expression<int>? o2_2_min,
    Expression<int>? o2_2_max,
    Expression<int>? air_min,
    Expression<int>? air_max,
    Expression<int>? co2_min,
    Expression<int>? co2_max,
    Expression<int>? vac_min,
    Expression<int>? vac_max,
    Expression<String>? temp_error,
    Expression<String>? n2o_error,
    Expression<String>? humi_error,
    Expression<String>? o2_1_error,
    Expression<String>? co2_error,
    Expression<String>? air_error,
    Expression<String>? o2_2_error,
    Expression<String>? vac_error,
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
      if (LocationID != null) 'LocationID': LocationID,
      if (Temp_min != null) 'Temp_min': Temp_min,
      if (Temp_max != null) 'Temp_max': Temp_max,
      if (Humi_min != null) 'Humi_min': Humi_min,
      if (Humi_max != null) 'Humi_max': Humi_max,
      if (O2_1_min != null) 'O2_1_min': O2_1_min,
      if (O2_1_max != null) 'O2_1_max': O2_1_max,
      if (n2o_min != null) 'n2o_min': n2o_min,
      if (n2o_max != null) 'n2o_max': n2o_max,
      if (o2_2_min != null) 'o2_2_min': o2_2_min,
      if (o2_2_max != null) 'o2_2_max': o2_2_max,
      if (air_min != null) 'air_min': air_min,
      if (air_max != null) 'air_max': air_max,
      if (co2_min != null) 'co2_min': co2_min,
      if (co2_max != null) 'co2_max': co2_max,
      if (vac_min != null) 'vac_min': vac_min,
      if (vac_max != null) 'vac_max': vac_max,
      if (temp_error != null) 'temp_error': temp_error,
      if (n2o_error != null) 'n2o_error': n2o_error,
      if (humi_error != null) 'humi_error': humi_error,
      if (o2_1_error != null) 'o2_1_error': o2_1_error,
      if (co2_error != null) 'co2_error': co2_error,
      if (air_error != null) 'air_error': air_error,
      if (o2_2_error != null) 'o2_2_error': o2_2_error,
      if (vac_error != null) 'vac_error': vac_error,
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
      Value<String>? LocationID,
      Value<int>? Temp_min,
      Value<int>? Temp_max,
      Value<int>? Humi_min,
      Value<int>? Humi_max,
      Value<int>? O2_1_min,
      Value<int>? O2_1_max,
      Value<int>? n2o_min,
      Value<int>? n2o_max,
      Value<int>? o2_2_min,
      Value<int>? o2_2_max,
      Value<int>? air_min,
      Value<int>? air_max,
      Value<int>? co2_min,
      Value<int>? co2_max,
      Value<int>? vac_min,
      Value<int>? vac_max,
      Value<String>? temp_error,
      Value<String>? n2o_error,
      Value<String>? humi_error,
      Value<String>? o2_1_error,
      Value<String>? co2_error,
      Value<String>? air_error,
      Value<String>? o2_2_error,
      Value<String>? vac_error,
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
      LocationID: LocationID ?? this.LocationID,
      Temp_min: Temp_min ?? this.Temp_min,
      Temp_max: Temp_max ?? this.Temp_max,
      Humi_min: Humi_min ?? this.Humi_min,
      Humi_max: Humi_max ?? this.Humi_max,
      O2_1_min: O2_1_min ?? this.O2_1_min,
      O2_1_max: O2_1_max ?? this.O2_1_max,
      n2o_min: n2o_min ?? this.n2o_min,
      n2o_max: n2o_max ?? this.n2o_max,
      o2_2_min: o2_2_min ?? this.o2_2_min,
      o2_2_max: o2_2_max ?? this.o2_2_max,
      air_min: air_min ?? this.air_min,
      air_max: air_max ?? this.air_max,
      co2_min: co2_min ?? this.co2_min,
      co2_max: co2_max ?? this.co2_max,
      vac_min: vac_min ?? this.vac_min,
      vac_max: vac_max ?? this.vac_max,
      temp_error: temp_error ?? this.temp_error,
      n2o_error: n2o_error ?? this.n2o_error,
      humi_error: humi_error ?? this.humi_error,
      o2_1_error: o2_1_error ?? this.o2_1_error,
      co2_error: co2_error ?? this.co2_error,
      air_error: air_error ?? this.air_error,
      o2_2_error: o2_2_error ?? this.o2_2_error,
      vac_error: vac_error ?? this.vac_error,
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
    if (LocationID.present) {
      map['LocationID'] = Variable<String>(LocationID.value);
    }
    if (Temp_min.present) {
      map['Temp_min'] = Variable<int>(Temp_min.value);
    }
    if (Temp_max.present) {
      map['Temp_max'] = Variable<int>(Temp_max.value);
    }
    if (Humi_min.present) {
      map['Humi_min'] = Variable<int>(Humi_min.value);
    }
    if (Humi_max.present) {
      map['Humi_max'] = Variable<int>(Humi_max.value);
    }
    if (O2_1_min.present) {
      map['O2_1_min'] = Variable<int>(O2_1_min.value);
    }
    if (O2_1_max.present) {
      map['O2_1_max'] = Variable<int>(O2_1_max.value);
    }
    if (n2o_min.present) {
      map['n2o_min'] = Variable<int>(n2o_min.value);
    }
    if (n2o_max.present) {
      map['n2o_max'] = Variable<int>(n2o_max.value);
    }
    if (o2_2_min.present) {
      map['o2_2_min'] = Variable<int>(o2_2_min.value);
    }
    if (o2_2_max.present) {
      map['o2_2_max'] = Variable<int>(o2_2_max.value);
    }
    if (air_min.present) {
      map['air_min'] = Variable<int>(air_min.value);
    }
    if (air_max.present) {
      map['air_max'] = Variable<int>(air_max.value);
    }
    if (co2_min.present) {
      map['co2_min'] = Variable<int>(co2_min.value);
    }
    if (co2_max.present) {
      map['co2_max'] = Variable<int>(co2_max.value);
    }
    if (vac_min.present) {
      map['vac_min'] = Variable<int>(vac_min.value);
    }
    if (vac_max.present) {
      map['vac_max'] = Variable<int>(vac_max.value);
    }
    if (temp_error.present) {
      map['temp_error'] = Variable<String>(temp_error.value);
    }
    if (n2o_error.present) {
      map['n2o_error'] = Variable<String>(n2o_error.value);
    }
    if (humi_error.present) {
      map['humi_error'] = Variable<String>(humi_error.value);
    }
    if (o2_1_error.present) {
      map['o2_1_error'] = Variable<String>(o2_1_error.value);
    }
    if (co2_error.present) {
      map['co2_error'] = Variable<String>(co2_error.value);
    }
    if (air_error.present) {
      map['air_error'] = Variable<String>(air_error.value);
    }
    if (o2_2_error.present) {
      map['o2_2_error'] = Variable<String>(o2_2_error.value);
    }
    if (vac_error.present) {
      map['vac_error'] = Variable<String>(vac_error.value);
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
          ..write('LocationID: $LocationID, ')
          ..write('Temp_min: $Temp_min, ')
          ..write('Temp_max: $Temp_max, ')
          ..write('Humi_min: $Humi_min, ')
          ..write('Humi_max: $Humi_max, ')
          ..write('O2_1_min: $O2_1_min, ')
          ..write('O2_1_max: $O2_1_max, ')
          ..write('n2o_min: $n2o_min, ')
          ..write('n2o_max: $n2o_max, ')
          ..write('o2_2_min: $o2_2_min, ')
          ..write('o2_2_max: $o2_2_max, ')
          ..write('air_min: $air_min, ')
          ..write('air_max: $air_max, ')
          ..write('co2_min: $co2_min, ')
          ..write('co2_max: $co2_max, ')
          ..write('vac_min: $vac_min, ')
          ..write('vac_max: $vac_max, ')
          ..write('temp_error: $temp_error, ')
          ..write('n2o_error: $n2o_error, ')
          ..write('humi_error: $humi_error, ')
          ..write('o2_1_error: $o2_1_error, ')
          ..write('co2_error: $co2_error, ')
          ..write('air_error: $air_error, ')
          ..write('o2_2_error: $o2_2_error, ')
          ..write('vac_error: $vac_error, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }
}

class $ErrorTableTable extends ErrorTable
    with TableInfo<$ErrorTableTable, ErrorTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ErrorTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _DeviceNoMeta =
      const VerificationMeta('DeviceNo');
  @override
  late final GeneratedColumn<String> DeviceNo = GeneratedColumn<String>(
      'DeviceNo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _parameterMeta =
      const VerificationMeta('parameter');
  @override
  late final GeneratedColumn<String> parameter = GeneratedColumn<String>(
      'parameter', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _logValueMeta =
      const VerificationMeta('logValue');
  @override
  late final GeneratedColumn<String> logValue = GeneratedColumn<String>(
      'log_value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _minValueMeta =
      const VerificationMeta('minValue');
  @override
  late final GeneratedColumn<int> minValue = GeneratedColumn<int>(
      'min_value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _maxValueMeta =
      const VerificationMeta('maxValue');
  @override
  late final GeneratedColumn<int> maxValue = GeneratedColumn<int>(
      'max_value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
      'value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _recordedAtMeta =
      const VerificationMeta('recordedAt');
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
      'recorded_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        DeviceNo,
        parameter,
        logValue,
        minValue,
        maxValue,
        value,
        recordedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'error_table';
  @override
  VerificationContext validateIntegrity(Insertable<ErrorTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('DeviceNo')) {
      context.handle(_DeviceNoMeta,
          DeviceNo.isAcceptableOrUnknown(data['DeviceNo']!, _DeviceNoMeta));
    } else if (isInserting) {
      context.missing(_DeviceNoMeta);
    }
    if (data.containsKey('parameter')) {
      context.handle(_parameterMeta,
          parameter.isAcceptableOrUnknown(data['parameter']!, _parameterMeta));
    } else if (isInserting) {
      context.missing(_parameterMeta);
    }
    if (data.containsKey('log_value')) {
      context.handle(_logValueMeta,
          logValue.isAcceptableOrUnknown(data['log_value']!, _logValueMeta));
    } else if (isInserting) {
      context.missing(_logValueMeta);
    }
    if (data.containsKey('min_value')) {
      context.handle(_minValueMeta,
          minValue.isAcceptableOrUnknown(data['min_value']!, _minValueMeta));
    } else if (isInserting) {
      context.missing(_minValueMeta);
    }
    if (data.containsKey('max_value')) {
      context.handle(_maxValueMeta,
          maxValue.isAcceptableOrUnknown(data['max_value']!, _maxValueMeta));
    } else if (isInserting) {
      context.missing(_maxValueMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
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
  ErrorTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ErrorTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      DeviceNo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}DeviceNo'])!,
      parameter: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parameter'])!,
      logValue: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}log_value'])!,
      minValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}min_value'])!,
      maxValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_value'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}value'])!,
      recordedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}recorded_at']),
    );
  }

  @override
  $ErrorTableTable createAlias(String alias) {
    return $ErrorTableTable(attachedDatabase, alias);
  }
}

class ErrorTableData extends DataClass implements Insertable<ErrorTableData> {
  final int id;
  final String DeviceNo;
  final String parameter;
  final String logValue;
  final int minValue;
  final int maxValue;
  final int value;
  final DateTime? recordedAt;
  const ErrorTableData(
      {required this.id,
      required this.DeviceNo,
      required this.parameter,
      required this.logValue,
      required this.minValue,
      required this.maxValue,
      required this.value,
      this.recordedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['DeviceNo'] = Variable<String>(DeviceNo);
    map['parameter'] = Variable<String>(parameter);
    map['log_value'] = Variable<String>(logValue);
    map['min_value'] = Variable<int>(minValue);
    map['max_value'] = Variable<int>(maxValue);
    map['value'] = Variable<int>(value);
    if (!nullToAbsent || recordedAt != null) {
      map['recorded_at'] = Variable<DateTime>(recordedAt);
    }
    return map;
  }

  ErrorTableCompanion toCompanion(bool nullToAbsent) {
    return ErrorTableCompanion(
      id: Value(id),
      DeviceNo: Value(DeviceNo),
      parameter: Value(parameter),
      logValue: Value(logValue),
      minValue: Value(minValue),
      maxValue: Value(maxValue),
      value: Value(value),
      recordedAt: recordedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(recordedAt),
    );
  }

  factory ErrorTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ErrorTableData(
      id: serializer.fromJson<int>(json['id']),
      DeviceNo: serializer.fromJson<String>(json['DeviceNo']),
      parameter: serializer.fromJson<String>(json['parameter']),
      logValue: serializer.fromJson<String>(json['logValue']),
      minValue: serializer.fromJson<int>(json['minValue']),
      maxValue: serializer.fromJson<int>(json['maxValue']),
      value: serializer.fromJson<int>(json['value']),
      recordedAt: serializer.fromJson<DateTime?>(json['recordedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'DeviceNo': serializer.toJson<String>(DeviceNo),
      'parameter': serializer.toJson<String>(parameter),
      'logValue': serializer.toJson<String>(logValue),
      'minValue': serializer.toJson<int>(minValue),
      'maxValue': serializer.toJson<int>(maxValue),
      'value': serializer.toJson<int>(value),
      'recordedAt': serializer.toJson<DateTime?>(recordedAt),
    };
  }

  ErrorTableData copyWith(
          {int? id,
          String? DeviceNo,
          String? parameter,
          String? logValue,
          int? minValue,
          int? maxValue,
          int? value,
          Value<DateTime?> recordedAt = const Value.absent()}) =>
      ErrorTableData(
        id: id ?? this.id,
        DeviceNo: DeviceNo ?? this.DeviceNo,
        parameter: parameter ?? this.parameter,
        logValue: logValue ?? this.logValue,
        minValue: minValue ?? this.minValue,
        maxValue: maxValue ?? this.maxValue,
        value: value ?? this.value,
        recordedAt: recordedAt.present ? recordedAt.value : this.recordedAt,
      );
  ErrorTableData copyWithCompanion(ErrorTableCompanion data) {
    return ErrorTableData(
      id: data.id.present ? data.id.value : this.id,
      DeviceNo: data.DeviceNo.present ? data.DeviceNo.value : this.DeviceNo,
      parameter: data.parameter.present ? data.parameter.value : this.parameter,
      logValue: data.logValue.present ? data.logValue.value : this.logValue,
      minValue: data.minValue.present ? data.minValue.value : this.minValue,
      maxValue: data.maxValue.present ? data.maxValue.value : this.maxValue,
      value: data.value.present ? data.value.value : this.value,
      recordedAt:
          data.recordedAt.present ? data.recordedAt.value : this.recordedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ErrorTableData(')
          ..write('id: $id, ')
          ..write('DeviceNo: $DeviceNo, ')
          ..write('parameter: $parameter, ')
          ..write('logValue: $logValue, ')
          ..write('minValue: $minValue, ')
          ..write('maxValue: $maxValue, ')
          ..write('value: $value, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, DeviceNo, parameter, logValue, minValue, maxValue, value, recordedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ErrorTableData &&
          other.id == this.id &&
          other.DeviceNo == this.DeviceNo &&
          other.parameter == this.parameter &&
          other.logValue == this.logValue &&
          other.minValue == this.minValue &&
          other.maxValue == this.maxValue &&
          other.value == this.value &&
          other.recordedAt == this.recordedAt);
}

class ErrorTableCompanion extends UpdateCompanion<ErrorTableData> {
  final Value<int> id;
  final Value<String> DeviceNo;
  final Value<String> parameter;
  final Value<String> logValue;
  final Value<int> minValue;
  final Value<int> maxValue;
  final Value<int> value;
  final Value<DateTime?> recordedAt;
  const ErrorTableCompanion({
    this.id = const Value.absent(),
    this.DeviceNo = const Value.absent(),
    this.parameter = const Value.absent(),
    this.logValue = const Value.absent(),
    this.minValue = const Value.absent(),
    this.maxValue = const Value.absent(),
    this.value = const Value.absent(),
    this.recordedAt = const Value.absent(),
  });
  ErrorTableCompanion.insert({
    this.id = const Value.absent(),
    required String DeviceNo,
    required String parameter,
    required String logValue,
    required int minValue,
    required int maxValue,
    required int value,
    this.recordedAt = const Value.absent(),
  })  : DeviceNo = Value(DeviceNo),
        parameter = Value(parameter),
        logValue = Value(logValue),
        minValue = Value(minValue),
        maxValue = Value(maxValue),
        value = Value(value);
  static Insertable<ErrorTableData> custom({
    Expression<int>? id,
    Expression<String>? DeviceNo,
    Expression<String>? parameter,
    Expression<String>? logValue,
    Expression<int>? minValue,
    Expression<int>? maxValue,
    Expression<int>? value,
    Expression<DateTime>? recordedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (DeviceNo != null) 'DeviceNo': DeviceNo,
      if (parameter != null) 'parameter': parameter,
      if (logValue != null) 'log_value': logValue,
      if (minValue != null) 'min_value': minValue,
      if (maxValue != null) 'max_value': maxValue,
      if (value != null) 'value': value,
      if (recordedAt != null) 'recorded_at': recordedAt,
    });
  }

  ErrorTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? DeviceNo,
      Value<String>? parameter,
      Value<String>? logValue,
      Value<int>? minValue,
      Value<int>? maxValue,
      Value<int>? value,
      Value<DateTime?>? recordedAt}) {
    return ErrorTableCompanion(
      id: id ?? this.id,
      DeviceNo: DeviceNo ?? this.DeviceNo,
      parameter: parameter ?? this.parameter,
      logValue: logValue ?? this.logValue,
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
      value: value ?? this.value,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (DeviceNo.present) {
      map['DeviceNo'] = Variable<String>(DeviceNo.value);
    }
    if (parameter.present) {
      map['parameter'] = Variable<String>(parameter.value);
    }
    if (logValue.present) {
      map['log_value'] = Variable<String>(logValue.value);
    }
    if (minValue.present) {
      map['min_value'] = Variable<int>(minValue.value);
    }
    if (maxValue.present) {
      map['max_value'] = Variable<int>(maxValue.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ErrorTableCompanion(')
          ..write('id: $id, ')
          ..write('DeviceNo: $DeviceNo, ')
          ..write('parameter: $parameter, ')
          ..write('logValue: $logValue, ')
          ..write('minValue: $minValue, ')
          ..write('maxValue: $maxValue, ')
          ..write('value: $value, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$PressDataDb extends GeneratedDatabase {
  _$PressDataDb(QueryExecutor e) : super(e);
  $PressDataDbManager get managers => $PressDataDbManager(this);
  late final $PressDataTableTable pressDataTable = $PressDataTableTable(this);
  late final $ErrorTableTable errorTable = $ErrorTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [pressDataTable, errorTable];
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
  required String LocationID,
  required int Temp_min,
  required int Temp_max,
  required int Humi_min,
  required int Humi_max,
  required int O2_1_min,
  required int O2_1_max,
  required int n2o_min,
  required int n2o_max,
  required int o2_2_min,
  required int o2_2_max,
  required int air_min,
  required int air_max,
  required int co2_min,
  required int co2_max,
  required int vac_min,
  required int vac_max,
  required String temp_error,
  required String n2o_error,
  required String humi_error,
  required String o2_1_error,
  required String co2_error,
  required String air_error,
  required String o2_2_error,
  required String vac_error,
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
  Value<String> LocationID,
  Value<int> Temp_min,
  Value<int> Temp_max,
  Value<int> Humi_min,
  Value<int> Humi_max,
  Value<int> O2_1_min,
  Value<int> O2_1_max,
  Value<int> n2o_min,
  Value<int> n2o_max,
  Value<int> o2_2_min,
  Value<int> o2_2_max,
  Value<int> air_min,
  Value<int> air_max,
  Value<int> co2_min,
  Value<int> co2_max,
  Value<int> vac_min,
  Value<int> vac_max,
  Value<String> temp_error,
  Value<String> n2o_error,
  Value<String> humi_error,
  Value<String> o2_1_error,
  Value<String> co2_error,
  Value<String> air_error,
  Value<String> o2_2_error,
  Value<String> vac_error,
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
            Value<String> LocationID = const Value.absent(),
            Value<int> Temp_min = const Value.absent(),
            Value<int> Temp_max = const Value.absent(),
            Value<int> Humi_min = const Value.absent(),
            Value<int> Humi_max = const Value.absent(),
            Value<int> O2_1_min = const Value.absent(),
            Value<int> O2_1_max = const Value.absent(),
            Value<int> n2o_min = const Value.absent(),
            Value<int> n2o_max = const Value.absent(),
            Value<int> o2_2_min = const Value.absent(),
            Value<int> o2_2_max = const Value.absent(),
            Value<int> air_min = const Value.absent(),
            Value<int> air_max = const Value.absent(),
            Value<int> co2_min = const Value.absent(),
            Value<int> co2_max = const Value.absent(),
            Value<int> vac_min = const Value.absent(),
            Value<int> vac_max = const Value.absent(),
            Value<String> temp_error = const Value.absent(),
            Value<String> n2o_error = const Value.absent(),
            Value<String> humi_error = const Value.absent(),
            Value<String> o2_1_error = const Value.absent(),
            Value<String> co2_error = const Value.absent(),
            Value<String> air_error = const Value.absent(),
            Value<String> o2_2_error = const Value.absent(),
            Value<String> vac_error = const Value.absent(),
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
            LocationID: LocationID,
            Temp_min: Temp_min,
            Temp_max: Temp_max,
            Humi_min: Humi_min,
            Humi_max: Humi_max,
            O2_1_min: O2_1_min,
            O2_1_max: O2_1_max,
            n2o_min: n2o_min,
            n2o_max: n2o_max,
            o2_2_min: o2_2_min,
            o2_2_max: o2_2_max,
            air_min: air_min,
            air_max: air_max,
            co2_min: co2_min,
            co2_max: co2_max,
            vac_min: vac_min,
            vac_max: vac_max,
            temp_error: temp_error,
            n2o_error: n2o_error,
            humi_error: humi_error,
            o2_1_error: o2_1_error,
            co2_error: co2_error,
            air_error: air_error,
            o2_2_error: o2_2_error,
            vac_error: vac_error,
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
            required String LocationID,
            required int Temp_min,
            required int Temp_max,
            required int Humi_min,
            required int Humi_max,
            required int O2_1_min,
            required int O2_1_max,
            required int n2o_min,
            required int n2o_max,
            required int o2_2_min,
            required int o2_2_max,
            required int air_min,
            required int air_max,
            required int co2_min,
            required int co2_max,
            required int vac_min,
            required int vac_max,
            required String temp_error,
            required String n2o_error,
            required String humi_error,
            required String o2_1_error,
            required String co2_error,
            required String air_error,
            required String o2_2_error,
            required String vac_error,
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
            LocationID: LocationID,
            Temp_min: Temp_min,
            Temp_max: Temp_max,
            Humi_min: Humi_min,
            Humi_max: Humi_max,
            O2_1_min: O2_1_min,
            O2_1_max: O2_1_max,
            n2o_min: n2o_min,
            n2o_max: n2o_max,
            o2_2_min: o2_2_min,
            o2_2_max: o2_2_max,
            air_min: air_min,
            air_max: air_max,
            co2_min: co2_min,
            co2_max: co2_max,
            vac_min: vac_min,
            vac_max: vac_max,
            temp_error: temp_error,
            n2o_error: n2o_error,
            humi_error: humi_error,
            o2_1_error: o2_1_error,
            co2_error: co2_error,
            air_error: air_error,
            o2_2_error: o2_2_error,
            vac_error: vac_error,
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

  ColumnFilters<String> get LocationID => $state.composableBuilder(
      column: $state.table.LocationID,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get Temp_min => $state.composableBuilder(
      column: $state.table.Temp_min,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get Temp_max => $state.composableBuilder(
      column: $state.table.Temp_max,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get Humi_min => $state.composableBuilder(
      column: $state.table.Humi_min,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get Humi_max => $state.composableBuilder(
      column: $state.table.Humi_max,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get O2_1_min => $state.composableBuilder(
      column: $state.table.O2_1_min,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get O2_1_max => $state.composableBuilder(
      column: $state.table.O2_1_max,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get n2o_min => $state.composableBuilder(
      column: $state.table.n2o_min,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get n2o_max => $state.composableBuilder(
      column: $state.table.n2o_max,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get o2_2_min => $state.composableBuilder(
      column: $state.table.o2_2_min,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get o2_2_max => $state.composableBuilder(
      column: $state.table.o2_2_max,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get air_min => $state.composableBuilder(
      column: $state.table.air_min,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get air_max => $state.composableBuilder(
      column: $state.table.air_max,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get co2_min => $state.composableBuilder(
      column: $state.table.co2_min,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get co2_max => $state.composableBuilder(
      column: $state.table.co2_max,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get vac_min => $state.composableBuilder(
      column: $state.table.vac_min,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get vac_max => $state.composableBuilder(
      column: $state.table.vac_max,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get temp_error => $state.composableBuilder(
      column: $state.table.temp_error,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get n2o_error => $state.composableBuilder(
      column: $state.table.n2o_error,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get humi_error => $state.composableBuilder(
      column: $state.table.humi_error,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get o2_1_error => $state.composableBuilder(
      column: $state.table.o2_1_error,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get co2_error => $state.composableBuilder(
      column: $state.table.co2_error,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get air_error => $state.composableBuilder(
      column: $state.table.air_error,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get o2_2_error => $state.composableBuilder(
      column: $state.table.o2_2_error,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get vac_error => $state.composableBuilder(
      column: $state.table.vac_error,
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

  ColumnOrderings<String> get LocationID => $state.composableBuilder(
      column: $state.table.LocationID,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get Temp_min => $state.composableBuilder(
      column: $state.table.Temp_min,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get Temp_max => $state.composableBuilder(
      column: $state.table.Temp_max,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get Humi_min => $state.composableBuilder(
      column: $state.table.Humi_min,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get Humi_max => $state.composableBuilder(
      column: $state.table.Humi_max,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get O2_1_min => $state.composableBuilder(
      column: $state.table.O2_1_min,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get O2_1_max => $state.composableBuilder(
      column: $state.table.O2_1_max,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get n2o_min => $state.composableBuilder(
      column: $state.table.n2o_min,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get n2o_max => $state.composableBuilder(
      column: $state.table.n2o_max,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get o2_2_min => $state.composableBuilder(
      column: $state.table.o2_2_min,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get o2_2_max => $state.composableBuilder(
      column: $state.table.o2_2_max,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get air_min => $state.composableBuilder(
      column: $state.table.air_min,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get air_max => $state.composableBuilder(
      column: $state.table.air_max,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get co2_min => $state.composableBuilder(
      column: $state.table.co2_min,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get co2_max => $state.composableBuilder(
      column: $state.table.co2_max,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get vac_min => $state.composableBuilder(
      column: $state.table.vac_min,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get vac_max => $state.composableBuilder(
      column: $state.table.vac_max,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get temp_error => $state.composableBuilder(
      column: $state.table.temp_error,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get n2o_error => $state.composableBuilder(
      column: $state.table.n2o_error,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get humi_error => $state.composableBuilder(
      column: $state.table.humi_error,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get o2_1_error => $state.composableBuilder(
      column: $state.table.o2_1_error,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get co2_error => $state.composableBuilder(
      column: $state.table.co2_error,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get air_error => $state.composableBuilder(
      column: $state.table.air_error,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get o2_2_error => $state.composableBuilder(
      column: $state.table.o2_2_error,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get vac_error => $state.composableBuilder(
      column: $state.table.vac_error,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get recordedAt => $state.composableBuilder(
      column: $state.table.recordedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$ErrorTableTableCreateCompanionBuilder = ErrorTableCompanion Function({
  Value<int> id,
  required String DeviceNo,
  required String parameter,
  required String logValue,
  required int minValue,
  required int maxValue,
  required int value,
  Value<DateTime?> recordedAt,
});
typedef $$ErrorTableTableUpdateCompanionBuilder = ErrorTableCompanion Function({
  Value<int> id,
  Value<String> DeviceNo,
  Value<String> parameter,
  Value<String> logValue,
  Value<int> minValue,
  Value<int> maxValue,
  Value<int> value,
  Value<DateTime?> recordedAt,
});

class $$ErrorTableTableTableManager extends RootTableManager<
    _$PressDataDb,
    $ErrorTableTable,
    ErrorTableData,
    $$ErrorTableTableFilterComposer,
    $$ErrorTableTableOrderingComposer,
    $$ErrorTableTableCreateCompanionBuilder,
    $$ErrorTableTableUpdateCompanionBuilder> {
  $$ErrorTableTableTableManager(_$PressDataDb db, $ErrorTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ErrorTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ErrorTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> DeviceNo = const Value.absent(),
            Value<String> parameter = const Value.absent(),
            Value<String> logValue = const Value.absent(),
            Value<int> minValue = const Value.absent(),
            Value<int> maxValue = const Value.absent(),
            Value<int> value = const Value.absent(),
            Value<DateTime?> recordedAt = const Value.absent(),
          }) =>
              ErrorTableCompanion(
            id: id,
            DeviceNo: DeviceNo,
            parameter: parameter,
            logValue: logValue,
            minValue: minValue,
            maxValue: maxValue,
            value: value,
            recordedAt: recordedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String DeviceNo,
            required String parameter,
            required String logValue,
            required int minValue,
            required int maxValue,
            required int value,
            Value<DateTime?> recordedAt = const Value.absent(),
          }) =>
              ErrorTableCompanion.insert(
            id: id,
            DeviceNo: DeviceNo,
            parameter: parameter,
            logValue: logValue,
            minValue: minValue,
            maxValue: maxValue,
            value: value,
            recordedAt: recordedAt,
          ),
        ));
}

class $$ErrorTableTableFilterComposer
    extends FilterComposer<_$PressDataDb, $ErrorTableTable> {
  $$ErrorTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get DeviceNo => $state.composableBuilder(
      column: $state.table.DeviceNo,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get parameter => $state.composableBuilder(
      column: $state.table.parameter,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get logValue => $state.composableBuilder(
      column: $state.table.logValue,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get minValue => $state.composableBuilder(
      column: $state.table.minValue,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get maxValue => $state.composableBuilder(
      column: $state.table.maxValue,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get recordedAt => $state.composableBuilder(
      column: $state.table.recordedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$ErrorTableTableOrderingComposer
    extends OrderingComposer<_$PressDataDb, $ErrorTableTable> {
  $$ErrorTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get DeviceNo => $state.composableBuilder(
      column: $state.table.DeviceNo,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get parameter => $state.composableBuilder(
      column: $state.table.parameter,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get logValue => $state.composableBuilder(
      column: $state.table.logValue,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get minValue => $state.composableBuilder(
      column: $state.table.minValue,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get maxValue => $state.composableBuilder(
      column: $state.table.maxValue,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get value => $state.composableBuilder(
      column: $state.table.value,
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
  $$ErrorTableTableTableManager get errorTable =>
      $$ErrorTableTableTableManager(_db, _db.errorTable);
}
