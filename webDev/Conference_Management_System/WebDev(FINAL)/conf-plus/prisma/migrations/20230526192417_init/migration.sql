/*
  Warnings:

  - You are about to drop the `Reviewers` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "Reviewers";
PRAGMA foreign_keys=on;

-- CreateTable
CREATE TABLE "ReviewPapers" (
    "title" TEXT NOT NULL,
    "id" TEXT NOT NULL,

    PRIMARY KEY ("title", "id"),
    CONSTRAINT "ReviewPapers_id_fkey" FOREIGN KEY ("id") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "ReviewPapers_title_fkey" FOREIGN KEY ("title") REFERENCES "Paper" ("title") ON DELETE RESTRICT ON UPDATE CASCADE
);
