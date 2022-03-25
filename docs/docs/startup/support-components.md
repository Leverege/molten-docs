# Support Component Plugins

The Plugins installed at `Constants.SUPPORT_COMPONENTS` or `'Molten.SupportComponent'` are invoked just before the Providers. These plugins should have an `id`, `sort`, and `createSupportComponents( molten )` function as properties. This function should an array of components to be placed beside the Application. Support components like Toast and Dialogs can use this.

In the React world, these components are used to install components to support the final app. They are siblings of the Main application and exist within the providers:
``` javascript
  <X.Provider>
    <AuthCheckScreen/>
    <MySypportComponent/>
    <Toast/>
    <Dialogs/>
    <...other Support Components...>
  </X.Provider>

```

The plugin should have a **createSupportComponents( molten )** function that returns an array of support components to install.

## Example

=== "Plugin"
    File **MySupportComponent.js**.
    ```javascript

      export default {
        id : 'molten.Theme',
        sort : 0, 
        createSupportComponents : ( molten ) => {
          return [
            React.createElement( Toast, { key : 'theme.toast', containerId : 'default' } ),
            React.createElement( Dialogs, { key : 'theme.dialogs' } )
          ]
        }
      }
    ```
=== "Setup"
    Be sure to install your plugin in your **PluginSetup.js** file.
    ``` javascript
      Plugin.add( 'Molten.SupportComponents', MySupportComponent )
    ```

## Default Support Components

| Type | Sort | Description |
|------|------|-------------|
| molten.Theme | 0 | This will install Toast and Dialogs support |


