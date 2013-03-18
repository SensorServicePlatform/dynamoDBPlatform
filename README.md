# Carnegie Mellon - Silicon Valley

## Glossary ##
Device Agent -  a local server or proxy that manages a set of devices registered to it. Device agents can receive data from devices, convert data to another format (eg. JSON), and can transmit it to central server over a LAN or WAN. 
Device -  a container (i.e., physical device) object that comprises one or more sensors and is capable of transmitting their readings over a network to a Device Agent.
Sensor - the atomic electronic component capable of reporting a measurement, usually in binary or encoded format.

## TODOs: ##

1. *Device Agents*: When providing GPS coordinates, provide a way to enter free form text in the various popular formats. Parse it in the backend to appropriate coordinates.e.g. Deg, Min, Second or just Deg etc.
2. *Sensor Types*: provide facility to edit conversion methods (a dropdown that allows you to pick threshold.Alternatively if you choose polynomial, then it displays options to populate coefficient)
3. Admin logging in present, but add logic to control device/sensor/device_agent registration through this admin interface.
4. Implement virtual sensor and virtual device.
