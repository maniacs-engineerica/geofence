# Geofence

This solution can be tested with iBeacons or by simulating a physical location.

iBeacon: 

1) Set up an iBeacon with proximityUUID = "F80E818A-5599-4B53-B3FD-0754AA2C050B".
2) Or go to ViewController.swift and replace static property "proximityUUID" with your iBeacon value.
3) Run build on real device and tap "Start (beacon)"

Geographic Location:

1) Run build on real device and tap "Start (geographic)"
2) Simulate location changes at runtime by select firstly "BuenosAires" and then "ZabriskiePoint".
