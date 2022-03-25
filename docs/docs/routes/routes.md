# Routes

The Routes defines what to render, where. The what is a React component, and the where is a URL. The route is a directive to tell Molten to render a particular React component at a mathcing url pattern when certain criteria are met. The criteria is captured in the `matches` object defined by the plugin, and follows the rules of the Plugin Matches system.

To define a Route, add a `Route` Plugin that has the following properties:

| Field | Type | Description |
|-------|------|-------------|
| id | String | The unique plugin id |
| exact | boolean | If `true`, the URL must match exactly the path. This should be true in the case of a leaf screen, `false` in the case where the screen manages deeper parts of the url. For example, our `/Group/5` screen above would set this to `false` and then render its own `Switch` Component useing the `Routes` object. |
| path | String or Array<String>| The path expression used to match eg. `/group/:groupId` |
| matches | Object | An object specifying where the the route should appear. Normally, the `client` is specified |
| component | ReactComponent or Function | The component to render |
| render | function | Optional React function to render |
| props | Object or null | Extra props to send into the component. These can be overriden by extra props sent into the `getRoutesFor` function |
| strict | boolean | If true, the path will compare trailing slashes | default | boolean | Specifies that the route should be used as the default redirect |

## Example

=== "Plugin"
    File **IncredibleRoute.js**.
    ```javascript
      export default {
        id : 'my.route.IncredibleScreen',
        exact : true,
        path : '/iscreen/',
        matches : { client : 'Main' }, 
        component : IncredibleScreen,
        props : {
          hello : 'world'
        }
      }
    ```

    This plugin is asking Molten to render the `IncredibleScreen` when the URL path is exactly `/iscreen/`. It will only be matched at the top level Switch, managed by the `Main` client. Extra prop will be given to the screen. 

=== "Setup"
    Be sure to install your plugin in your **PluginSetup.js** file.
    ``` javascript
          exports.install = ( molten ) => {
            molten.addPlugin( 'Route', IncredibleRoute )
          }
    ```

## Dynamic Plugin Addition

The Routing mechanism is listening for changes to the routes, so Routes added during execution will be used the next time the Switch/getRoutesFor() is called.

The order in which the plugins are added does not matter. The order in which Routes are returned are based on a specificity. 

!!! Info "Sorting Paths"
    The routes are turned into strings of 'A's, 'C's, 'E's and 'R's, where 'A' are explicit path components, and 'C's are variable (changeable) parameters, 'E's are extact match and 'R's indicates the rest matches too. These will then be sorted first by length, then by string sort on the ACER strings.