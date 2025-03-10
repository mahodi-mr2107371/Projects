/*
  Warnings:

  - The primary key for the `PaperAuthors` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `title` on the `PaperAuthors` table. All the data in the column will be lost.
  - The primary key for the `Paper` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `file` on the `Paper` table. All the data in the column will be lost.
  - The primary key for the `ReviewPapers` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `title` on the `ReviewPapers` table. All the data in the column will be lost.
  - Added the required column `paperId` to the `PaperAuthors` table without a default value. This is not possible if the table is not empty.
  - The required column `fileId` was added to the `Paper` table with a prisma-level default value. This is not possible if the table is not empty. Please add this column as optional, then populate it before making it required.
  - The required column `paperId` was added to the `Paper` table with a prisma-level default value. This is not possible if the table is not empty. Please add this column as optional, then populate it before making it required.
  - Added the required column `paperId` to the `ReviewPapers` table without a default value. This is not possible if the table is not empty.

*/
-- CreateTable
CREATE TABLE "PaperFiles" (
    "fileId" TEXT NOT NULL PRIMARY KEY,
    "title" TEXT NOT NULL,
    "fileName" TEXT NOT NULL,
    "file" BLOB NOT NULL,
    CONSTRAINT "PaperFiles_fileId_fkey" FOREIGN KEY ("fileId") REFERENCES "Paper" ("fileId") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_PaperAuthors" (
    "paperId" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "fname" TEXT NOT NULL,
    "lname" TEXT NOT NULL,
    "affil" TEXT NOT NULL,
    "isPresenter" BOOLEAN NOT NULL,

    PRIMARY KEY ("email", "paperId"),
    CONSTRAINT "PaperAuthors_paperId_fkey" FOREIGN KEY ("paperId") REFERENCES "Paper" ("paperId") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "PaperAuthors_email_fkey" FOREIGN KEY ("email") REFERENCES "User" ("email") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "PaperAuthors_affil_fkey" FOREIGN KEY ("affil") REFERENCES "Institution" ("institution") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_PaperAuthors" ("affil", "email", "fname", "isPresenter", "lname") SELECT "affil", "email", "fname", "isPresenter", "lname" FROM "PaperAuthors";
DROP TABLE "PaperAuthors";
ALTER TABLE "new_PaperAuthors" RENAME TO "PaperAuthors";
CREATE TABLE "new_Paper" (
    "paperId" TEXT NOT NULL PRIMARY KEY,
    "title" TEXT NOT NULL,
    "abstract" TEXT NOT NULL,
    "score" INTEGER NOT NULL,
    "fileId" TEXT NOT NULL,
    "fileName" TEXT,
    "size" INTEGER,
    "overall" TEXT,
    "contributions" TEXT,
    "strengths" TEXT,
    "weaknesses" TEXT
);
INSERT INTO "new_Paper" ("abstract", "fileName", "score", "size", "title") SELECT "abstract", "fileName", "score", "size", "title" FROM "Paper";
DROP TABLE "Paper";
ALTER TABLE "new_Paper" RENAME TO "Paper";
CREATE UNIQUE INDEX "Paper_fileId_key" ON "Paper"("fileId");
CREATE TABLE "new_ReviewPapers" (
    "paperId" TEXT NOT NULL,
    "id" TEXT NOT NULL,

    PRIMARY KEY ("paperId", "id"),
    CONSTRAINT "ReviewPapers_id_fkey" FOREIGN KEY ("id") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "ReviewPapers_paperId_fkey" FOREIGN KEY ("paperId") REFERENCES "Paper" ("paperId") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_ReviewPapers" ("id") SELECT "id" FROM "ReviewPapers";
DROP TABLE "ReviewPapers";
ALTER TABLE "new_ReviewPapers" RENAME TO "ReviewPapers";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
