# Carnegie Mellon - Silicon Valley

## Glossary ##
* Device Agent -  a local server or proxy that manages a set of devices registered to it. Device agents can receive data from devices, convert data to another format (eg. JSON), and can transmit it to central server over a LAN or WAN.
* Device -  a container (i.e., physical device) object that comprises one or more sensors and is capable of transmitting their readings over a network to a Device Agent.
* Sensor - the atomic electronic component capable of reporting a measurement, usually in binary or encoded format.

## API ##
1. get_devices - return a json array of devices.
    
    eg. http://cmu-sds.herokuapp.com/get_devices
2. sensor_readings - retrieve sensor readings of a device within a specific time range.

    specify device id with following paramters:
    - start_time, end_time - Unix epoch UTC timestamp of the time range to retrieve readings
    - tuples - optional parameter. Instead of raw readings return the aggregated reading per specified amount of records. If there are less readings than the specified tuples, then no results will be returned. Attributes unique to tuples: average_timestamp, first, last, min, max, average.
    
    eg.
    http://cmu-sds.herokuapp.com/sensor_readings/23100015?start_time=1359581004000&end_time=1359582134000
    http://cmu-sds.herokuapp.com/sensor_readings/23100015?start_time=1359581004000&end_time=1359582134000?tuples=4


## TODOs: ##

1. *Device Agents*: When providing GPS coordinates, provide a way to enter free form text in the various popular formats. Parse it in the backend to appropriate coordinates.e.g. Deg, Min, Second or just Deg etc.
2. *Sensor Types*: provide facility to edit conversion methods (a dropdown that allows you to pick threshold.Alternatively if you choose polynomial, then it displays options to populate coefficient)
3. Admin logging in present, but add logic to control device/sensor/device_agent registration through this admin interface.
4. Implement virtual sensor and virtual device.

