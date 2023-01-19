# Graph Background
The UI Attributes Graphs Library comes with several customizable background types that may suit your needs.

## Solid
The default background for new graphs, the solid background is simply a single color covering the entire background of the graph which can be customized by the user.

## Striped
A striped background gives the user options to set the background color of the graph, in addition to selecting from several defined patterns of stripes to display in the inner area of the graph (inside its margin). Options include Diagonal, Diagonal (Reverse), Diagonal (Both), Horizontal, Vertical as well as Horizontal and Vertical. The color of the stripe can also be chosen.

## Image
An image background allows the user to supply an image url and various options such as size and position to place an image in the background of a graph. This is handy to add something like a company watermark to all graphs in a particular UI.

## Custom Backgrounds
In order to add a custom graph background,  you will need to register a [Model](/concepts/models), a Renderer and optionally (if your background is user customizable) a [Model Editor](/concepts/models/editors).

### Example
To create a Graph Background that displays one color on even days of the week and another on odd days, you would do the following:

=== "Model"
    File **SillyGraphBackgroundModel.js**.
    ```javascript
    const TYPE = 'myCustomNamespace.graph.SillyGraphBackground'
    function create() {
      return {
        type : TYPE,
        evenDayColor : 'purple',
        oddDayColor : 'black'
      }
    }

    export default {
      TYPE,
      create,
      ...ModelUtil.createAllValue( 'evenDayColor' ),
      ...ModelUtil.createAllValue( 'oddDayColor' )
    }
    ```
=== "Editor"
    File **SillyGraphBackgroundEditor.jsx**.
    ```javascript
    ...
    import SillyGraphBackgroundModel from './SillyGraphBackgroundModel'

    export default function SillyGraphBackgroundEditor( props ) {
      const { value } = props
      const onModelChange = useValueChange( SillyGraphBackgroundModel, props )

      return (
        <Pane style={{ '--propertyGrid-numColumns' : 1 }}>
          <PropertyGrid variant="backgroundEditor|editor">
            <PropertyGrid.Item label="Even Day Color">
              <TextInput
                value={SillyGraphBackgroundModel.getEvenDayColor( value )}
                eventData="setEvenDayColor"
                onChange={onModelChange}
                hint="Even Day Color" />
            </PropertyGrid.Item>
            <PropertyGrid.Item label="Odd Day Color">
              <TextInput
                value={SillyGraphBackgroundModel.getOddDayColor( value )}
                eventData="setOddDayColor"
                onChange={onModelChange}
                hint="Odd Day Color" />
            </PropertyGrid.Item>
          </PropertyGrid>
        </Pane>
      )
    }
    ```
=== "Renderer"
    File **SillyGraphBackgroundRenderer.jsx**.
    ```javascript
    import { DataContext } from '@visx/xychart'

    import SillyGraphBackgroundModel from './SillyGraphBackgroundModel'

    export default function SillyGraphBackgroundRenderer( props ) {
      const { model } = props
      const { theme, margin, width, height } = useContext( DataContext )

      const { backgroundColor } = useMemo( () => {
        const day = new Date().getDay()
        const isEven = day % 2 === 0

        const backgroundColor = isEven ? SillyGraphBackgroundModel.getEvenColor( model ) : SillyGraphBackgroundModel.getOddColor( model )
        
        return {
          backgroundColor : backgroundColor || theme?.backgroundColor || '#fff'
        }
      }, [ theme?.backgroundColor, model ] )

      if( width == null || height == null || margin == null || theme == null ) {
        return null
      }

      return (
        <rect
          x={0}
          y={0}
          width={width}
          height={height}
          fill={backgroundColor} />
      )
    }
    ```
=== "Setup"
    File **PluginSetup.js**.
    ```javascript
    export default {
      install( molten ) {
        molten.addPlugin( 'GraphBackgroundModel', { type : SillyGraphBackgroundModel.TYPE, name : 'Silly Graph Background', model : SillyGraphBackgroundModel } )
        molten.addPlugin( 'GraphBackgroundModelEditor', { type : SillyGraphBackgroundModel.TYPE, editor : SillyGraphBackgroundEditor } )
        molten.addPlugin( 'GraphBackgroundRenderer', { type : SillyGraphBackgroundModel.TYPE, renderer : SillyGraphBackgroundRenderer } )
      }
    }
    ```
As you may have noticed, graph background are renderer as children of a visx XYChart component, and as such, they have access to the chart's context. This context contains helpful data, such as chart dimensions and all of the chart's data. See the documentation for [@visx/xychart](https://airbnb.io/visx/docs/xychart){:target="_blank"} for more information.

!!! Tip
    Registering your model and editor using the 'GraphBackgroundModel' and 'GraphBackgroundModelEditor' will automatically register those plugins with the 'Model' and 'ModelEditor' plugin points, which is an important step that allows various generic model selectors and factories to know about your model and editor.
