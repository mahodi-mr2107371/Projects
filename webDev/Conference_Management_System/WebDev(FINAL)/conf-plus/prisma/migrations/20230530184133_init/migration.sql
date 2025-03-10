-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Paper" (
    "title" TEXT NOT NULL PRIMARY KEY,
    "abstract" TEXT NOT NULL,
    "score" INTEGER NOT NULL,
    "fileName" TEXT,
    "size" INTEGER,
    "file" BLOB
);
INSERT INTO "new_Paper" ("abstract", "fileName", "score", "title") SELECT "abstract", "fileName", "score", "title" FROM "Paper";
DROP TABLE "Paper";
ALTER TABLE "new_Paper" RENAME TO "Paper";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
