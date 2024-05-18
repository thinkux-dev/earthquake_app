import 'package:freezed_annotation/freezed_annotation.dart';
part 'query_params.freezed.dart';
part 'query_params.g.dart';

@unfreezed
class QueryParams with _$QueryParams {
  factory QueryParams({
    @Default('geojson') String format,
    required String starttime,
    required String endtime,
    required String minmagnitude,
    required String orderby,
    required String limit,
    required String maxradiuskm,
    required String latitude,
    required String longitude,
  }) = _QueryParams;

  factory QueryParams.fromJson(Map<String, dynamic> json) =>
      _$QueryParamsFromJson(json);
}