import UM 1.2 as UM
import Cura 1.0 as Cura

import QtQuick 2.2

Item
{
    id: base

    Cura.SecondaryButton
    {
        id: pauseResumeButton
        objectName: "pauseResumeButton"

        fixedWidthMode: true

        function boolCheck(value) //Hack to ensure a good match between python and qml.
        {
            if(value == "True")
            {
                return true
            }else if(value == "False" || value == undefined)
            {
                return false
            }
            else
            {
                return value
            }
        }

        property bool paused: !boolCheck(UM.Preferences.getValue("general/auto_slice"))

        height: UM.Theme.getSize("action_button").height
        width: height
        iconSource: paused ? "play.svg" : "pause.svg"

        tooltip: paused ? catalog.i18nc("@info:tooltip", "Resume automatic slicing") : catalog.i18nc("@info:tooltip", "Pause automatic slicing")

        onClicked:
        {
            paused = !paused
            if(paused)
            {
                UM.Preferences.setValue("general/auto_slice", false)
            }
            else
            {
                UM.Preferences.setValue("general/auto_slice", true)
            }
        }
    }

    UM.I18nCatalog{id: catalog; name:"cura"}
}