The first step in implementing our pet list demo is to create "action" classes. Action classes in molten allow for a code interface to common actions that would be performed against individuals or groups of items in an API.

Some examples of these actions include requesting a list from the data's source (like a REST API) as bounded by a set of filters, creating an item in a list, updating an item in a list, deleting an item from a list, etc.

Additional actions may revolve around retrieving previously requested data in a synchronous manner (like from redux or another local state mechanism)

An example of what custom actions look like is located below

These two files demonstrate the proper way to extend ItemActions and GroupActions respectively. The base classes for ItemActions and GroupActions can be found in the `src/dataSource` folder. They contain documentation around which functions are required to be implemented to successfully extend them, and which are optional.

For the purpose of this tutorial, the most relevant functions are:

PetsActions:

- item - gets a PetActions instance relevant to a single Pet

- create - creates a pet in the pets list

- list/search - goes and gets a list of pets that match a filter object

- update - updates a specified pet in the list

- delete - deletes a specified pet from the list

- getList - gets the list that was requested by list/search from local state

PetActions:
- parent - gets a PetsActions instance

- get - goes and gets the state of a given pet

- update - updates the pet specified by this actions class

- delete - deletes the pet specified by this actions class

- getItem - gets the item specified by this actions class from local state

## Action Files

=== "PetActions"
    ```javascript
      import { GlobalState } from '@leverege/ui-redux'
      import { DataSources } from '@leverege/ui-attributes/lib/dataSource'
      import ItemActions from '../../../src/dataSource/ItemActions'
      // eslint-disable-next-line import/no-cycle
      import PetsActions from './PetsActions'
      import PetApi from './PetApi'

      export default class PetActions extends ItemActions {

        static getItem( state = GlobalState.get() ) {
          return PetApi.get( this.id )
        }

        constructor( { match, relationship, id } ) {
          super()
          this.match = match
          this.relationship = relationship
          this.systemId = relationship?.systemId
          this.id = id
        }

        getGroup() {
          return this.parent()
        }

        /**
        * Returns the parent's action object. 
        */
        parent( ) {
          return new PetsActions( {} )
        }

        getInterfaceUrl() {
          return this.getUrl()
        }

        /**
        * Returns the url for this group action object
        */
        getUrl() {
          return `pets/${this.id}`
        }

        /**
        * Returns a redux action that will call api to read a child of the current path
        * @param {object} data values of the item to be changed
        * @param {object} options api options
        * @returns {function} redux thunk function
        */
        get( ) {
          // looks like an action but doesn't touch redux
          return async () => {
            return PetApi.get( this.id )
          }
        }

        /**
        * Returns a redux action that will call the api to create an item at the current path
        * @param {object} data the data of the item to create
        * @param {object} options a set of options
        */
        create( data ) {
          return async () => {
            return PetApi.create( data )
          }
        }

        /**
        * Returns a redux action that will call api to update a child of the current path
        * @param {object} data values of the item to be changed
        * @param {object} options api options
        * @returns {function} redux thunk function
        */
        update( data ) {
          return async () => {
            const pds = DataSources.DataSourceFactory.get( 'petApi.pet' )
            const entry = pds.getData( { id : this.id } )
            return PetApi.set( this.id, { ...entry, ...data } )
          }
        }

        /**
        * Returns a redux action that will call api to delete a child of the current path
        * @param {object} options api options
        * @returns {function} redux thunk function
        */
        delete() {
          return () => {
            return PetApi.delete( this.id )
          }
        }

        // local access
        getItem() {
          return PetApi.get( this.id )
        }
        
        isLoading() {
          return false
        }

        isDone() {
          return true
        }

      }
    ```
=== "PetsActions.js"
    ```javascript
      import { GlobalState } from '@leverege/ui-redux'
      import PetActions from './PetActions'
      import GroupActions from '../../../src/dataSource/GroupActions'
      import PetApi from './PetApi'

      export default class PetsAction extends GroupActions {

        constructor( opts ) {
          super()
          this.opts = opts
          this.searches = {}
          this.queryName = 'default'
        }

        getGroup() {
          return this
        }

        getInterfaceUrl() {
          return this.getUrl()
        }

        /**
         * Returns the url for this group action object
         */
        getUrl() {
          return 'pets'
        }

        /**
         * Creates a item action for the id in the group.
         */
        item( id ) {
          return new PetActions( { id } )
        }

        itemRef( id ) {
          return {
            type : this.relationship.blueprint.type,
            ref : this.getUrl(),
            id
          }
        }

        /**
         * Returns a redux action that will call api to create an item as a child of the current path
         * @param {object} obj item to be created
         * @param {object} options api options
         * @returns {function} redux thunk function 
         */
        create( obj, options ) {
          return async () => {
            return PetApi.create( obj )
          }
        }

        /**
         * Create a dispatch action for a request of a list of objects
         */
        list( options ) {
          return this.search( options )
        }

        search( obj, options ) {
          return async ( dispatch, getState, { api } ) => {
            const search = obj?.filter?.value
            const queryName = options?.queryName || this.queryName
            const perPage = obj?.perPage || obj?.limit || 200
            this.searches[queryName] = { perPage, search }
            const res = await PetApi.search( this.searches[queryName] )
            return res
          }
        }

        /**
         * Returns a redux action that will call api to update a child of the current path
         * @param {string} id id of the item to be updated
         * @param {object} data values of the item to be changed
         * @param {object} options api options
         * @returns {function} redux thunk function
         */
        update( id, data, options ) {
          return this.item( id ).update( data, options )
        }

        /**
         * Returns a redux action that will call api to delete a child of the current path
         * @param {string} id id of the item to be deleted
         * @param {object} options api options
         * @returns {function} redux thunk function
         */
        delete( id, body, options, reducerOptions ) {
          return this.item( id ).delete( body, options, reducerOptions )
        }

        getList( state = GlobalState.get(), options ) {
          const queryName = options?.queryName || this.queryName
          const res = PetApi.search( this.searches[queryName] )
          return res
        }

        isLoading( state = GlobalState.get() ) {
          return false
        }

        isDone( state = GlobalState.get() ) {
          return true
        }
      }

    ```

## Mock Pet API

The mock api below simulates normal functions of an API without requiring an externally running api.  

```javascript
  import B62 from '@leverege/base62-util'
  import Gen from 'project-name-generator'
  import { UI, GlobalState } from '@leverege/ui-redux'
  import { Attributes } from '@leverege/ui-attributes'

  function createPet( data ) {
    return {
      id : B62.v4(),
      type : 'petApi.pet',
      name : data?.name == null ? Gen().spaced : data?.name,
      age : data?.age == null ? Math.ceil( Math.random() * 20 ) : data?.age,
      position : data?.position == null ? {
        lat : 38 + ( Math.random() - 0.5 ),
        lon : -76 + ( Math.random() - 0.5 )
      } : data?.position
    }
  }

  /**
  * This is a mock of an api and thus makes no requests, in a real
  * situation this would reach out to external data.
  */
  class PetApi {

    generateData = ( count = 200 ) => {
      const data = {}
      const list = []
      for ( let n = 0; n < count; n++ ) {
        const p = createPet()
        data[p.id] = p
        list.push( p )
      }
      GlobalState.dispatch( UI.multiSet( { petList : list, petData : data } ) )
    }

    get( id ) {
      const state = GlobalState.get()
      const data = state?.ui?.petData
      return data?.[id]
    }

    set( id, newValue ) {
      const state = GlobalState.get()
      const data = state?.ui?.petData
      const list = state?.ui?.petList

      if ( !data[id] ) {
        return null
      }
      const index = list.findIndex( item => item.id === id )

      const nList = [
        ...list.slice( 0, index ),
        newValue,
        ...list.slice( index + 1 )
      ]
      const nData = {
        ...data,
        [id] : newValue
      }
      GlobalState.dispatch( UI.multiSet( { petList : nList, petData : nData } ) )
      return nList
    }

    delete( id ) {
      const state = GlobalState.get()
      const data = state?.ui?.petData
      const list = state?.ui?.petList

      const nData = { ...data }
      delete nData[id]
      const nList = list.filter( entry => entry.id !== id )
      GlobalState.dispatch( UI.multiSet( { petList : nList, petData : nData } ) )
    }

    create( newData ) {
      const state = GlobalState.get()
      const data = state?.ui?.petData
      const list = state?.ui?.petList

      const newPet = createPet( newData )
      const nData = { ...data }
      const nList = [ ...list ]
      nData[newPet.id] = newPet
      nList.unshift( newPet )
      GlobalState.dispatch( UI.multiSet( { petList : nList, petData : nData } ) )
    }

    search( { perPage, search } = { perPage : 200, search : null } ) {
      const state = GlobalState.get()
      let list = state?.ui?.petList

      if ( !list && !this.loaded ) {
        this.loaded = true
        process.nextTick( () => this.generateData() )
        return null
      }

      if ( !list ) {
        return null
      }
      
      const res = list
      const items = {}
      const toCheck = search?.replace( /[*]/g, '' )
      if ( toCheck ) {
        const attrs = Attributes.getAttributesFor( 'petApi.pet' )
        attrs.forEach( ( attr ) => {
          if ( attr.valueType !== 'string' ) {
            return
          }
          res?.forEach( ( i ) => {
            const val = attr.get( i )
            if ( typeof val === 'string' && val.toLowerCase().includes( toCheck.toLowerCase() ) ) {
              items[i.id] = i
            }
          } )
        } )
        list = Object.values( items )
      }

      return {
        total : list.length,
        start : 0,
        perPage,
        count : list.length,
        items : list
      }
    }

  }

  export default new PetApi()
```