class DistinctData {
  final String serialNo;
  final String locationNo;

  DistinctData({required this.serialNo, required this.locationNo});

  get deviceNo => null;
}

class DistinctErrorData {
  final String errorType;

  DistinctErrorData({required this.errorType});
}
