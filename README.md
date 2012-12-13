# Carnegie Mellon - Silicon Valley

This is Team 4's Sensor Data Storage project

## TODOs: ##

High Priority:

1. add unique constraint validations to all uri fields in the database
2. *Sensor Types*: add manufacturer key to model (MitsubishiA2323)
3. *Sensor Types*: separate out "property type" (which currently acts as a key) from print_name/physical description
4. *Device Agents*: Network address e.g. 231000003
5. *Device Agents*: When providing GPS coordinates, provide a way to enter free form text in the various popular formats. Parse it in the backend to appropriate coordinates.e.g. Deg, Min, Second or just Deg etc.

Medium Priority:

6. *Sensor Types*: provide facility to edit conversion methods (a dropdown that allows you to pick threshold.Alternatively if you choose polynomial, then it displyas options to populate coefficient)
7. *Sensor Types*: The conversion mentioned above is from the manufacturer's documentation. If a general conversion is preferred like deg C to deg F, create a virtual sensor as a wrapper to this.
8. *Device Agents*: The conversion mentioned above is from the manufacturer's documentation. If a general conversion is preferred like deg C to deg F, create a virtual sensor as a wrapper to this.
9. *Device Agents*: Add a field for "polling interval". This indicates how often the device agent will poll/push data to the database. Either enter an interval, cron job or provide a dropdown for which script to execute for the polling.
10. Admin logging in present, but add logic to control device/sensor/device_agent registration through this admin interface.
11. Implement virtual sensor and virtual device.
