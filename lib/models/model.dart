class PressData {
  String type;
  dynamic value;

  PressData.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        value = json['value'];

  get serialNumber => null;

  Map<String, dynamic> toJson() => {
        'type': type,
        'value': value,
      };
}
