# Glyph Symbolizers
Similar to [Colorizers](../../colorizers), Glyph Symbolizers can be used to conditionally render a glyph at a data point based on the data data in the target object. They allow you to define a function which can return a symbol to be used by a glyph renderer (either for a series data point or a rollover tooltip indicator).

UI Attributes Graphs comes with one built-in Glyph Symbolizer,  the Value Glyph Symbolizer which simple allows a user to choose a static string of text to be rendered at every point.

## Custom Glyph Symbolizers
Here is an example of an Alert Symbolizer that shows a particular symbol when a given temperature threshold has been exceeded:

### Example
=== "Symbolizer"
    File **AlertGlyphSymbolizer.js**.
    ```javascript
    import ModelUtil from '@leverege/model-util'
    import { Attributes } from '@leverege/ui-attributes'

    const TYPE = 'symbolizer.test.history.Alert'

    export default {
      create() {
        return {
          type : TYPE,
          value : 30,
          symbol : '😃',
          alertSymbol : '😈'
        }
      },
      symbolFor( model, obj, context ) {
        const temp = Attributes.get( 'test.history.temperature', obj.type, obj.data )

        if ( temp.value > model.value ) {
          return model.alertSymbol
        }

        return model.symbol
      },
      ...ModelUtil.createAllValue( 'value' ),
      ...ModelUtil.createAllValue( 'symbol' ),
      ...ModelUtil.createAllValue( 'alertSymbol' ),
      TYPE
    }
    ```
=== "Editor"
    File **AlertSymbolizerEditor.jsx**.
    ```javascript
    import { NumericInput, TextInput, PropertyGrid } from '@leverege/ui-elements'
    import { useValueChange } from '@leverege/ui-hooks'

    import AlertGlyphSymbolizer from './AlertGlyphSymbolizer'

    export default function AlertSymbolizerEditor( props ) {
      const { value } = props

      const onModelChange = useValueChange( AlertGlyphSymbolizer, props )

      return (
        <PropertyGrid>
          <PropertyGrid.Item label="Alert Value">
            <NumericInput
              value={AlertGlyphSymbolizer.getValue( value )}
              hint="Alert Value"
              float
              eventData="setValue"
              onChange={onModelChange} />
          </PropertyGrid.Item>
          <PropertyGrid.Item label="Symbol">
            <TextInput
              value={AlertGlyphSymbolizer.getSymbol( value )}
              hint="Symbol"
              eventData="setSymbol"
              onChange={onModelChange} />
          </PropertyGrid.Item>
          <PropertyGrid.Item label="Alert Symbol">
            <TextInput
              value={AlertGlyphSymbolizer.getAlertSymbol( value )}
              hint="Alert Symbol"
              eventData="setAlertSymbol"
              onChange={onModelChange} />
          </PropertyGrid.Item>
        </PropertyGrid>
      )
    }
    ```
=== "Setup"
    File **PluginSetup.js**.
    ```javascript
    import AlertGlyphSymbolizer from './AlertGlyphSymbolizer'
    import AlertSymbolizerEditor from './AlertSymbolizerEditor'

    molten.addPlugin( 'Model', { type : AlertGlyphSymbolizer.TYPE, model : AlertGlyphSymbolizer } )
    molten.addPlugin( 'ModelEditor', { type : AlertGlyphSymbolizer.TYPE, editor : AlertSymbolizerEditor } )
    molten.addPlugin( 'GlyphSymbolizer', { type : AlertGlyphSymbolizer.TYPE, name : 'Alert Symbolizer', symbolizer : AlertGlyphSymbolizer } )
    ```
This Glyph Symbolizer will render a 😃 when an object's temperature is less than or equal to a ceratin threshold and a 😈 when the temperature is greater.

**You are encouraged to use Glyph Symbolizers in your own plugins when applicable to increase potential customization by users.**