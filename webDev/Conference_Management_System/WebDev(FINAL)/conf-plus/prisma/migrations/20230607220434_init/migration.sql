/*
  Warnings:

  - You are about to alter the column `contributions` on the `Paper` table. The data in that column could be lost. The data in that column will be cast from `String` to `Int`.
  - You are about to alter the column `overall` on the `Paper` table. The data in that column could be lost. The data in that column will be cast from `String` to `Int`.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Paper" (
    "title" TEXT NOT NULL,
    "abstract" TEXT NOT NULL,
    "score" INTEGER NOT NULL,
    "fileName" TEXT NOT NULL,
    "size" INTEGER NOT NULL,
    "file" BLOB NOT NULL,
    "type" TEXT NOT NULL,
    "overall" INTEGER,
    "contributions" INTEGER,
    "strengths" TEXT,
    "weaknesses" TEXT,

    PRIMARY KEY ("title", "abstract")
);
INSERT INTO "new_Paper" ("abstract", "contributions", "file", "fileName", "overall", "score", "size", "strengths", "title", "type", "weaknesses") SELECT "abstract", "contributions", "file", "fileName", "overall", "score", "size", "strengths", "title", "type", "weaknesses" FROM "Paper";
DROP TABLE "Paper";
ALTER TABLE "new_Paper" RENAME TO "Paper";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
