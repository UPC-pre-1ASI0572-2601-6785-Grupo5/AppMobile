class OrderModel {
  final int id;
  final int requesterId;
  final String productName;
  final double quantityGallons;
  final String documentRef;
  final String status;
  final int? assignedTruckId;
  final String createdAt;
  final String updatedAt;
  final bool isCapped;
  final double originalGallons;

  OrderModel({
    required this.id,
    required this.requesterId,
    required this.productName,
    required this.quantityGallons,
    required this.documentRef,
    required this.status,
    this.assignedTruckId,
    required this.createdAt,
    required this.updatedAt,
    this.isCapped = false,
    this.originalGallons = 0.0,
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
      quantityGallons: finalGallons,
      documentRef: json['documentRef'] as String? ?? '',
      status: json['status'] as String? ?? 'PENDING',
      assignedTruckId: null,
      createdAt: json['createdAt']?.toString() ?? DateTime.now().toUtc().toIso8601String(),
      updatedAt: json['updatedAt']?.toString() ?? '',
      isCapped: capped,
      originalGallons: rawGallons,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requesterId': requesterId,
      'productName': productName,
      'quantityGallons': quantityGallons,
      'documentRef': documentRef,
      'status': status,
      'assignedTruckId': assignedTruckId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

}
