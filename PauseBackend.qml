// Copyright (c) 2015 Ultimaker B.V.
// Uranium is released under the terms of the AGPLv3 or higher.

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Window 2.2

import UM 1.1 as UM

Item
{
    id: base
    property bool paused: false
;
    UM.I18nCatalog { id: catalog; name: "cura" }

    width: parent.width - 2 * UM.Theme.getSize("default_margin").width
    height: UM.Theme.getSize("save_button_save_to_button").height + 3.75* UM.Theme.getSize("default_margin").height
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.bottomMargin: UM.Theme.getSize("default_margin").height
    anchors.rightMargin: UM.Theme.getSize("sidebar").width - UM.Theme.getSize("default_margin").width - width

    Rectangle
    {
        color: UM.Theme.getColor("sidebar")
        width: parent.width
        height: parent.height

        anchors.bottom: parent.bottom
        visible: parent.paused

        Label {
            id: statusLabel
            anchors.top: parent.top
            anchors.left: parent.left

            color: UM.Theme.getColor("text")
            font: UM.Theme.getFont("large")
            text: catalog.i18nc("@label:PrintjobStatus","Slicing paused");
        }
    }

    Button
    {
        id: pauseButton
        width: UM.Theme.getSize("save_button_save_to_button").height
        height: UM.Theme.getSize("save_button_save_to_button").height

        anchors.bottom: parent.bottom
        anchors.left: parent.left

        onClicked:
        {
            base.paused = !base.paused
        }

        style: ButtonStyle {
            background: Rectangle {
                id: deviceSelectionIcon
                border.width: UM.Theme.getSize("default_lining").width
                border.color: control.pressed ? UM.Theme.getColor("action_button_active_border") :
                                control.hovered ? UM.Theme.getColor("action_button_hovered_border") : UM.Theme.getColor("action_button_border")
                color: control.pressed ? UM.Theme.getColor("action_button_active") :
                        control.hovered ? UM.Theme.getColor("action_button_hovered") : UM.Theme.getColor("action_button")
                Behavior on color { ColorAnimation { duration: 50; } }
                anchors.left: parent.left
                anchors.leftMargin: UM.Theme.getSize("save_button_text_margin").width / 2
                width: parent.height
                height: parent.height

                UM.RecolorImage {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: UM.Theme.getSize("standard_arrow").width
                    height: UM.Theme.getSize("standard_arrow").height
                    sourceSize.width: width
                    sourceSize.height: height
                    color: control.pressed ? UM.Theme.getColor("action_button_active_text") :
                            control.hovered ? UM.Theme.getColor("action_button_hovered_text") : UM.Theme.getColor("action_button_text")
                    source: base.paused ? "play.svg" : "pause.svg"
                }
            }
            label: Label{ }
        }
    }
}
