import 'package:floor/floor.dart';
import 'package:yala_pay/models/bank_account.dart';

@dao
abstract class BankAccountDao {
  @Query("SELECT * FROM bankAccounts")
  Stream<List<BankAccount>> observeBankAccounts();

  @Query("SELECT * FROM bankAccounts WHERE accountNumber = :id")
  Future<BankAccount?> findBankAccountById(String id);

  @Insert(
    onConflict: OnConflictStrategy.replace,
  )
  Future<void> insertBankAccount(BankAccount account);

  @update
  Future<void> updateBankAccount(BankAccount account);

  @delete
  Future<void> deleteBankAccount(BankAccount account);
}
