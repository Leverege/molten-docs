Pets have 3 attributes (besides their id): Name, Age, and Position.

To be able to view these attributes in a table, update form, or creation form, `Attribute` plugins must be created for them.

Attributes plugins have a few required fields, namely:

- name - The name of the Attribute, which is used to look it up along with objectType to perform common operations

- objectType - The type of object this Attribute is relevant to, which is used along with name to look it up to perform common operations

- valueType - The type of the attribute, which can be anything, but common types include `strings`, `numbers`, `integers`, `geoPoints`, `geoJson`, and `Timestamp`.

- get - This function is used by display and update mechanisms to get the current value of this attribute given an instance of the objectType it pertains to and some context

- displayName - A field of the Attribute used to display the attribute in lists for configuration or default titles

=== "Name Attribute"
    ```javascript
      {
        name : 'name',
        objectType : 'petApi.pet',
        valueType : 'string',
        get : ( data, cxt ) => { 
          return data?.name
        },
        displayName : 'Name'
      }
    ```

=== "Age Attribute"
    ```javascript
      {
        name : 'age',
        objectType : 'petApi.pet',
        valueType : 'number',
        get : ( data, cxt ) => { 
          return data?.age
        },
        displayName : 'Age'
      }
    ```

=== "Position Attribute"
    ```javascript
      {
        name : 'geoPosition',
        objectType : 'petApi.pet',
        valueType : 'geoPoint',
        get : ( data, cxt ) => { 
          return data?.position
        },
        displayName : 'Position'
      }
    ```
=== "Setup"
    ```javascript
      molten.addPlugin( 'Attribute', NameAttribute )
      molten.addPlugin( 'Attribute', AgeAttribute )
      molten.addPlugin( 'Attribute', PositionAttribute )
    ```