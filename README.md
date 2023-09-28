# Fetch-Mobile-Assessment

A native iOS app that retrieves the data from https://fetch-hiring.s3.amazonaws.com/hiring.json

Displays a list of items to the user based on the following requirements:
- Items grouped by "listId"
- Sorted the results first by "listId" then by "name" when displaying.
- Filtered out any items where "name" is blank or null.
