CREATE TABLE `Customer`(
    `id` LINESTRING NOT NULL,
    `companyName` LINESTRING NOT NULL,
    `street` LINESTRING NOT NULL,
    `city` LINESTRING NOT NULL,
    `country` LINESTRING NOT NULL,
    `firstName` LINESTRING NOT NULL,
    `lastName` LINESTRING NOT NULL,
    `email` LINESTRING NOT NULL,
    `mobile` LINESTRING NOT NULL,
    PRIMARY KEY(`id`)
);
CREATE TABLE `Invoice`(
    `id` LINESTRING NOT NULL,
    `customerId` LINESTRING NOT NULL,
    `customerName` LINESTRING NOT NULL,
    `amount` DOUBLE NOT NULL,
    `invoiceDate` LINESTRING NOT NULL,
    `dueDate` LINESTRING NOT NULL,
    PRIMARY KEY(`id`)
);
CREATE TABLE `Payment`(
    `id` LINESTRING NOT NULL,
    `invoiceNo` LINESTRING NOT NULL,
    `amount` DOUBLE NOT NULL,
    `paymentDate` LINESTRING NOT NULL,
    `paymentMode` LINESTRING NOT NULL,
    `chequeNo` BIGINT NOT NULL,
    PRIMARY KEY(`id`)
);
CREATE TABLE `Cheque`(
    `chequeNo` LINESTRING NOT NULL,
    `amount` DOUBLE NOT NULL,
    `drawer` LINESTRING NOT NULL,
    `bankName` LINESTRING NOT NULL,
    `status` LINESTRING NOT NULL,
    `receivedDate` LINESTRING NOT NULL,
    `dueDate` LINESTRING NOT NULL,
    `chequeImageUri` LINESTRING NOT NULL,
    PRIMARY KEY(`chequeNo`)
);
CREATE TABLE `Cheque-Deposits`(
    `id` LINESTRING NOT NULL,
    `depositDate` LINESTRING NOT NULL,
    `bankAccountNo` LINESTRING NOT NULL,
    `status` LINESTRING NOT NULL,
    `chequeNos` BIGINT NOT NULL,
    PRIMARY KEY(`id`)
);
ALTER TABLE
    `Payment` ADD CONSTRAINT `payment_invoiceno_foreign` FOREIGN KEY(`invoiceNo`) REFERENCES `Invoice`(`id`);
ALTER TABLE
    `Invoice` ADD CONSTRAINT `invoice_customerid_foreign` FOREIGN KEY(`customerId`) REFERENCES `Customer`(`id`);
ALTER TABLE
    `Cheque` ADD CONSTRAINT `cheque_drawer_foreign` FOREIGN KEY(`drawer`) REFERENCES `Customer`(`id`);
ALTER TABLE
    `Cheque-Deposits` ADD CONSTRAINT `cheque_deposits_chequenos_foreign` FOREIGN KEY(`chequeNos`) REFERENCES `Cheque`(`chequeNo`);
ALTER TABLE
    `Payment` ADD CONSTRAINT `payment_chequeno_foreign` FOREIGN KEY(`chequeNo`) REFERENCES `Cheque`(`chequeNo`);
ALTER TABLE
    `Payment` ADD CONSTRAINT `payment_id_foreign` FOREIGN KEY(`id`) REFERENCES `Customer`(`id`);