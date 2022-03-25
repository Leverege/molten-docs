# Model Editors


## ModelEditorFactory

```javascript
import { ModelEditorFactory } from '@leverege/ui-plugin'
```

The ModelEditorFactory is a great way to dynamically edit objects when you don't want to care what they are. Consider the following code:

=== "PluginSetup.js"
    ```javascript
      import MyModel from './MyModel'
      import MyModelEditor from './MyModelEditor'

      export default {
        install : ( molten ) => {
          molten.addPlugin( 'Model', { type : MyModel.TYPE, model : MyModel } )
        }
      }
    ```

=== "MyModel.js"
    ```javascript
      import { createAllValue } from '@leverege/model-util'
      const type = 'my.model'
      function create( existing ) {
        return {
          type,
          age : existing?.age,
        }
      }
      export {
        type,
        TYPE : type,
        create,
        ...createAllValue( 'age', 'Age' )
      }
    ```
=== "MyModelEditor.jsx"
    ```javascript
      import React from 'react'
      import { PropertyGrid, NumericInput } from '@leverege/ui-elements'
      import MyModel from './MyModel'

      export default function MyModelEditor( props ) {
        const { value } = props

        const onModelChange = useValueChange( MyModel, props )

        return (
          <PropertyGrid>
            <PropertyGrid.Item label="Age">
              <NumericInput
                value={MyModel.getAge( value )}
                hint="Age"
                eventData="setAge"
                onChange={onModelChange} />
            </PropertyGrid.Item>
          </PropertyGrid>
        )
      }
    ```

=== "SettingsEditor.jsx"
    ```javascript
      import React from 'react'
      import { ModelEditorFactory } from '@leverege/ui-plugin'

      export default function SettingsEditor( props ) {
        const { settingValue } = props
        const onChange = () => {
          // make a network call to change the setting
        }
        return ModelEditorFactory.create( settingValue, { value : settingValue, onChange } )
      }
    ```
=== "Setting.js"
    ```javascript
      const MyModel = './MyModel'
      
      export default MyModel.create( { age : 32 } )
    ```

This allows you to create a SettingsEditor that doesn't care what the setting actually looks like. Assuming any possible setting model has a registered editor in the plugins library, that setting will be editable. This powerful paradigm is used throughout molten to edit ui settings, filter objects, re-parent Leverege devices, and so much more!

To note some additional best practices in the code above, look specifically at the MyModelEditor file. Note that to render the field editors, we're using a combination of PropertyGrid from the Leverege ui-elements library and the useValueChange hook from the Leverege ui-hooks library. These are considered the general best practices for creating model editors, since they standardize how callbacks occur between compoonents, and the styles used when editing objects.

## Hook: useInstanceCallback

The purpose of this hook is to generate callbacks that do not change when new props are supplied. This can prevent excess renders from occurring on subcomponents. It is useful for proxying changes to parent components

The hook can be invoked with either a function, or an array of functions, and the variables that should be available to the currently returned callbacks (normally props).

Each function supplied will be given the variables and the arguments that where given to the callback.

```javascript
 // Static function that takes ( variables, ...args )
 function click( props, evt ) {
   // send the click somewhere, with maybe some extra stuff
   props.sendClick( props.model, evt )
 } 

 // React function. The click method above will be invoked with props and the event
 function myEditor( props ) {
   const [ onClick ] = useInstanceCallback( [ click ], props )
   return <button onClick={onClick}>Do Something</button>
 }
```

## Hook: useModelChange

This hook is meant to be used with the model-util (or equivalent) library and ui-element events. It makes use of the useInstanceCallback hook to invoke a method on a given mutator function and forward the result to the onChange callback. The method invoked is supplied in the event's data field.

For example, if you have a Model Class:

```javascript
const ModelUtil = require( '@leverege/model-util' )
const { useModelChange } = require( '@leverege/ui-hooks' )
const TYPE = 'armedModel'

module.exports = {
  TYPE,
  create : ( ) => { return { type : TYPE, armed : true } },
  ...ModelUtil.createAllValue( 'armed', 'Armed' )
}
```

In your React function, you can use this hook like this:

```javascript
 function myEditor( props ) {
   const { model } = props
   const [ onChange ] = useModelChange( ArmedModel, props )

   return <ToggleButton 
    onChange={onChange} 
    value={ArmedModel.getArmed( model )}     
    eventData="setArmed">Armed</ToggleButtton>
 }
```

When the ui-element ToggelButton is clicked, `ArmedModel.setArmed( model, event.value )` will be invoked. The result (newModel) from that call will be sent to `props.onChange( { value : newModel, data : props.eventData })`.

## Hook: useValueChange

useValueChange is very similar to the useModelChange hook, with the principal difference being that it expects the model value to be in the value prop rather than the model prop.
## Function: onModelChange

The `useModelChange` hook uses the `onModelChange` method to do most of the work. It can be used in a class to avoid some code. The `createModelChange` method is supplied as a convenient class method to do this.

```javascript
class MyElem extends React.Component {

  onChange = createModelChange( ArmedModel )

  render( ) {
    return <ToggleButton 
      onChange={onChange} 
      value={ArmedModel.getArmed( model )}     
      eventData="setArmed">Armed</ToggleButtton>
  }
}
```

