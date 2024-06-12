# DWH on DBT and Vault (with [Automate_dv](https://automate-dv.readthedocs.io/en/latest/))

## Start project
```
docker-compose --env-file .all-env  up -d 
```
```
dbt init dwhvault
```
```
dbt deps 
```

## Data generator (golang project)
Make migrations (Up)
```
go run .\cmd\migrator\main.go --mode="up"
```
Make migrations (Down)
```
go run .\cmd\migrator\main.go --mode="down"
```
Run generator with N rows
```
go run .\cmd\main.go --numRows="N"
```

## Changed automate_dv files


## DBT
Run dbt models with vars
```
dbt run --vars '{"key": "value", "date": 20180101}'
dbt run --vars '{key: value, date: 20180101}'
dbt run --vars 'key: value'
```