
# Plugin Refinement

There are many situations where the Plugins registered at a given plugin point are further analyzed before being used. An example of this are Actions that are presented in a toolbar or context menu. In this situation, there are many Action plugins registered, but we only want to use the Actions that desired to be seen on a particular screen or when the target object is of a particular type. This refinement can occur in different ways depending on the plugin point, but two common paradigms often occur: `matches` objects and `handles()` functions. 

!!! Info "Match vs Handles"
    Ultimately, how plugins are selected for use depends on the plugin point. There are situations when both `matches` and `handles()` are used. When this occurs, it is usually an indication of broad stroke filter(the matches) and then a finer grain mechanism to really decide whether or not the plugin should used. An example of this is Actions in a toolbar, where the matches is used to identify the client and particular toolbar, and the handles() is use to indicate that it can be used if a particular object is selected in the context given to handles(). The client will feed different contexts to the toolbars based on which objects are selected in table, map, list or other UI mechanism.

## Matches Paradigm

Sometimes a plugin point will use the Matches paradigme to filter Plugins. This is often used as static, cacheable filter for all possible things that might show up in a plugin point. This paradigm has two sides: one advertised by the plugin point indicating what and/or where it is, and one on the Plugin that indicates its specific requirements. In order for a Plugin to be used, all the required fields in the Plugin's `matches` object must be met by the plugin point's `matchContext`. For example:

``` javascript
export default MyAction {
  matches : {
    use : 'actionBar',
    client : 'MyScreen'
  }
  // ...
}
```

This plugin is specifying that it should be used only when the plugin point specifies that the plugins are being used for an `actionBar` and the plugin point is in client called `MyScreen`. How plugin point specifies this filtered set of plugins can vary, but a simple example is to use the filter parameter on Plugins.get()

``` javascript
import { Plugins, Context } from '@leverege/plugin'

const matchContext = { 
  use : 'actionBar', 
  client :'MyScreen', 
  mobile : false, 
  otherParam : 'yes' 
}
const actions = Plugins.get( 'Actions', Context.createMatch( matchContext ) )
```

In this particualr case, MyAction's `matches.use` would be compared against `matchContext.use`, and `matches.client` would be compared to `matchContext.client`. Since both fields match, the Action would pass the filter an be used. The other fields in the matchContext are unused in the case of MyAction, but other plugins might use them. It is important for the plugin point creator to document the contents of the matchContext. Some common matchContext parameters are represent here, but any keys can be supplied by the plugin point. 

| Field | Example |
|-------|---------|
| client | The overal type of screen or client. |
| clientType | A refinement of the client. Is sometimes the same as client |
| mobile | Is this client being used for a mobile presentation |
| objectType | The type of object being represented |
| path | The relationship path |
| relationship | A Relationship object |
    

!!! Info "Example Note"
    In the above case, the Plugins.get() is not caching its results so the filter will occur
    every time. This is for example purposes only, and a Plugin View should really be used instead.
    The Context.createMatch() is a convenience function that calls 
    ``` 
    plg => Match.isMatch( clientMatch, plg.matches )
    ```

### Match Syntax

The `Match.isMatch( context, matches )` function has several rules it follows.

| If matches is | Result |
|---------------|--------|
| null | return true. All requirements are met. |
| Array | `isMatch()` is called for each element in the array. If any ony return true, the outer `isMatch()` will return true as well. |
| function | The result of calling `matches( context )` will be returned. (it should return true or false) |
| Object | Each `key` in `matches` is evaluated against the `context`. If any one returns false, false is returned. Otherwise return true. See below for Field rules. |
| else &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;   | return false. |

!!! Tip
    In general, it is best to use the Array or the Object when ever possible and avoid the complicated function at the field level. However, setting matches to a function and console logging the `context` is a quick way to see debug the `matchesContext` being used to evaluate your Plugin. 


When isMatch compares the fields in the matches object to the context object, it will use the following rules to evaluate each field key. The `matches[field]` and `context[field]` maybe both be arrays, in which cases each item in the `matches` is compared to each value in the `context`, and if any result in a true evaluation, the field will be considered matching.

(For this description, V is the field value supplied in the matches object from the Plugin, and CV is the value of the field in the matchContext. R is used to indicate a recursive invokation of this rule.)

| If the field value V | Result |
|-----------------|--------|
| is an Array | Return true if `R( V[n], CV)` is true |
| equals CV | return true |
| * | return true if CV is non-null |
| Starts with '!' | return true if `V.substring(1)` is not equal to CV |
| Starts with '>', '>=', '<', '<=' | returns true if mathematically CV is greater than, greater than or equal to, less then, less than or equal to the V minues the comparator |
| null | return true if CV is null or undefined |
| Object | if `V.not` exists, return false if `R( V.not, CV)` returns true. If `V.and` exists, return `R( V.and, CV)`. Otherwise return true |
| function | return result of V( context, CV ) |
| &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  | return false |

## Handles Paradigm

In this paradigm, the Plugin will have a `handle( cxt )` method that can return either true or false. If true, the Plugin should be used. This is very similar to Matches paradigm, though the intent is different, and these two paradigms are often used together on the same plugin point. Where the Matches paradigm may statically filter the set of Plugins down to all possible ones that might be used in this particular plugin point, the `handles( cxt )` is meant to look deeper at what is happening in that particular case to determine if the plugin can or wants participate. The context object `cxt` supplied to this method contains entries that represent the current state of the plugin point: are certain objects checked, is the user right clicking on a particular item, is an item in a list selected, etc.

As an example, a Contextual Action Menu plugin might want to work in a table of objects of type "vehicle", but only want that vehicle is in an alert state and the user has permissions to send an sms message to its owner. The Matches might match against client equaling 'TableView' and its path equaling 'dealer.vehicles', while the `handles( cxt )` would check that the target object is a vehicle and the user is permissioned to send an sms. 

### Context 

The plugins library includes a `Context` class meant to aid in the evaluation of the `handles()` context object. On primary support supplied is in regards to the target of the given context. It can be one object or many. There could also be a secondary target, or many secondary targets. It is up to your Plugin to decide when it should participate using the given context. In the case of a Action, some can support many targets, like perhaps a bulk remove. Some may require a single primary and a single secondary target, like a pair A to B. Some may allow many targets and many secondary targets. And some may not require targets at all, but some other field in the context. 

The following methods in `Context` can help your Plugin evaluate this context object. The following target methods below will look at the 'target' key in the Context object. Normally, objects are expected to have a `{ type : <objectType> }` field. When this is not possible, the context can be constructed with a `targetType` field that indicates the type of targets in the target list.

| Method | Description |
|--------|-------------|
| getTarget( cxt )| Returns the first object in the target field |
| getTargets( cxt ) | Returns an Array of objects in the target field |
| getTargetTypes( cxt ) | Returns an Array of objectTypes in the target field |
| isTargetOfType( cxt, type, only&nbsp;=&nbsp;true&nbsp;) | Returns true if the target is of the given type. When `isOnly` is true, this will also return false when there are more than one target.  |
| getTargetOfType( cxt, type, only&nbsp;=&nbsp;true&nbsp;) | Returns the object or null in the target if it is of the given type. When `isOnly` is true, this will also return null when there are more than one target.  |
| hasTargetsOfType( cxt, type, arrayCondition&nbsp;=&nbsp;'any&nbsp;) | This will return true if there are any targets in the list of the specified type. Possible options for `arrayCondition` inclue 'any', 'onlyOne', 'one', and 'all'. Using 'onlyOne' means there is only one target in the list and it is of the given type. Using 'one' means there is only one target in the list of the type. Using 'all' means all trargets must be of the specified type.  | 
| getTargetsOfType( cxt, type, arrayCondition&nbsp;=&nbsp;'any&nbsp;) | This is like `hasTargetsOfType()` but an array of the targets are actually returned. | 

For secondary target evaluation, the same methods above exist but with the addition of 'Secondary' in the method name: `getSecondaryTargetTypes`, `isSecondaryTargetOfType`, `getSecondaryTargetOfType`, `hasSecondaryTargetsOfType`, `getSecondaryTargetsOfType`. These methods will use the fields called `secondaryTarget` and ``secondaryTargetType`.

These methods are also available in a generic form where you can supply the keys to evaluate: `getObject`, `getObjects`, `getOfType`, `getObjectTypes`, `isObjectOfType`, `getObjectOfType`, `hasObjectsOfType`.