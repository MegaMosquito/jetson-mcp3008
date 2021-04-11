# jetson-mcp3008
A simple example that reads analog input from an MCP3008 over SPI on an NVIDIA Jetson nano.

The MCP3008 is an Analog to Digital Convertos (ADC) chip with 8 anaolg input channels that have about 10 bits of resolution. This is a convenient addition to the Jetson nano which has no general purpose analog inputs. You can pick up an MCP3008 for about $4. E.g.: https://www.adafruit.com/product/856

## Host Preparation:

For SPI on NVIDIA Jetson nanos, you need to run this on the *host*:

```
sudo mkdir -p /boot/dtb
sudo cp -v /boot/tegra210-p3448-0000-p3449-0000-[ab]0[02].dtb /boot/dtb/sudo
sudo find /opt/nvidia/jetson-io/ -mindepth 1 -maxdepth 1 -type d -exec touch {}/__init__.py \;
```

Then you need to run the interactive configuration tool:

```
sudo /opt/nvidia/jetson-io/jetson-io.py
```

And in that tool, enable the "SPI1" interface.

If you have trouble with SPI, connect a jumper between pin 19 (SPI1_MOSI) and pin 21 (SPI1_MISO) then run the `spidev_test` program provided in the Docker file. Usage details for that are also in the Dockerfile.

## Usage:

To build the container:

```
make build
```

To run the container (like a daemon, it never exits on its own, and restarts itself after reboots):

```
make run
```

To stop the container from running (and from restarting itself):

```
make stop
```

To clean up everything (remove containers and built images)

```
make clean
```

## More info

See the Makefile, Dockerfile, and python source file for more info. All are small files.

