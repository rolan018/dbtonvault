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

Add connection parameters to the database in `profiles.yml` file

Add packages to `dbt_packages`: automate-dv and dbt_utils

Pay attention to the file `packages.yml` ([Packages file](https://docs.getdbt.com/docs/build/packages#how-do-i-add-a-package-to-my-project)) where you need to specify the location of the installed packages

And **Finaly Command** to install:
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