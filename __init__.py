# Copyright (c) 2018 Aldo Hoeben / fieldOfView.
# PauseBackendPlugin is released under the terms of the AGPLv3 or higher.

from . import PauseBackend

def getMetaData():
    return {}

def register(app):
    return { "extension": PauseBackend.PauseBackend() }
