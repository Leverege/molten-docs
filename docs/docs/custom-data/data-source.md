The second step of consuming custom data in your molten application is creating a DataSource. More general DataSource documentation can be found [here](/docs/data-sources)

For our use case, of creating a list of pets, the DataSource might look like this:

```javascript
import { GlobalState } from '@leverege/ui-redux'
import PetsActions from './PetsActions'
import PetActions from './PetActions'

export default class PetDataSource {

  dataSource() {
    return 'petApi.pets'
  }

  getData( objRef ) {
    const state = GlobalState.get()
    const data = state?.ui?.petData
    return data?.[objRef.id]
  }

  getActions( objRef ) {
    if ( objRef?.id ) {
      return new PetActions( { item : objRef, id : objRef?.id } )
    }
    return new PetsActions()
  }

}
```

Notice that in the getActions function we are returning instances of our PetActions and PetsActions classes as implemented in the previous step.