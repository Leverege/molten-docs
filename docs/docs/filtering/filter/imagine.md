# Imagine Filtering

By default, filtering for Imagine group data parts of the `@leverege/condition` and `@leverege/ui-attributes` libraries to create a Condition Filter Model to query for its data. The base Condition Filter Model for Imagine data is called ConditionFilterModel and is registered for Imagine group data as follows:

```javascript
...
import GroupActions from '../../dataSource/GroupActions'

export default {
  install( molten ) {
    ...
    molten.addPlugin( 'ConditionFilterModel', { type : GroupActions.TYPE, model : ConditionFilterModel } )
    ...
  }
}
```

The ConditionFilterModel itself is quite simple and consists only of a type and a rootCondition property:
```javascript
const TYPE = 'condition.Filter'

function create( extra ) {
  return {
    rootCondition : null,
    ...extra,
    type : TYPE,
  }
}
```
## Default Model Configuration
This model is purposely generic in order to allow reuse by other, non-Imagine data types. To configure the default condition model for Imagine data further, a Condition Filter Model Configurer is registered. It is passed an instance of a Condition Filter Model and is expected to return another Condition Filter Model. Condition Filter Model Configurers can be registered against specific paths and object types in order to make customization on a per device type basis simple. Configurers can be registered with a sort priority to ensure the order in which they are called to configure the defauly model. The default imagine Condition Filter Model Configurer simply adds a LogicCondition as the rootCondition property:
```javascript
import { LogicCondition } from '@leverege/condition'
import { ModelFactory } from '@leverege/ui-plugin'

export default {
  id : 'molten.filter.condition.configurer.imagine',
  matches : {
    delegateType : 'groupDelegate.imagine'
  },
  configure : ( model, ...rest ) => {
    const Model = ModelFactory.get( model )

    return Model.setRootCondition( model, LogicCondition.create( { operator : 'and' } ) )
  }
}
```
## Condition Options Configuration
Because various Data Sources may support varying complexities and varieties of query, the behavior of Conditions and their editors is highly configurable. For instance, by default the LogicCondition editor supports the AND, OR, XOR, NOR, XNOR and NAND operators, but Imagine's data source only supports AND and OR queries. As a result, further configuration is required. To accomplish this, we register a Condition Filter Options Creator using our delegate's type as a key like this:

```javascript
/* PluginSetup.js */
molten.addPlugin( 'ConditionFilterOptionsCreator', ImagineConditionFilterOptionsCreator )

/* ImagineConditionFilterOptionsCreator.js */

import { ConditionCreators } from '@leverege/ui-condition'
import { LogicCondition } from '@leverege/condition'
import { AttributeCondition } from '@leverege/ui-attributes'

import ComparatorFilterConverterFactory from '../../../filters/filter/comparator/ComparatorFilterConverterFactory'
import ComparatorUtil from '../../../filters/filter/comparator/Util'

const conditionOptions = {}
const conditions = [ LogicCondition, AttributeCondition ]

export default {
  id : 'molten.filter.condition.optionsCreator.imagine',
  type : 'groupDelegate.imagine',
  getOptions : ( delegateType, props ) => {

    if ( !conditionOptions[delegateType] ) {
      conditionOptions[delegateType] = {
        logicalOperators : [ 'and', 'or' ],
        attributeCondition : {
          attributeFilter : ( attr ) => {
            // TODO: MOLTEN-594 Rename 'blueprint' attribute on the imagine attributes to source, and given them a type
            return attr?.getOption?.( 'filterable' ) === true
          },
          comparatorFilter : ( plg ) => {
            const converter = ComparatorFilterConverterFactory.get(
              ComparatorUtil.getComparatorConverterTypeForType( delegateType, plg.type )
            )
      
            return converter != null
          }
        }
      }
    }

    const creators = ConditionCreators.toCreators( conditions )

    return {
      creators,
      conditionOptions : conditionOptions[delegateType]
    }
  }
}
```
Registering this options creator will ensure that these options are passed to condition editors for our delegate type in a SharedContext.

At first this may seem a bit complicated, but the important parts to note are the `logicalOperators` property, which signals to the LogicCondition editor that it should only allow selection of those two types of operators and the `attributeFilter` property, which tells the AttributeCondition editor to filter the available UI Attributes so that attributes which do not support filtering (perhaps attributes that are client side only with no server backing) are not presented to be selected by the user.

Also important are the `creators` that are returned. These creators are presented by the condition editor for addition by the user. By default, Imagine supports only the LogicCondition and AttributeCondition types, but custom Conditions can be added if needed.

You may also notice the `comparatorFilter` property which is particular to the AttributeCondition type and is further explained in the [Attribute Conditions](./attribute-conditions.md) section of this documentation.