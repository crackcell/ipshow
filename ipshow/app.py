#!/usr/bin/env python
# -*- encoding: utf-8; indent-tabs-mode: nil -*-
#
# Copyright 2013 Menglong TAN <tanmenglong@gmail.com>
#

import os

ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
TEMPLATE_DIR = os.path.join(ROOT_DIR, 'templates')
CONF_DIR = os.path.join(ROOT_DIR, 'conf')
STATIC_DIR = os.path.join(TEMPLATE_DIR, 'static')
REDIS_DB = 'ipshow'
REDIS_HOST = 'localhost'
REDIS_PORT = '6379'
REDIS_PREFIX = 'ipshow-'

from flask import Flask, request

import redis
r = redis.Redis(host = REDIS_HOST, port = int(REDIS_PORT))

def create_app(conf_file, is_offline=False):
    app = Flask(__name__,
                static_url_path='/static',
                static_folder=STATIC_DIR,
                template_folder=TEMPLATE_DIR)

    init_path(app)

    return app

def init_path(app):
    pass
    # index
    app.route('/ipshow/')(index)
    app.route('/ipshow/post')(post)
    app.route('/ipshow/show')(show)
    #app.route('/show_all')(show_all)

def index():
    return "hello"

def post():
    host = request.args.get('host', 'null')
    ip = request.args.get('ip', 'null')
    r.set(REDIS_PREFIX + host, ip)
    return 'ok'

def show():
    host = request.args.get('host', 'null')
    ip = r.get(REDIS_PREFIX + host)
    return ip
