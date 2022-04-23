// Copyright (c) 2022 Aldo Hoeben / fieldOfView
// PauseBackendPlugin is released under the terms of the AGPLv3 or higher.

import UM 1.2 as UM
import Cura 1.0 as Cura

import QtQuick 2.2
import QtQuick.Controls 2.3

Item
{
    id: base

    Cura.SecondaryButton
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
            function onPreferenceChanged(preference)
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

        height: UM.Theme.getSize("action_button").height
        iconSource: Qt.resolvedUrl(paused ? "play.svg" : "pause.svg")

        tooltip: paused ? catalog.i18nc("@info:tooltip", "Resume automatic slicing") : catalog.i18nc("@info:tooltip", "Pause automatic slicing")
        toolTipContentAlignment: UM.Enums.ContentAlignment.AlignRight

        onClicked: togglePaused()
        Action
        {
            shortcut: "Ctrl+Shift+P"
            onTriggered: pauseResumeButton.togglePaused()
        }
    }

    UM.I18nCatalog{id: catalog; name:"cura"}
}