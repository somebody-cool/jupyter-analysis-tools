An environment for reproducible data analysis. The environment includes pyenv, poetry, a configurable python version, a postgres database, and packages typical of statistical workloads, running on a ubuntu base image. Run `docker-compose up jupyter-analysis` to build and spin up a jupyter server and a postgres database.

If an analysis requires input data
  1. Placing it in the data folder will cause it to be cloned into the postgres database's volume
  2. Define the database schema and copy using the `data_load.sql` command and data for data to be automatically loaded the postgres container's build stage

If the data requires some preprocessing, such as for gnarly CSVs, first use `docker-compose up munge_date && docker-compose down`.
