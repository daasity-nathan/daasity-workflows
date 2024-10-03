# Producing transform code for a URS/URMS pipeline
1. Ensure the data is available in the `Retail Dev: Snowflake` merchant
2. Locate the "source -> destination mapping" Google Sheet for this pipeline.
    a. note the source id for this source, as specified in that spreadsheet. 
3. Update the file `config/integrations_map.yml` and push to master
    a. _the SQL Manifests feature looks to master's mapping of the sources, that's why this is needed_
