# Data Viewers

Data Viewers are widgets that are used to display viewers and editors about a certain data set. The root controller will load the base data and supply it to the data viewers as props. The root controller will manage the layout and its models, which allows data viewers to be added and removed in particular locations. The root Layout consists of two main sections and four surrounding auxilary sections ( top, bottom, left, right ). These sections are fixed to the screen current screen size, meaning that they do now scroll off the screen: the top is fixed to the top of the area, the bottom to the bottom, left and right to the sides, and the remaining section is divided amongst the two main sections. Any one of these sections can be null, and its space is given to the other data viewers. A special DashboardDataViewer that support Cards allows these sections to be further divided and scrolled.

DataViewers are made available for use via the Plugins mechanism under the key `DataViewer`. DataViewer plugins will act handle to the various parts of the DataViewer: the name/usage, the DataViewer's settings model, and the React component used to display the data to the user. The DataViewer's interface looks like this:


| Filed | Type | Description |
|------|------|-------------|
| id | string | The unique DataViewer plugin id |
| type | string | The unique type of the DataViewer. |
| name | string | The human readable name of the plugin |
| icon | string | The url or font icon class name of the image used to represent the icon. |
| location | string or array of strings | Specifies where in the layout the DataViewer is usable. See [Locations](#location-strings) |
| matches | object or function | This is used to determine if the DataViewer should be used in controllers layout. See [below](#match-context).|
| createSettings | function(props) | Creates and returns the DataViewer's Settings model. | 
| updateSettings | funciton | Optional function( { settings, props } ) to allow upgrading of the settings model. |
| component | React.Component | A react component to use to render. Only this or `render` should be supplied. |
| render | function | A function given props. It should return the create react component. Only this or `component` should be supplied. |
| getCardTitle | function | Used with `card` location. A `function( model, dashboardContext )` that returns the card's title, if it is visible |
| getCardIcon | function | Used with `card` location. A `function( model, dashboardContext )` that returns the card's icon, if it is visible |
| getCardRequired | function | Used with `card` location. This `( model, factory, dashboardContext )` returns the required support models/editors that should be present at the dashboards root.
| getCardMenuEditor | function | Used with `card` location. A `function( props )` that returns an editor for the card's editor menu. |
| getCardFooterEditor | function | Used with `card` location. A `function( props )` that returns an editor for the card footer. |
| getDefaultCardContentOptions | object or function | Used with `card` location. A `function( props, dashboardContext )` that returns an object that can specify the card contents height, minHeight, and maxHeight. or an object such as { height : '300px' }. The props are the same as the dashboardContext.sharedProps object, which will the props given to the DataViewer. | 
| getDefaultCardOptions | object or function | Used with `card` location. A `function( props, dashboardContext )` that returns an object that can specify the card default card options, such as width (span), height (span), style, titleVisible or or an object such as { width : 2 } The props are the same as the dashboardContext.sharedProps object, which will the props given to the DataViewer |





## Match Context
Not all DataViewers will work with all root controllers. The DataViewers will use the [match](../../concepts/plugins/refinement.md) mechanism to determine if the root controller supplies the appropriated context that will allow the DataViewer to work. The root controller defines the match context used when determining the possible DataViewers to use and can consist any fields. In Molten, the GroupScreen and ItemInfoScreen are used alot. Their match contexts look like this:

| Match Field | Value | Meaning |
|-------------|-------|---------|
| type | 'GroupDataViewer' or 'ItemInfoDataViewer' | This is legacy, and defines a similar concept as the client below. |
| client | 'GroupScreen' or 'ItemInfoScreen' | This is the type of the root controller. |
| clientType | string | The specific client type. If the implementation does not supply this, it will be either 'GroupScreen' or 'ItemInfoScreen' |
| path | string | The relationship path |
| objectType | string | The type of objects at the relationship path |
| relationship | Relationship | The relationship object |
| mobile | boolean | True or false depending on if this is a mobile client or desktop client |


## Location Strings

DataViewers can restrict where they can be used via its location field:

| Location String | Meaning |
|-----------------|---------|
| main | This DataViewer can be used the two center layout sections. |
| aux | This DataViewer can be used the on of the four auxilary sections. |
| card | This DataViewer can be used as a card in the DashboardDataViewer. Its DataViewer can have card specific functions. |
| any | This is the same as [ 'main', 'aux', 'card' ] |
| hidden | All hidden data viewers are loaded for the layout, but will not be seen. The purpose of hidden DataViewers is to load or prepare other data. It should be a viewless component, meaning its render function returns null. |
| support | Not for use by the root controller, but meant as support for other DataViewers. |

## Example

=== "DataViewer"
    File **MyDataViewer.js**.
    ```javascript
      import I18N from '@leverege/i18n'
      const { tf, tfIcon } = I18N.ns( 'my.MyDataViewer' )

      export default {
        id : 'my.MyDataViewer',
        type : 'my.MyDataViewer',
        name : tf( 'name' ),
        icon : tfIcon( 'configIcon' ),
        location : [ 'main' ],
        matches : { client : 'GroupScreen },
        createSettings : ( props ) => {
          return MyDataViewerModel.create()
        },
        settingsUpdaters : ( { settings, ...opts } ) => { },
        component : MyDataView,
      }
    ```
=== "Setup"
    Be sure to install your plugin in your **PluginSetup.js** file.
    ``` javascript
      molten.addPlugin( 'DataViewer', MyDataViewer )
    ```


## GroupScreen and ItemInfoScreen DataViewer Props

When a DataViewer is used in a GroupScreen or ItemInfoScreen, the following props will be supplied the Component or render function.

| Prop | Type | Description |
|------|------|-------------|
| ... | | All of the fields in the [match context]( #match-context)|
| actions | object | Deprecated. The Delegate object |
| data | object | The current data. The data.items maybe sparce if multiple non-sequential pages have been loaded. Use the pagination to access a single page. The values in data are { status, perPage, page, count, items } |
| dataViewer | DataViewer | The DataViewer |
| dataViewerId | string | The id of the data from the LayoutModel |
| dataViewerInstanceId | string | An id tied to the current incarnation of the data viewer component. Useful as a key in dashboard style layouts. Using dataViewerId in a situation like this can lead to duplicate ids when a data viewer's model is copied |
| dataViewerModel | object | The DataViewerModel |
| dataViewers | DataViewer | Object containing the available data viewers and context. { context : {...}, dataViewers : [...] } |
| delegate | object | An object used to request creations, delections, etc from the server. The actions should be dispatched. |
| dispatch | object | The redux dispatch |
| filter | object | The FilterSourceModel. This is only present in the GroupScreen.  |
| filterName | string | The key used to store the filter object within the FilterSourcesModel. Used as then `data` property when calling the onFilterChange function. This is only present in the GroupScreen.  |
| filters | object | The FiltersSourceModel. This is only present in the GroupScreen.  |
| history | object | The connected react router history object |
| isMobile | boolean | repeat of mobile |
| item | ObjRef | The current object ref. This is only present in the ItemInfoScreen. |
| layout | object | The root layout model. (GroupScreen only)|
| loading | boolean | True if the data is being loaded |
| location | object | The connected react router location object |
| match | object | The connected react router match object |
| mobile | boolean | Whether or not the device is mobile sized |
| model | boolean | The `settings` component of the dataViewerModel |
| objectType | string | The object type, which is the blueprint's alias or id |
| onFilterChange | function | Invoke this when the data screen wishes to change its contribution to the filter and sort. The argument should be an event contining { data : filterName, value : newFilterModelObject }. This is only present in the GroupScreen. |
| onSettingsChange | function | the function to call to modify the settings object.
| overrideModel | Obejct| The current overrides for this data viewer. May be null. Key value pairs set using overrides. |
| overrides | Obejct | Use overrides.set( dataViewerId, key, value ) to store settings outside of settings model. |
| paginator | object | The object used to manage pagination. |
| parentItem | ObjRef | The parent object ref, if available. |
| path | string | The data path of the current screen (e.g. location.vehicles) |
| profile | object | The current users profile |
| reloadData | function | A function to call to retrigger data loading |
| rollover | object | The Rollover object containing any rolled-over ObjRefs |
| rolloverKey | string | The key used with Selections to manage objects that are rolled over |
| selection | object | The Selection object containing any selected ObjRefs |
| selectionKey | string | The key used with Selections to manage objects that are selected |
| settings | object | The DataViewer's settings model: { id, type, settings } |
| settingsData | any | DataViewers must give this as the data option to the change event fired in onSettingChanged |
| settingsPath | string | The path used with UserSettings to save data. |
| targetKey | string | The key used with Selections to manage objects that are targeted |
| targeted | object | The Targeted object containing any targeted ObjRefs |
| vertical | boolean | If the DataViewer is used in a header/footer capacity, this will indicate the direction the component will be layed out. This is undefined for primary DataViewers. |
