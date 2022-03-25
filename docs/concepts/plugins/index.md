# Plugins

Molten makes heavy use of the `@leverege/plugins` library. This library supplies a central registration mechanism in which various classes, functions, and objects can be declared to participate in other framework's interfaces. Often this binding can occur without the need for a direct dependency on target framework. The uses for this 'repository of things' can very greatly: from dynamic url routing, to custom contextual actions, to attribute definition, to logic intercept mechanisms, to initializers, to UI editor lookups, to colorizers, to name just a few. 

## Use 

The use of this library can be very simple and the requirements are very few:

* Including the library in your own code
* Defining an interface for your custom plugin mechanism (sometimes called Plugin Points)
* Picking a unique plugin name for your mechanism (usually namespaced, like <myProject>.<MyPluginPoint> )

``` javascript
import { Plugins } from '@leverege/plugin' // 1

const plgs = Plugins.get( 'myProject.Initializer' ) // 2
plgs.forEach( ( initializer ) => { 
  initializer.init() // 3
} )
```

In this example, we have defined our own custom plugin point that will invoke an `init` method at the appropriate time. It has imported the library (1), asked for all plugins registered as a `myProject.Initializer` plugin (2),  and used the custom plugin point's interface to invoke init() on each plugin (3). It can be that simple to define your own custom Plugins point. 

To participate in that example plugin point, simply add a plugin to the Plugin mechanism:

``` javascript
import { Plugins } from '@leverege/plugin' // 1

MyInitializer = { init : () => { /* do something */ } }

// Alternately: molten.addPlugin( 'myProject.Initializer', MyInitializer )
Plugins.add( 'myProject.Initializer', MyInitializer )
```

This `Plugins.add()` or `molten.addPlugin()` registers the plugin for use at the specified plugins point. Adding a plugin can be as simple as this. 

Some plugin points are a little more complicated. These plugin points will often use [match objects](./refinement), type values, and methods to help determine whether or not a particular plugin should be used in a particular instance. Some will define sort values (like [Molten's initializer plugins](/docs/startup/initializers/)) to help aid in ordered invokation. Some are meant to be used in [Factory]((./factories)) lookup mechanism or participate in active [Views]((./views)). These extra mechanisms need to be defined by the plugin points interface documentation so developers can understand how to leverage the particular plugin point. 


## Observable

The Plugins mechanism is also observable, meaning that listeners can be registered to detect when plugins are added or removed. This can help plugin endpoints respond to new plugins or avoid ordering issues cause by importation/registration order. It can also help to support dynamic loading of code. 

``` javascript
// Add a listener to all types
const unsubscribeGlobal = Plugins.on( listener )

// Add a listener to a specific type
const unsubscribeType = Plugins.on( 'myProject.Initializer', listener )

// To remove a listener from all types
Plugins.off( listener )
// or use the returned function
unsubscribeGlobal() 

// To remove a listener from a specific type
Plugins.off( 'myProject.Initializer', listener )
// or use the returned function
unsubscribeType() 
```

The listener method will be invoked with an object when an add or remove occurs:

``` javascript
{ 
  type,       // either 'pluginAdded' or 'pluginRemoved', 
  pluginType, // The plugin type that changed
  plugin,     // The plugin that was added or removed
  plugins     // The Plugins object 
}
```

An alternative why of determining if Plugins were added or removed without listening to Plugins is to look at the version number for a type. 

``` javascript
 const version = Plugins.getVersion( 'myProject.Initializer' )
```

Anytime a plugin is added or removed, the version number will be updated. This change detection is useful when caches are being used to record previous work using the plugins. A change to the version can be used to bust the cache and cause the work to be recalculated with the current plugin set.

``` javascript 
  const version = Plugins.getVersion( 'myProject.PluginPoint' )

  // React Example
  const result = useMemo( ( ) => {
    const p = Plugins.get( 'myProject.PluginPoint' )
    // do some work
    return result
  }, [ version ] )

  // @leverege/value-cache example
  const result = valueCache.calc(( ) => {
    const p = Plugins.get( 'myProject.PluginPoint' )
    // do some work
    return result
  }, version )

```