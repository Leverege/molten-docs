# Models

Molten uses the concept of a `Model` in much of its architecture. It is a way of transfering settings and workflows, and defining behaviors in plain JSON.

## Characteristics

A model has several characteristics that should be enforced while using them. Following these characteristics make it easy to save them, restore them, edit them, and find handlers/executors for them. 

### Plain JSON Object

Models should be a simple javascript object. They should not be or contain classes, functions, or Dates anywhere in their structure. This allows them to be easy stored to a network server, or added to a Redux like mechanism.

### Immutable

Models should be considered immutable. Changing a field redirectly in a Model will break caches, Redux and UI's that rely on top level object differences.

### Typed

Models should have a `type` field that defines its unique identity. Normally this is a namespaced string such as `myProject.MyModel`

## Working with Models

There tends to be a lot of broilerplate code when it comes to mutating models. To support this, the [`@leverege/model-util`](/docs/concepts/models/model-util/) library is available for use. For example, when changing a value and following the immutablitly rule above, it would look like: 

``` javascript 
import MyModel from './MyModel'

// If model was defined as
model = { type : 'myMode', value : 5, subValues : { sv : 1 } }

// WRONG - Dont do this
model.value = 42

// CORRECT - Do this
const nModel = MyModel.setValue( model, 42 )
model === nModel // => false
model.subValues === nModel.subValues // => true

```

The [`@leverege/model-util`](/docs/concepts/models/model-util/) will support creating getters and setters for single values in the model, for child arrays of items, and for child maps of other values. By leveraging the ModelUtil class these can be created very easily. Once created, these Model should be registered with Plugins by invoking `Plugins.add( 'Model', MyModel )`.

Because Models have types, they are easily used with the Plugin's Factory mechanism. Setting up a mechanism that should change behaviors based on the type of model installed is just another plugin point. Mechanisms like if/then/else logic options, color or symbol selectors, filtering or exporting of data become new plugin point Factories with the Plugins bound against the Model type.

If you need to allow the user to edit a model, going to the ModelEditorFactory to find a React component works great. Using the immutablily principle, the Model object and UI Element's eventData mechanism, change a model via a UI Element and sending the new model value to a change listener is very easy. At the controller level of the UI, the model could be stored into a Components state, or shoved into Redux, or sent across a network. 

