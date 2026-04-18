// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SlotImpl _$$SlotImplFromJson(Map<String, dynamic> json) => _$SlotImpl(
  id: json['id'] as String,
  date: DateTime.parse(json['date'] as String),
  startTime: DateTime.parse(json['startTime'] as String),
  endTime: DateTime.parse(json['endTime'] as String),
  status: $enumDecode(_$SlotStatusEnumMap, json['status']),
  pendingCount: (json['pendingCount'] as num?)?.toInt() ?? 0,
  confirmedPerformerName: json['confirmedPerformerName'] as String?,
  confirmedPerformerAvatarUrl: json['confirmedPerformerAvatarUrl'] as String?,
);

Map<String, dynamic> _$$SlotImplToJson(_$SlotImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'status': _$SlotStatusEnumMap[instance.status]!,
      'pendingCount': instance.pendingCount,
      'confirmedPerformerName': instance.confirmedPerformerName,
      'confirmedPerformerAvatarUrl': instance.confirmedPerformerAvatarUrl,
    };

const _$SlotStatusEnumMap = {
  SlotStatus.pending: 'pending',
  SlotStatus.confirmed: 'confirmed',
};
