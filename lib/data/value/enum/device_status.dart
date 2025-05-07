enum DeviceStatus {
  offline,
  recovery,
  fastboot,
  unknown,
  device,
  unauthorized,
  sideload,
}

DeviceStatus deviceStatusFromString(String statusStr) {
  return DeviceStatus.values.firstWhere(
    (status) => status.name == statusStr,
    orElse: () => DeviceStatus.unknown,
  );
}
