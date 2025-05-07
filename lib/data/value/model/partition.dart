class Partition {
  final String name;
  final String size;

  Partition({required this.name, required this.size});

  @override
  String toString() {
    return 'Partition(name: $name, size: $size)';
  }
}
