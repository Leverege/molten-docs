# Series Renderers
A series renderer is a component that displays XY series data visually. the UI Attributes Graphs library has several built-in renderers and allows you to register your own renderer if you so desire. Most of the built-in renderers are simply wrappers around the base series renderer types supported by the [@visx/xychart](https://airbnb.io/visx/docs/xychart){:target="_blank"} library, but a renderer is simple a component which is given access to the DataContext of the graph (including the graph's dimensions, it's X and Y scales, and its data) and can return any valid SVG for display.

## Built-In Types
### Line
A line series renderer renders series data using a line. The only option for the line series is stroke opacity.
### Area
Similar to a line series, except that the area beneath the line is shaded the same color as the line's stroke.
### Bar
Graphs data as a series of bars.
### Area Stack
Similar to an Area graph, but data points from different series with the same x coordinate are stacked on top of each other for a cumulative effect. This graph type is only useful when all of your series data shares the same X coordinates.
### Bar Stack
A bar graph where datum with the same X coordinate are stacked cumulatively on top of each other, just as in an AreaStack renderer.
### Bar Group
Also only useful for data sets that share the same set of X coordinates, the Bar Group displays series of data side-by-side grouped by their X coodrinate, rather than overlapping each other or stacking as in Bar and Bar Stack.
### Glyph Line
Like a line graph, but with user-customizable glyphs at each data point.
### Custom Series
It is possible to create your own custom Series Renderer by registering SeriesModel, SeriesModelEditor and SeriesRender plugins for your series type. Again, a Series Renderer need only return valid svg, so any manner of visualization is possible. As an example, let's look at the Glyph Line Renderer, which is a conglomeration of [LineSeries](https://airbnb.io/visx/docs/xychart#LineSeries){:target="_blank"} and [GlyphSeries](https://airbnb.io/visx/docs/xychart#LineSeries){:target="_blank"} types from [@visx/xychart](https://airbnb.io/visx/docs/xychart){:target="_blank"}
!!! Tip
    Registering your SeriesModel and SeriesModelEditor plugins will automatically register those plugins as Models and ModelEditors as well, which will make them available in UI Plugins that use the [ModelFactory and ModelEditorFactory](/concepts/models)
#### Example
=== "Model"
    File **LineGlyphModel.js**.
    ```javascript
    import ModelUtil from '@leverege/model-util'
    import DotGlyphModel from '../glyph/DotGlyphModel'

    const TYPE = 'graph.series.glyphLine'
    const name = 'Glyph Line'

    function create( extend ) {
      return {
        type : TYPE,
        name,
        strokeOpacity : 1,
        glyph : DotGlyphModel.create(),
        ...extend
      }
    }

    const base = {
      ...ModelUtil.createAllValue( 'strokeOpacity' ),
      ...ModelUtil.createAllValue( 'glyph' )
    }

    export default {
      create,
      TYPE,
      name,
      type : TYPE,
      getSeriesProps : ( model ) => {
        return {
          strokeOpacity : base.getStrokeOpacity( model )
        }
      },
      ...base
    }
    ```
    !!! Info "getSeriesProps"
        Note that this model type has a getSeriesProps function. This function will take an instance of your model and should return any props that should be passed to your renderer component, such as stroke colors, opacity or anything else you need to customize your renderer's look and feel. Your renderer will also be passed your entire model object as well, but getSeriesProps is designed to allow you to use components not designed with the model, editor and renderer paradigm in mind. It is, for example, how the appropriate props are passed to [@visx/xychart's](https://airbnb.io/visx/docs/xychart){:target="_blank"} built-in series types without them needing to know about the model that is powering their appearance.
=== "Editor"
    Filename **GlyphLineSeriesEditor.jsx**.
    ```javascript
    import React from 'react'
    import { PropertyGrid, Pane, NumericInput } from '@leverege/ui-elements'
    import { useValueChange } from '@leverege/ui-hooks'
    import { ModelTypeSelector } from '@leverege/ui-plugin'
    import { Plugins } from '@leverege/plugin'

    import GlyphLineSeriesModel from '../../models/series/GlyphLineSeriesModel'

    export default function GlyphLineSeriesEditor( props ) {
      const { value, objectType } = props
      const onModelChange = useValueChange( GlyphLineSeriesModel, props )

      return (
        <Pane style={{ '--propertyGrid-numColumns' : 2 }}>
          <PropertyGrid variant="seriesEditor|editor">
            <PropertyGrid.Header title="Line" />
            <PropertyGrid.Item label="Stroke Opacity">
              <NumericInput
                value={GlyphLineSeriesModel.getStrokeOpacity( value )}
                eventData="setStrokeOpacity"
                min={0}
                max={1}
                float
                onChange={onModelChange} />
            </PropertyGrid.Item>
            <PropertyGrid.Header title="Glyph" />
            { ModelTypeSelector.createSelectorAndEditor( {
              values : Plugins.get( 'GlyphModel' ),
              value : GlyphLineSeriesModel.getGlyph( value ),
              eventData : 'setGlyph',
              onChange : onModelChange,
              allowNone : false,
              isPropertyGrid : true,
              modelKey : 'model',
              propertyGridOpts : {
                fill : true
              },
              editorProps : {
                objectType
              }
            } ) }
          </PropertyGrid>
        </Pane>
      )
    }
    ```
=== "Renderer"
    Filename **GlyphLineSeries.jsx**.
    ```javascript
    import React, { useCallback } from 'react'
    import { GlyphSeries, LineSeries } from '@visx/xychart'
    import GlyphLineSeriesModel from '../../models/series/GlyphLineSeriesModel'
    import { GlyphRendererFactory } from '../Factory'

    export default function GlyphLineSeries( props ) {
      const { dataKey, data, xAccessor, yAccessor, strokeOpacity, model } = props
      const glyphModel = GlyphLineSeriesModel.getGlyph( model )

      const renderGlyph = useCallback( ( glyphProps ) => {
        return GlyphRendererFactory.create( glyphModel, {
          ...glyphProps
        } )
      }, [ glyphModel ] )

      return (
        <React.Fragment>
          <LineSeries
            dataKey={dataKey}
            data={data}
            xAccessor={xAccessor}
            yAccessor={yAccessor}
            strokeOpacity={strokeOpacity} />
          <GlyphSeries
            dataKey={dataKey}
            data={data}
            xAccessor={xAccessor}
            yAccessor={yAccessor}
            renderGlyph={renderGlyph} />
        </React.Fragment>
      )
    }
    ```
=== "Setup"
    Filename **PluginSetup.js**.
    ```javascript
    import GlyphLineSeriesModel from './GlyphLineSeriesModel'
    import GlyphLineSeriesEditor from './GlyphLineSeriesEditor'
    import GlyphLineSeries from './GlyphLineSeries'

    Plugins.add( 'SeriesModel', { type : GlyphLineSeriesModel.TYPE, name : GlyphLineSeriesModel.name, model : GlyphLineSeriesModel } )
    Plugins.add( 'SeriesModelEditor', { type : GlyphLineSeriesModel.TYPE, editor : GlyphLineSeriesEditor } )
    Plugins.add( 'SeriesRenderer', { type : GlyphLineSeriesModel.TYPE, renderer : GlyphLineSeries } )
    ```
!!! Tip
    As you can see, this model encapsulates a Glyph Model inside of it, this editor provides the ability to edit the model using a model editor factory and this renderer uses a glyph renderer factory to render the glyph portion of the renderer. This composition is a common pattern and can save a great deal of code.