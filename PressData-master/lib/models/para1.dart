class Para1 {
  String tempMax;
  String tempMin;
  String humiMax;
  String humiMin;
  String o2_1Max;
  String o2_1Min;
  String n2oMax;
  String n2oMin;
  String co2Max;
  String co2Min;

  Para1({
    required this.tempMax,
    required this.tempMin,
    required this.humiMax,
    required this.humiMin,
    required this.o2_1Max,
    required this.o2_1Min,
    required this.n2oMax,
    required this.n2oMin,
    required this.co2Max,
    required this.co2Min,
  });

  factory Para1.fromJson(Map<String, dynamic> json) {
    return Para1(
      tempMax: json['Temp_Max'] ?? 'N/A', // Provide default value for null
      tempMin: json['Temp_Min'] ?? 'N/A',
      humiMax: json['Humi_Max'] ?? 'N/A',
      humiMin: json['Humi_Min'] ?? 'N/A',
      o2_1Max: json['O2_1_Max'] ?? 'N/A',
      o2_1Min: json['O2_1_Min'] ?? 'N/A',
      n2oMax: json['N2O_Max'] ?? 'N/A',
      n2oMin: json['N2O_Min'] ?? 'N/A',
      co2Max: json['CO2_Max'] ?? 'N/A',
      co2Min: json['CO2_Min'] ?? 'N/A',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Temp_Max': tempMax,
      'Temp_Min': tempMin,
      'Humi_Max': humiMax,
      'Humi_Min': humiMin,
      'O2_1_Max': o2_1Max,
      'O2_1_Min': o2_1Min,
      'N2O_Max': n2oMax,
      'N2O_Min': n2oMin,
      'CO2_Max': co2Max,
      'CO2_Min': co2Min,
    };
  }
}
