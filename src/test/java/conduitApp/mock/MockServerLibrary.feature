Feature: Lib mock server

Scenario: pathMatches('/lib')
* def response = 
"""
{
    "name": "City Library",
    "location": "456 Elm St, Metropolis, USA",
    "establishedYear": 1985,
    "totalBooks": 12000,
    "hours": {
        "Monday": "9:00 AM - 5:00 PM",
        "Tuesday": "9:00 AM - 7:00 PM",
        "Wednesday": "9:00 AM - 5:00 PM",
        "Thursday": "9:00 AM - 7:00 PM",
        "Friday": "9:00 AM - 5:00 PM",
        "Saturday": "10:00 AM - 4:00 PM",
        "Sunday": "Closed"
    },
    "services": [
        "Book Lending",
        "Reading Rooms",
        "Public Computers",
        "Events and Workshops"
    ]
}
"""