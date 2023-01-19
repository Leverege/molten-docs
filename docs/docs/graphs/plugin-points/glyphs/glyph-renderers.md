# Glyph Renderers

Glyph Renderers are plugins that know how to render a glyph, which is a visual indicator at a point on an XYChart. Glyphs can be shapes, text or more complex constructions. Since they are based on svg, any element type supported by that standard can be rendered as a glyph. UI Attributes Graphs comes with several built in Glyph Renderer types that can be used to render series data or rollover tooltip markers.

## Dot
The Dot renderer renders a circle of a configurable size, stroke and fill at a point.

## Square
The Square renderer renders a square of a configurable size, stroke and fill at a point.

## Text
The Text renderer renders a given text string of a configurable font size and stroke at a point. The Text renderer can use [Glyph Symbolizers](../glyph-symbolizers) to customize the glyph that is rendered based on object data.

## Custom Glyph Renderers
Let's take a look at the library's implementation of the Dot glyph renderer as an example of how one might add their own custom Glyph type:

=== "Model"
    File **DotGlyphModel.js**.
    ```javascript
    import ModelUtil from '@leverege/model-util'

    const TYPE = 'graph.glyph.dot'

    function create( extend ) {
      return {
        type : TYPE,
        stroke : null,
        fill : null,
        size : 14
      }
    }

    export default {
      TYPE,
      create,
      ...ModelUtil.createAllValue( 'stroke' ),
      ...ModelUtil.createAllValue( 'fill' ),
      ...ModelUtil.createAllValue( 'size' ),
      name : 'Dot'
    }
    ```
=== "Editor"
    File **DotGlyphEditor.js**.
    ```javascript
    import React from 'react'
    import { PropertyGrid, Pane, NumericInput, Label } from '@leverege/ui-elements'
    import { useValueChange } from '@leverege/ui-hooks'
    import { ModelTypeSelector } from '@leverege/ui-plugin'
    import { Colorizers } from '@leverege/ui-attributes'

    import DotGlyphModel from '../../models/glyph/DotGlyphModel'

    export default function DotGlyphEditor( props ) {
      const { value, objectType } = props
      const onModelChange = useValueChange( DotGlyphModel, props )

      return (
        <Pane style={{ '--propertyGrid-numColumns' : 2 }}>
          <PropertyGrid variant="glyphEditor|editor">
            <PropertyGrid.Item label="Size">
              <NumericInput
                value={DotGlyphModel.getSize( value )}
                eventData="setSize"
                onChange={onModelChange} />
            </PropertyGrid.Item>
            { ModelTypeSelector.createSelectorAndEditor( { 
              modelKey : 'colorizer',
              values : Colorizers.getColorizersFor( objectType ),
              value : DotGlyphModel.getStroke( value ), 
              eventData : 'setStroke',
              onChange : onModelChange,
              isPropertyGrid : true,
              propertyGridOpts : {
                preLabel : <Label>Stroke Color</Label>,
              }
            } )}
            { ModelTypeSelector.createSelectorAndEditor( { 
              modelKey : 'colorizer',
              values : Colorizers.getColorizersFor( objectType ),
              value : DotGlyphModel.getFill( value ), 
              eventData : 'setFill',
              onChange : onModelChange,
              isPropertyGrid : true,
              propertyGridOpts : {
                preLabel : <Label>Fill Color</Label>
              }
            } )}
          </PropertyGrid>
        </Pane>
      )
    }
    ```
=== "DotGlyphRenderer"
    File **DotGlyphRenderer.jsx**.
    ```javascript
    import React from 'react'
    import { GlyphDot } from '@visx/glyph'
    import { Colorizers } from '@leverege/ui-attributes'

    import DotGlyphModel from '../../models/glyph/DotGlyphModel'

    export default function DotGlyphRenderer( props ) {
      const { model, size : pSize, color, x, y, datum, context } = props
      const size = DotGlyphModel.getSize( model ) || pSize
      const strokeModel = DotGlyphModel.getStroke( model )
      const fillModel = DotGlyphModel.getFill( model )

      const stroke = Colorizers.getColor( strokeModel, datum, { ...context, seriesColor : color } ) || color
      const fill = Colorizers.getColor( fillModel, datum, { ...context, seriesColor : color } ) || color

      return (
        <GlyphDot
          left={x}
          top={y}
          r={size / 2}
          stroke={stroke}
          fill={fill} />
      )
    }
    ```
=== "Setup"
    File **PluginSetup.js**.
    ```javascript
    import DotGlyphModel from './DotGlyphModel'
    import DotGlyphEditor from './DotGlyphEditor'
    import DotGlyphRenderer from './DotGlyphRenderer'

    molten.addPlugin( 'GlyphModel', { type : DotGlyphModel.TYPE, name : DotGlyphModel.name, model : DotGlyphModel } )
    molten.addPlugin( 'GlyphModelEditor', { type : DotGlyphModel.TYPE, editor : DotGlyphEditor } )
    molten.addPlugin( 'GlyphRenderer', { type : DotGlyphModel.TYPE, renderer : DotGlyphRenderer } )
    ```
!!! Tip
    Registering your model and editor using the 'GlyphModel' and 'GlyphModelEditor' will automatically register those plugins with the 'Model' and 'ModelEditor' plugin points, which is an important step that allows various generic model selectors and factories to know about your model and editor.
    
You can see that the DotGlyphRenderer returns an instance of DotGlyph from the [@visx/glyph](https://airbnb.io/visx/docs/glyph){:target="_blank"} library, but that component in turn just renders plain svg and is not much more than a convenience wrapper. A Glyph Renderer can return any valid svg.