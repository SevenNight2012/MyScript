#!/usr/bin/env python
# -*- coding: utf-8 -*-
# unzip-gbk.py

import os
import sys
import zipfile


def dirName(dir, fileName):
    return dir + os.path.sep + fileName


reload(sys)
sys.setdefaultencoding('utf-8')
print sys.getdefaultencoding()


def doUnzip(target):
    print "Processing Zip:" + target
    targetZip = zipfile.ZipFile(target, "r")
    targetDir = os.path.dirname(targetZip.filename)
    print targetZip.filename
    print targetDir
    file = zipfile.ZipFile(target, "r")
    for name in file.namelist():
        utf8name = name.decode("gb18030", errors='ignore')
        print "Processing zipFile:" + utf8name
        pathname = os.path.dirname(utf8name)
        dir = dirName(targetDir, pathname)
        if not os.path.exists(dir) and dir != "":
            os.makedirs(dir)
        data = file.read(name)
        if not os.path.exists(dirName(targetDir, utf8name)):
            fo = open(dirName(targetDir, utf8name), "w")
            fo.write(data)
            fo.close()
    file.close()


count = 0
for f in sys.stdin:
    print "----------------do unzip----------------"
    doUnzip(f.strip().replace("\n", ""))
    count = count + 1

print "unzip finish,file count:" + count.__str__()
