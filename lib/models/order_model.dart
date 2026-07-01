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
      productName: json['productName'] as String? ?? 'Desconocido',
      quantityGallons: (json['quantityGallons'] as num?)?.toDouble() ?? 0.0,
      documentRef: json['documentRef'] as String? ?? '',
      status: json['status'] as String? ?? 'PENDING',
      assignedTruckId: json['assignedTruckId'] as int?,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
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
