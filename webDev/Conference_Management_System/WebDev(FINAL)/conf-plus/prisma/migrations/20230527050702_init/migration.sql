-- DropIndex
DROP INDEX "Paper_title_key";

-- CreateTable
CREATE TABLE "PaperAuthors" (
    "title" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "fname" TEXT NOT NULL,
    "lname" TEXT NOT NULL,
    "affil" TEXT NOT NULL,
    "isPresenter" BOOLEAN NOT NULL,

    PRIMARY KEY ("email", "title"),
    CONSTRAINT "PaperAuthors_title_fkey" FOREIGN KEY ("title") REFERENCES "Paper" ("title") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "PaperAuthors_email_fkey" FOREIGN KEY ("email") REFERENCES "User" ("email") ON DELETE RESTRICT ON UPDATE CASCADE
);
