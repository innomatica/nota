const dbname = 'nota.db';
const dbversion = 1;

const createNotaItems = """CREATE TABLE items (
  id INTEGER PRIMARY KEY,
  title TEXT NO NULL,
  content TEXT,
  completed INTEGER NOT NULL,
  alarm TEXT,
  tag_ids TEXT NOT NULL,
  created_at TEXT NOT NULL
);""";
const createNotaTags = '''CREATE TABLE tags (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  alarm TEXT,
  color INTEGER NOT NULL,
  layout TEXT NOT NULL
);''';

const createTablesV1 = [createNotaItems, createNotaTags];
