# Views

As mentioned earlier, the `Plugins.get( type, filter )` call can return a filtered set of plugins of a given type. Sometimes, however, these plugins are evaluated and organized into a more complicated structure that allows for easier and quicker access. This is where the `View` comes into play. The `View` will watch the Plugin mechanisms for Plugins that are added and removed, and mark its view as dirty when appropriate. When the View is nexted ask for its value, it can either recalculate the value or return a cached one.



For a plugin point to use a Factory, it should use the `createView( type, options, throwError = false )` method to obtain and/or create it.

``` javascript
const view = Plugins.createView( 'myProject.MyLookupType', options )
```

The first argument identifies the plugin point type that the View is using , the second object is the options used to configure the factory:

| Option Field | Default | Description |
|--------------|---------|-------------|
| name | default | The name of the View. This is used to cache the View so it can be returned from a repeated `createFactory()` or `getFactory()` call. |
| sort | defaultSort | This defines the sort function used to sort the plugins. By default, the sort function uses a string sorting mechanism on the 'sort' key, but alternates functions can be used. If this is 'byNumber', a sort using a number will be installed. |
| filter | null | The filter used to prune plugins from the View. If `processor` is supplied, this is not used. |
| processor | null | A function that, if supplied, this is invoked with an Array of sorted  plugins. The result of this function is returned from `View.get()`. If this is not supplied, the `filter` options will be used.  |

If a processor is not supplied, `view.get()` will return an array of plugins, sorted and filtered according to those options. If the processor is given, the result from the processor defines the shape of the return value of `view.get()`.

When a Plugin of the View's type is added or removed, the view is marked as dirty and is recalculated vi `processor` or `filter` on the next invokation of `view.get()`.
