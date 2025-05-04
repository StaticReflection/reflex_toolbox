class MemoryInfo {
  final double total;
  final double free;
  final double used;
  final double shared;
  final double buffers;
  final double available;

  MemoryInfo({
    required this.total,
    required this.used,
    required this.available,
    required this.shared,
    required this.buffers,
  }) : free = total - available;

  @override
  String toString() {
    return 'MemoryInfo(total: $total GB, free: $free GB, used: $used GB, shared: $shared GB, buffers: $buffers GB, available: $available GB)';
  }
}
