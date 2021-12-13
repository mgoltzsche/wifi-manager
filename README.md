# Wifi manager

A linux container and Docker Compose application to make a SoC join a wifi network.  

To support SoCs such as a Raspberry Pi without a display and keyboard, the container creates a (temporary) wifi hotspot when the wifi is not configured or the configured access point is not reachable, allowing the user to connect with another (mobile) device to select the actual access point and enter its credentials within a web UI.  

Currently this project is solely based on [balena-os/wifi-connect](https://github.com/balena-os/wifi-connect).

## Build

Build the image:
```
make image
```

## Run

Start the Docker Compose application:
```
make compose-up
```

