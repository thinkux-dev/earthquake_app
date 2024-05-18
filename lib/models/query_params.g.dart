// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QueryParamsImpl _$$QueryParamsImplFromJson(Map<String, dynamic> json) =>
    _$QueryParamsImpl(
      format: json['format'] as String? ?? 'geojson',
      starttime: json['starttime'] as String,
      endtime: json['endtime'] as String,
      minmagnitude: json['minmagnitude'] as String,
      orderby: json['orderby'] as String,
      limit: json['limit'] as String,
      maxradiuskm: json['maxradiuskm'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
    );

Map<String, dynamic> _$$QueryParamsImplToJson(_$QueryParamsImpl instance) =>
    <String, dynamic>{
      'format': instance.format,
      'starttime': instance.starttime,
      'endtime': instance.endtime,
      'minmagnitude': instance.minmagnitude,
      'orderby': instance.orderby,
      'limit': instance.limit,
      'maxradiuskm': instance.maxradiuskm,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
