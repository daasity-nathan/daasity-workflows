# Making a Change to a URS/URMS Pipeline
## Prepare Requirements
1. Identify the Asana card related to this work. Keep this open.
2. Identify in the card where the exact changes needed are given
    a. If not given, fill these in a new comment on the card
3. Create a comment specifying the change that you will make
4. Identify the `__source_id`, and which merchant has this source built currently
    a. Confirm that there are rows that have this `__source_id`
    b. If the source hasn't been built, build it.
5. Identify the reporting table which has the data related to this change
    a. Open it in your query console (DataGrip, Snowflake, DBeaver, etc.)
    b. If it's multiple tables, write a query to join them together so that there's a single table which shows the data that needs changing
    c. _Make sure to use the mart if it's available_
6. Comparing `3` and `5a`, create a failing test
    a. Query should select from the table identified in `5a`, 
    b. The query should test to see if the change needed has been applied. 
        A. Since at this point the change has not been made, it should fail
    c. It's helpful to include a row count as well

## Make the Change


