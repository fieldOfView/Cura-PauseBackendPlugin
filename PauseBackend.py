# Copyright (c) 2022 Aldo Hoeben / fieldOfView
# PauseBackendPlugin is released under the terms of the AGPLv3 or higher.

from UM.Extension import Extension
from UM.Application import Application
from UM.PluginRegistry import PluginRegistry
from UM.Logger import Logger

from UM.Backend.Backend import BackendState

USE_QT5 = False
try:
    from PyQt6.QtQml import QQmlComponent, QQmlContext
    from PyQt6.QtCore import QUrl, pyqtSlot, QObject, QTimer
except ImportError:
    USE_QT5 = True
    from PyQt5.QtQml import QQmlComponent, QQmlContext
    from PyQt5.QtCore import QUrl, pyqtSlot, QObject, QTimer

import os.path

class PauseBackend(QObject, Extension):
    def __init__(self, parent = None):
        super().__init__(parent = parent)

        self._additional_component = None

        Application.getInstance().engineCreatedSignal.connect(self._createAdditionalComponentsView)

    def _createAdditionalComponentsView(self):
        Logger.log("d", "Creating additional ui components for Pause Backend plugin.")

        try:
            major_api_version = Application.getInstance().getAPIVersion().getMajor()
        except AttributeError:
            # UM.Application.getAPIVersion was added for API > 6 (Cura 4)
            # Since this plugin version is only compatible with Cura 3.5 and newer, it is safe to assume API 5
            major_api_version = 5

        if USE_QT5:
            if major_api_version <= 5:
                qml_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "PauseBackend3x.qml")
            else:
                qml_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "PauseBackend4x.qml")
        else:
            qml_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "PauseBackend5x.qml")

        self._additional_components = Application.getInstance().createQmlComponent(qml_path, {"manager": self})
        if not self._additional_components:
            Logger.log("w", "Could not create additional components.")
            return

        Application.getInstance().addAdditionalComponent("saveButton", self._additional_components.findChild(QObject, "pauseResumeButton"))
