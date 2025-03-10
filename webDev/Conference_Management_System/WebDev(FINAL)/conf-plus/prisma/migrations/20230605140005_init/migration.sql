/*
  Warnings:

  - You are about to drop the `PaperFiles` table. If the table is not empty, all the data it contains will be lost.
  - The primary key for the `Paper` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `fileId` on the `Paper` table. All the data in the column will be lost.
  - You are about to drop the column `paperId` on the `Paper` table. All the data in the column will be lost.
  - The primary key for the `PaperAuthors` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `paperId` on the `PaperAuthors` table. All the data in the column will be lost.
  - The primary key for the `ReviewPapers` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `paperId` on the `ReviewPapers` table. All the data in the column will be lost.
  - Added the required column `file` to the `Paper` table without a default value. This is not possible if the table is not empty.
  - Added the required column `type` to the `Paper` table without a default value. This is not possible if the table is not empty.
  - Made the column `fileName` on table `Paper` required. This step will fail if there are existing NULL values in that column.
  - Made the column `size` on table `Paper` required. This step will fail if there are existing NULL values in that column.
  - Added the required column `abstract` to the `PaperAuthors` table without a default value. This is not possible if the table is not empty.
  - Added the required column `title` to the `PaperAuthors` table without a default value. This is not possible if the table is not empty.
  - Added the required column `abstract` to the `ReviewPapers` table without a default value. This is not possible if the table is not empty.
  - Added the required column `title` to the `ReviewPapers` table without a default value. This is not possible if the table is not empty.

*/
-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "PaperFiles";
PRAGMA foreign_keys=on;

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
    "overall" TEXT,
    "contributions" TEXT,
    "strengths" TEXT,
    "weaknesses" TEXT,

    PRIMARY KEY ("title", "abstract")
);
INSERT INTO "new_Paper" ("abstract", "contributions", "fileName", "overall", "score", "size", "strengths", "title", "weaknesses") SELECT "abstract", "contributions", "fileName", "overall", "score", "size", "strengths", "title", "weaknesses" FROM "Paper";
DROP TABLE "Paper";
ALTER TABLE "new_Paper" RENAME TO "Paper";
CREATE TABLE "new_PaperAuthors" (
    "title" TEXT NOT NULL,
    "abstract" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "fname" TEXT NOT NULL,
    "lname" TEXT NOT NULL,
    "affil" TEXT NOT NULL,
    "isPresenter" BOOLEAN NOT NULL,

    PRIMARY KEY ("email", "title"),
    CONSTRAINT "PaperAuthors_title_abstract_fkey" FOREIGN KEY ("title", "abstract") REFERENCES "Paper" ("title", "abstract") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "PaperAuthors_affil_fkey" FOREIGN KEY ("affil") REFERENCES "Institution" ("institution") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_PaperAuthors" ("affil", "email", "fname", "isPresenter", "lname") SELECT "affil", "email", "fname", "isPresenter", "lname" FROM "PaperAuthors";
DROP TABLE "PaperAuthors";
ALTER TABLE "new_PaperAuthors" RENAME TO "PaperAuthors";
CREATE TABLE "new_ReviewPapers" (
    "title" TEXT NOT NULL,
    "abstract" TEXT NOT NULL,
    "id" TEXT NOT NULL,

    PRIMARY KEY ("title", "id"),
    CONSTRAINT "ReviewPapers_id_fkey" FOREIGN KEY ("id") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "ReviewPapers_title_abstract_fkey" FOREIGN KEY ("title", "abstract") REFERENCES "Paper" ("title", "abstract") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_ReviewPapers" ("id") SELECT "id" FROM "ReviewPapers";
DROP TABLE "ReviewPapers";
ALTER TABLE "new_ReviewPapers" RENAME TO "ReviewPapers";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
