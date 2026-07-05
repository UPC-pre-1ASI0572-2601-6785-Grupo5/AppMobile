import '../config/api_config.dart';
import 'api_client.dart';

class DriverModel {
  final int? id;
  final int? providerId;
  final String name;
  final String licenseNumber;
  final String? profilePicture;
  final String status;
  final int drivingMinutes;
  final int restingMinutesLeft;

  DriverModel({
    this.id,
    this.providerId,
    required this.name,
    required this.licenseNumber,
    this.profilePicture,
    required this.status,
    this.drivingMinutes = 0,
    this.restingMinutesLeft = 0,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'],
      providerId: json['providerId'],
      name: json['name'] ?? '',
      licenseNumber: json['licenseNumber'] ?? '',
      profilePicture: json['profilePicture'],
      status: json['status'] ?? 'AVAILABLE',
      drivingMinutes: json['drivingMinutes'] ?? 0,
      restingMinutesLeft: json['restingMinutesLeft'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (providerId != null) 'providerId': providerId,
      'name': name,
      'licenseNumber': licenseNumber,
      if (profilePicture != null) 'profilePicture': profilePicture,
      'status': status,
      'drivingMinutes': drivingMinutes,
      'restingMinutesLeft': restingMinutesLeft,
    };
  }
}

class TankModel {
  final int? id;
  final int? providerId;
  final String plate;
  final String model;
  final double capacityGallons;
  final double currentFuelGallons;
  final String status;
  final String smartLockStatus;
  final String valveStatus;
  final double tirePressurePsi;
  final double speedKmh;

  TankModel({
    this.id,
    this.providerId,
    required this.plate,
    required this.model,
    required this.capacityGallons,
    required this.currentFuelGallons,
    required this.status,
    this.smartLockStatus = 'LOCKED',
    this.valveStatus = 'CLOSED',
    this.tirePressurePsi = 32.0,
    this.speedKmh = 0.0,
  });

  factory TankModel.fromJson(Map<String, dynamic> json) {
    return TankModel(
      id: json['id'],
      providerId: json['providerId'],
      plate: json['plate'] ?? '',
      model: json['model'] ?? '',
      capacityGallons: (json['capacityGallons'] ?? 0.0).toDouble(),
      currentFuelGallons: (json['currentFuelGallons'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'AVAILABLE',
      smartLockStatus: json['smartLockStatus'] ?? 'LOCKED',
      valveStatus: json['valveStatus'] ?? 'CLOSED',
      tirePressurePsi: (json['tirePressurePsi'] ?? 32.0).toDouble(),
      speedKmh: (json['speedKmh'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (providerId != null) 'providerId': providerId,
      'plate': plate,
      'model': model,
      'capacityGallons': capacityGallons,
      'currentFuelGallons': currentFuelGallons,
      'status': status,
      'smartLockStatus': smartLockStatus,
      'valveStatus': valveStatus,
      'tirePressurePsi': tirePressurePsi,
      'speedKmh': speedKmh,
    };
  }
}

class FleetService {
  final ApiClient _api = ApiClient.instance;

  // --- DRIVERS ---
  Future<List<DriverModel>> getDrivers() async {
    try {
      final response = await _api.get(ApiConfig.drivers);
      if (response is List) {
        return response.map((json) => DriverModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching drivers: $e');
      return [];
    }
  }

  Future<DriverModel> addDriver(DriverModel driver) async {
    final response = await _api.post(ApiConfig.drivers, body: driver.toJson());
    return DriverModel.fromJson(response);
  }

  Future<DriverModel> updateDriver(DriverModel driver) async {
    final response = await _api.put('${ApiConfig.drivers}/${driver.id}', body: driver.toJson());
    return DriverModel.fromJson(response);
  }

  Future<void> deleteDriver(int id) async {
    await _api.delete('${ApiConfig.drivers}/$id');
  }

  // --- TANKS ---
  Future<List<TankModel>> getTanks() async {
    try {
      final response = await _api.get(ApiConfig.tanks);
      if (response is List) {
        return response.map((json) => TankModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching tanks: $e');
      return [];
    }
  }

  Future<TankModel> addTank(TankModel tank) async {
    final response = await _api.post(ApiConfig.tanks, body: tank.toJson());
    return TankModel.fromJson(response);
  }

  Future<TankModel> updateTank(TankModel tank) async {
    final response = await _api.put('${ApiConfig.tanks}/${tank.id}', body: tank.toJson());
    return TankModel.fromJson(response);
  }

  Future<void> deleteTank(int id) async {
    await _api.delete('${ApiConfig.tanks}/$id');
  }
}
