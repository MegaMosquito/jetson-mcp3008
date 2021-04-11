# Read an analog input from channel 1 of an MCP3008 (over SPI0) and set the
# brightness accordingly for an LED on board pin 32 using PWM.
# Written by Glen Darling, April 2021

import adafruit_mcp3xxx.mcp3008 as MCP
from adafruit_mcp3xxx.analog_in import AnalogIn
import board
import busio
import digitalio
import Jetson.GPIO as GPIO
import time

# When VERBOSE is True a line of test is printed each loop
VERBOSE = False

# Setup the MCP3008
spi = board.SPI()
cs = digitalio.DigitalInOut(board.CE0)
mcp = MCP.MCP3008(spi, cs)

# Create analog input channel 1 (numbered from 0, so MCP.P0 means pin #1)
ch1 = AnalogIn(mcp, MCP.P0)

# Setup the PWM GPIO (one of the libs above sets BCM numbering)
#GPIO.setmode(GPIO.BCM)
GPIO.setup('LCD_BL_PW', GPIO.OUT)
pwm = GPIO.PWM('LCD_BL_PW', 1000)
pwm.start(0)

# Loop forever, reading the pot on MCP3008 
while True:
  dc = int(100.0 * (ch1.value / 65535.0))
  pwm.ChangeDutyCycle(dc)
  if VERBOSE:
    print('DC: ' + str(dc) + ', ADC: ' + str(ch1.value) + ', ' + str(ch1.voltage) + 'V')
  time.sleep(0.05)
