# Copyright ;(c) 2016 Ultimaker B.V.
# Cura is released under the terms of the AGPLv3 or higher.

from PyQt5.QtCore import QTimer

from UM.Extension import Extension
from UM.Application import Application
from UM.PluginRegistry import PluginRegistry
from UM.Logger import Logger

from UM.Backend.Backend import BackendState

from PyQt5.QtQml import QQmlComponent, QQmlContext
from PyQt5.QtCore import QUrl, pyqtSlot, QObject

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

        if major_api_version <= 5:
            # In Cura 3.x, the monitor item only shows the camera stream
            qml_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "PauseBackend3x.qml")
        else:
            qml_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "PauseBackend4x.qml")

        self._additional_components = Application.getInstance().createQmlComponent(qml_path, {"manager": self})
        if not self._additional_components:
            Logger.log("w", "Could not create additional components.")
            return

        Application.getInstance().addAdditionalComponent("saveButton", self._additional_components.findChild(QObject, "pauseResumeButton"))
