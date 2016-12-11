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
import logging
from color_definitions import colors
from gradient import get_color_gradient
from status_block import StatusBlock, StatusUnit

from togglapi import api
from toggltarget import target
from workingtime import workingtime

TOP_BORDER_WIDTH = 2

def blockify_toggl():
  w = workingtime.WorkingTime(config.WORKING_HOURS_PER_DAY, config.BUSINESS_DAYS, config.WEEK_DAYS)
  a = api.TogglAPI(config.API_TOKEN, config.TIMEZONE)
  t = target.Target()
  achieved_minutes = a.get_minutes_tracked(start_date=w.week_start, end_date=w.minute)
  t.achieved_hours = achieved_minutes / 60.0
  today_minutes = a.get_minutes_tracked(start_date=w.today, end_date=w.minute)
  t.today_hours = today_minutes / 60.0
  logging.debug('today minutes: %d' % (today_minutes))
  t.required_hours = w.required_hours_this_month
  t.tolerance      = config.TOLERANCE_PERCENTAGE

  normal_min_hours, crunch_min_hours = t.get_required_daily_hours(w.business_days_left_count, w.days_left_count)

  today_required_minutes = normal_min_hours * 60
  elapsed_minutes = today_required_minutes - today_minutes

  if (elapsed_minutes > 0):
    e_h, e_m = divmod(elapsed_minutes, 60)
    text = '%dh %dm' % (e_h, e_m)
  else:
    text = ''

  text += "  "

  if (achieved_minutes > 0):
    a_h, a_m = divmod(achieved_minutes, 60)
    text += '%dh %dm' % (a_h, a_m)
  else:
    text += '0h 0m'

  toggl = StatusUnit('toggl')
  toggl.set_icon('')
  toggl.set_text(text)
  toggl.set_background(colors['blue'])
  toggl.set_color(colors['red'], colors['bg'])
  return toggl

#########################################
### MAIN ################################
#########################################

if __name__ == '__main__':
  blocks = [
    blockify_toggl(),
  ]

  filter(partial(is_not, None), blocks)

  custom_bg_blocks = []
  idx = 0
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
