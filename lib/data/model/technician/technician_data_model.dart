import 'package:rental_service/data/model/technician/technician_info_model.dart';


class TechnicianData {
  final List<TechnicianInfo> list;

  TechnicianData({required this.list});

  factory TechnicianData.fromJson(Map<String, dynamic> json) {
    return TechnicianData(
      list: (json['list'] as List)
          .map((e) => TechnicianInfo.fromJson(e))
          .toList(),
    );
  }
}
