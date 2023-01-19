# AttributeCellRenderer

Registering an AttributeCellRenderer plugin give you the chance to replace the default cell renderer for a particular table column. The best way to demonstrate is through a simple example.

## Example
=== "Renderer"
    File **DoubleNameRenderer.jsx**
    ```javascript
    import React from 'react'

    function DoubleNameRenderer( props ) {
      const { data : { value } } = props
      return `${value} ${value}`
    }

    export default {
      objectType : 'test',
      attrName : 'name',
      renderer : ( data, props, context ) => {
        return React.createElement( DoubleNameRenderer, {
          ...props,
          data,
          context
        } )
      }
    }
    ```
=== "Setup"
    File **PluginSetup.js**
    ```javascript
    import DoubleNameRenderer from './DoubleNameRenderer'

    export default {
      install( molten ) {
        molten.addPlugin('AttributeCellRenderer', DoubleNameRenderer )
      }
    }
    ```

As you can see, the process is simply to register a renderer against a particular object type and attribute name. This will cause any cells rendered for that objectType ane attribute name combination to use our renderer instead of the default.

The three arguments passed to the renderer function are as follows:

| Prop | Purpose |
| ---- | ------- |
| data | This is the data that is passed to each cell by the parent table. It includes almost all of the state of the entire table, including that of the current cell, the current row and all other rows. Notably though, data contains a property called "value" which is the actual value for this table cell. |
| context | This is the context that the table passes to each cell containing it's props under the `clientProps` key, the current row object under `target` and the original column renderer under the key `renderer`. This last property allows you to use the original renderer conditionally if you'd like to make some cells appear in their default state but for others to have a customized look by calling `renderer.renderCell( data, props, context )`. |
| props | These are additional style props that are passed to the cell component and are generally undefined. The TableView uses react-table internally, and for very custom table implementations, additional cell props can be provided to each cell through the [react-table apis](https://react-table.tanstack.com/docs/api/useTable#cell-properties){:target="_blank"}. |
