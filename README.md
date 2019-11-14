# Rideshare

An exemplary Rails 6.0 API app, in iterations

### Iteration 5

Generate sample Driver, Trip, Rider, and Rating data. Add basic Driver dashboard. Show driver stats.

<img src="https://i.ibb.co/KcgZTBM/driver-dashboard.png" alt="Driver dashboard"/>

### Iteration 4

UML Sequence Diagram of Rider, Driver, Trip Request, Trip, and Rating messages

```
@startuml

title "Rider, Driver, Trip Sequence Diagram"

actor Rider
boundary "TripRequest"
actor Driver
entity Trip

Rider -> Rider : Enters Start and End Location
Rider -> TripRequest : Requests Trip
Driver -> TripRequest : Accepts Trip Request
TripRequest -> Trip : Trip Starts
Trip -> Trip : Trip Ends
Rider -> Trip : Rider Rates Trip

@enduml
```

<img src="https://www.plantuml.com/plantuml/img/PP0v3i8m44NxESKeDLo00WKfT5G95nZi4RAKsC6U8ENsU4C4gBoz__tiDWXvMQOHG8oCZ4rlDFiTTjuyqtZrPiQ17mjRnTWPkdkQ6W1IuZnc66vkiPhyYasY-mG7QIfIYe1jx5zp7K2EuVvOydZ0inNs0OSaWsHrtD1uSOh4EFl1D_KnL6UXb9Px_gcJKZnNw1s1BL8J4IrlJGuX4xz7KIfyooIBlEv9k8f0orR77tq1" alt="Trips Sequence diagram">

### Iteration 3

* Trip model, when a Driver accepts a Trip Request
* Completed Trips can be rated


### Iteration 2

* Location (Geo coordinates) and Trip Request models
* API base controller
* Trip Requests index and create API endpoints


### Iteration 1

* Design Document
  * Writing out use cases
  * Planning models, database tables, constraints, validations
    * Using single-table inheritance for Driver and Rider instances in a Users table
