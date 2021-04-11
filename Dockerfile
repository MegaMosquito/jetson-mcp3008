# Container that reads an analog input from an MCP3008 (over SPI0) and sets
# the brightness accordingly for an LED on board pin 32 using PWM.
#
# Tested on NVIDIA Jetson nano 2GB. Expected to work on other Jetsons.
# Uses the MCP3008 Analog to Digital Convertor (ADC) hardware:
#    https://www.adafruit.com/product/856

# For SPI, you need to (on the *host*:
# sudo mkdir -p /boot/dtb
# sudo cp -v /boot/tegra210-p3448-0000-p3449-0000-[ab]0[02].dtb /boot/dtb/sudo
# sudo find /opt/nvidia/jetson-io/ -mindepth 1 -maxdepth 1 -type d -exec touch {}/__init__.py \;
#
# Then run this
#   sudo /opt/nvidia/jetson-io/jetson-io.py
# and configure spi1

FROM ubuntu:20.04
WORKDIR /

# Install python basics
RUN apt update && apt install -y \
  python3 python3-dev python3-pip git

# Optional dev tools
#RUN apt install -y wget curl jq make vim

# Install the python GPIO library for Jetson (used for PWM)
RUN pip3 install Jetson.GPIO
RUN pip3 install adafruit-circuitpython-busdevice
RUN pip3 install spidev
RUN pip3 install adafruit-circuitpython-mcp3xxx

# Copy over the SPI test code and build it (optional; could be removed)
RUN git clone https://github.com/rm-hull/spidev-test
RUN cd spidev-test && gcc spidev_test.c -o /bin/spidev_test
# To test SPI on the nano, first connect a jumper wire between board
# pins #19 and #21 (the SPI1_MOSI and SPI1_MISO oins). Then run this:
#     spidev_test -D /dev/spidev0.0 -v
# The output line starting with "RX" should mirror the line starting with "TX".

# Copy over the daemon code
COPY jetson-mcp3008.py /

# Run the daemon
CMD python3 /jetson-mcp3008.py

