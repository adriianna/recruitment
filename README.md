## Table of contents
* [General info](#general-info)
* [Task1](#task1)
* [Task2](#task2)
* [Task3 / Optional task](#task3)

### General info
Solution structure:
```
recruitment
│   README.md   
│
└───task1
│   │   task1_input.tsv
│   │   url_parser.py
│   │   requirements.txt
└───task2
│   │   docker-compose.yaml
│   │   .env
│   └───postgres_input_data
│   │   │   project_properties.csv
│   │   │   project_properties_values.csv
│   └───scripts
│   │   │   setup.sql
└───task3
    │   task3.sql
```
### Task1
* Python version: 3.8.10
* Additional libraries: requirements.txt
* The solution url_parser.py assumes that input data tsv is placed in the same directory (otherwise script would fail).
* Output .tsv file would be saved in the same directory.

### Task2
* For short-track review go to task2/scripts/setup.sql 

Solution for task 2 is dockerized.
* For simplified review purpose there's .env file included. \
Feel free to change any variable you need (especially ports for mapping - in case those from .env are already in use).
* Variables with PG_ prefix belong to postgresql database settings./
* Variables with PGADMIN_ prefix belong to pgadmin settings.
To run this project change directory for /task2 and use :
```
docker-compose build
docker-compose up
```

docker-compose structure: 
1. pgdatabase_td 
 * database container with init sql script 
2. pgadmin_td 
 * pgadmin container
 * tool is avaliable on localhost:9090 (by default) or localhost:${PGADMIN_PORT} (.env variable)
 * passwords for login are in .env file (admin@admin.com/root by default)
 * to connect to pgdatabase_td database you need to register new server with the following settings: \

    General/name: up to you \
    Connection/Host name: pgdatabase_td \
    Connection/Port: 5432 \
    Connection/Username: postgres (by default; $PG_USER from env) \
    Connection/password: root (by default; $PG_PASSWORD from env) 
 

 * View: marketing_program
    

### Task3 / Optional task
 * sql statement can be found in task3.sql

