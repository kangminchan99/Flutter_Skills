import 'package:flutterskills/common/model/cursor_pagination_model.dart';
import 'package:flutterskills/common/model/model_with_id.dart';
import 'package:flutterskills/common/model/pagination_params.dart';

abstract class IBasePaginationRepository<T extends IModelWithId> {
  Future<CursorPaginationModel<T>> paginate({
    PaginationParams? paginationParams = const PaginationParams(),
  });
}
