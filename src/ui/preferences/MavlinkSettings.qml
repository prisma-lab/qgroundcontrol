/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


import QtQuick                  2.5
import QtQuick.Controls         1.2
import QtQuick.Controls.Styles  1.2
import QtQuick.Dialogs          1.1

import QGroundControl                       1.0
import QGroundControl.FactSystem            1.0
import QGroundControl.Controls              1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.Palette               1.0

Rectangle {
    id:             __mavlinkRoot
    color:          qgcPal.window
    anchors.fill:   parent

    property real _labelWidth:      ScreenTools.defaultFontPixelWidth * 28
    property real _valueWidth:      ScreenTools.defaultFontPixelWidth * 24
    property int  _selectedCount:   0

    QGCPalette { id: qgcPal }

    Connections {
        target: QGroundControl.mavlinkLogManager
        onSelectedCountChanged: {
            var selected = 0
            for(var i = 0; i < QGroundControl.mavlinkLogManager.logFiles.count; i++) {
                var logFile = QGroundControl.mavlinkLogManager.logFiles.get(i)
                if(logFile.selected)
                    selected++
            }
            _selectedCount = selected
        }
    }

    MessageDialog {
        id:         emptyEmailDialog
        visible:    false
        icon:       StandardIcon.Warning
        standardButtons: StandardButton.Close
        title:      qsTr("Uploading Log Files")
        text:       qsTr("Please enter an email address before uploading log files.")
    }

    QGCFlickable {
        clip:               true
        anchors.fill:       parent
        anchors.margins:    ScreenTools.defaultFontPixelWidth
        contentHeight:      settingsColumn.height
        contentWidth:       settingsColumn.width

        Column {
            id:                 settingsColumn
            width:              __mavlinkRoot.width
            spacing:            ScreenTools.defaultFontPixelHeight * 0.5
            anchors.margins:    ScreenTools.defaultFontPixelWidth
            //-----------------------------------------------------------------
            //-- Ground Station
            Item {
                width:              __mavlinkRoot.width * 0.8
                height:             gcsLabel.height
                anchors.margins:    ScreenTools.defaultFontPixelWidth
                anchors.horizontalCenter: parent.horizontalCenter
                QGCLabel {
                    id:             gcsLabel
                    text:           qsTr("Ground Station")
                    font.family:    ScreenTools.demiboldFontFamily
                }
            }
            Rectangle {
                height:         gcsColumn.height + (ScreenTools.defaultFontPixelHeight * 2)
                width:          __mavlinkRoot.width * 0.8
                color:          qgcPal.windowShade
                anchors.margins: ScreenTools.defaultFontPixelWidth
                anchors.horizontalCenter: parent.horizontalCenter
                Column {
                    id:         gcsColumn
                    spacing:    ScreenTools.defaultFontPixelWidth
                    anchors.centerIn: parent
                    Row {
                        spacing:    ScreenTools.defaultFontPixelWidth
                        QGCLabel {
                            width:              _labelWidth
                            anchors.baseline:   sysidField.baseline
                            text:               qsTr("MavLink System ID:")
                        }
                        QGCTextField {
                            id:     sysidField
                            text:   QGroundControl.mavlinkSystemID.toString()
                            width:  _valueWidth
                            inputMethodHints:       Qt.ImhFormattedNumbersOnly
                            anchors.verticalCenter: parent.verticalCenter
                            onEditingFinished: {
                                QGroundControl.mavlinkSystemID = parseInt(sysidField.text)
                            }
                        }
                    }
                    //-----------------------------------------------------------------
                    //-- Mavlink Heartbeats
                    QGCCheckBox {
                        text:       qsTr("Emit heartbeat")
                        checked:    QGroundControl.multiVehicleManager.gcsHeartBeatEnabled
                        onClicked: {
                            QGroundControl.multiVehicleManager.gcsHeartBeatEnabled = checked
                        }
                    }
                    //-----------------------------------------------------------------
                    //-- Mavlink Version Check
                    QGCCheckBox {
                        text:       qsTr("Only accept MAVs with same protocol version")
                        checked:    QGroundControl.isVersionCheckEnabled
                        onClicked: {
                            QGroundControl.isVersionCheckEnabled = checked
                        }
                    }
                }
            }
            //-----------------------------------------------------------------
            //-- Mavlink Logging
            Item {
                width:              __mavlinkRoot.width * 0.8
                height:             mavlogLabel.height
                anchors.margins:    ScreenTools.defaultFontPixelWidth
                anchors.horizontalCenter: parent.horizontalCenter
                QGCLabel {
                    id:             mavlogLabel
                    text:           qsTr("Vehicle Mavlink Logging")
                    font.family:    ScreenTools.demiboldFontFamily
                }
            }
            Rectangle {
                height:         mavlogColumn.height + (ScreenTools.defaultFontPixelHeight * 2)
                width:          __mavlinkRoot.width * 0.8
                color:          qgcPal.windowShade
                anchors.margins: ScreenTools.defaultFontPixelWidth
                anchors.horizontalCenter: parent.horizontalCenter
                Column {
                    id:         mavlogColumn
                    width:      gcsColumn.width
                    spacing:    ScreenTools.defaultFontPixelWidth
                    anchors.centerIn: parent
                    //-----------------------------------------------------------------
                    //-- Enable auto log on arming
                    QGCCheckBox {
                        text:       qsTr("Enable automatic logging start when vehicle is armed")
                        checked:    QGroundControl.mavlinkLogManager.enableAutoStart
                        onClicked: {
                            QGroundControl.mavlinkLogManager.enableAutoStart = checked
                        }
                    }
                    //-----------------------------------------------------------------
                    //-- Manual Start/Stop
                    Row {
                        spacing:    ScreenTools.defaultFontPixelWidth
                        anchors.horizontalCenter: parent.horizontalCenter
                        QGCButton {
                            text:       "Start Logging"
                            enabled:    !QGroundControl.mavlinkLogManager.logRunning && QGroundControl.mavlinkLogManager.canStartLog
                            onClicked:  QGroundControl.mavlinkLogManager.startLogging()
                        }
                        QGCButton {
                            text:       "Stop Logging"
                            enabled:    QGroundControl.mavlinkLogManager.logRunning
                            onClicked:  QGroundControl.mavlinkLogManager.stopLogging()
                        }
                    }
                }
            }
            //-----------------------------------------------------------------
            //-- Mavlink Logging
            Item {
                width:              __mavlinkRoot.width * 0.8
                height:             logLabel.height
                anchors.margins:    ScreenTools.defaultFontPixelWidth
                anchors.horizontalCenter: parent.horizontalCenter
                QGCLabel {
                    id:             logLabel
                    text:           qsTr("Mavlink Log Uploads")
                    font.family:    ScreenTools.demiboldFontFamily
                }
            }
            Rectangle {
                height:         logColumn.height + (ScreenTools.defaultFontPixelHeight * 2)
                width:          __mavlinkRoot.width * 0.8
                color:          qgcPal.windowShade
                anchors.margins: ScreenTools.defaultFontPixelWidth
                anchors.horizontalCenter: parent.horizontalCenter
                Column {
                    id:         logColumn
                    spacing:    ScreenTools.defaultFontPixelWidth
                    anchors.centerIn: parent
                    //-----------------------------------------------------------------
                    //-- Email address Field
                    Row {
                        spacing:    ScreenTools.defaultFontPixelWidth
                        QGCLabel {
                            width:              _labelWidth
                            anchors.baseline:   emailField.baseline
                            text:               qsTr("Email address for Log Upload:")
                        }
                        QGCTextField {
                            id:     emailField
                            text:   QGroundControl.mavlinkLogManager.emailAddress
                            width:  _valueWidth
                            inputMethodHints:       Qt.ImhNoAutoUppercase | Qt.ImhEmailCharactersOnly
                            anchors.verticalCenter: parent.verticalCenter
                            onEditingFinished: {
                                QGroundControl.mavlinkLogManager.emailAddress = emailField.text
                            }
                        }
                    }
                    //-----------------------------------------------------------------
                    //-- Description Field
                    Row {
                        spacing:    ScreenTools.defaultFontPixelWidth
                        QGCLabel {
                            width:              _labelWidth
                            anchors.baseline:   descField.baseline
                            text:               qsTr("Default Description:")
                        }
                        QGCTextField {
                            id:     descField
                            text:   QGroundControl.mavlinkLogManager.description
                            width:  _valueWidth
                            anchors.verticalCenter: parent.verticalCenter
                            onEditingFinished: {
                                QGroundControl.mavlinkLogManager.description = descField.text
                            }
                        }
                    }
                    //-----------------------------------------------------------------
                    //-- Upload URL
                    Row {
                        spacing:    ScreenTools.defaultFontPixelWidth
                        QGCLabel {
                            width:              _labelWidth
                            anchors.baseline:   urlField.baseline
                            text:               qsTr("Default Upload URL")
                        }
                        QGCTextField {
                            id:     urlField
                            text:   QGroundControl.mavlinkLogManager.uploadURL
                            width:  _valueWidth
                            inputMethodHints:       Qt.ImhNoAutoUppercase | Qt.ImhUrlCharactersOnly
                            anchors.verticalCenter: parent.verticalCenter
                            onEditingFinished: {
                                QGroundControl.mavlinkLogManager.uploadURL = urlField.text
                            }
                        }
                    }
                    //-----------------------------------------------------------------
                    //-- Automatic Upload
                    QGCCheckBox {
                        text:       qsTr("Enable automatic log uploads")
                        checked:    QGroundControl.mavlinkLogManager.enableAutoUpload
                        enabled:    emailField.text !== "" && urlField !== ""
                        onClicked: {
                            QGroundControl.mavlinkLogManager.enableAutoUpload = checked
                        }
                    }
                }
            }
            //-----------------------------------------------------------------
            //-- Log Files
            Item {
                width:              __mavlinkRoot.width * 0.8
                height:             logFilesLabel.height
                anchors.margins:    ScreenTools.defaultFontPixelWidth
                anchors.horizontalCenter: parent.horizontalCenter
                QGCLabel {
                    id:             logFilesLabel
                    text:           qsTr("Saved Log Files")
                    font.family:    ScreenTools.demiboldFontFamily
                }
            }
            Rectangle {
                height:         logFilesColumn.height + (ScreenTools.defaultFontPixelHeight * 2)
                width:          __mavlinkRoot.width * 0.8
                color:          qgcPal.windowShade
                anchors.margins: ScreenTools.defaultFontPixelWidth
                anchors.horizontalCenter: parent.horizontalCenter
                Column {
                    id:         logFilesColumn
                    spacing:    ScreenTools.defaultFontPixelWidth
                    anchors.centerIn: parent
                    width:          ScreenTools.defaultFontPixelWidth * 68
                    Rectangle {
                        width:          ScreenTools.defaultFontPixelWidth  * 64
                        height:         ScreenTools.defaultFontPixelHeight * 10
                        anchors.horizontalCenter: parent.horizontalCenter
                        color:          qgcPal.window
                        border.color:   qgcPal.text
                        border.width:   0.5
                        ListView {
                            width:          ScreenTools.defaultFontPixelWidth  * 56
                            height:         ScreenTools.defaultFontPixelHeight * 8.75
                            anchors.centerIn: parent
                            orientation:    ListView.Vertical
                            model:          QGroundControl.mavlinkLogManager.logFiles
                            clip:           true
                            delegate: Rectangle {
                                width:          ScreenTools.defaultFontPixelWidth  * 52
                                height:         ScreenTools.defaultFontPixelHeight * 1.25
                                color:          qgcPal.window
                                Row {
                                    width:  ScreenTools.defaultFontPixelWidth  * 50
                                    anchors.centerIn: parent
                                    spacing: ScreenTools.defaultFontPixelWidth
                                    QGCCheckBox {
                                        width:      ScreenTools.defaultFontPixelWidth * 4
                                        checked:    object.selected
                                        onClicked:  {
                                            object.selected = checked
                                        }
                                    }
                                    QGCLabel {
                                        text:       object.name
                                        width:      ScreenTools.defaultFontPixelWidth * 28
                                    }
                                    QGCLabel {
                                        text:       Number(object.size).toLocaleString(Qt.locale(), 'f', 0)
                                        visible:    !object.uploading
                                        width:      ScreenTools.defaultFontPixelWidth * 20;
                                        horizontalAlignment: Text.AlignRight
                                    }
                                    ProgressBar {
                                        visible:    object.uploading
                                        width:      ScreenTools.defaultFontPixelWidth * 20;
                                        height:     ScreenTools.defaultFontPixelHeight
                                        anchors.verticalCenter: parent.verticalCenter
                                        minimumValue:   0
                                        maximumValue:   100
                                        value:          object.progress * 100.0
                                    }
                                }
                            }
                        }
                    }
                    Row {
                        spacing:    ScreenTools.defaultFontPixelWidth
                        anchors.horizontalCenter: parent.horizontalCenter
                        QGCButton {
                            text:       "Check All"
                            enabled:    !QGroundControl.mavlinkLogManager.busy
                            onClicked: {
                                for(var i = 0; i < QGroundControl.mavlinkLogManager.logFiles.count; i++) {
                                    var logFile = QGroundControl.mavlinkLogManager.logFiles.get(i)
                                    logFile.selected = true
                                }
                            }
                        }
                        QGCButton {
                            text:       "Check None"
                            enabled:    !QGroundControl.mavlinkLogManager.busy
                            onClicked: {
                                for(var i = 0; i < QGroundControl.mavlinkLogManager.logFiles.count; i++) {
                                    var logFile = QGroundControl.mavlinkLogManager.logFiles.get(i)
                                    logFile.selected = false
                                }
                            }
                        }
                        QGCButton {
                            text:       "Delete Selected"
                            enabled:    _selectedCount > 0 && !QGroundControl.mavlinkLogManager.busy
                            onClicked:  deleteDialog.open()
                            MessageDialog {
                                id:         deleteDialog
                                visible:    false
                                icon:       StandardIcon.Warning
                                standardButtons: StandardButton.Yes | StandardButton.No
                                title:      qsTr("Delete Selected Log Files")
                                text:       qsTr("Confirm deleting selected log files?")
                                onYes: {
                                    QGroundControl.mavlinkLogManager.deleteLog()
                                }
                            }
                        }
                        QGCButton {
                            text:       "Upload Selected"
                            enabled:    _selectedCount > 0 && !QGroundControl.mavlinkLogManager.busy
                            visible:    !QGroundControl.mavlinkLogManager.busy
                            onClicked:  {
                                QGroundControl.mavlinkLogManager.emailAddress = emailField.text
                                if(QGroundControl.mavlinkLogManager.emailAddress === "")
                                    emptyEmailDialog.open()
                                else
                                    uploadDialog.open()
                            }
                            MessageDialog {
                                id:         uploadDialog
                                visible:    false
                                icon:       StandardIcon.Question
                                standardButtons: StandardButton.Yes | StandardButton.No
                                title:      qsTr("Upload Selected Log Files")
                                text:       qsTr("Confirm uploading selected log files?")
                                onYes: {
                                    QGroundControl.mavlinkLogManager.uploadLog()
                                }
                            }
                        }
                        QGCButton {
                            text:       "Cancel"
                            enabled:    QGroundControl.mavlinkLogManager.busy
                            visible:    QGroundControl.mavlinkLogManager.busy
                            onClicked:  cancelDialog.open()
                            MessageDialog {
                                id:         cancelDialog
                                visible:    false
                                icon:       StandardIcon.Warning
                                standardButtons: StandardButton.Yes | StandardButton.No
                                title:      qsTr("Cancel Upload")
                                text:       qsTr("Confirm canceling the upload process?")
                                onYes: {
                                    QGroundControl.mavlinkLogManager.cancelUpload()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
