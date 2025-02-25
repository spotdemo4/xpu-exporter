#!/usr/bin/env python3
#
# Copyright (C) 2021-2023 Intel Corporation
# SPDX-License-Identifier: MIT
# @file rest_config.py
#
# Modified by trev for xpu-exporter
#

import configparser
import os
import pwd
import grp
import hashlib
import getpass
import argparse

if __name__ == '__main__':

    parser = argparse.ArgumentParser()
    parser.add_argument( "-u", "--user", help="username for the generated config file" )
    parser.add_argument( "-p", "--pass", help="password for the generated config file" )
    args = parser.parse_args()

    user = args.user if args.user else 'xpumadmin'
    pw = args.pass if args.pass else 'password'

    salt = os.popen( 'tr -dc A-Za-z0-9 < /dev/urandom |head -c 12' ).read()
    pwHash = hashlib.pbkdf2_hmac('sha512', pw.encode('ASCII'), salt.encode('ASCII'), 10000).hex()

    config = configparser.ConfigParser()
    config['default'] = {}
    config['default']['username'] = user
    config['default']['salt'] = salt
    config['default']['password'] = pwHash
    
    path = os.getcwd()
    os.umask( 0o007 )
    with open( '/usr/lib/xpum/rest/conf/rest.conf', 'w' ) as configFile:
        config.write( configFile )

    print( 'rest.conf has been generated succefully' )