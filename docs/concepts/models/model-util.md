# Model Util

The Leverege model util library `@leverege/model-util` is a helpful tool for creating and managing immutable models.

## Example

Let's say you have an instance of a `pet` model that looks like this:

```javascript
let fluffy = {
  type : 'pet',
  name : 'Fluffy',
  species : 'cat',
  color : 'white',
  // fluffy might be immortal
  birthDate : '1973-01-08T00:00:00.000Z'
}
```

And you need to be able to update the `species`, `color`, and `birthDate` of Fluffy because given
their apparent immortality you're no longer convinced they're a cat. You have a couple of options do so
immutably. The naive (and wrong) way to do it is as follows:

```javascript
fluffy = {
  ...fluffy,
  species : 'shapeshifter',
  color : 'cream',
  birthDate : '0000-01-01T00:00:00.000Z'
}
```

???+ danger

    Don't modify models like this, its not reproducible across the code base and is prone to errors

The better way to modify a model is like so:

=== "PetModel.js"
    ```javascript
    const { createAllValue, createAllArray, createAllMap } = require( '@leverege/model-util' )

    module.exports = {
      ...createAllValue( 'name', 'Name' ),
      ...createAllValue( 'species', 'Species' ),
      ...createAllValue( 'color', 'Color' ),
      ...createAllValue( 'birthDate', 'BirthDate' ),
    }
    ```

=== "EditFluffy.js"
    ```javascript
    const PetModel = require( './PetModel' )

    let fluffy = {
      type : 'pet',
      name : 'Fluffy',
      species : 'cat',
      color : 'white',
      // fluffy might be immortal
      birthDate : '1973-01-08T00:00:00.000Z'
    }

    fluffy = PetModel.setSpecies( fluffy, 'shapeshifter' )
    fluffy = PetModel.setColor( fluffy, 'cream' )
    fluffy = PetModel.setBirthDate( fluffy, '0000-01-01T00:00:00.000Z' )
    ```

## createAllValue( key, name, setOpts, getOpts )
  
  createAllValue will return an object like the following

  ```javascript
  {
    `set${name}`( model, newVal ) { ... },
    `get${name}`( model ) { ... }
  }
  ```

  This can be used to get and set a value at a known key in a model
## createAllArray( key, name, namePlural )

  discussion about normalization of this into
  ```javascript
  { 
    // adds an item into the array at a given index
    `add${name}`( model, item, insertAt ) { ... },
    // remove an item (without knowing the index in the array)
    `remove${name}`( model, item ) { ... },
    // remove an item at a given index
    `remove${name}At`( model, index ) { ... },
    // set a given index to a new value
    `set${name}`( model, index, value ) { ... },
    // swap two items in the array
    `swap${namePlural}`( model, index1, index2 ) { ... },
    // move an item to a new index
    `move${name}`( model, from, to ) { ... },
    // empty the array
    `clear${namePlural}`( model ) { ... },
    // set the whole array
    `set${namePlural}`( model, value ) { ... },
    // get an item at a known index
    `get${name}`( model, index ) { ... },
    // get the whole array
    `get${namePlural}`( model ) { ... },
    // get the index of a given item in the array (-1 if its not in the array)
    `indexOf${name}`( model, item ) { ... },
  }
  ```

## createAllMap( key, name, namePlural)
  discussion about normalization of this into
  ```javascript
  {
    // set a known key to a new value
    `set${name}`( model, itemKey, item ) { ... },
    // get the value at a known key
    `get${name}`( model, itemKey ) { ... },
    // check if the map has a value at a known key
    `contains${name}`( model, itemKey ) { ... },
    // remove the value at a known key
    `remove${name}`( model, itemKey ) { ... },
    // set the whole map to a new object
    `set${namePlural}`( model, object ) { ... },
    // get the whole map
    `get${namePlural}`( model ) { ... },
    // get all the entries in the map
    `get${name}Entries`( model ) {... },
    // remove all keys from the map
    `clear${namePlural}`( model ) { ... },
  }
  ```

