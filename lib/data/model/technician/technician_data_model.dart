import 'package:rental_service/data/model/technician/technician_info_model.dart';


class TechnicianData {
  final TechnicianInfo list;

  TechnicianData({required this.list});

  factory TechnicianData.fromJson(Map<String, dynamic> json) {
    return TechnicianData(
      list: TechnicianInfo.fromJson(json['list']),
    );
  }
}
