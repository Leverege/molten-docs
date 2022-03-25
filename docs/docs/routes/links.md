# Links

Links to a Screen can be done in many ways. Any standard component can change the URL when told to do so by the user. In the case of the default Molten Desktop Screen, toolbars are install to allow th user to put custom actions to perform a variety of commands such as logging out, changing persona, bring up a dialog, or going to a URL. 

To got to our new Route and Screen using the toolbars, we can use the `LinkAction.create()` to create an action that will integrate with the existing menus. The following options can be given to the create function:

| Field | Type | Description |
|-------|------|-------------|
| id | String | The unique plugin id |
| matches | Object | An object specifying where the the Action should appear. Normally, the `client` is specified and in come cases an even finer criteria |
| layout | Object | The Plugins Layout object that can specify where the action should appear, including submenuing, section names and sorting. See [Layout](/docs/plugins/layout/) |
| path | String | The URL path to take the user to |
| name | String or funciton | The name of string to show the user |
| icon | String | The font icon or url to use as an icon for the action |
| iconOn | String | The font icon or url to use as an icon for the action when the user is at the path. |
| iconOff | String | The font icon or url to use as an icon for the action when the user is not at the path |
| handles | function | The action handles method that can be used to further refined if this action is visible |

## Example

=== "Plugin"
    File **IncredibleLink.js**.
    ```javascript
      export default LinkAction.create( {
        id : 'my.link.IncredibleScreen',
        matches : { use : 'userBar', client : 'Main' },
        name : 'Incredible', 
        icon : 'fa fa-snowflake-o fa-fw',
        path : '/iscreen'
      } )
    ```
    In this case, we are going to put the link to `/iscreen` into the Main Screen's user profile toolbar (targeted by using `use : "userBar"`) with the name "Incredible" and a snowfake icon.
=== "Setup"
    Be sure to install your plugin in your **PluginSetup.js** file.
    ``` javascript
      exports.install = ( molten ) => {
        molten.addPlugin( 'Action', IncredibleLink )
      }
    ```
