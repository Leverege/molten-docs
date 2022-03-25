Beyond basic list functionality, it's easy in molten to add actions to Create, Update, and Delete items in your list if those are things your API supports.

Below is the code for basic actions to perform these operations continuing the pet shop example.

## Create Action

=== "Plugin"
    File **CreateAction.js**
    ```javascript
      import { Dialogs } from '@leverege/ui-elements'
      import { Config } from '@leverege/plugin'
      import CreatePet from '../views/CreatePet'

      // given a Relationship instance, make a create action that can be installed into molten
      export default relationship => ( { 
        id : 'action.pet.CreateItem',
        name : 'Create Pet Item',
        layout : { sort : 'item.add' },
        handles : cxt => true,
        appearance : ( ) => {
          return { 
            name : 'Create Pet', 
            icon : Config.get(
              'BlueprintActions',
              'createIcon',
              'https://storage.googleapis.com/molten-ui-assets/create-action.png'
            )
          }
        },
        perform : ( { context } ) => {
          const { clientProps : { actions }, reloadData } = context
          
          Dialogs.show( {
            component : CreatePet,
            props : { reloadData, actions, relationship }
          } )
        }
      } )
    ```
=== "Create Pet Component"
    File **CreatePet.jsx**
    ``` javascript
      import React from 'react'
      import { Dialog, Toast } from '@leverege/ui-elements'
      import { GlobalState } from '@leverege/ui-redux'

      import CreateEditForm from './CreateEditForm'

      export default function CreatePet( props ) {
        const { show, onClose, actions, value, reloadData } = props

        const onSubmit = async ( { value } ) => {
          try {
            await GlobalState.dispatch( actions.create( value ) )
            Toast.success( 'Successfully Created Pet' )
          } catch ( err ) {
            console.error( err )
            Toast.error( 'Failed to Create Pet' )
          }
          await reloadData?.()
          onClose()
        }

        return (
          <Dialog show={show} onClose={onClose}>
            <CreateEditForm
              {...props}
              value={value}
              title="Create Pet"
              submitText="Submit"
              onSubmit={onSubmit}
              onCancel={onClose} />
          </Dialog>
        )
      }  
    ```
=== "Shared Create/Edit Form"
    File **CreateEditForm.jsx**
    ```javascript
      import React from 'react'
      import { Pane, Button, TextInput, NumericInput, PropertyGrid, Content } from '@leverege/ui-elements'
      import { TitleBar } from '@leverege/ui-plugin'
      import { GeoPointEditor } from '@leverege/ui-geo-elements'

      export default class CreateEditForm extends React.Component {

        constructor( props ) {
          super( props )
          const { value } = props
          this.state = {
            newValue : value
          }
        }

        onCancel = ( evt ) => {
          const { onCancel, eventData } = this.props
          return onCancel?.( { data : eventData, value : null, originalEvent : evt } )
        }

        onSubmit = ( evt ) => {
          const { onSubmit, eventData } = this.props
          const { newValue } = this.state

          return onSubmit?.( { data : eventData, value : newValue, originalEvent : evt } )
        }

        onAgeChange = ( evt ) => {
          const { newValue } = this.state
          this.setState( {
            newValue : { ...newValue, age : evt?.value }
          } )
        }

        onNameChange = ( evt ) => {
          const { newValue } = this.state
          this.setState( {
            newValue : { ...newValue, name : evt?.value }
          } )
        }

        onPositionChange = ( evt ) => {
          const { newValue } = this.state
          this.setState( {
            newValue : { ...newValue, position : evt?.value }
          } )
        }

        render() {
          const { value, submitText, title, titleIcon } = this.props
          const { newValue } = this.state
          return (
            <Content relative>
              <Content.Header variant="formHeader">
                <TitleBar variant="dialogTitle" title={title} icon={titleIcon} />
              </Content.Header>
              <Content.Area variant="formBody">
                <Pane>
                  <PropertyGrid>
                    <PropertyGrid.Item label="Name">
                      <TextInput value={newValue?.name} onChange={this.onNameChange} />
                    </PropertyGrid.Item>
                    <PropertyGrid.Item label="Age">
                      <NumericInput value={newValue?.age} onChange={this.onAgeChange} />
                    </PropertyGrid.Item>
                    <PropertyGrid.Item label="Position">
                      <GeoPointEditor value={newValue?.position} onChange={this.onPositionChange} />
                    </PropertyGrid.Item>
                  </PropertyGrid>
                </Pane>
              </Content.Area>
              <Content.Footer variant="formButtons" layout="flex:rowMEnd">
                <Pane layout="flex:rowM">
                  <Button variant="secondary" onClick={this.onCancel}>Cancel</Button>
                  <Button disabled={newValue === value} variant="primary" onClick={this.onSubmit}>{submitText}</Button>
                </Pane>
              </Content.Footer>
            </Content>
            
          )
        }
      }
    ```
## Update Action

=== "Plugin"
    File **UpdateAction.js**
    ```javascript
      import { Dialogs } from '@leverege/ui-elements'
      import { Config, Context } from '@leverege/plugin'
      import { DataSources } from '@leverege/ui-attributes'
      import UpdatePet from '../views/UpdatePet'

      // given a Relationship instance, make an update action that can be installed into molten
      export default relationship => ( { 
        id : 'blueprint.action.pet.UpdateItem',
        name : 'Update Pet Item',
        layout : { sort : 'item.update' },
        handles : ( cxt ) => { 
          const targets = Context.getTargetsOfType( cxt, 'petApi.pet' )
          return !( targets == null || targets.length === 0 || targets.length > 1 )
        },
        appearance : ( ) => {
          return { 
            name : 'Update Pet', 
            icon : Config.get(
              'BlueprintActions',
              'updateIcon',
              'https://storage.googleapis.com/molten-ui-assets/update-action.png'
            )
          }
        },
        perform : ( { context } ) => {
          const { reloadData } = context
          const target = Context.getTargetOfType( context, 'petApi.pet' )
          const actions = DataSources.getActions( target )

          Dialogs.show( {
            component : UpdatePet,
            props : { reloadData, actions, relationship, value : target?.data }
          } )
        }
      } )
    ```
=== "Update Pet Component"
    File **UpdatePet.jsx**
    ```javascript
      import React from 'react'
      import { GlobalState } from '@leverege/ui-redux'
      import { Dialog, Toast } from '@leverege/ui-elements'

      import CreateEditForm from './CreateEditForm'

      export default function UpdatePet( props ) {
        const { show, onClose, actions, value, reloadData } = props

        const onSubmit = async ( { value } ) => {
          try {
            await GlobalState.dispatch( actions.update( value ) )
            Toast.success( 'Successfully Updated Pet' )
          } catch ( err ) {
            console.error( err )
            Toast.error( 'Failed to Update Pet' )
          }
          await reloadData?.()
          onClose()
        }

        return (
          <Dialog show={show} onClose={onClose}>
            <CreateEditForm
              {...props}
              value={value}
              title="Update Pet"
              submitText="Update"
              onSubmit={onSubmit}
              onCancel={onClose} />
          </Dialog>
        )
      }
    ```
=== "Shared Create/Edit Form"
    File **CreateEditForm.jsx**
    ```javascript
      import React from 'react'
      import { Pane, Button, TextInput, NumericInput, PropertyGrid, Content } from '@leverege/ui-elements'
      import { TitleBar } from '@leverege/ui-plugin'
      import { GeoPointEditor } from '@leverege/ui-geo-elements'

      export default class CreateEditForm extends React.Component {

        constructor( props ) {
          super( props )
          const { value } = props
          this.state = {
            newValue : value
          }
        }

        onCancel = ( evt ) => {
          const { onCancel, eventData } = this.props
          return onCancel?.( { data : eventData, value : null, originalEvent : evt } )
        }

        onSubmit = ( evt ) => {
          const { onSubmit, eventData } = this.props
          const { newValue } = this.state

          return onSubmit?.( { data : eventData, value : newValue, originalEvent : evt } )
        }

        onAgeChange = ( evt ) => {
          const { newValue } = this.state
          this.setState( {
            newValue : { ...newValue, age : evt?.value }
          } )
        }

        onNameChange = ( evt ) => {
          const { newValue } = this.state
          this.setState( {
            newValue : { ...newValue, name : evt?.value }
          } )
        }

        onPositionChange = ( evt ) => {
          const { newValue } = this.state
          this.setState( {
            newValue : { ...newValue, position : evt?.value }
          } )
        }

        render() {
          const { value, submitText, title, titleIcon } = this.props
          const { newValue } = this.state
          return (
            <Content relative>
              <Content.Header variant="formHeader">
                <TitleBar variant="dialogTitle" title={title} icon={titleIcon} />
              </Content.Header>
              <Content.Area variant="formBody">
                <Pane>
                  <PropertyGrid>
                    <PropertyGrid.Item label="Name">
                      <TextInput value={newValue?.name} onChange={this.onNameChange} />
                    </PropertyGrid.Item>
                    <PropertyGrid.Item label="Age">
                      <NumericInput value={newValue?.age} onChange={this.onAgeChange} />
                    </PropertyGrid.Item>
                    <PropertyGrid.Item label="Position">
                      <GeoPointEditor value={newValue?.position} onChange={this.onPositionChange} />
                    </PropertyGrid.Item>
                  </PropertyGrid>
                </Pane>
              </Content.Area>
              <Content.Footer variant="formButtons" layout="flex:rowMEnd">
                <Pane layout="flex:rowM">
                  <Button variant="secondary" onClick={this.onCancel}>Cancel</Button>
                  <Button disabled={newValue === value} variant="primary" onClick={this.onSubmit}>{submitText}</Button>
                </Pane>
              </Content.Footer>
            </Content>
            
          )
        }
      }
    ```

## Delete Action
=== "Plugin"
    File **DeleteAction.js**
    ```javascript
    import { Context, Config } from '@leverege/plugin'
    import { Dialogs } from '@leverege/ui-elements'
    import DeletePet from '../views/DeletePet'

    export default ( relationship, { objectType, name, namePlural } ) => {
      const { path, attribute } = relationship
      const sectionName = `${name} Actions`

      return {
        id : `action.${path}.DeleteItem`,
        name : `Delete ${namePlural} Items`,
        layout : { sort : 'item.zzz', sectionName },
        handles : ( cxt ) => { 
          const targets = Context.getTargetsOfType( cxt, objectType )
          return !( targets == null || targets.length === 0 )
        },
        appearance : ( { context, action } ) => { 
          const targets = Context.getTargetsOfType( context, objectType )
          const num = targets.length
          return { 
            name : num < 2 ? `Delete ${name}` : `Delete ${num} ${namePlural}`,
            icon : Config.get(
              'PetActions',
              'deleteIcon',
              'https://storage.googleapis.com/molten-ui-assets/delete-action.png'
            ),
            disabled : num === 0
          }
        },
        perform : ( { context } ) => { 
          const { clientProps : { actions, targetKey } } = context
          const targets = Context.getTargetsOfType( context, objectType )
          if ( targets.length === 0 ) {
            return
          }
          Dialogs.show( {
            component : DeletePet,
            props : {
              targets,
              actions,
              attribute,
              isItem : false,
              selectionKey : targetKey,
            } } )
        }
      }
    }
    ```
=== "Delete Pet Component"
    File **DeletePet.jsx**
    ```javascript
      /* eslint-disable no-await-in-loop */
      import React from 'react'
      import { DataSources } from '@leverege/ui-attributes'
      import { GlobalState, Selection } from '@leverege/ui-redux'
      import { Dialog, Toast } from '@leverege/ui-elements'

      /**
      * Removes the userIds from the given action.
      */
      async function onRemove( { data } ) {

        // Get parameters
        const { targets, selectionKey, onClose } = data
        const num = targets.length
        if ( num === 0 ) {
          onClose()
          return
        }
        // Try to remove users
        let success = 0
        let failure = 0
        let err = null

        for ( let n = 0; n < num; n++ ) {
          try { 
            const tgt = targets[n]
            const actions = DataSources.getActions( tgt )
            await GlobalState.dispatch( actions.delete() )
            success++
            if ( selectionKey ) {
              GlobalState.dispatch( Selection.remove( selectionKey, tgt.id ) )
            }
          } catch ( error ) {
            failure++
            if ( err == null ) {
              err = error
            }
            // eslint-disable-next-line no-console
            console.error( error )
          }
        }

        // Successfully removed
        if ( failure === 0 ) {
          Toast.success( `${success === 1 ? '' : num} Pet${num === 1 ? '' : 's'} Deleted` )
        } else if ( success === 0 ) {
          Toast.error( [ `Failed to Delete ${failure === 1 ? '' : num} Pet`, err.message ] )
        } else {
          Toast.warn( [ `Deleted ${success}/${num} Pet. Failed to delete ${failure}.`, err.message ] )
        }
        onClose()
      }

      /**
      * Remove users dialog.
      */
      export default function DeletePet( props ) {

        // Get parameters
        const { onClose, show, targets } = props

        const num = targets?.length || 0
        const title = num < 2 ? 'Pet' : `${num} Pets`
        const button = 'Delete'
        const titleType = 'Delete'
        const extra = `This will permanently delete the ${title} and cannot be undone.`

        // Render component
        return (
          <Dialog.Question
            show={show}
            eventData={props}
            title={`${titleType} ${title}?`}
            message={`Are you sure you want to DELETE ${num} Pet${num === 1 ? '' : 's'}? ${extra}`}
            okay={button}
            okayVariant="primaryDestructive"
            onCancel={onClose}
            onOkay={onRemove}/>
        )
      }
    ```

## Setup

File **PluginSetup.js**
```javascript
import DeleteAction from './DeleteAction'
import CreateAction from './CreateAction'
import UpdateAction from './UpdateAction'
import Relationship from '../../../src/dataSource/Relationship'

const objectType = 'petApi.pet'
const name = 'Pet'
const namePlural = 'Pets'

exports.install = ( molten ) => {

  const relationship = new Relationship( { 
    apiName : 'petApi',
    name : 'pets',
    objectType,
    path : 'petApi.pets',
    refPath : '/pets',
    urlPath : '/pets',
  } )
  
  molten.addPlugin( 'Action', DeleteAction( relationship, { objectType, name, namePlural } ) )
  molten.addPlugin( 'Action', CreateAction( relationship, { objectType, name, namePlural } ) )
  molten.addPlugin( 'Action', UpdateAction( relationship, { objectType, name, namePlural } ) )
}
```