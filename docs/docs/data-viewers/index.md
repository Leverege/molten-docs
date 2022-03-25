# Data Viewers

!!! Danger Update
    This is outdated

Data Viewers are widgets that are mean to display pieces of information about a common set of data. Usually, this common data is either a list of items (via `GroupScreen`) or a single item (via `ItemInfoScreen`). The top level controller that manages dataViewers will load the data as needed, but the DataViewers can have some control to effect which data is loaded. In the `GroupScreen` usage, data viewers are given a filters object by which they can contribute filters.

## Location

DataViewers are presented in a Layout. The root Layout consists of two main sections and four surrounding auxilary sections ( top, bottom, left, right ). These sections are fixed to the screen current screen size, meaning that they do now scroll off the screen: the top is fixed to the top of the area, the bottom to the bottom, left and right to the sides, and the remaining section is divided amoungst the two main sections. Any one of these sections can be null, in which case their space is given to the appropriate section. Within these sections, a Dashboard layout can be created to construct a screen where there are a lot of DataViewers. The dashboard will scroll within its area. A DataViewer can indicate which of this locations they are usable in by specifying an array containing `main`, `aux`, or `card` in their location field. 

There are also Hidden DataViewers, whose purpose is to load or prepare other data. It should be a viewless component, meaning its render function returns null.

Support DataViewers also exist, and implement the same interface. They are meant to be used by other DataViewers and not directly selected for use. 

To specify a hidden or support DataViewer, set location to be `hidden` or `support`.

# Group Screen

# Group Data Viewers

GroupDataViewers are controlled and organized by the GroupScreen. They will receive the current data, pagination information, filtering information and various keys to help them organize themselves. They can also contribute filters and sort values back to the overall group.

## Installing
To install a plugin, use the following:

```javascript
// Plugins.add( 'GroupDataViewer', ... ) can also be used
molten.addPlugin( 'GroupDataViewer', { 
  id,
  type : 'table',
  icon : 'fa fa-list fa-fw',
  name : 'Table View',
  location : 'aux|main|any', // null => main. Array is also allowed
  handles : ( relationship ) => { return true }
  component,
  createSettings,
  updateSettings,
  props : { mode : 1 }
} )
```

| Prop | Type | Description |
|------|------|-------------|
| id | string | The unique plugin id |
| type | string | The unique type of the DataViewer. |
| icon | string | The url or font icon class name of the image used to represent the icon. |
| name | string | The human readable name of the plugin |
| location | string | Where the DataViewer is usable. `primary` means only the main sections, where they components must fill 100% of width and height. `aux` means only the header sections, where based on the `vertical` prop, the component should take up 100% of width or height, but not both. The other axis should be limited (and relatively small). This is meant for aggregations, rollups, extra command bars, etc. If left null, this will mean `primary`. If a component can be both, `any` can be specified. The value of the `vertical` prop will be undefined when it is used in a `primary` capacity. |
| handles | function | A function that takes a `relationship` object and returns true if the DataViewer can function with the data.|
| component | React | A react component |
| props | object | An options object that will be given to the component |



## Props

The GroupScreen will supply the following as props to each DataViewers

| Prop | Type | Description |
|------|------|-------------|
| dispatch | object | The redux dispatch |
| match | object | The connected react router match object |
| location | object | The connected react router location object |
| history | object | The connected react router history object |
| profile | object | The current users profile |
| objectType | string | The object type, which is the blueprint's alias or id |
| data | object | The current data. The data.items maybe sparce if multiple non-sequential pages have been loaded. Use the pagination to access a single page. The values in data are { status, perPage, page, count, items } |
| relationship | object | The relationship object for current viewed group of data |
| actons | object | An object used to request creations, delections, etc from the server. The actions should be dispatched. |
| filter | object | The FilterSourceModel contributed by this data screen |
| filterName | string | The name of the FilterSourceModel in the FilterSourcesModel. This should be supplied as the 'data' filed in the onFilterChange() event. |
| onFilterChange | function | Invoke this when the data screen wishes to change its contribution to the filter and sort. The argument should be an event contining { data : filterName, value : newFilterModelObject } |
| filters | object | The FilterSourcesModel |
| selectionKey | string | The key used with Selections to manage objects that are selected |
| rolloverKey | string | The key used with Selections to manage objects that are rolled over |
| targetKey | string | The key used with Selections to manage objects that are targeted |
| settingsPath | string | The path used with UserSettings to save data. |
| paginator | object | The object used to manage pagination. |
| vertical | boolean | If the DataViewer is used in a header/footer capacity, this will indicate the direction the component will be layed out. This is undefined for primary DataViewers. |

## Hidden Group Screen Viewers

Occasionally it is useful to have a group screen viewer installed at a path which does not 
render any visible UI but which still has the ability to contribute things like filters 
to the group screen. This can be accomplished by registering a GroupDataViewer with the 
location of 'hidden'. You can also add a 'matches' property to this plugin which will allow
you to only render your hidden viewer for certain paths,object types, etc. The name and icon 
properties of the GroupDataViewer become unnecessary in this context.

**NOTE: As a matter of convention, your hidden component should return null from its function body or render method. However, your component will also be wrapped in a display: none; div and will not be visible**

For example:
```
molten.addPlugin( 'GroupDataViewer', {
  type : 'ghost',
  location : 'hidden',
  matches : {
    objectType : 'cow'
  },
  handles : () => true,
  component : HiddenTest,
  props : { dude : 'Sweet!' }
} )
```
This plugin will render for all pages with objectType === 'cow' and will be passed its own set of filters, etc 
which it can use to contribute to the group screen.

see `demo/dataViewer/PluginSetup.js` for a working example