List<String> parseAreaCodeInAddress(String address) {
  String code = address.split(' ').last;

  if (code.length != 10) {
    return [];
  }

  List<String> codes = [];

  codes.add(code.substring(0, 2));
  codes.add(code.substring(2, 4));
  codes.add(code.substring(4, 7));
  codes.add(code.substring(7, 10));

  return codes;
}
