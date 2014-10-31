import common
import os
import sys
import time

def FullOTA_InstallEnd(info):
  info.script.AppendExtra('delete("/system/bin/auditd");')
