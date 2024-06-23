Welcome to DWHVAULT!

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

