-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "userRole" TEXT NOT NULL,
    CONSTRAINT "User_userRole_fkey" FOREIGN KEY ("userRole") REFERENCES "Role" ("role") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Role" (
    "role" TEXT NOT NULL PRIMARY KEY
);

-- CreateTable
CREATE TABLE "Paper" (
    "title" TEXT NOT NULL PRIMARY KEY,
    "abstract" TEXT NOT NULL,
    "score" INTEGER NOT NULL,
    "fileName" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "Reviewers" (
    "title" TEXT NOT NULL,
    "id" TEXT NOT NULL,

    PRIMARY KEY ("title", "id"),
    CONSTRAINT "Reviewers_id_fkey" FOREIGN KEY ("id") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Reviewers_title_fkey" FOREIGN KEY ("title") REFERENCES "Paper" ("title") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Paper_title_key" ON "Paper"("title");

-- CreateIndex
CREATE UNIQUE INDEX "Paper_fileName_key" ON "Paper"("fileName");
