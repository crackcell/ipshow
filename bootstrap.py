#!/usr/bin/env python
# -*- encoding: utf-8; indent-tabs-mode: nil -*-
#
# Copyright 2013 Menglong TAN <tanmenglong@gmail.com>
#

from ipshow.app import create_app

import os
ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '.'))

if __name__ == "__main__":
    app = create_app(os.path.join(ROOT_DIR, "conf/offline.conf"), True)
    app.run(host='0.0.0.0', debug=True)
else:
    app = create_app(os.path.join(ROOT_DIR, "conf/online.conf"), False)
