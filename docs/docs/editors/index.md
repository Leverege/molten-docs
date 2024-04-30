# Editors

In order to edit any type of data, it is important to provide an editing UI and optionally some data validation. Molten provides a default set of editors and validators for most data types (string, number, int, boolean, etc.), but sometimes it is desirable to add a new data type OR to override the default editor/validator type for a particular object [Attribute](../../concepts/attributes). These aims can be accomplished through the use of only 3 plugin types, `AttributeValueEditor`, `AttributeValueValidator` and `AttributeObjectValidator`.

## AttributeValueEditor

Attributes can be edited in [Tables](../table), Detail Blocks and in dedicated [Forms](#forms). In all of these cases, the form fields will be rendered using the single `AttributeValueEditor` plugin point. `AttributeValueEditor` plugins consist of a valueType (string, number, int, boolean, etc.), an optional name and objectType, which is the name of the attribute that the editor should be tied to (e.g. location.position) and it's objectType (e.g. location), a getOptions function for supplying and additional options to the component and a create function, which is given props and context for the editor and should return a React element. Here is a simple example which is the built-in string editor:
```javascript
const opts = { 
  table : { embed : true, isRenderer : false },
  detail : { embed : true, isRenderer : false }
}

export default {
  valueType : 'string',
  getOptions : ( usage ) => { 
    return Config.get( 'AttributeStringEditor', usage, opts[usage] ) 
  },
  create : ( opts ) => {
    const { usage, style, context, attribute, editable, canSet, variant, ...options } = opts
    
    return (
      <TextInput
        style={style} // This makes it follow colorizers
        variant={EditorUtil.getVariant( usage, 'string', 'editor' )}
        {...options}
        autoFocus={usage !== 'form'}
        onDoubleClick={stopProp} />
    )
  }
}
```
### getOptions
The getOptions function here is returning an object keyed by `usage` string (more on that below). The options here are embed and isRenderer. The `embed` option controls whether the editor should be shown *in place* in a table or detail as opposed to being popped out into a dialog view. `isRenderer` controls whether this view should be used regardless of whether the `editable` flag (more on this below) is set to true or false (ie whether this editor should also serve as a "viewer"). This is sometimes advantageous when the data that is being shown is slightly more complex than a basic value type. For instance, the stored value of an enum field would be a simple string value, but the display value for the enum should be another, more human readable string value that is stored with the enum definition. Defining an enum editor as a renderer as well gives you the oportunity to fetch that data (if necessary) and map the label string to the value string for display.
### create
The `create` function here returns a simple TextInput element which allows the user to edit the value of this string field. Important properties that are passed to this create function are:

| Field | Description |
|-------|-------------|
| usage | The usage field will contain a string value representing *where* this editor is being renderered. Examples include `table`, `detail` and `form`. In this simple case, the usage field is not used, but for some editors, it might be important or desirable to render the editor differently depending on which of these different places it is appearing. The usage field allows a developer to branch their rendering logic in this way. |
| style | In molten, users are able to configure options for how they would like their data to appear. This may be as simple as the color of text but may change all sorts of different aspects of a fields appearance. The style field is an object of style attributes, appropriate for passing to a React component that has been extracted from a user's configuration for this field. It is good practice to try to apply these styles so that the value of the field appears as a user expects. |
| context | The context property passes many useful other properties from the parent rendering context. Generally, these are the props that are passed down to a [GroupScreen or ItemScreen](../data-viewers/?h=groups#groupscreen-and-iteminfoscreen-dataviewer-props) |
| attribute | The [Attribute](../../concepts/attributes) object that is being edited |
| editable | Whether or not editing mode has been turned on for this view. Note that some types of views, like forms, are always in edit mode. This property will always be true in that case. In the case where an editor is not a renderer as well, the editable property needn't be used since a different view will be rendered when not in edit mode |
| canSet | Whether the user has permission to edit this field. |
| variant | Like the style attribute, the variant attribute is a value resolved from user preferences and configuration and when possible should be passed to the underlying React component to allow proper styling |
| eventData | Event data is generally a string indicating which field the editor is editing. It should be passed to the editor component and if the editor is not a standard editor component from the @leverege/ui-elements library, it should be passed as the `data` field when calling the `onChange` function. |
| onChange | A function to be called when the value of the field changes. The format for the call should be: `{ data : eventData, value : newValue }`. If multiple fields are being changed, an object version of the change event can be used: <pre><code>{<br/> {<br/> data : {<br/>  [attribute.name] : attribute.name,<br/>  [otherAttribute.name] : otherAttribute.name <br/> },<br/> value : {<br/>  [attribute.name] : attributeValue,<br/>  [otherAttribute.name] : otherAttributeValue <br/> } <br/>} <br/>}</pre></code> |

## AttributeValueValidator
It is often important that validation occur on an attribute when it is being edited. Molten provides a set of default validators that ensure that values fall broadly in line with their declared value types (a string field should accept only string values, for instance). Further field validation can be achieved using an `AttributeValueValidator`. These plugins are passed to an ObjectValidator instance from the [@leverege/object-validator](https://bitbucket.org/leverege/object-validator/src/development) library. Documentation on how to create a validator can be found in that library's README.md. In order to register an AttributeValueValidator for a particular object field in molten, you would do something similar to the included-by-default AlphaNumeric validator that molten provides:
```javascript
import { z } from 'zod'

const ALPHA_REGEX = /^[0-9a-zA-Z\s]+$/

const validator = ( value ) => {
  if ( value == null ) {
    return true
  }

  if ( Array.isArray( value ) ) {
    return value.every( val => ALPHA_REGEX.test( val ) )
  }

  return ALPHA_REGEX.test( value )
}

molten.addPlugin( 'AttributeValueValidator', {
  name,
  objectType,
  valueValidator : z.custom( validator, opts )
} )
```
Here the validator is registered to a particular attribute name and objectType, for instance `location.name` and `location`, respectively. This ensures that whenever a user attrmpts to change the name of a location (whether in a form, a table, or anywhere else), that input will be validated using this validator (and indeed, any additional registered validators). Additional options, such as custom validation failure messages can be explored in the documentation for the @leverege/object-validator library.

### labelDecorator
One addtional useful feature of the `AttributeValueValidator` is the optional `labelDecorator` field. The `labelDecorator` is a function that is called with the original label value for a form field (if the field is being displayed in a form) and from which you can return an altered or "decorated" label. A common use of this option would be to add an asterix to any field that is required, as molten does in its default RequiredValidator:
```javascript
molten.addPlugin( 'AttributeValueValidator', {
  name,
  objectType,
  labelDecorator : ( value ) => {
    return `${value} *`
  },
  valueValidator : z.custom( ( val ) => {
    if ( val == null ) {
      return false
    }

    if ( typeof val === 'string' && val.trim().length === 0 ) {
      return false
    }

    return true
  }, { message : t( 'message', { name : attr.displayName || 'Field' } ) } )
} )
```
The return value of this function can be any valid React element.

## AttributeObjectValidator
In some cases, it is important to validate multiple fields in conjunction with each other. For this task, you will require an `AttributeObjectValidator`. These plugins will run whenever any field on a particular object is changed and will be passed the entire object's state, including updates. This allows validation of fields whose validity is dependent on the value of another field. For instance, if an "Other" option is chosen in an enum dropdown, an object validator can validate that an additional "Explanation" field is also filled out. If any other option is chosen from the dropdown, we can ignore validation of the "Explanation" field. Another example from the documentation of the @leverege/object-validator library is that of a password and confirmPassword field:
```javascript
const opts = {
  objectValidators : z.custom( ( val ) => {
    if ( val?.confirmPassword && val.password !== val.confirmPassword ) {
      return false
    }
    return true
  }, { message : 'Password and confirm password must match' } )
}
```
Here we validate that if the confirmPassword field has been filled out, it also must match what is filled in the password field.

## Forms
In addition to substituting custom form fields for attributes, the entire create or edit form for an objectType can be replaced using the `AttributeValueEditorForm` plugin.
```javascript
molten.addPlugin( 'AttributeValueEditorForm', {
  type : 'blueprint.location',
  form : LocationFormComponent
} )
```
This would, for example, replace the create/edit form entirely for all "location" objects.