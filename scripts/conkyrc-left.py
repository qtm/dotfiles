#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys
import netifaces
import basiciw
import time
import datetime
import re
import config

from jsonpath_rw import jsonpath, parse

from operator import is_not
from functools import partial
import volume_control
import executor
from color_definitions import colors
from gradient import get_color_gradient
from status_block import StatusBlock, StatusUnit

from togglapi import api
from toggltarget import target
from workingtime import workingtime

TOP_BORDER_WIDTH = 2

def blockify_active_window():
  """ Print the currently active window (or 'none'). """

  active_window, return_code = executor.run('xdotool getactivewindow getwindowname')
  if return_code != 0:
    return None
  if len(active_window) > 100:
    active_window = active_window[:80] + '...' + active_window[-20:]

  block = StatusUnit('active-window')
  block.set_icon('')
  block.set_text(active_window)

  return block

def blockify_battery():
  """ Print the current battery level. """

  block = StatusUnit('battery')
  block.set_icon('')

  acpi = executor.run('acpi -b')[0]
  battery = re.search('\d*%', acpi).group(0)
  battery_int = int(battery[:-1])
  is_charging = bool(re.search('Charging|Unknown', acpi))

  if is_charging:
    block.set_icon('')
  elif battery_int > 90:
    block.set_icon('')
  elif battery_int > 60:
    block.set_icon('')
  elif battery_int > 30:
    block.set_icon('')
  elif battery_int > 10:
    block.set_icon('')
  else:
    block.set_icon('')

  if is_charging:
    block.set_text('')
  else:
    block.set_text(battery)
    block.set_background(colors['red'])
    block.set_color(colors['white'], colors['white'])

  return block

def blockify_wifi():
  """ Prints information about the connected wifi. """

  interface = "wlan0"
  try:
    with open('/sys/class/net/{}/operstate'.format(interface)) as operstate:
      status = operstate.read().strip()
  except:
    return None
  if status != 'up':
    return None

  info = basiciw.iwinfo(interface)

  block = StatusUnit('network')
  block.set_icon('')
  block.set_background(colors['yellow'])
  block.set_color(colors['bg'], colors['bg'])
  block.set_text(info['essid'])

  return block

# TODO combine with wifi code
# TODO if ethernet is there but not connected, the i3bar disappears :(
def blockify_ethernet():
  """ Prints information about the connected ethernet. """

  interface = "eth0"
  try:
    with open('/sys/class/net/{}/operstate'.format(interface)) as operstate:
      status = operstate.read().strip()
  except:
    return None
  if status != 'up':
    return None

  block = StatusUnit('network')
  block.set_icon('')
  block.set_text(interface + ' @ ' + netifaces.ifaddresses(interface)[netifaces.AF_INET][0]['addr'])

  return block

#########################################
### MAIN ################################
#########################################

if __name__ == '__main__':
  blocks = [
    blockify_active_window(),
    blockify_wifi(),
    blockify_ethernet(),
    blockify_battery(),
  ]

  filter(partial(is_not, None), blocks)

  custom_bg_blocks = []
  idx = 1
  while idx < len(blocks):
    if blocks[idx] != None :
      if blocks[idx].get_background() != colors['bg']:
        custom_bg_blocks.append(idx)
    idx += 1


  i = 0
  for idx in custom_bg_blocks:
    before = StatusBlock('before_separator')
    before.set_full_text('')
    before.set_color(blocks[idx + i].get_background())
    before.set_separator(False, 0)
    blocks.insert(idx+i, before)

    after = StatusBlock('after_separator')
    after.set_full_text('')
    after.set_background(blocks[idx+1+i].get_background())
    after.set_color(colors['bg'])
    after.set_separator(False, 10)
    blocks.insert(idx+2+i, after)
    i += 2

  json = ",".join(block.to_json() for block in blocks if block)
  json = json + ","

  sys.stdout.write(json)
  sys.stdout.flush()
