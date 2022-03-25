# Scale
Graphs can be drawn using various scales to achieve different results, or to compliment different data sets. The most common scales are provided as built-in model and editor pairs, but adding a new scale type to be available for selection is also a fairly straighforward task.

All scales are based on scale types available in the [@visx/scale](https://airbnb.io/visx/docs/scale){:target="_blank"} library, which are in turn based on scale types from the popular [d3-scale](https://github.com/d3/d3-scale){:target="_blank"} library.

The official d3-scales documetation can be consulted for information on any of the built-in types or as a reference when attempting to implement a custom type.

- [Time Scale](https://github.com/d3/d3-scale#scaleTime){:target="_blank"}
- [UTC Scale](https://github.com/d3/d3-scale#scaleUtc){:target="_blank"}
- [Band Scale](https://github.com/d3/d3-scale#scaleBand){:target="_blank"}
- [Linear Scale](https://github.com/d3/d3-scale#scaleLinear){:target="_blank"}

To implement a new scale, add both a ScaleModel and ScaleModelEditor plugin to allow a user to customize any scale options:

=== "Model"
    File **LogScaleModel.js**.
    ```javascript
    const TYPE = 'graph.scale.log'

    function create() {
      return {
        type : TYPE,
        visxScaleType : 'log',
        ...otherOptions
      }
    }

    export default {
      create,
      TYPE
    }
    ```
    !!! Warning "Scale Types"
        Each scale model must have a property called visxScaleType which indicates the type of scale from among the available scale types found [here](https://github.com/airbnb/visx/tree/master/packages/visx-scale/src/scales){:target="_blank"} in the @visx/scale library.
=== "Setup"
    File **PluginSetup.js**
    ```javascript
    molten.addPlugin( 'ScaleModel', { type : LogScaleModel.TYPE, name : 'Logarithmic', model : LogScaleModel } )
    molten.addPlugin( 'ScaleModelEditor', { type : LogScaleModel.TYPE, editor : LogScaleModelEditor } )
    ```
    !!! Tip
        Adding your ScaleModel and ScaleModelEditor plugins will automatically register those plugins with the Model and ModelEditor plugin points.
!!! Info "Scale Editor"
    Note: Not shown above is the logarithm scale editor. You can provide an editor to allow users to set any of the available options on the particular [d3-scale](https://github.com/d3/d3-scale){:target="_blank"} type you are implementing.