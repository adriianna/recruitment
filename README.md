## Table of contents
* [General info](#general-info)
* [Task1](#task1)
* [Task2](#task2)

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
│       │   setup.sql
```
### Task1
* Python version: 3.8.10
* Additional libraries: requirements.txt
* The solution url_parser.py assumes that input data tsv is placed in the same directory (otherwise script would fail).
* Output .tsv file would be saved in the same directory.

### Task2
Solution for task 2 is dockerized.
To run this project use :
```
docker-compose build
docker-compose up
```
