# Configuration
This describes the values in the Molten Confg.js file.

## Show/Hide the Layout Controller
<table>
  <thead>
    <tr>
      <th>Path</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>plugins/config/LayoutViewerSelector</td>
      <td>
        <p>Allows visibility control of the layout button in GroupScreen and ItemInfoScreen.</p>
        ```
        {
          allowEditing : <boolean>;|<string>|<function>
        }
        ```
        for example:
        ```
        {
          allowEditing : "Installer, Admin"
        }
        ```
        Would allow user in the persona of Installer or Admin to see the buttons
      </td>
    </tr>
    <tr>
      <td>
        plugins/config/mapBoxPosition
      </td>
      <td>
        Sets default position and zoom.

        <ul>
          <li><b>selectedRezoomThreshold:</b> Indicates at what range (or less ) the view should recenter/zoom in on the selected object.</li>
          <li><b>selectedZoom:</b> target zoom when selection occurs and rezoom threshold is exceeded. ( Negative one means dont zoom )</li>
          <li><b>pathOptions:</b> an object where the keys are the blueprint paths to allow customization of selectedRezoom options.</li>
        </ul>
        ```
        {
          center : [ -77.1902656, 39.1081595 ],
          zoom : 18,
          selectedRezoomThreshold : 12, // if we re beyond this range, selection will cause rezoom/center
          selectedZoom : 18, // this is the target range to go to on selection. 
          pathOptions : {
            building : { selectedRezoomThreshold : 10, selectedZoom : 18 }
          }
        }
        ```
      </td>
    </tr>
  </tbody>
</table>



 

## UserManagement / ResourceUser Screen

Under plugins/config/ResourceUsers, the following keys can be set to change properties:

| Key | Default |
| --- | ------- |
| activateAccountFieldValidators | null |
| activateAccountPreSubmitComponents | null |
| activateAccountValidator | () => true |
| activateAccountCustomOnSubmit | () => |
| activateAccountSupportsLogin | true |
| userSelectorUsernameLabel | Email or Username* |
| userSelectorUsernameHint | Enter Email or Username |
| userSelectorUsernameInstructions | Enter user's email or username and hit enter or next to continue. |
| addUserTitle | Add User |
| editUserTitle | Edit User |
| addUserOkay | Next |
| editUserUpdate | Update |
| allowCreateUser | true |
| allowInviteUser | true |
| inviteEmailLabel | Email* |
| inviteEmailHint | Enter Email |
| createEmailLabel | Account Email* |
| createEmailHint | ex. johnsmith@example.com |
| createUsernameLabel | Username |
| createUsernameHint | Enter Username |
| activateEmailLabel | Account Email* |
| createNameLabel | Name* |
| createNameHint | ex. John Smith |
| createPhoneLabel | Phone Number |
| createPhoneHint | ex. (555) 555-5555 |
| createPasswordLabel | Password |
| createPasswordHint | Enter password |
| createConfirmPasswordLabel | Confirm Password |
| createConfirmPasswordHint | Re-enter password |
| screenIcon | null |
| addDialogIcon | null |
| editDialogIcon | null |
| removeUserDialogIcon | null |

## 404 / LostScreen

Under plugins/config/LostScreen, the following keys can be set to change properties:

| Key | Default | Description |
| --- | ------- | ----------- |
| title | Oops! | The title to put on the page |
| message | We couldn't find this page - our apologies! | The sub text to display to the user |
| button | Let's find our way | The label of the button on the ‘home’ link |
| link | '/' | The location to take the user when the button is pressed |
| image | fa fa-meh-o | The font icon or image url to display. This can also be an array of font icons and image urls. If it is an Array, one will randomly be selected and used. |

These images are supplied as good initial resources:

```
LostScreen : {
  image : [
    'https://molten-ui-assets.storage.googleapis.com/404-UFO.png',
    'https://molten-ui-assets.storage.googleapis.com/404-Earth.png',
    'https://molten-ui-assets.storage.googleapis.com/404-Page.png',
    'https://molten-ui-assets.storage.googleapis.com/404-Ghost.png'
  ]
}
```
 

## NetworkOffline

Under plugins/config/NetworkOffline, the following keys can be set to change properties:

| Key | Default | Description |
| --- | ------- | ----------- |
| message | Your Network connection has been lost. | The message to display when network connection is lost. |
| icon | fa fa-exclamation-triangle | The font icon class or image url to display with the text, when the connection is lost. |

 
## BlueprintActions

Under plugins/config/BlueprintActions, the following keys can be set to change properties:

| Key | Default | Description |
| --- | ------- | ----------- |
| updateIcon | fa fa-pencil fa-fw | The font icon class or image url to display for a blueprint update action. |
| createIcon | fa fa-plus fa-fw | The font icon class or image url to display for a blueprint create action. |
| bulkCreateIcon | fa fa-plus fa-fw | The font icon class or image url to display for a blueprint bulk create action. |
| removeIcon | fa fa-trash fa-fw | The font icon class or image url to display for a blueprint remove action. |

## No Data/No Search Results Views

Under plugins/config/<client> where <client> is one of ListDataViewer or TableDataViewer the following keys can be set to change the no data/no search results views:

| Key | Default | Description |
| noDataMessage | The class found in molten at: src/screens/shared/group/noData/NoDataView.jsx | The string or React Component/Function to render when there is no data in the table/list |

Under plugins/config/NoDataView the following keys can be set to configure the NoDataView that is used by default

| Key | Default | Description |
| --- | ------- | ----------- |
| noDataTitle | the name of the blueprint | Can be overridden by a string in the blueprint or attribute |
| noDataBody | Looks like there's nothing here, try creating something! | Can be overridden by a string in the blueprint or attribute |
| noDataIcon | https://molten-ui-assets.storage.googleapis.com/no-data.svg | Can be overridden by a string in the blueprint or attribute |
| noDataIconDimensions | `{ height : 224, width : 224 }` | Can be overridden by a string in the blueprint or attribute |
| noDataDocLink | null | Can be overridden by a string in the blueprint or attribute |
| noSearchResultsTitle | We couldn't find any matches for that | Can be overridden by a string in the blueprint or attribute |
| noSearchResultsBody | Please try searching for another item | Can be overridden by a string in the blueprint or attribute |
| noSearchResultsIcon | https://molten-ui-assets.storage.googleapis.com/no-search-results.svg | Can be overridden by a string in the blueprint or attribute |
| noSearchResultsIconDimensions | `{ height : 224, width : 224 }` | Can be overridden by a string in the blueprint or attribute |

## Group Screen

| Key | Default | Description |
| --- | ------- | ----------- |
| refreshTime | 30000 | Number of milliseconds between data refreshes on all group screens |
| <relationship.path>/defaultPerPage | 200 | Default per page for a given relationship path |
| defaultPerPage | 200 | Default per page for all GroupScreens (used as a fallback if no value specified for a specific path) |