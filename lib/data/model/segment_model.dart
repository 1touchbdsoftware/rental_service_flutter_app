class SegmentModel {
  final String? code;
  final String id;
  final String? value;
  final String text;
  final bool? disabled;
  final bool? isFixed;
  final bool? isActive;
  final String? type;
  final String? flag;
  final int? count;
  final int? max;
  final int? duration;

  SegmentModel({
    this.code,
    required this.id,
    this.value,
    required this.text,
    this.disabled,
    this.isFixed,
    this.isActive,
    this.type,
    this.flag,
    this.count,
    this.max,
    this.duration,
  });

  factory SegmentModel.fromJson(Map<String, dynamic> json) {
    return SegmentModel(
      code: json['code'],
      id: json['id'] ?? '',
      value: json['value'],
      text: json['text'] ?? '',
      disabled: json['disabled'],
      isFixed: json['isFixed'],
      isActive: json['isActive'],
      type: json['type'],
      flag: json['flag'],
      count: json['count'],
      max: json['max'],
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'id': id,
      'value': value,
      'text': text,
      'disabled': disabled,
      'isFixed': isFixed,
      'isActive': isActive,
      'type': type,
      'flag': flag,
      'count': count,
      'max': max,
      'duration': duration,
    };
  }
}
