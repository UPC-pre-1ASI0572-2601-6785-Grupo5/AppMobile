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
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int,
      requesterId: json['requesterId'] as int,
      productName: json['fuelType'] as String? ?? 'Desconocido',
      quantityGallons: _parseGallons(json['gallons']),
      documentRef: json['documentRef'] as String? ?? '',
      status: json['status'] as String? ?? 'PENDING',
      assignedTruckId: null,
      createdAt: json['createdAt']?.toString() ?? DateTime.now().toUtc().toIso8601String(),
      updatedAt: json['updatedAt']?.toString() ?? '',
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

  static double _parseGallons(dynamic jsonValue) {
    double g = (jsonValue as num?)?.toDouble() ?? 0.0;
    // Hard limit para descartar outliers gigantes como pruebas de estrés (ej. 6969696969)
    if (g > 1000000000) return 1000.0;
    return g;
  }
}
