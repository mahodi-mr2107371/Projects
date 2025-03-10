-- CreateTable
CREATE TABLE "Location" (
    "location" TEXT NOT NULL PRIMARY KEY
);

-- CreateTable
CREATE TABLE "Date" (
    "date" TEXT NOT NULL PRIMARY KEY
);

-- CreateTable
CREATE TABLE "Session" (
    "title" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    "date" TEXT NOT NULL,
    "fromTime" TEXT NOT NULL,
    "toTime" TEXT NOT NULL,
    "acceptedTitle" TEXT NOT NULL,
    "acceptedAbstract" TEXT NOT NULL,

    PRIMARY KEY ("title", "location"),
    CONSTRAINT "Session_location_fkey" FOREIGN KEY ("location") REFERENCES "Location" ("location") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Session_date_fkey" FOREIGN KEY ("date") REFERENCES "Date" ("date") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Session_acceptedTitle_acceptedAbstract_fkey" FOREIGN KEY ("acceptedTitle", "acceptedAbstract") REFERENCES "Paper" ("title", "abstract") ON DELETE RESTRICT ON UPDATE CASCADE
);
