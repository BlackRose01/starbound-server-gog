# Starbound Server (GOG Version)

Create a dockerized Starbound Server (GOG Version)

## How to use

1) Download Starbound (Linux Version) from GOG
2) Create two shared folders (game data, downloaded file) for the container
3) Set up the container
   - Game Port: 21025
   - RCON Port: 21026
   - Game Data: /starbound
   - Downloaded File: /starbound_upgrade


Example:
```bash
docker build -t starbound .
docker run -d --name starbound -p 21025:21025 -p 21026:21026 -v /vol1/Starbound/game:/starbound -v /vol1/Starbound/upgrade:/starbound_upgrade starbound
```

## Environment Variables

The following environment variables exists:
| Variable | Description | Mandatory | Default value |
| --- | --- | --- | --- |
| FORCE_UPGRADE | force an upgrade or downgrade of the server | no | false (1) |

## Upgrade

If you restart the container and there is a game file in the upgrade folder then the container tries to upgrade the server files. Your world and server configuration will be restored after an upgrade or downgrade.
