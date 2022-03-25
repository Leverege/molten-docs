# Startup

There are many phases to startup. Plugins are used to drive as many of these as possible. The startup flow looks like:

``` mermaid
flowchart TB
  subgraph Providers
    E[Run Reducer Plugins] --> F[Run Middleware Plugins];
  end
  subgraph Prerender
    direction LR;
    PRA[Verify Current User] --> PRB[Load OIDC Clients];
  end
  subgraph OnLogin [Run On Login Plugins ]
    LA[Role Downloading] --> LB[Blueprint Analysis];
    LB --> LC[Custom];
  end
  A[Load Plugins] --> B[Run Initializers Plugins];
  B -->C[Run Support Component Plugins];
  C --> D[Run Provider Plugins];
  D --> Providers;
  Providers --> Prerender;
  Prerender --> Auth{Valid User?};
  Auth -- Yes --> Render[Render Main React App];
  Auth -- No --> Login[Render Login Screen];
  Login --> Auth;
  Render --> OnLogin;
  click B href "./initializers/" "Run the Initializer Plugins" _self
  click C href "./support-components/" "Run the Component Support Plugins" _self
```


* Init Molten
    - This loads the default Plugins
* Load custom plugins
    - Implemented by custom application
* Run all Initializer Plugins
* Run all Support Component Plugins
* Run all Provider Plugins
    - Reducer Plugins run from ReduxStore plugin
    - Middleware Plugins run from ReduxStore plugin
* Run all Prerender Plugins
    - Auth verify run by Auth plugin
    - Oidc loaded here to be ready for login screen by Auth plugin
* Render React application
* Login/Authentication
* LoggedIn Plugins run
    - Role downloading
    - Blueprint Analysis
        * Auto plugins created
