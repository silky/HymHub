#!/usr/bin/env python
# Copyright (c) 2015, Daniel S. Standage and CONTRIBUTORS
#
# HymHub is distributed under the CC BY 4.0 License. See the
# 'LICENSE' file in the HymHub code distribution or online at
# https://github.com/BrendelGroup/HymHub/blob/master/LICENSE.

import re
import sys
for line in sys.stdin:
    line = line.rstrip()
    idmatch = re.search("ID=([^;\n]+)", line)
    namematch = re.search("Name=([^;\n]+)", line)
    if idmatch and not namematch:
        line += ";Name=%s" % idmatch.group(1)
    print line
