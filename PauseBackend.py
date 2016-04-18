# Copyright ;(c) 2016 Ultimaker B.V.
# Cura is released under the terms of the AGPLv3 or higher.

from PyQt5.QtCore import QTimer

from UM.i18n import i18nCatalog
from UM.Extension import Extension
from UM.Application import Application
from UM.PluginRegistry import PluginRegistry

from UM.Scene.SceneNode import SceneNode
from UM.Mesh.MeshBuilder import MeshBuilder
from UM.Mesh.MeshData import MeshData

from UM.Operations.AddSceneNodeOperation import AddSceneNodeOperation
from UM.Operations.RemoveSceneNodeOperation import RemoveSceneNodeOperation

from UM.Math.Vector import Vector
from UM.Math.Color import Color

from PyQt5.QtQuick import QQuickView, QQuickItem
from PyQt5.QtQml import QQmlComponent, QQmlContext
from PyQt5.QtCore import QUrl, pyqtSlot, QObject

import os.path

class PauseBackend(Extension, QObject):
    def __init__(self, parent = None):
        QObject.__init__(self, parent)
        Extension.__init__(self)

        self._ui_object = None
        self._ui_context = None
        self._handle_width = 10

        self._controller = Application.getInstance().getController()
        self._root = self._controller.getScene().getRoot()
        self._node = SceneNode()
        self._node.setMeshData(self._createMesh())
        self._node.setName("PauseBackendStub")

        Application.getInstance().engineCreatedSignal.connect(self._onEngineCreated)

    def _createMesh(self):
        mb = MeshBuilder()
        mb.addCube(
            width = self._handle_width,
            height = self._handle_width,
            depth = self._handle_width,
            center = Vector(150, 0, 0),
            color = Color(1.0, 0.0, 0.0, 1.0)
        )
        return mb.getData()

    def _addToScene(self):
        self._node.setParent(self._root)
        op = AddSceneNodeOperation(self._node, self._root)
        op.push()

        self._controller.getScene().sceneChanged.emit(self._node) #Force scene change.

    def _removeFromScene(self):
        self._node.setParent(None)
        op = RemoveSceneNodeOperation(self._node)
        op.push()

        self._controller.getScene().sceneChanged.emit(self._node) #Force scene change.

    def _onEngineCreated(self):
        path = QUrl.fromLocalFile(os.path.join(PluginRegistry.getInstance().getPluginPath(self.getPluginId()), "PauseBackend.qml"))

        component = QQmlComponent(Application.getInstance()._engine, path)
        self._ui_context = QQmlContext(Application.getInstance()._engine.rootContext())
        self._ui_context.setContextProperty("manager", self)
        self._ui_object = component.create(self._ui_context)

        main_item = Application.getInstance().getMainWindow().contentItem()
        self._ui_object.setParentItem(main_item)

        ui_button_object = self._ui_object.children()[1]
        ui_button_object.clicked.connect(self._onClicked)

    def _onClicked(self):
        if self._ui_object.property("paused"):
            self._addToScene()
        else:
            self._removeFromScene()