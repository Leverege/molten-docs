# Table

## Purpose
Unsurprisingly, the purpose of the Table module is to render tabular data. To do so, it needs a model, some data and a renderer.

### Model
The TableModel from the [@leverege/ui-attributes](https://bitbucket.org/leverege/ui-attributes){:target="_blank"} library provides all of the configuration options necessary to render a table component. THe only top-level option is whether each table row should be selectable, meaning whether a checkbox should be rendered to the left most side of each row to allow selection. The rest of the table model is dedicated to a list of Columns, each of which has their own options which are [documented elsewhere](columns). It is worth noting here however that ColumnCreators (objects that are capable of creating table column models) are automatically generated for each [Attribute](../../concepts/attributes) that is created, making attributes eligible for inclusion in a table by default.

### Data
The data for a table instance is simply an array of [object refs](../../concepts/attributes/data-sources).

### Renderer
The renderer for a Table is the [TableView](https://bitbucket.org/leverege/molten/src/development/src/dataViewers/table/TableView.jsx){:target="_blank"}, found in [@leverege/molten](https://bitbucket.org/leverege/molten){:target="_blank"}.

#### Actions Match
There are four toolbars within each table view that you can target to install [Actions](../../concepts/actions) with the following match contexts:

| Location | Match Context |
| ---------| --------------|
| Top Left | `{ use : 'filterBar', client : 'TableDataViewer | HistoryTableViewer', objectType, path }` |
| Top Right | `{ use : 'actionBar', client : 'TableDataViewer | HistoryTableViewer', objectType, path }` |
| Bottom Left | `{ use : 'footerLeft', client : 'TableDataViewer | HistoryTableViewer', objectType, path }` |
| Bottom Right | `{ use : 'footerRight', client : 'TableDataViewer | HistoryTableViewer', objectType, path }` |