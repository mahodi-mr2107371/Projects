// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  BankAccountDao? _bankAccountDaoInstance;

  ReturnReasonsDao? _returnReasonsDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `bankAccounts` (`accountName` TEXT NOT NULL, `accountNumber` TEXT NOT NULL, PRIMARY KEY (`accountNumber`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `returnReasons` (`reasonId` INTEGER NOT NULL, `description` TEXT NOT NULL, PRIMARY KEY (`reasonId`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  BankAccountDao get bankAccountDao {
    return _bankAccountDaoInstance ??=
        _$BankAccountDao(database, changeListener);
  }

  @override
  ReturnReasonsDao get returnReasonsDao {
    return _returnReasonsDaoInstance ??=
        _$ReturnReasonsDao(database, changeListener);
  }
}

class _$BankAccountDao extends BankAccountDao {
  _$BankAccountDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _bankAccountInsertionAdapter = InsertionAdapter(
            database,
            'bankAccounts',
            (BankAccount item) => <String, Object?>{
                  'accountName': item.accountName,
                  'accountNumber': item.accountNumber
                },
            changeListener),
        _bankAccountUpdateAdapter = UpdateAdapter(
            database,
            'bankAccounts',
            ['accountNumber'],
            (BankAccount item) => <String, Object?>{
                  'accountName': item.accountName,
                  'accountNumber': item.accountNumber
                },
            changeListener),
        _bankAccountDeletionAdapter = DeletionAdapter(
            database,
            'bankAccounts',
            ['accountNumber'],
            (BankAccount item) => <String, Object?>{
                  'accountName': item.accountName,
                  'accountNumber': item.accountNumber
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<BankAccount> _bankAccountInsertionAdapter;

  final UpdateAdapter<BankAccount> _bankAccountUpdateAdapter;

  final DeletionAdapter<BankAccount> _bankAccountDeletionAdapter;

  @override
  Stream<List<BankAccount>> observeBankAccounts() {
    return _queryAdapter.queryListStream('SELECT * FROM bankAccounts',
        mapper: (Map<String, Object?> row) => BankAccount(
            accountName: row['accountName'] as String,
            accountNumber: row['accountNumber'] as String),
        queryableName: 'bankAccounts',
        isView: false);
  }

  @override
  Future<BankAccount?> findBankAccountById(String id) async {
    return _queryAdapter.query(
        'SELECT * FROM bankAccounts WHERE accountNumber = ?1',
        mapper: (Map<String, Object?> row) => BankAccount(
            accountName: row['accountName'] as String,
            accountNumber: row['accountNumber'] as String),
        arguments: [id]);
  }

  @override
  Future<void> insertBankAccount(BankAccount account) async {
    await _bankAccountInsertionAdapter.insert(
        account, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateBankAccount(BankAccount account) async {
    await _bankAccountUpdateAdapter.update(account, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteBankAccount(BankAccount account) async {
    await _bankAccountDeletionAdapter.delete(account);
  }
}

class _$ReturnReasonsDao extends ReturnReasonsDao {
  _$ReturnReasonsDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _returnReasonInsertionAdapter = InsertionAdapter(
            database,
            'returnReasons',
            (ReturnReason item) => <String, Object?>{
                  'reasonId': item.reasonId,
                  'description': item.description
                },
            changeListener),
        _returnReasonUpdateAdapter = UpdateAdapter(
            database,
            'returnReasons',
            ['reasonId'],
            (ReturnReason item) => <String, Object?>{
                  'reasonId': item.reasonId,
                  'description': item.description
                },
            changeListener),
        _returnReasonDeletionAdapter = DeletionAdapter(
            database,
            'returnReasons',
            ['reasonId'],
            (ReturnReason item) => <String, Object?>{
                  'reasonId': item.reasonId,
                  'description': item.description
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ReturnReason> _returnReasonInsertionAdapter;

  final UpdateAdapter<ReturnReason> _returnReasonUpdateAdapter;

  final DeletionAdapter<ReturnReason> _returnReasonDeletionAdapter;

  @override
  Stream<List<ReturnReason>> observeReturnReasons() {
    return _queryAdapter.queryListStream('SELECT * FROM returnReasons',
        mapper: (Map<String, Object?> row) => ReturnReason(
            reasonId: row['reasonId'] as int,
            description: row['description'] as String),
        queryableName: 'returnReasons',
        isView: false);
  }

  @override
  Future<ReturnReason?> findReturnReason(int id) async {
    return _queryAdapter.query(
        'SELECT * FROM returnReasons WHERE reasonId = ?1',
        mapper: (Map<String, Object?> row) => ReturnReason(
            reasonId: row['reasonId'] as int,
            description: row['description'] as String),
        arguments: [id]);
  }

  @override
  Future<void> insertReturnReason(ReturnReason returnReason) async {
    await _returnReasonInsertionAdapter.insert(
        returnReason, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateReturnReason(ReturnReason returnReason) async {
    await _returnReasonUpdateAdapter.update(
        returnReason, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteReturnReason(ReturnReason returnReason) async {
    await _returnReasonDeletionAdapter.delete(returnReason);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
final _dateTimeConverterConditional = DateTimeConverterConditional();
final _intListConverter = IntListConverter();
