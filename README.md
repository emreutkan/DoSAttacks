# Deauthentication Scripts

-- each file has(or will have) in-depth README files... 

## Auto Deauthentication
- this script usea Aircrack-ng suite to perform deauthentication attack just by the target AP SSID, 

## Wifi Networks By MAC OUI 
- this script gathers OUI (Organizational Unique Identifier) from Routers MAC Address, then lists all boradcasted APs from each Router 

## Wifi Deauthentication By OUI
- this script starts same as `Wifi Networks By MAC OUI`, and from that information, with the user given OUI the Script automaticallt Deauthenticates all APs on the given Router

## Auto Deauhentication by Device
- this script additional to `AutoDeauth` has a feature to select a specific device on the AP, and instead of performing Deauhentication on the whole AP it only Deauhenticates a selected device


# Future ideas

## handshake capture

## Sequential Deauhentication on AP
  - this script will deauthenticate each device for 30 seconds on a given AP sequentially and indefinetely

## adding mac spoofing to the scripts

## listing networks by their proximity
