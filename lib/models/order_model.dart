class OrderModel {
  final int id;
  final int requesterId;
  final String productName;
  final String name;
  final double quantityGallons;
  final String documentRef;
  final String status;
  final String? assignedTruckId;
  final String createdAt;
  final String updatedAt;
  final bool isCapped;
  final double originalGallons;
  final int? etaMinutes;
  final String? dispatchedAt;
  final String? completedAt;
  final String? securityHash;
  final int? providerId;
  final String? providerName;
  final String? providerAddress;
  final String? driverName;
  final String? driverProfilePicture;
  final int? driverTrips;

  OrderModel({
    required this.id,
    required this.requesterId,
    required this.productName,
    this.name = '',
    required this.quantityGallons,
    required this.documentRef,
    required this.status,
    this.assignedTruckId,
    required this.createdAt,
    required this.updatedAt,
    this.isCapped = false,
    this.originalGallons = 0.0,
    this.etaMinutes,
    this.dispatchedAt,
    this.completedAt,
    this.securityHash,
    this.providerId,
    this.providerName,
    this.providerAddress,
    this.driverName,
    this.driverProfilePicture,
    this.driverTrips,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    double rawGallons = (json['gallons'] as num?)?.toDouble() ?? 0.0;
    bool capped = false;
    double finalGallons = rawGallons;
    
    if (rawGallons > 1000000000) {
      finalGallons = 1000.0;
      capped = true;
    }

    return OrderModel(
      id: json['id'] as int,
      requesterId: json['requesterId'] as int,
      productName: json['fuelType'] as String? ?? 'Desconocido',
      name: json['name'] as String? ?? '',
      quantityGallons: finalGallons,
      documentRef: json['documentRef'] as String? ?? '',
      status: json['status'] as String? ?? 'PENDING',
      assignedTruckId: json['truckId'] as String?,
      createdAt: json['createdAt']?.toString() ?? DateTime.now().toUtc().toIso8601String(),
      updatedAt: json['updatedAt']?.toString() ?? '',
      isCapped: capped,
      originalGallons: rawGallons,
      etaMinutes: json['etaMinutes'] as int?,
      dispatchedAt: json['dispatchedAt']?.toString(),
      completedAt: json['completedAt']?.toString(),
      securityHash: json['securityHash']?.toString(),
      providerId: json['providerId'] as int?,
      providerName: json['providerName'] as String?,
      providerAddress: json['providerAddress'] as String?,
      driverName: json['driverName'] as String?,
      driverProfilePicture: json['driverProfilePicture'] as String?,
      driverTrips: json['driverTrips'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requesterId': requesterId,
      'productName': productName,
      'name': name,
      'quantityGallons': quantityGallons,
      'documentRef': documentRef,
      'status': status,
      'assignedTruckId': assignedTruckId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'etaMinutes': etaMinutes,
      'dispatchedAt': dispatchedAt,
      'completedAt': completedAt,
      'securityHash': securityHash,
      'providerId': providerId,
      'providerName': providerName,
      'providerAddress': providerAddress,
      'driverName': driverName,
      'driverProfilePicture': driverProfilePicture,
      'driverTrips': driverTrips,
    };
  }

}
