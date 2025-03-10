import 'package:floor/floor.dart';
import 'package:yala_pay/models/return_reason.dart';

@dao
abstract class ReturnReasonsDao {
  @Query("SELECT * FROM returnReasons")
  Stream<List<ReturnReason>> observeReturnReasons();

  @Query("SELECT * FROM returnReasons WHERE reasonId = :id")
  Future<ReturnReason?> findReturnReason(int id);

  @Insert(
    onConflict: OnConflictStrategy.replace,
  )
  Future<void> insertReturnReason(ReturnReason returnReason);

  @update
  Future<void> updateReturnReason(ReturnReason returnReason);

  @delete
  Future<void> deleteReturnReason(ReturnReason returnReason);
}
