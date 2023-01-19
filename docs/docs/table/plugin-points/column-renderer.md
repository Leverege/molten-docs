# ColumnRenderer
In most cases, when you want to replace the default renderer for a column, an [AttributeCellRenderer](../attribute-cell-renderer) plugin will suffice. However, perhaps your custom data type has an [Attribute](../../../../concepts/attributes) with a `valueType` that the table does not support out of the box. For instance, the table does not have an image column renderer by default. Let's take a look at what you'd need to do to implement such a renderer.

## Requirements
Each column renderer needs its own column model which defines all of the options that can be configured for that column. It can also optionally provide an editor to allow a user to change and tweak model options. And finally, it requires a renderer that knows how to convert a model and object ref data into a visualization of an attribute.

## Example
=== "Model"
    File **ImageAttributeColumnModel.js**.
    ```javascript
    import { ColumnModel, Attributes } from '@leverege/ui-attributes'

    /* Initialize Constants */
    const VALUE_TYPE = 'image'
    const TYPE = `attr.column.${VALUE_TYPE}`

    /**
    * Gets name from data.
    */
    function getName( data ) {
      return Attributes.getDisplayName( data.attrName, data.objectType )
    }

    /* Initialize Model Base */
    const base = {
      ...ColumnModel,
      getName,
    }
    delete base.create

    /**
    * Creates an attribute detail model instance.
    */
    function create( attrName, objectType ) {
      return ColumnModel.create( TYPE, {
        attrName,
        objectType,
      } )
    }

    /* Export Modules */
    module.exports = {
      TYPE,
      create,
      ...base
    } 
    ```
=== "Renderer"
    File **ImageAttributeColumnRenderer.jsx**
    ```javascript
    import React from 'react'

    import {AttributeColumnRenderer} from '@leverege/ui-attributes'

    export default class ImageColumnRenderer extends AttributeColumnRenderer {
      renderCell = ( data ) => {
        const {
          value
        } = data
        return (
          <img alt={value} src={value} />
        )
      }
    }
    ```
=== "Setup"
    File **PluginSetup.js**
    ```javascript
    import { Plugins } from '@leverege/plugin'
    import AttributeColumnEditor from '@leverege/ui-attributes'

    import ImageColumnModel from './ImageColumnModel'
    import ImageColumnRenderer from './ImageColumnRenderer'

    export default {
      install( molten ) {
        molten.addPlugin( 'Model', { type : ImageColumnModel.TYPE, model : ImageColumnModel } )
        molten.addPlugin( 'ModelEditor', { type : ImageColumnModel.TYPE, editor : AttributeColumnEditor } )
        molten.addPlugin( 'ColumnRenderer', { type : ImageColumnModel.TYPE, renderer : ImageColumnRenderer } )
      }
    }
    ```

As you can see, this is a very simple example that simply extends the AttributeColumnModel, AttributeColumnEditor and AttributeColumnRenderer from [@leverege/ui-attributes](https://bitbucket.org/leverege/ui-attributes){:target="_blank"}. In a real-life situation, you'd likely want to add additional parameters like a width and height for the image to the model and either extend or completely replace the column editor. More details on models and model editors can be found [here](../../../../concepts/models).