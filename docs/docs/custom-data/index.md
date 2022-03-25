# Adding Custom Data

A common need in molten is the consumption of data that is external to the leverege platform. That data might be stored locally in files, accessible through a 3rd party API, or elsewhere. Assuming the data is roughly structured as a group of items with individual items within it, the process for consuming and displaying this data on custom pages within a molten application are as follows:

1. Create actions classes that mirror the Group and Item Actions
2. Create a DataSource object to make those actions available
3. Add custom Atrribute plugins to let the ui configure viewing the data
4. Make a custom route that uses GroupScreen to view the data
5. Add custom actions to CRUD the data (optional)
6. Customize the search features (optional)

This section of the documentation will serve as a tutorial for how to perform these actions and, in particular, how to set up a pet shop demo in molten that manages a list of pets