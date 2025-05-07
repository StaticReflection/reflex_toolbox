class StorageInfo {
  final double total;
  final double free;
  final double used;

  StorageInfo({required this.total, required this.used}) : free = total - used;

  @override
  String toString() {
    return 'StorageInfo(total: $total GB, free: $free GB, used: $used GB)';
  }
}
