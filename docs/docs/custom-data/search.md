If optionally you wish to add the ability for users to free text search your list of items (and your API supports such functionality), you can add just a couple of plugins to do so.

The first thing you need to add is a SearchBar plugin, which will look something like this:

### SearchBar Plugin installation

A SearchBar at its core is a DataViewer, so it's installed using that plugin type, but specifically tuned to be used as a search plugin on GroupScreen's

```javascript
molten.addPlugin( 'DataViewer', {
  id : 'molten.dataViewer.search.PetSearchBar',
  type : 'molten.Search',
  name : 'Search Bar',
  icon : 'fa fa-search fa-fw',
  // this is what tells the GroupScreen where to put this plugin
  location : [ 'search' ],
  // this search bar can only be used against group screens of petApi.pet's
  matches : {
    type : 'GroupDataViewer',
    objectType : 'petApi.pet'
  },
  component : SearchBar,
} )
```

### SearchBar Component

For the ease of the pet shop demo, we opted to use the SearchBar from molten, and simply wrap it to adjust some of its props

```javascript
import React from 'react'
import ResponsiveSearchBar from '../../../src/screens/group/search/SearchBar'

export default function SearchBar( props ) {
  const { objectType, path } = props
  const client = 'molten.group.SearchBar'
  // changing the use prevents Imagine API suggestions from being rendered, which would break
  const suggestionsMatchContext = { use : 'petApi.suggestions', client, objectType, path }
  return <ResponsiveSearchBar {...props} suggestionsMatchContext={suggestionsMatchContext} />
}
```

### Suggestions Plugin Installation

SearchSuggesters are a specialized plugin that allows you to tack additional suggestions onto any search bar (not just the pet shop one!)

```javascript
molten.addPlugin( 'SearchSuggester', {
    id : 'petApi.Suggestions',
    name : 'API Suggestions',
    // NOTE: this use matches the use from the SearchBar component suggestionsMatchContext
    matches : { use : 'petApi.suggestions', client : 'molten.group.SearchBar' },
    handles : () => true,
    // could be useful for storing recent searches
    onSearchChange : ( { search } ) => {},
    suggestions : Suggestions
  } )
```

### Suggestions Component

This component as a note is very similar to the ApiSuggestions in the molten library, but with some changes to make it work with the
pet shop example.

#### Get Suggestions Function
```javascript
import { GlobalState } from '@leverege/ui-redux'
import { Attributes } from '@leverege/ui-attributes'
import Path from '@leverege/path'
import { Config } from '@leverege/plugin'
import Model from '../../../src/screens/group/search/filter/GroupedTextFilterModel'

const getSuggestions = async ( actions, filter, search, objectType, api ) => {
  const f = filter
  const res = await GlobalState.dispatch( actions.search( {
    filter : f ? { ...f, value : Model.toImagineValue( search, filter, objectType ) } : null,
    limit : 100
  }, { queryName : 'searchSuggestions' } ) )
  const items = {}
  const toCheck = Model.getLastToken( search ).toLowerCase()
  if ( f?.fields && f.fields.length > 0 ) {
    f.fields.forEach( ( field ) => {
      let accessor = () => null
      if ( typeof field === 'string' ) {
        accessor = Path( field ) 
      } else if ( typeof field === 'object' && field?.field ) {
        accessor = Path( field.field )
      }
      res?.items.forEach( ( i ) => {
        const val = accessor.get( i )
        if ( typeof val === 'string' && val.toLowerCase().includes( toCheck ) ) {
          items[val] = true
        }
      } )
    } )
  } else {
    const attrs = Attributes.getAttributesFor( objectType )
    attrs.forEach( ( attr ) => {
      if ( attr.valueType !== 'string' ) {
        return
      }
      res?.items.forEach( ( i ) => {
        const val = attr.get( i )
        if ( typeof val === 'string' && val.toLowerCase().includes( toCheck ) ) {
          items[val] = true
        }
      } )
    } )
  }
  return Object.keys( items )
}

const updateSuggestions = ( opts ) => {
  const { actions, filterModel, search, objectType } = opts
  const filter = Model.toImagineFilter( filterModel, objectType )
  if ( !search || Model.getLastToken( search ).length < Config.get( 'ApiSuggestions', 'minSuggestionLength', 3 ) ) {
    opts.setItems( [] )
    return Promise.resolve( [] )
  }
  // do this so we can get at the raw api object and not touch api-redux
  return new Promise( ( resolve ) => {
    process.nextTick(
      GlobalState.dispatch,
      async ( dispatch, getState, { api } ) => {
        const items = await getSuggestions( actions, filter, search, objectType, api )
        opts.setItems( items )
        resolve( items )
      }
    )
  } )
}

export {
  updateSuggestions,
  getSuggestions
}
```

#### Suggestion Component
```javascript
import React from 'react'
import Suggestion from '../../../src/screens/group/search/suggestions/Suggestion'

// an individual suggestion
export default function PetSuggestion( props ) {
  const { item, search } = props
  const match = item?.toLowerCase().lastIndexOf( search?.toLowerCase() )
  
  if (
    !item ||
    match < 0 ||
    item?.toLowerCase() === search?.toLowerCase() ||
    search?.toLowerCase().endsWith( item?.toLowerCase() )
  ) {
    return null
  }

  const contents = (
    <>
      {item.slice( 0, match )}
      <b>{item.slice( match, match + search.length )}</b>
      {item.slice( match + search.length )}
    </>
  )
    
  return (
    <Suggestion {...props} newSearch={item} contents={contents} />
  )
}

```

#### Suggestions Component

```javascript
import React from 'react'
import { Config } from '@leverege/plugin'

import Suggestion from './Suggestion'
import Suggestions from '../../../src/screens/group/search/suggestions/Suggestions'
import { updateSuggestions } from './Util'

const searchLongEnough = ( search ) => {
  return search?.length >= Config.get( 'ApiSuggestions', 'minSuggestionLength', 3 )
}

// a list of suggestions
export default function PetSuggestions( props ) {
  return (
    <Suggestions
      {...props}
      updateSuggestions={updateSuggestions}
      searchLongEnough={searchLongEnough}
      suggestionClass={Suggestion}
      minSuggestionLength={Config.get( 'ApiSuggestions', 'minSuggestionLength', 3 )}
      searchDebounceMs={Config.get( 'ApiSuggestions', 'searchDebounceMs', 100 )} />
  )
}
```
