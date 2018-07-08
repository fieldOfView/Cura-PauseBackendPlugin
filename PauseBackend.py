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

        path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "PauseBackend.qml")
        self._additional_components = Application.getInstance().createQmlComponent(path, {"manager": self})
        if not self._additional_components:
            Logger.log("w", "Could not create additional components for OctoPrint-connected printers.")
            return

        Application.getInstance().addAdditionalComponent("saveButton", self._additional_components.findChild(QObject, "pauseResumeButton"))
