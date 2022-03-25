# Colorizers
While Colorizers are not unique to the UI Attributes Graphs library, they can be used to control the color of both series point glpyhs in the Glyph Line series type and the glyph used by the rollover tooltip. Installing a Colorizer for a particular object type will cause a function that you define to be called when a color needs to be determined for a particular data point. This allows for conditional coloring based on object values. Take a look at this simple example for an Alert Colorizer, which changes the color of a line or rollover glpyh when a particular temperature value is surpassed:

## Example
=== "Colorizer"
    File **TemperatureAlertColorizer.js**.
    ```javascript
    import ModelUtil from '@leverege/model-util'
    import { Attributes } from '@leverege/ui-attributes'
    
    const TYPE = 'colorizer.test.history.Alert'

    export default {
      create() {
        return {
          type : TYPE,
          value : 30,
          color : '#ff0000'
        }
      },
      colorFor( model, obj, context ) {
        const temp = Attributes.get( 'test.history.temperature', obj.type, obj.data )

        if ( temp.value > model.value ) {
          return model.color
        }

        return context.seriesColor
      },
      ...ModelUtil.createAllValue( 'value' ),
      ...ModelUtil.createAllValue( 'color' ),
      TYPE
    }
    ```
=== "Editor"
    File **TemperatureAlertColorizerEditor.jsx**.
    ```javascript
    import { NumericInput, TextInput PropertyGrid } from '@leverege/ui-elements'
    import { useValueChange } from '@leverege/ui-hooks'

    import TemperatureAlertColorizer from './TemperatureAlertColorizer'

    export default function TemperatureAlertColorizerEditor( props ) {
      const { value } = props

      const onModelChange = useValueChange( TemperatureAlertColorizer, props )

      return (
        <PropertyGrid>
          <PropertyGrid.Item label="Alert Value">
            <NumericInput
              value={TemperatureAlertColorizer.getValue( value )}
              hint="Alert value"
              float
              eventData="setValue"
              onChange={onModelChange} />
          </PropertyGrid.Item>
          <PropertyGrid.Item label="Color">
            <TextInput
              value={TemperatureAlertColorizer.getColor( value )}
              hint="Color"
              eventData="setColor"
              onChange={onModelChange} />
          </PropertyGrid.Item>
        </PropertyGrid>
      )
    }
    ```
=== "Setup"
    File **PluginSetup.js**.
    ```javascript
    import TemperatureAlertColorizer from './TemperatureAlertColorizer'
    import TemperatureAlertColorizerEditor from './TemperatureAlertColorizerEditor'

    export default {
      install( molten ) {
        molten.addPlugin( 'Model', { type : TemperatureAlertColorizer.TYPE, model : TemperatureAlertColorizer } )
        molten.addPlugin( 'ModelEditor', { type : TemperatureAlertColorizer.TYPE, editor : TemperatureAlertColorizerEditor } )
        molten.addPlugin( 'Colorizer', { type : TemperatureAlertColorizer.TYPE, name : 'Alert Colorizer', colorizer : TemperatureAlertColorizer } )
      }
    }
    ```
**You are encouraged to use Colorizers in your own plugins when applicable to increase potential customization by users.**
!!! Tip
    The wonderful thing about this Colorizer is that it can be resued anywhere that a color is needed to determine an appropriate color for the object type 'test.history'. In other words, it has no special attachment to the concept of a graph and could just as easily be used to color a table cell or a dot on a map representing the same type of object. With a bit of refactoring, this Colorizer could even be made to allow the Attribute that it is checking to be set dynamically as well.