# TableModelConfigurer

The TableModelConfigurer Plugin Point allows you to register a function which will generate the default table model for a given matchContext. For instance, if you have an object type of "vehicle" in your application, you can register a TableModelConfigurer like this and it will be invoked for generating the default model for all tables whose Match context includes `objectType : 'vehicle'`:

=== "Configurer"
    File **UnselectableTableModelConfigurer.js**
    ```javascript
    import { TableModel } from '@leverege/ui-attributes'

    export default {
      id : 'unselectable.vehicle.TableModelConfigurer'
      sort : 'aaa',
      configure : ( tableModel, objectType, addName, cxt ) => {
        return TableModel.setSelectable( tableModel, false )
      }
    }
    ```
=== "Setup"
    File **PluginSetup.js**
    ```javascript
    import UnselectableTableModelConfigurer from './UnselectableTableModelConfigurer'

    export default {
      install( molten ) {
        molten.addPlugin( 'TableModelConfigurer', UnselectableTableModelConfigurer )
      }
    }
    ```
Each TableModelConfigurer plugin is passed the model instance from the configurer before it and is expected to return a model instance in turn. The first configurer will recieve a freshly initialized default model (the result of [TableModel.create()](https://bitbucket.org/leverege/ui-attributes/src/development/src/table/shared/TableModel.js){:target="_blank"}). The order that each configurer is called in depends on the "sort" property of the plugin itself.

!!! Tip
    Molten comes with a default table model configurer for Imagine objects, the [BlueprintTableModelConfigurerer](https://bitbucket.org/leverege/molten/src/development/src/blueprints/attributes/BlueprintTableModelConfigurer.js){:target="_blank"}.