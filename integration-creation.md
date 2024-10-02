# Workflow for loading data (after an integration is available in the app)
1. Go to the merchant you will be doing this for
2. Enable integration if not yet enabled (Account > Access > check enabled)
3. Create a new integration (`Integrations > New Integration`) 
    a. Use default values 
    b. If asked to, fill source name as "USA"
4. Compare pattern between integration & flat file 
    a. Rename flat file if needed
5. Find file location in S3 and load all of the types of files (one of each) used for this integration
6. Note date range in files & do historical load of that file.
7. Go to Workflows (`Devops > Workflows`) and confirm completion of that
8. Find the destination table from the integration, confirm the presence of filled data. 


## FAQ

### What if when checking for data, there's none loaded? (8) 
1. Go back and check the workflow and look for any error there. 
2. Confirm the file in S3 has data rows
3. Confirm file name has no spaces and no special characters in it
    a. If the integration itself has these in the spec, update the integration. Be sure to remove those from the .yml template also

