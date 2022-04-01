# Getting Started

## Overview

The primary component of Leverege Build is Molten. Molten is a React-based plugin framework for rapid UI development. Simply write and register a plugin and Molten will make it available throughout your application exactly where you need it--without requiring changes to existing code.

At its core, Molten is a plugin registry with update and access mechanisms. It also includes an extensive suite of pre-built plugins that solve common data patterns and visualizations. Molten's default plugins are designed to make it easy to build powerful IoT applications using the Leverege Stack, but Molten can be used on its own to make your codebase more modular, dynamic, and flexible.

Molten gives you the ability register new plugins--code to be accessed elsewhere in the app--and to add new plugin points that call your custom code. This means you have maximum control over the data and displays driving your app. Add a button that appears on select toolbars. Call a function that conditionally colors icons based on external data. Query an API and render items on a table and a map. You can use Molten to make small changes to an existing app, or as a starting point for a totally custom product.

!!! tip Learn more
    To learn more about Molten's key concepts before jumping in, see the Concepts section for an overview of plugins, models, and attributes.

## Using Molten with Leverege's IoT Stack

[Leverege's IoT Stack](https://www.leverege.com/iot-stack/overview) provides a powerful, flexible system for working with internet connected devices, and the businesses built around them. Molten's default settings and plugins make working with your Leverege project simple.

It handles user authentication and dynamically creates routes and views based on your Imagine project configuration. Molten uses Leverege's Builder tool for advanced themeing allowing you to dial in the look and feel of your app. You can learn more about configuring your Imagine project in the tutorials on the [Leverege User Configuration](https://stack-docs.leverege.com/4.0.0/config/).

To get started:

* Install Molten: `npm i @leverege/molten`
* Molten uses Mapbox for geographic utilities (map displays, geocoding). You will need to add a Mapbox API key to your `.env`

  ```shell
    MAPBOX_APIKEY=your-api-key-here
  ```

* Initialize Molten in your startup script

  *index.js*

  ```javascript
  import Molten from '@leverege/molten'
  import Theme from './Theme' // path to your exported theme

  function start() {
    const theme = {
      theme : Theme,
      appearanceProjectId : '<your-Builder-appearance-id>',
      useActiveTheme : true // if true, Molten will pull theme data from Builder in real time, immediately reflecting design change. Set to false for production or to improve performance.
    }

    const api = {
      host : 'https://example-api.leverege.com', // your Leverege API host
      systemId : '<your-system-id>', // system in your Leverege Project
      projectId : '<your-project-id>', // your Leverege Project ID
      storeToken : true
    }

    const config = { theme, api }

    Molten.init( config )

    Molten.create()
  }

  window.Application = { start }
  ```

* Configure your html to start the application

*index.html*

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>My Leverege Project With Molten</title>
  <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1" />
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"/>
</head>

<body>
  <div id="root" style="z-index:0">
    <script src="/index.js"></script>
    <script> Application.start( ) </script>
  </div>
</body>
</html>
```

* Start your application: `npm start`

## Using Molten without Leverege's IoT Stack

You do not need to use Leverege's IoT Stack to benefit from using Molten. Its plugin framework can make any codebase simpler and more extensible.

Because the default plugins are designed for working with the Leverege Stack, we just need to take some extra steps to exclude those plugins.

* Install Molten: `npm i @leverege/molten`
* Initialize Molten in your startup script

  ```javascript
  import Molten from '@leverege/molten'
  import Theme from './Theme' // path to your exported theme
  import MyCustomScreen from './MyCustomScreen' // Path to the component you want to display on load

  function start() {
    // Molten renders the authScreenClass component on startup. By default, it's a login to a Leverege project, but you can replace it with whatever want in your config.
    const authScreenClass = MyCustomScreen

    // The excludes array in your config lists all the plugin IDs of any registered plugins (including default plugins) you want to exclude. Here we are taking out plugins related to authenticating to Leverege's API and theme engine.
    const excludes = [
      'molten.ApiInit',
      'molten.ThemeInit',
      'molten.ApiLogin',
      'molten.ApiUserSettings',
      'molten.AuthInit',
    ]

    const config = {
      molten : { authScreenClass },
      plugins : { excludes }
    }

    Molten.init( config )

    Molten.create()
  }

  window.Application = { start }
  ```

* Start the web server: `npm start`

These steps will get a Molten enabled system running displaying only your custom code. To take advantage of Molten's plugin framework, you will need to add plugin points (and probably some plugins) to your code.

See the [plugins concepts page](../concepts/plugins/index.md) for a high level overview of plugins.
