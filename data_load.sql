CREATE TABLE "example_table" (
    "id" SERIAL PRIMARY KEY
  , "col1" VARCHAR(12) NOT NULL
  , "col2" INTEGER NOT NULL
)
;

COPY "example_table" ("col1", "col2")
    FROM '/usr/data/example.csv'
    CSV
    DELIMITER ','
    QUOTE '"'
    ESCAPE '\'
    NULL '\N'
;
