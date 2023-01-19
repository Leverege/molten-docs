# Custom Suggestors

Key to the Attribute Condition editor is the ability to provide value suggestions for the Attribute as a user types.

Molten provides several built-in Suggestors for Imagine based Attributes that provide values for a given Attribute valueType. For instance, the StringAttributeValueSuggestor provides auto-suggest results based on the existing values for the Attribute among existing devices filtered by the user's text input. The UnitAttributeValueSuggestor provides suggestions for all of the available unit types for a particular unit (e.g. temperature Attributes are given suggestions for C, F, K, and R unit types).

When registering a custom Attribute, it is necessary to also register a custom Suggestor to provide possible values for the user to select from. A Suggestor is simple an instance of a class that provides a `suggest` method which takes a single argument, the value that the user has entered. Take for example the Full Name Attribute example from the [previous section](./custom-comparators.md). An implementation of a suggestor for that Attribute might look like this:

```javascript
import { Attributes } from '@leverege/ui-attributes'
import { GlobalState } from '@leverege/ui-redux'

export default class MakeModelYearValueSuggestor {
  constructor( type, opts = {} ) {
    this.attribute = opts.attribute
    this.actions = opts.actions
    this.relationship = opts.relationship
    this.objectType = opts.objectType
    this.firtNameAttribute = Attributes.getAttribute( 'person.firstName', 'person' )
    this.lastNameAttribute = Attributes.getAttribute( 'person.lastName', 'person' )
  }

  async suggest( value ) {
    const [ firstName, lastName ] = ( value || '' ).split( ' ' )

    const filters = []

    if ( firstName ) {
      filters.push( {
        type : 'expression',
        value : `*${firstName}*`,
        field : this.firstNameAttribute.blueprint.field,
        kind : 'queryString',
        analyzeWildcard : true
      } )
    }

    if ( lastName ) {
      filters.push( {
        type : 'expression',
        value : `*${lastName}*`,
        field : this.lastNameAttribute.blueprint.field,
        kind : 'queryString',
        analyzeWildcard : true
      } )
    }

    const results = await GlobalState.dispatch(
      this.actions.search( {
        filter : {
          type : 'logical',
          operator : 'or',
          conditions : filters
        },
        queryName : 'search.FullNameValueSuggestor'
      } )
    )

    const suggestions = results.items.map( ( item ) => {
      return `${this.firstNameAttribute.get( item )} ${this.lastNameAttribute.get( item )}`
    } )

    if ( suggestions && suggestions.length > 0 ) {
      return suggestions
    }

    return []
  }
}
```
As you can see, the options that are passed to a suggestor upon construction include the attribute being searched, the delegate (or actions) for the group, the relationship and the objectType. This allows us to search the delegate for entries where first name and last name match our user's input and return suggestions. Suggestions can be an array of strings or an array of objects with name and value keys in the event that you want to use a different display value to represent a backing value. If no results are available, simply return null or an empty array.