# Configuration

The `Plugins` mechanism supplies a way registering objects for use in different mechanisms. The `Config` mechanism supplies a single location where these plugins can supply configurable options without each interface having to make its own options mechanism.

## Getting Config Values 

To use the Config option in your plugin, invoke the `get( rsource, key, defaultValue )` method:

``` javascript 
import { Config } from `@leverege/plugins`

const opt1 = Config.get( 'myProject.MyPlugin', 'option1', 12 )

```

In general, you should avoid get Config options at the time you javascript is loaded, but instead delay until when the option is needed. This will avoid any ordering issues between intialization and usage of the Config options.

## Setting Config Values 

To set the Config option, use `set( rsource, key, value )` method:

``` javascript 
import { Config } from `@leverege/plugins`

Config.set( 'myProject.MyPlugin', 'option1', 42 )

```

On Molten startup, the `LoadConfig` plugin will take all options stored in Molten's config object at the path 'plugins/config' and set them on the Plugin's Config object.


