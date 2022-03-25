# XYChart
## Purpose
An XYChart is a type of graph that renders a series or multiple series of data on an X-Y coordinate plane. It can for instance, render something like temperature or battery level of a sensor over time. To do this, the XYChart needs a model, some formatted data and a renderer.

### Model
The XYChartModel describes the type of graph that the XYChart will produce, from the type of [series](../plugin-points/series-renderers.md) (Line, Bar, Area, etc.) to which datum should be used for the x and y coordinates (based on [UI Attributes](../../../concepts/attributes)), to the [scale](../plugin-points/scale.md) that each axis should be rendered on (Linear, Time, Band, etc.)

When running in a Molten environment, attributes will be created for all Blueprint attributes in your Imagine project and the UI Attributes Graphs library will automatically create coordinate types for each of your attributes and assign them an appropriate default scale for their data type. For instance, an attribute with the value type of 'timestamp' will be graphable by default and will automatically be assigned a 'Time' scale type.

### Data
Data for the XYChart graph is simply an object with unique keys and values comprised of arrays of [object refs](../../../concepts/attributes/data-sources) representing the various series that you wish to graph. UI Atttributes Graphs exports a `useSeriesData` hook as a convenience in order to take data in a single array format and separate it into series chunks given an attribute to chunk on. For instance, the following data array:
```javascript
const dataArray = [
  {
    "type": "test.history",
    "id": "1",
    "data": {
      "time": 1642444110759,
      "name": "Device 1",
      "data": {
        "temperature": 45.7891
      }
    }
  },
  {
    "type": "test.history",
    "id": "2",
    "data": {
      "time": 1642461033498,
      "name": "Device 1",
      "data": {
        "temperature": 40.7705
      }
    }
  },
  {
    "type": "test.history",
    "id": "3",
    "data": {
      "time": 1642411955689,
      "name": "Device 1",
      "data": {
        "temperature": 48.7092
      }
    }
  },
  {
    "type": "test.history",
    "id": "7",
    "data": {
      "time": 1642474048199,
      "name": "Device 2",
      "data": {
        "temperature": 12.299
      }
    }
  },
  {
    "type": "test.history",
    "id": "8",
    "data": {
      "time": 1642407220379,
      "name": "Device 2",
      "data": {
        "temperature": 5.4862
      }
    }
  },
  {
    "type": "test.history",
    "id": "9",
    "data": {
      "time": 1642478679300,
      "name": "Device 2",
      "data": {
        "temperature": 4.5652
      }
    }
  }
]
```
can be passed to the useSeriesData hook with a chunk attribute of 'name' (and an optional sortAttribute of 'test.time' in order to produce arrays sorted by that attribute) in order to produce a chunked data object like so:
```javascript
const seriesData = useSeriesData( dataArray, 'name', { sortAttribute : 'test.time' } )

/*
  seriesData => {
  "Device 2": [
    {
      "type": "test.history",
      "id": "8",
      "data": {
        "time": 1642407220379,
        "name": "Device 2",
        "data": {
          "temperature": 5.4862
        }
      }
    },
    {
      "type": "test.history",
      "id": "7",
      "data": {
        "time": 1642474048199,
        "name": "Device 2",
        "data": {
          "temperature": 12.299
        }
      }
    },
    {
      "type": "test.history",
      "id": "9",
      "data": {
        "time": 1642478679300,
        "name": "Device 2",
        "data": {
          "temperature": 4.5652
        }
      }
    }
  ],
  "Device 1": [
    {
      "type": "test.history",
      "id": "3",
      "data": {
        "time": 1642411955689,
        "name": "Device 1",
        "data": {
          "temperature": 48.7092
        }
      }
    },
    {
      "type": "test.history",
      "id": "1",
      "data": {
        "time": 1642444110759,
        "name": "Device 1",
        "data": {
          "temperature": 45.7891
        }
      }
    },
    {
      "type": "test.history",
      "id": "2",
      "data": {
        "time": 1642461033498,
        "name": "Device 1",
        "data": {
          "temperature": 40.7705
        }
      }
    }
  ]
}
 */
```
If you can't use the hook because of the complexity of your data or formatting needs, a normal object keyed on some unique property will work fine, just remember to memoize the data yourself.

### Renderer
The last thing we need to render an XYChart is... a renderer. Luckily this is the simplest part of the equation. UI Attributes Graphs provides an XYChart component which takes a model instance, some data and an objectType string and will render your data in stunning color.

``` javascript
import { XYChartModel, XYChartRenderer, useSeriesData } from '@leverege/ui-attributes-graphs'

const [ model, setModel ] = useState( XYChartModel.create() )
const seriesData = useSeriesData( myUnformattedData, 'name', { sortAttribute : 'test.time' } )

return (
  <XYChartRenderer
    data={seriesData}
    objectType="test.history"
    model={model} />
)
```