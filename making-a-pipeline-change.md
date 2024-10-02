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
1. Open a query--running console where you can run the query to make the change
2. Identify which file(s) need to be changed
    a. Create a secondary test if it is helpful, make sure to maintain the main test.
3. Make change to file, run query, run test
    a. Avoid making formatting changes, to ensure clean commits
4. Repeat `3` until passing
5. Run all files needed to ensure primary test passes.
    a. If fails, revisit `2`.
6. Commit and push changes
7. Reset for this source (drop the schema), log into Daasity app, and re-run the whole workflow with these changes
    a. Run from the proper branch being used
8. Run test and ensure passing
9. Make any final formatting commits
    a. Good to also look for places where the comments can be improved
10. Create PR. Add link to Asana card in PR
    a. Give a short description followed by the link
    b. If there are related changes to be made on this branch:
        1. make the PR into a "draft" (CLI: `gh pr ready --undo`)
        2. restart from (1) in the prep section above
11. Post a link to the PR to shared `gh product pr` channel in Slack
    a. Give a short description
    b. Tag a specific individual to review
    
