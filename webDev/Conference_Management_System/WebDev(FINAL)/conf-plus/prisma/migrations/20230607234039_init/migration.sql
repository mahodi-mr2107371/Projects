/*
  Warnings:

  - The primary key for the `Session` table will be changed. If it partially fails, the table could be left without primary key constraint.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Session" (
    "title" TEXT NOT NULL PRIMARY KEY,
    "location" TEXT NOT NULL,
    "date" TEXT NOT NULL,
    "fromTime" TEXT NOT NULL,
    "toTime" TEXT NOT NULL,
    "acceptedTitle" TEXT NOT NULL,
    "acceptedAbstract" TEXT NOT NULL,
    CONSTRAINT "Session_location_fkey" FOREIGN KEY ("location") REFERENCES "Location" ("location") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Session_date_fkey" FOREIGN KEY ("date") REFERENCES "Date" ("date") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Session_acceptedTitle_acceptedAbstract_fkey" FOREIGN KEY ("acceptedTitle", "acceptedAbstract") REFERENCES "Paper" ("title", "abstract") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_Session" ("acceptedAbstract", "acceptedTitle", "date", "fromTime", "location", "title", "toTime") SELECT "acceptedAbstract", "acceptedTitle", "date", "fromTime", "location", "title", "toTime" FROM "Session";
DROP TABLE "Session";
ALTER TABLE "new_Session" RENAME TO "Session";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
