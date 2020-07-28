// Copyright (c) 2020 Aldo Hoeben / fieldOfView
// PauseBackendPlugin is released under the terms of the AGPLv3 or higher.

import UM 1.2 as UM
import Cura 1.0 as Cura

import QtQuick 2.2
import QtQuick.Controls 1.1

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

        function togglePaused()
        {
            paused = !paused;
            UM.Preferences.setValue("general/auto_slice", !paused);
        }

        property bool paused: !boolCheck(UM.Preferences.getValue("general/auto_slice"))

        height: UM.Theme.getSize("action_button").height
        iconSource: paused ? "play.svg" : "pause.svg"

        tooltip: paused ? catalog.i18nc("@info:tooltip", "Resume automatic slicing") : catalog.i18nc("@info:tooltip", "Pause automatic slicing")
        toolTipContentAlignment: Cura.ToolTip.ContentAlignment.AlignLeft

        onClicked: togglePaused()
        Action
        {
            shortcut: "Ctrl+Shift+P"
            onTriggered: pauseResumeButton.togglePaused()
        }
    }

    UM.I18nCatalog{id: catalog; name:"cura"}
}