# Columns

Most of the available customization in the Table module is in tweaking and customizing the way that columns are rendered. By default, each attribute you create will automatically have a [ColumnCreator](https://bitbucket.org/leverege/ui-attributes/src/development/src/attribute/AttributeColumnCreator.js){:target="_blank"} generated for it. This column creator is capable of generating an [AttributeColumnModel](https://bitbucket.org/leverege/ui-attributes/src/development/src/table/type/AttributeColumnModel.js){:target="_blank"} or [UnitAttributeColumnModel](https://bitbucket.org/leverege/ui-attributes/src/development/src/table/type/UnitAttributeColumnModel.js){:target="_blank"} depending upon whether your attribute represents a unit type or not. AttributeColumnModel and UnitAttributeColumnModel instances each have built in editors and renderers that are capable of allowing a user to customize things like text color, font style, background color, unit and value formatting, unit conversion and more.

## Customization

You can also customize the behavior and appearance of table columns using the available table [Plugin Points](../plugin-points).