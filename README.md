# wifi_smart_living

These App help to controll the Eurotronic WiFi Devices
- Thermostat Comet WiFi
- Waterering Computer Comet Aqua (comming soon)
- To compile the app, change flutter channel to master

Open points:
- If a user account not activated in correct way the app should open ui screens to activate a created account again. There exist some UI Screens for this but there some  bugs inside the UI 
- App do not support to change the holiday profile icon and name. The edit option is missing here
- App do not support the option to remove rooms from an existing holiday profile, add rooms to an existing holiday profile and show which rooms are added to an existing holiday profile. See heating profile structure for more infoemation 
- bad behaviour: to remove an existing room from an heating profile the user do a long click on an room widget. change the long press by popup menu.
- old app had some bug that databse entries sometimes not created (room_profile and device_profile). if the app starts first time the app has to check if all entries are exist. If not the app has to create the missing entries with default values. I implementet the logic to create default values but this logic not called. Check if you can do this part in the DatabaseSync class (api_handler->sync->databasesync)

- iOS Optimization:
App cannot work with allow access location always. If this option is selected, the option not accepted by iOS Systems
UI Opimization for iOS SE and (general) small app screens

Code Structur:
api_handler: Here are all classes defind whitch are used to interact with api for example get data, update or remove
bloc : The app works with bloc pattern. the folder bloc contains all bloc implementations
cleanup: create missing device and roomprofile helper classes
connectivity: network stuff to check network connections 

App Release:
Version 1.0 - released 29-03-2023 on android -> build id: 1