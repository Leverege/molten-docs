# Attributes

Molten make use of a mechanism call `attributes` for much of its data access. An Attribute is used to access a named piece of data about an object. This piece of data may represent a unique property on the data being accesssed, or it might represent a shared idea that can be applied to many types of objects, such as a human readable name or geographic position. 

These Attributes are used in a variety of places in molten to facilitate different needs. For example, when presenting data columns in a table or information to see in a detail card, the user will pick which Attributes to use. When rendering to a geographic map, the geodetic position attribute can be used to place the object. When building a logical condition to do dynamic data styling or alerting, the Attributes can be selected to perform the conditional if/then logic.

The Attribute is acting as a delegate between the attribute name and a particular type of object. It provides a common interface to get data and in some cases, set data. Where pieces of information represent a well known and shared concept, a well known attribute name is used. Where the data represents very specific information, a unique attribute name can be used. To demonstrate this concept, here are some example attribute names:


| Attribute Name | What is it |
|----------------|------------|
| name | The user displayable name of the object. This is a shared Attribute that can be used in a generic information display or readout that tells the user what it is. Usually, every object type can have one of these, even if it just returns the objects unique id. |
| icon | Returns an image url ro font icon class name used to represent the object |
| geoPosition | This represents the latitude/longitude of an object. This could be used to map any geo spatial point object on a map, or perform a containment check against it for alert purposes. |
| boat.bilge.status | A example of a unique attribute about a boat's bilge status. When an attribute is unique to a type of object, its name should be prefixed with the object type, boat in this case.  |
| myType.myAttribute | A example of a unique attribute.  |

The Attribute acts as a normalization mechanism between the name of the attribute and the type of an attribute. For example, an object of type `car` may store its geographic position in a `lat` and `lon` field, while an object of type `boat` may store it in a `geoPosition : { latitude, longitude }` subfield. The attribute for the car knows to access the lat and lon field and assemble the appropriate geoPosition object. The boat, likewise, would know to use the `geoPosition` field. 

The attribute when registered, supplies the attibrute name and type of object it works against, as well as the method to retreive the data. This allows the car and boat attribute to extract the data appropriately based on the objects data type and return the correct format of the data. 

The fields of an Attribute are:

| Field      | Type       | Description |
|------------|------------|-------------|
| name       | string     | Defines the name of the attribute |
| objectType | string     | The string name of the type of object the attribute can get/set data on. |
| valueType  | string     | The type of object the returned from get(). The valueType must be the same for all attributes with the same name. |
| displayName | string | The human display name of the attribute |
| get        | function   | A function( object, context ) that returns the value of the attribute for the given object. If `Attributes.get()` is invoked with the objRef, the `data` portion of the obejctRef will be given to this function unless the Attribute sets `usesObjRef` to `true`.  |
| usesObjRef | boolean    | Defaults to false. If this is true, the objRef will be given to the `get()` method |
| canSet     | function   | Optional. A function( objRef, value, context ) the should return true or false, indicating where or not the set function is available |
| set        | function   | Optional. A function( object, value, context ) invoked to perform the set |


!!! Info "Attributes Library"
    The `@leverege/ui-attributes` library contains all of the base mechanics to make this work.

## Value Types

There are many default valueTypes supplied. You can make your own as well. You will need to add other plugins to support other mechanism such as Details and Tables. Here is a list of the predefined valueTypes:


| Value Type | Return |
|----------------|-------------|
| string | string |
| number | number |
| timestamp | Date |
| boolean | boolean |
| int | number |
| icon | string of a url or a font icon class name |
| percent | number |
| length | `UnitType` |
| speed | `UnitType` |
| acceleration | `UnitType` |
| surface | `UnitType` |
| volume | `UnitType` |
| mass | `UnitType` |
| time | `UnitType` |
| frequency | `UnitType` |
| angle | `UnitType` |
| current | `UnitType` |
| temperature | `UnitType` |
| substanceAmount | `UnitType` |
| luminousIntensity | `UnitType` |
| force | `UnitType` |
| energy | `UnitType` |
| power | `UnitType` |
| pressure | `UnitType` |
| electricCharge | `UnitType` |
| electricCapacitance | `UnitType` |
| electricPotential | `UnitType` |
| electricResistance | `UnitType` |
| electricInductance | `UnitType` |
| electricConductance | `UnitType` |
| magneticFlux | `UnitType` |
| magneticFluxDensity | `UnitType` |
| bit | `UnitType` |
| flow | `UnitType` |
| geoPoint | Object containing `{ lat, lon }` where lat and lon are in degrees |
| geoJson | string containing the geoJson data |
| relationship | string *(Imagine attribute type)* |
| parentRelationship | string id *(Imagine attribute type)* |
| enum | string *(Imagine attribute type)* |

`UnitType` is an object that contains { type : <UnitType>, value, unit }.