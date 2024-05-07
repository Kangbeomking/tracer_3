// ignore_for_file: file_names

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/dataModel.dart';

/// 데이터베이스 관리를 위한 클래스
class DatabaseManager {
  static Database? _database;

  /// 데이터베이스 인스턴스를 싱글턴으로 관리하여 여러번 생성되지 않도록 함
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  /// 데이터베이스 파일 생성 및 테이블 구조를 초기화
  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'project_database.db');
    int dbVersion = 2; // 데이터베이스 버전을 변수로 선언

    // 데이터베이스 버전을 출력
    print('Initializing database at path: $path with version: $dbVersion');
    return await openDatabase(path,
        version: 4, onCreate: createTables, onUpgrade: onUpgrade);
  }

  void onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 4) {
      // KeyResults 테이블에 'progress' 컬럼 추가
      await addColumnIfNotExists(db, 'KeyResults', 'progress', 'INTEGER');

      // Sub_goals 테이블에 'weight' 컬럼 추가
      await addColumnIfNotExists(db, 'Sub_goals', 'weight', 'INTEGER');

      // Sub_goals 테이블에 'progress' 컬럼 추가
      await addColumnIfNotExists(db, 'Sub_goals', 'progress', 'INTEGER');

      // Actionx 테이블에 'weight' 컬럼 추가
      await addColumnIfNotExists(db, 'Actionx', 'weight', 'INTEGER');

      print("업그레이드 완료");
    }
  }

  Future<void> addColumnIfNotExists(Database db, String tableName,
      String columnName, String columnType) async {
    var columnExists = await db.rawQuery("PRAGMA table_info($tableName);").then(
        (List<Map<String, dynamic>> list) =>
            list.any((Map<String, dynamic> row) => row['name'] == columnName));

    if (!columnExists) {
      await db.execute(
          'ALTER TABLE $tableName ADD COLUMN $columnName $columnType;');
    }
  }

  /// 데이터베이스 테이블을 생성하는 메소드
  void createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE KeyResults (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        contents TEXT,
        weight INTEGER DEFAULT 0,
        progress INTEGER 
      );
    ''');
    await db.execute('''
      CREATE TABLE Sub_goals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        contents TEXT,
        weight INTEGER,
        progress INTEGER 
      );
    ''');
    await db.execute('''
      CREATE TABLE Actionx (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        contents TEXT,
        weight INTEGER,
        progress INTEGER 
      );
    ''');
    await db.execute('''
      CREATE TABLE KeyResult_SubGoal (
        keyResultId INTEGER,
        subGoalId INTEGER,
        weight INTEGER,
        PRIMARY KEY (keyResultId, subGoalId),
        FOREIGN KEY (keyResultId) REFERENCES KeyResults(id),
        FOREIGN KEY (subGoalId) REFERENCES SubGoals(id)
      );
    ''');
    await db.execute('''
      CREATE TABLE SubGoal_Actions (
        subGoalId  INTEGER,
        actionId  INTEGER,
        weight INTEGER,
        PRIMARY KEY (subGoalId, actionId),
        FOREIGN KEY (subGoalId) REFERENCES SubGoals(id),
        FOREIGN KEY (actionId) REFERENCES Actionx(id)
      );
    ''');
  }

  /// KeyResults 객체를 데이터베이스에 삽입
  Future<void> insertKeyResult(KeyResults keyResult) async {
    final db = await database;
    await db.insert('KeyResults', keyResult.toMap());
  }

  /// Sub_goal 객체를 데이터베이스에 삽입
  Future<void> insertSubGoal(Sub_goal subGoal) async {
    final db = await database;
    await db.insert('Sub_goals', subGoal.toMap());
  }

  /// Actions 객체를 데이터베이스에 삽입
  Future<void> insertAction(Actionx action) async {
    final db = await database;
    await db.insert('Actionx', action.toMap());
  }

  /// KeyResult와 SubGoal 간의 다대다 관계를 관리하는 테이블에 데이터를 삽입하는 메소드
  Future<void> insertKeyResultSubGoal(
      int keyResultId, int subGoalId, int weight) async {
    final db = await database;
    print(
        "Inserting KeyResultSubGoal with keyResultId: $keyResultId, subGoalId: $subGoalId, weight: $weight");
    await db.insert('KeyResult_SubGoal',
        {'keyResultId': keyResultId, 'subGoalId': subGoalId, 'weight': weight});
    print("Data inserted into KeyResult_SubGoal table.");
  }

  /// SubGoal과 Action 간의 다대다 관계를 관리하는 테이블에 데이터를 삽입하는 메소드
  Future<void> insertSubGoalAction(
      int subGoalId, int actionId, int weight) async {
    final db = await database;
    print(
        "Inserting KeyResultSubGoal with keyResultId: $subGoalId, subGoalId: $actionId, weight: $weight");
    await db.insert('SubGoal_Actions',
        {'subGoalId': subGoalId, 'actionId': actionId, 'weight': weight});
    print("Data inserted into subgoal_action table.");
  }

  // KeyResults 테이블에서 모든 데이터를 가져오는 함수
  Future<List<Map<String, dynamic>>> getKeyResults() async {
    final db = await database; // 데이터베이스 인스턴스를 가져옵니다.
    final List<Map<String, dynamic>> maps =
        await db.query('KeyResults'); // 데이터베이스에서 KeyResults 테이블을 쿼리합니다.
    return maps; // 쿼리 결과를 반환합니다.
  }

// Sub_goals 테이블에서 모든 데이터를 가져오는 함수
  Future<List<Map<String, dynamic>>> getSubGoals() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Sub_goals');
    return maps;
  }

// Actions 테이블에서 모든 데이터를 가져오는 함수
  Future<List<Map<String, dynamic>>> getActions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Actionx');
    return maps;
  }

  // KeyResult ID에 해당하는 Sub_goals를 가져오는 메서드
  Future<List<Map<String, dynamic>>> getSubGoalsFor(int keyResultId) async {
    final db = await database;
    print("Database connected.");

    final List<Map<String, dynamic>> keyResultSubGoalsMaps = await db.query(
      'KeyResult_SubGoal',
      columns: ['subGoalId', 'weight'],
      where: 'keyResultId = ?',
      whereArgs: [keyResultId],
    );
    print("KeyResult_SubGoals fetched: $keyResultSubGoalsMaps");

    if (keyResultSubGoalsMaps.isEmpty) {
      print("No SubGoals found for KeyResult ID: $keyResultId");
      return [];
    }

    List<Map<String, dynamic>> subGoalMaps = [];
    for (var keyResultSubGoal in keyResultSubGoalsMaps) {
      // Here we use 'subGoalId' to fetch the related sub-goals from the 'Sub_goals' table
      final List<Map<String, dynamic>> tempSubGoalMaps = await db.query(
        'Sub_goals',
        where: 'id = ?',
        whereArgs: [
          keyResultSubGoal['subGoalId']
        ], // Corrected from 'keyResultId' to 'subGoalId'
      );
      print(
          "Sub_goals for ID ${keyResultSubGoal['subGoalId']}: $tempSubGoalMaps");

      if (tempSubGoalMaps.isNotEmpty) {
        final Map<String, dynamic> subGoal = Map.from(tempSubGoalMaps.first);
        subGoal['weight'] = keyResultSubGoal['weight'];
        subGoalMaps.add(subGoal);
      }
    }

    print("Final subGoals list: $subGoalMaps");
    return subGoalMaps;
  }

  Future<List<Map<String, dynamic>>> getActionsFor(int subGoalId) async {
    final db = await database;
    print("Database connected.");

    final List<Map<String, dynamic>> SubGoalsActionMaps = await db.query(
      'SubGoal_Actions',
      columns: ['actionId', 'weight'],
      where: 'subGoalId = ?',
      whereArgs: [subGoalId],
    );
    print("SubGoals_actions fetched: $SubGoalsActionMaps");

    if (SubGoalsActionMaps.isEmpty) {
      print("No actions found for SubGoal ID: $subGoalId");
      return [];
    }

    List<Map<String, dynamic>> actionMaps = [];
    for (var subGoalAction in SubGoalsActionMaps) {
      // Here we use 'subGoalId' to fetch the related sub-goals from the 'Sub_goals' table
      final List<Map<String, dynamic>> tempActionlMaps = await db.query(
        'Actionx',
        where: 'id = ?',
        whereArgs: [
          subGoalAction['actionId'] //
        ],
      );
      print("Actions for ID ${subGoalAction['actionId']}: $tempActionlMaps"); //

      if (tempActionlMaps.isNotEmpty) {
        final Map<String, dynamic> action = Map.from(tempActionlMaps.first);
        action['weight'] = subGoalAction['weight'];
        actionMaps.add(action); //
      }
    }

    print("Final actions list: $actionMaps");
    return actionMaps;
  }

  // 현재 KeyResult와 연결되지 않은 Sub_goals를 가져오는 메서드
  Future<List<Map<String, dynamic>>> getAvailableSubGoals(
      int keyResultId) async {
    final db = await database;
    // 먼저 현재 KeyResult와 연결된 모든 Sub_goal ID를 가져옵니다.
    final List<Map<String, dynamic>> linkedSubGoals = await db.query(
      'KeyResult_SubGoal',
      columns: ['subGoalId'],
      where: 'keyResultId = ?',
      whereArgs: [keyResultId],
    );

    // 연결된 Sub_goal ID 목록을 추출합니다.
    List<int> linkedSubGoalIds =
        linkedSubGoals.map((sg) => sg['subGoalId'] as int).toList();

    // 연결되지 않은 Sub_goals를 조회합니다.
    final String whereClause = linkedSubGoalIds.isNotEmpty
        ? 'id NOT IN (${linkedSubGoalIds.join(', ')})'
        : '1 = 1'; // 모든 Sub_goals를 가져오기 위한 조건 (연결된 Sub_goal이 없는 경우)

    final List<Map<String, dynamic>> availableSubGoals =
        await db.query('Sub_goals', where: whereClause);

    return availableSubGoals;
  }

  Future<void> deleteAction(int actionId) async {
    final db = await database; // 데이터베이스 인스턴스를 가져옵니다.
    await db.delete(
      'Actionx', // 액션 데이터가 저장된 테이블 이름
      where: 'id = ?', // 삭제 조건
      whereArgs: [actionId], // 조건에 사용될 id 값
    );
  }

  // 서브골을 삭제하는 메서드
  Future<void> deleteSubGoal(int subGoalId) async {
    final db = await database;
    await db.delete('Sub_goals', where: 'id = ?', whereArgs: [subGoalId]);
  }

  // 서브골과 연결된 KeyResult_SubGoal 데이터를 삭제하는 메서드
  Future<void> deleteKeyResultSubGoalWithSubGoal(int subGoalId) async {
    final db = await database;
    await db.delete('KeyResult_SubGoal',
        where: 'subGoalId = ?', whereArgs: [subGoalId]);
  }

  // 키리저트를 삭제하는 메서드
  Future<void> deleteKeyResult(int keyResultId) async {
    final db = await database;
    await db.delete('KeyResults', where: 'id = ?', whereArgs: [keyResultId]);
  }

  // 키리저트와 연결된 KeyResult_SubGoal 데이터를 삭제하는 메서드
  Future<void> deleteKeyResultSubGoalWithKeyResult(int keyResultId) async {
    final db = await database;
    await db.delete('KeyResult_SubGoal',
        where: 'keyResultId = ?', whereArgs: [keyResultId]);
  }

  Future<void> deleteSubGoalAction(int subGoalId, int actionId) async {
    final db = await database;
    await db.delete('SubGoal_Action',
        where: 'subGoalId = ? AND actionId = ?',
        whereArgs: [subGoalId, actionId]);
  }
}
