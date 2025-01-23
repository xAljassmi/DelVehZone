# DelVehZone

DelVehZone is a QBCore script that automatically deletes vehicles when players enter a specified zone. This script is useful for managing vehicle clutter and ensuring that vehicles are not left unattended in specific areas.

## Features

- Automatically detects when a player enters or leaves a specified zone.
- Notifies players when their vehicle is about to be deleted.
- Deletes vehicles after a specified amount of time if the player is not in the vehicle.
- Configurable zones and deletion times.
- Option to delete vehicles even if the player is still in the vehicle.
- Use the `/pzcreate circle` command to visualize how the zone area will look.

## Showcase

Watch the video tutorial on how DelVehZone works:

[Watch the video](https://www.youtube.com/watch?v=POYAtxu0KOs&ab)

## Installation

1. Download the script and place it in your `resources` folder.
2. Add the following line to your `server.cfg`:

   ```plaintext
   ensure DelVehZone

