#!/usr/bin/env python
# -*- coding: utf-8 -*-

import hashlib
import json
import urllib, urllib2
import yaml
import sys

def writeFile(f,s):
    with open(f,'w') as fd:
        fd.write(s)

def getHost(ident):
    url = "http://localhost:8000/api/gethostbyident?hostidentity=%s" % ident
    CACHE_FILE='/var/tmp/api-cache-%s.json' % hashlib.md5(url).hexdigest()
    try:
        data = urllib2.urlopen(url).read()
        writeFile(CACHE_FILE, data)
    except Exception,e:
        data = open(CACHE_FILE,'r').read()
    return json.loads(data)

def getHostClass(data):
    ret = set()
    for hostgroup in data:
        if hostname in [h['hostname'].lower() for h in hostgroup['members']]:
            ret.add(str(hostgroup['hostgroup']))
    return ret

def main():
    ident = sys.argv[1]
    cmdb_data = getHost(ident)
    if cmdb_data['status'] == 0:
        #classes = getHostClass(cmdb_data['data'])
        data = {'classes': [str(i) for i in cmdb_data['data']['hostgroups']]}
        print yaml.dump(data, explicit_start=True,default_flow_style=False)
if __name__ == "__main__":
    main()
