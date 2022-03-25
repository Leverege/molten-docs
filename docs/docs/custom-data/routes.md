Once you have actions, a dataSource, and ui-attributes, the next step is to create a screen. For this example we intend to re-use the GroupScreen.

## Using GroupScreen

If you've been following along so far, using the GroupScreen is easy! All of the hard work came from the implementation of your DataSource and Action classes earlier.

Assuming you stuck to the interface as specified previously, all you have to do to use the GroupScreen is include it as the component in your route (seen in the next step), and pass it the right props, namely:

- objectType - in this case petApi.pet, but just the type you picked for you items

- relationship - an instance of the Relationship class from molten

- actions - an instance of your PetsActions class from before

This will look like this:
```javascript
const props = {
  objectType : 'petApi.pet',
  relationship : new Relationship( { 
    apiName : 'petApi',
    name : 'pets',
    objectType : 'petApi.pet',
    path : 'petApi.pets',
    refPath : '/pets',
    urlPath : '/pets'
  } ),
  actions : new PetsActions()
}
```

## Installing the Route

`Route`s are another type of plugin, and have several required keys. The Pets Screen `Route` plugin looks like this:

```javascript
  {
    // all plugins need a unique id
    id : 'pets.route.PetScreen',
    // what is the url of the route? This will be prefixed in the final ui
    // by the molten baseRoute, which may include additional information like
    // systemId and person
    path : '/pets/',
    // whether or not the path has to be an exact match to render
    exact : true,
    // where in the ui the route will go. This means it
    // will be rendered at the route inside the Main Screen.
    // This is common for root level ui screens.
    matches : { client : 'Main' }, 
    // what React component is rendered by the route (this is the molten GroupScreen)
    component : GroupScreen,
    // what props should be passed to the GroupScreen
    props : {
      objectType : 'petApi.pet',
      relationship : new Relationship( { 
        apiName : 'petApi',
        name : 'pets',
        objectType : 'petApi.pet',
        path : 'petApi.pets',
        refPath : '/pets',
        urlPath : '/pets'
      } ),
      actions : new PetsActions()
    }
  }
```

and is installed like so:
```javascript
  molten.addPlugin( 'Route', PetRoute )
```

Of course without a way to get to that route in the ui, its not particularly useful! The best way to install a link to your new pet shop route is with a LinkAction, which
can be created and installed like so:
```javascript
  // this import is different when working from the molten demo folder
  import { LinkAction } from '@leverege/molten/lib/routes'

  const PetLink = LinkAction.create( {
    id : 'pet.PetsLink',
    matches : { use : 'navBar', client : 'Main' },
    name : 'Pets', 
    icon : 'fa fa-bug fa-fw',
    path : '/pets'
  } )

  molten.addPlugin( 'Action', PetLink )
```