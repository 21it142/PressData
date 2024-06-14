class PressData {
  String type;
  dynamic value;
  PressData.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        value = json['value'];

  Map<String, dynamic> toJson() => {
        'type': type,
        'value': value,
      };
}
