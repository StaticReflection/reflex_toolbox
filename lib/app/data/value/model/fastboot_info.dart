class FastbootInfo {
  final String name;
  final String value;

  FastbootInfo({required this.name, required this.value});

  // tostring
  @override
  String toString() {
    return 'FastbootInfo{name: $name, value: $value}';
  }
}
