# XYChartModelConfigurer

The XYChartModelConfigurer Plugin Point allows you to register a function which will generate the default XYChart model for a given matchContext. For instance, if you have an object type of "vehicle" in your application, you can register an XYChartModelConfigurer like this and it will be invoked for generating the default model for all XYCharts whose Match context includes `objectType : 'vehicle'`:

=== "Configurer"
    File **FixedWidthXYChartModelConfigurer.js**
    ```javascript
    import { XYChartModel } from '@leverege/ui-attributes-graphs'

    export default {
      id : 'fixedWidth.vehicle.XYChartModelConfigurer'
      sort : 'aaa',
      configure : ( xyChartModel, objectType, cxt ) => {
        let model = XYChartModel.setWidth( xyChartModel, 500 )
        model = XYChartModel.setHeight( model, 500 )

        return model
      }
    }
    ```
=== "Setup"
    File **PluginSetup.js**
    ```javascript
    import FixedWidthXYChartModelConfigurer from './FixedWidthXYChartModelConfigurer'

    export default {
      install( molten ) {
        molten.addPlugin( 'XYChartModelConfigurer', FixedWidthXYChartModelConfigurer )
      }
    }
    ```
Each XYChartModelConfigurer plugin is passed the model instance from the configurer before it and is expected to return a model instance in turn. The first configurer will recieve a freshly initialized default model (the result of [XYChartModel.create()](https://bitbucket.org/leverege/ui-attributes-graphs/src/development/src/models/XYChartModel.js){:target="_blank"}). The order that each configurer is called in depends on the "sort" property of the plugin itself.

!!! Tip
    Molten comes with default XYChart model configurers for [Imagine objects and aggregations](https://bitbucket.org/leverege/molten/src/development/src/blueprints/attributes/BlueprintXYChartModelConfigurer.js){:target="_blank"}.