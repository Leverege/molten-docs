# Screens

A Screen is just a React Component. It can pretty much do what it wants. It can connect to Redux, it can call external APIs, it can use its own custom Plugins, it can other Plugins mechanism that already exist such as attributes or toolbars, it can use `Routes.getRoutesFor()` to have its own sub registered Routes/Screens with a custom navigation mechanism.

The only real consideration is that the screen will be given an area to render in, and it should manage it own rendering and scroll areas. This is good place to use ui-elements' `Content`,  but other mechanism can work as well.

!!! note "React Components"

    We highly recommend using `@leverege/ui-elements` for your
    components, as they will inherit the theme used for the
    rest of the screens. You can also use the css variables that the theme exports to aid with this theme consistency if using the ui-elements library is not feasible.



## Example

In the following example, our IncredibleScreen will have a title bar, and action toolbar to accept plugins, and a greeting.

File **IncredibleRoute.js**.
```javascript
import React from 'react'
import { connect } from 'react-redux'
import { Text, Content } from '@leverege/ui-elements'
import { Config } from '@leverege/plugin'
import { TitleBar, Toolbar } from '@leverege/ui-plugin'

class IncredibleScreen extends React.Component {
  
  render() {
    const { hello = '-' } = this.props
    // Putting welcome into the matchContext for the
    // tool bar is not required, but would all actions
    // to only appear if welcome is a certain value
    this.matchContext = { 
      client : 'IncredibleScreen', 
      welcome : hello 
    }

    return ( 
      <Content>
        <Content.Header>
          <TitleBar variant="screenTitle" 
            title="Incredible Screen" 
            icon={Config.get( 
              'IncredibleScreen', 
              'screenIcon', 
              'fa fa-snowflake-o fa-fw' )}>
            <Toolbar
              variant="actionBar"
              prefer="icon"
              hasContextMenu={false}
              matchContext={this.matchContext}
              context={{}} />
          </TitleBar>
        </Content.Header>
        <Content.Area variant="screenContent">
          <Text variant="caption" icon="fa fa-snowflake fa-fw">
            My incredible Screen!
          </Text>
          <Text variant="smallCaption" icon="fa fa-snowflake fa-fw">
            Hello {hello}!
          </Text>
        </Content.Area>
      </Content>
    )
  }
}

export default connect(
  state => ( {
  } )
)( IncredibleScreen )

```