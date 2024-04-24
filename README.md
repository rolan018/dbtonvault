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
