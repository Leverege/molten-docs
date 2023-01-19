# Factories

 The Factory concept encapsulates the "I have a object, give me a way to do X with it". This 'way' can be represented by a Class, a function or object, and is defined by the plugin point making use of the factory. What the intent of this mechanism is ( the X ), is left up to the plugin point. Examples include but are in no way limited to:

 * Finding a processor for an incoming message object
 * Presenting a React editor or view for an object
 * Exporting an XML node that represents the object
 * Finding a formatting object to convert the object to a string
 * Configuring a cache mechanism to use a different backend
 * Finding and configuring a color calculator for objects   

 In order to find or lookup the appropriate handling mechanism from the Factory, the object must have a `type` associated with it. By default, the factories look for the 'type' field on the object and use it to look up the mechanism registered in the factory.

!!! Tip Plugin Replacement
    If you are unhappy with a registered factory object (like an Editor for a Model), you can replace the install one with you own. It will be use in place of the original. Make sure your object implements all the requirements defined by the plugin point.

## Creation and Registration

For a plugin point to use a Factory, it should use the `createFactory( type, options, throwError = false )` method to obtain and/or create it.

``` javascript
const factory = Plugins.createFactory( 
  'myProject.MyLookupType',
  {
    name : 'default',
    pluginKey : 'processor',
    strategy : Plugins.ALL
  }
)
```

The first argument identifies the plugin point type that the Factory is using in its lookups, the second object is the options used to configure the factory:

| Option Field | Default | Description |
|--------------|---------|-------------|
| name | default | The name of the Factory. This is used to cache the factory so it can be returned from a repeated `createFactory()` or `getFactory()` call. |
| pluginKey | plugin | The key in the registered plugin that defines the item the Factory will use. |
| pluginKeyType | type | The type key name used by `Factory.create()` and `Factory.get()` when finding a factory item. |
| strategy | Plugins.ALL | This determines how to treat the item found in create() before it is returned. See below for strategy descriptions. |
| defaultObject | null | If no look up is found for a type, this object will be used |
| registry | null | The default objects in the lookup |

To register a Plugins for use in the factory describe above:

``` javascript 
const myFactoryPlugin = { 
  type : 'myObjectType',
  processor : ( obj ) => { /* do something */ }
}
Plugins.add( `myProject.MyLookupType`, myFactoryPlugin )
```

In this case, the `type` defines what kind of object this processor will be used for. Because the Factory options specified `processor` as the `pluginKey`, the actual object is registered using that key. If the factory is invoked like this

``` javascript 
const msg = { type : 'myObjectType', /* more values */ }
const result = factory.create( msg )
```

the `myFactoryPlugin.processor( msg )` will be invoked and its result returned. Because the stategy is `ALL` and the processor is a function, the function will be invoked will all parameters given to the `create()`.

Different Strategy objects can be set on a Factory to allow different behaviors to occur. 
When `create( obj, ...rest )` is invoked, the strategies will behave in the following ways:

| Strategy | Result |
|----------|--------|
| Plugins.ALL | This is the default strategy. If the registered item is a function, it will be invoked with `f( obj, ...rest )` and the result returned. If the registered item is a Class, `new Clzz( obj, ...args )` will be returned. |
| Plugins.NONE | If the registered item is a function, it will be invoked with no options. If the registered item is a Class, `new Clzz( )` will be returned. |
| Plugins.ARGS | If the registered item is a function, it will be invoked with `f( ...rest )` and the result returned. If the registered item is a Class, `new Clzz( ...args )` will be returned. |
| Plugins.MERGE | If the registered item is a function, it will be invoked with `f( { model : msg, ...rest } )` and the result returned. If the registered item is a Class, `new Clzz( { model : msg, ...args } )` will be returned. The `Plugins.mergeStrategy()` call can be used to create a merge strategy that will use a different key.|
| Plugins.LOOKUP | In this case, the registered object is simply returned |
| Plugins.reactStrategy( React, propKey = 'model' ) | This strategy will call React.createElement() with the registered item as the component function or class. The `...rest` object will be supplied as props to the component. If propKey is a string, the `obj` object will be given as a prop as well, using the `propKey` as the prop name. |
| function | A custom `function( factory, registeredItem, typeOrObject, props )` can be set as the strategy object as well. |

## Dynamic Factories

The Factory mechanism used in the plugin library is backed by `@leverege/factory` and augmented to include automatic registration and deregistration of plugins as they are added and removed.


The factory mechanism can be used independently of Plugins as well - See `@leverege/factory`.