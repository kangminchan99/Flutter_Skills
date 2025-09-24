import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

abstract class CursorPaginationBase {}

// 에러 발생했을 때
class CursorPaginationError extends CursorPaginationBase {
  final String errorMsg;

  CursorPaginationError({required this.errorMsg});
}

// 로딩
class CursorPaginationLoading extends CursorPaginationBase {}

@JsonSerializable(genericArgumentFactories: true)
class CursorPaginationModel<T> extends CursorPaginationBase {
  final CursorPaginationMetaModel meta;
  final List<T> data;

  CursorPaginationModel({required this.data, required this.meta});

  CursorPaginationModel copyWith({
    CursorPaginationMetaModel? meta,
    List<T>? data,
  }) {
    return CursorPaginationModel<T>(
      meta: meta ?? this.meta,
      data: data ?? this.data,
    );
  }

  factory CursorPaginationModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$CursorPaginationModelFromJson(json, fromJsonT);
}

@JsonSerializable()
class CursorPaginationMetaModel {
  final int count;
  final bool hasMore;

  CursorPaginationMetaModel({required this.count, required this.hasMore});

  CursorPaginationMetaModel copyWith({int? count, bool? hasMore}) {
    return CursorPaginationMetaModel(
      count: count ?? this.count,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  factory CursorPaginationMetaModel.fromJson(Map<String, dynamic> json) =>
      _$CursorPaginationMetaModelFromJson(json);
}

// 새로고침 할 때
class CursorPaginationRefetching<T> extends CursorPaginationModel<T> {
  CursorPaginationRefetching({required super.data, required super.meta});
}

// 리스트의 맨 아래로 내려서
// 추가 데이터를 요청하는 중
class CursorPaginationFetchingMore<T> extends CursorPaginationModel<T> {
  CursorPaginationFetchingMore({required super.data, required super.meta});
}
