# Layout

Sometimes, especially for UI Plugins, the Plugins need to be ordered and arranged into a tree like structure. This can be true of actions in a menu, creators in a selector, and other such mechanisms. The `Layout` is supplied as a common way to do this ordering.

To use it:

``` javascript 
import { Layout } from '@leverege/plugins'

const tree = Layout.create( arrayOfItems /*, { buildTree : true } */ )
```

This `create` call will look at every item in the array for a `layout` object. This object can have the following options:

| Field | Default | Description |
|-------|---------|-------------|
| sort | item.name or item.type or '_z' | This string is used to organize the objects into priorities. Items sorted with small sort values are higher in the list, so an 'a' will occur before a 'z' in sort order.  |
| group | [] | An array of strings representing groups. In a tree, items that share the group path will end up in the same node in hierarchy.  |
| groupNames | [] | The name of the group elements, used for human consumption. Only one item will contribute this value (the first one defining it) |
| groupIcons | [] | The icon (either url or font icon) of the groups, used for human consumption. Only one item will contribute this value (the first one defining it) |

If `create()` is called with the `buildTree` option set to false, and array of objects containing `{ sort, group, groupKey, groupNames, groupIcons, item }` will be returned.

If `buildTree` is not set or is true, the array will be turned into a tree, where the root and groups in the tree look like:

``` javascript 
{
  type : 'layoutNode',
  name,
  icon,
  items : [ ]
}
```

The items array will contain items from the original array and other layout nodes, created in order to support the hierarchy.


