// Copyright (c) 2022 Aldo Hoeben / fieldOfView
// PauseBackendPlugin is released under the terms of the AGPLv3 or higher.

import UM 1.2 as UM
import Cura 1.0 as Cura

import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Item
{
    id: base

    Button
    {
        id: pauseResumeButton
        objectName: "pauseResumeButton"

        function boolCheck(value) //Hack to ensure a good match between python and qml.
        {
            if(value == "True")
            {
                return true;
            }
            else if(value == "False" || value == undefined)
            {
                return false;
            }
            else
            {
                return value;
            }
        }

        Connections
        {
            target: UM.Preferences
            onPreferenceChanged:
            {
                if (preference !== "general/auto_slice")
                {
                    return;
                }
                pauseResumeButton.paused = !pauseResumeButton.boolCheck(UM.Preferences.getValue("general/auto_slice"));
            }
        }

        function togglePaused()
        {
            paused = !paused;
            UM.Preferences.setValue("general/auto_slice", !paused);
        }

        property bool paused: !boolCheck(UM.Preferences.getValue("general/auto_slice"))
        property int extraMargin: (CuraApplication.platformActivity || !paused) ? 0 : (UM.Theme.getSize("sidebar_margin").width - UM.Theme.getSize("default_margin").width)

        height: UM.Theme.getSize("save_button_save_to_button").height
        width: height + extraMargin

        tooltip: paused ? catalog.i18nc("@info:tooltip", "Resume automatic slicing") : catalog.i18nc("@info:tooltip", "Pause automatic slicing")

        style: ButtonStyle {
            background: Rectangle {
                border.width: UM.Theme.getSize("default_lining").width
                border.color: !control.enabled ? UM.Theme.getColor("action_button_disabled_border") :
                                  control.pressed ? UM.Theme.getColor("action_button_active_border") :
                                  control.hovered ? UM.Theme.getColor("action_button_hovered_border") : UM.Theme.getColor("action_button_border")
                color: !control.enabled ? UM.Theme.getColor("action_button_disabled") :
                           control.pressed ? UM.Theme.getColor("action_button_active") :
                           control.hovered ? UM.Theme.getColor("action_button_hovered") : UM.Theme.getColor("action_button")
                Behavior on color { ColorAnimation { duration: 50; } }
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: control.extraMargin
                width: parent.height
                height: parent.height

                UM.RecolorImage {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width / 2
                    height: parent.height / 2
                    sourceSize.width: width
                    sourceSize.height: height
                    color: !control.enabled ? UM.Theme.getColor("action_button_disabled_text") :
                               control.pressed ? UM.Theme.getColor("action_button_active_text") :
                               control.hovered ? UM.Theme.getColor("action_button_hovered_text") : UM.Theme.getColor("action_button_text");
                    source: control.paused ? "play.svg" : "pause.svg"
                }
            }
            label: Label{ }
        }

        onClicked: togglePaused()
        Action
        {
            shortcut: "Ctrl+Shift+P"
            onTriggered: pauseResumeButton.togglePaused()
        }
    }

    UM.I18nCatalog{id: catalog; name:"cura"}
}