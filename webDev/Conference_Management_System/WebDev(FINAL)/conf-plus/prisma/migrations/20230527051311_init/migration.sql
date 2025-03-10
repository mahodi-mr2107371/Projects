-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_PaperAuthors" (
    "title" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "fname" TEXT NOT NULL,
    "lname" TEXT NOT NULL,
    "affil" TEXT NOT NULL,
    "isPresenter" BOOLEAN NOT NULL,

    PRIMARY KEY ("email", "title"),
    CONSTRAINT "PaperAuthors_title_fkey" FOREIGN KEY ("title") REFERENCES "Paper" ("title") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "PaperAuthors_email_fkey" FOREIGN KEY ("email") REFERENCES "User" ("email") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "PaperAuthors_affil_fkey" FOREIGN KEY ("affil") REFERENCES "Institution" ("institution") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_PaperAuthors" ("affil", "email", "fname", "isPresenter", "lname", "title") SELECT "affil", "email", "fname", "isPresenter", "lname", "title" FROM "PaperAuthors";
DROP TABLE "PaperAuthors";
ALTER TABLE "new_PaperAuthors" RENAME TO "PaperAuthors";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
