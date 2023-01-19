
# Initializer Plugins
The Plugins installed at `Constants.INITIALIZER` or `'Molten.Initializer'` are invoked after as the first step in `Molten.create()`. These plugins should have an `id`, `sort`, and `init( molten )` function as properties. This function can be async and the next initializer in the chain will not be called until the one before it finishes.

Initializers can initialize objects from the config options (`molten.getConfig()`) and make them available to other steps by calling `molten.set( key, value )` or `molten.setThunk( key, )`.


## Example


=== "Plugin"
    File **MyInitializer.js**.
    ```javascript
      export default {
        id : 'my.Initializer',
        sort : -5, // defaults to 0, 
        init : ( molten ) => {
          const api = new Api( molten.getConfig( 'api' ) ) 
          molten.set( 'api' )
          molten.setThunkArg( 'api', api )
        }
      }
    ```
=== "Setup"
    Be sure to install your plugin in your **PluginSetup.js** file.
    ``` javascript
      Plugin.add( 'Molten.Initializer', MyInitialize )
    ```

## Default Initializers

The inital Molten setup will install the following plugins as **Initializer** Plugins.

| Type | Sort | Description |
|------|------|-------------|
| molten.LoadConfig | -1000000 | This will take values from `config.plugins.config` and call Config.set( resource, key, value ). The `config.plugins.config` should be configured with as { <resource> : { <key> : <value> } } |
| molten.Splash | -100000 | This will create a splash screen based on the config's `molten.splashClass`, if present. |
| molten.ApiInit | -100 | This will create an Api object to interface to Leverege's platform and advertise it as a the 'api' thunk argument and the value 'api' in Molten's values. |
| molten.RouterInit | -30 | Creates a history object and sets it as 'history' in molten's values. |

