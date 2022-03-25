# Adding a Screen

Molten will by default, analyze your Imagine project's Blueprints and create Screens and Routes to the screens based off of their hierarchies. Custom Screens can be added, however. There are normally three parts to this process: creation of the [Screen](/docs/routes/screens/) component, registering a [Route](/docs/routes/routes/) to a URL, and making a [Link](/docs/routes/link/) to take the user to the URL.

Molten uses React Router and Plugins define which screens are presented at a particular URL. The screen presented at a URL may actually be composed of several subscreens, depending on how the Routes are specific. For example, a URL of `/Group/5/Children` may actually present a screen for `Group/5`, which has some links, widgets, information, etc, but also has a Dynamic Route mechanism it it that would also present the `Children` screen.

Route Plugins are evaluated and installed when the `getRoutesFor()` call is invoked. This can occur in multiple screens in your application. The `DesktopMainScreen`, for example calls:

```
  <Switch>
    {Routes.getRoutesFor( 'Main', null, { client : 'Main' } )}
  </Switch>
```

This is asking for all Routes that wish to be installed at the 'Main' client level. Route Plugins should specify a `matches` object that indicates where it wishes to be installed. 
