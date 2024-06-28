Welcome to DWHVAULT!


## Load strategies
Be careful, the model is based on ***INCREMENTAL*** loading of objects(hubs, sats, links). 

The `macros/incrementals/incremental_strategies` file defines incremental loading strategies for all objects(hubs, sats, links).

The incremental strategies are called `snapshot_<object>` because the source transmits the source data for the models in a ***COMPLETE SLICE***, which are in the scheme `stage`.

Source is a `data-generator` (go-service) whose data model is located here `data-generator/models`

## Custom Macroses
The `macros` folder contains custom macroses. 

`macros/vault` contain scripts for the formation of the main data vault objects. 
The basis is taken from the [Automate_dv](https://automate-dv.readthedocs.io/en/latest/) package and has been completely redesigned for the tasks of fast unloading and custom data schema in the model.

`macros/log` - for logging.

`macros/schema` - custom schema name.

`macros/incrementals` - incremental load generation scripts, including various increment strategies.

`macros/stage_vault/hash` - a script for generating a hash of fields for primary keys, foreign keys, etc.

## Work with load_date
To work with the load_date, the "source_date" or others variables is described inside the model. 
There are 2 ways to use this variable. 
1 - Set the value of the variable in the dbt_project.yml file in the VARS section. 
```
dwhvault/dbt_project.yml

# VARS
vars:
  source_date: '2024-10-01'
```

2 - Explicitly run the model specifying a variable.
Run dbt models with vars
```
dbt run --vars '{"key": "value", "date": 20180101}'
dbt run --vars '{key: value, date: 20180101}'
dbt run --vars 'key: value'
```
Example
```
dbt run --vars 'source_date: '2024-11-01'' -m customer_stage
```

