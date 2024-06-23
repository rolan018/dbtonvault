# DWH on DBT and Vault (with [Automate_dv](https://automate-dv.readthedocs.io/en/latest/))
Automate_DV and dbt_utils packages are installed in
```
dbt/dwhvault/dbt_packages
```
Pay attention to the file
```
dbt/dwhvault/packages.yml
```

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


## DBT
```
cd ./dbt/dwhvault
```
In Docker container
```
docker exec -it <container_name> bash

cd dwhvault 
```


# Finish work
```
docker-compose --env-file .all-env down 
```