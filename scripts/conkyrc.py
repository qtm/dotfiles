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

def blockify_date():
  """ Prints the date and time. """

  now = datetime.datetime.now()

  calendar = StatusUnit('calendar')
  calendar.set_icon('')
  calendar.set_text(now.strftime('%a %d/%b.'))
  return calendar

def blockify_time():
  """ Prints the time. """

  now = datetime.datetime.now()

  clock = StatusUnit('clock')
  clock.set_icon('')
  clock.set_text(now.strftime('%H:%M:%S'))
  clock.set_color(colors['bg'], colors['bg'])
  clock.set_background(colors['green'])
  return clock

def blockify_separator():
  block = StatusBlock('separator')
  block.set_full_text(' ')
  block.set_separator(False, 0)
  return block

#########################################
### MAIN ################################
#########################################

if __name__ == '__main__':
  blocks = [
    blockify_date(),
    blockify_time()
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

  sys.stdout.write(json)
  sys.stdout.flush()
