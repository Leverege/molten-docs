# Custom Data

Implementing filtering using custom data can essentially take three forms, each more custom (and perhaps more difficult to implement as a result) than the last.

For the purposes of this guide, we will assume that you have already created your own custom [Data Source](../../data-sources/index.md) and corresponding delegate (or "actions"). Your delegate should have a static delegateType string property and each instance should have the same value as its delegateType property as well.

## The Happy Path
Perhaps the easiest way to implement filtering for a custom data source is to reuse the existing Condition Attribute, Attribute Condition, and Comparator Condition infrastructure provided by molten. To start, you will need to register the Condition Filter as the base condition for your delegate type like this:
```javascript
import { ConditionFilterModel } from '@leverege/molten/filters'

molten.addPlugin( 'ConditionFilterModel', {
  type : PetsAction.TYPE,
  model : ConditionFilterModel
} )
```
where PetsAction is your group delegate class described above. this will provide the built-in Condition Filter editor for each of your custom data group screens exactly as Imagine based group screens have. It will also provide all of the built-in comparator types that Molten supports for each of your Attributes.

Because the default ConditionFilterModel has an empty `rootCondition`, you will need to provide at least one Condition Filter Model Configurer. Here we will reuse the built in Imagine configurer:

```javascript
import { LogicCondition } from '@leverege/condition'
import { ModelFactory } from '@leverege/ui-plugin'

export default {
  id : 'molten.filter.condition.configurer.pets',
  matches : {
    delegateType : 'groupDelegate.pets'
  },
  configure : ( model, ...rest ) => {
    const Model = ModelFactory.get( model )

    return Model.setRootCondition( model, LogicCondition.create( { operator : 'and' } ) )
  }
}
```
Because the `match` on this configurer specifies only `delegateType`, it will match all group screens using your PetsAction delegate. You can register more specific configurerers using properties such as objectType and path to configure default models for particular screens. You can also supply a `sort` property to customize the order in which your configurers are called.

Because your particular backing Data Store may not support filtering on all attributes, all comparator types, or using all operators supplied by the Logic Condition, you will also need to supply a Condition Filter Options Creator:

```javascript
import { ConditionCreators } from '@leverege/ui-condition'
import { AttributeCondition } from '@leverege/ui-attributes'

const conditionOptions = {}
const conditions = [ AttributeCondition ]

export default {
  id : 'molten.filter.condition.optionsCreator.pets',
  type : 'groupDelegate.pets',
  getOptions : ( delegateType, props ) => {

    if ( !conditionOptions[delegateType] ) {
      conditionOptions[delegateType] = {
        logicalOperators : [ 'and' ],
        attributeCondition : {
          attributeFilter : ( attr ) => {
            return attr.name === 'name'
          },
          comparatorFilter : ( plg ) => {
            return plg.type === 'string.Contains'
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
Here we use some very basic caching to ensure we don't create a new set of options every time our condition creator is called. The props object passed to the getOptions method will allow you to cache and customize these options based on things like objectType, path or relationship as well. We are only allowing filtering on one attribute here, only allowing a single root 'and' condition and only allowing comparison using the "Contains" comparator. You will best know the characteristics of your data to be able to customize these options.

Finally, for each comparator type that we plan to support, we need to register a custom ComparatorFilterConverter:

```javascript
/* PetsContainsComparatorFilterConverter.js */
export default {
  id : 'molten.string.Contains.ComparatorFilterConverter',
  type : 'groupDelegate.pets.string.Contains.ComparatorFilterConverter',
  convert : ( type, cmp, attribute ) => {
    return cmp
  }
}

/* PluginSetup.js */
molten.addPlugin( 'ComparatorFilterConverter', PetsContainsComparatorFilterConverter )
```
We register the comparator using a type key of the pattern `${delegateType}.${comparatorType}.ComparatorFilterConverter`. For a complete set of comparator types, see the `@leverege/ui-attributes` library.

This comparator converter simply returns the condition model, assuming that our PetsAction delegate will understand that format natively, but your can perform any type of conversion necessary here.

## Semi-Custom Filtering
The second available method to implement filtering in Molten for custom data types is to register a Condition Filter Model Configurer which sets as its rootCondition an entirely custom Condition. In this case, you will also need to register your custom Condition as a Condition as well as with the Model factory and register a custom editor with the ModelEditor factory:

```javascript
Plugins.add( 'Condition', PetsCondition )
Plugins.add( 'Model', { type : PetsCondition.TYPE, model : PetsCondition } )
Plugins.add( 'ModelEditor', { type : PetsCondition.TYPE, editor : PetsConditionEditor } )
```
You would register the ConditionFilterModel as the Condition Filter Model for your delegate type as above:
```javascript
molten.addPlugin( 'ConditionFilterModel', {
  type : PetsAction.TYPE,
  model : ConditionFilterModel
} )
```
And a Condition Model Configurer similar to the one above but set an instance of this PetsCondition as your rootCondition.

You can then register a Condition Filter Converter for this condition which will be called each time the condition model is changed by the user using your editor:

```javascript
molten.addPlugin( 'ConditionFilterConverter', PetsConditionFilterConverter )
```

With this method, you can still register an options creator and the creators and conditionOptions you create will be provided to your editor and its children through a SharedContext object. You will be 

## Total Custom Filtering

The final method of implementing filtering in Molten is to register a completely custom model as the Condition Filter Model for your delegate type:
```javascript
molten.addPlugin( 'ConditionFilterModel', {
  type : PetsAction.TYPE,
  model : PetsFilterModel
} )
```
Going this route allows you to create your own editor for filters. You will not be passed Condition Filter Options in a SharedContext automatically and all filtering methodology will be up to you.