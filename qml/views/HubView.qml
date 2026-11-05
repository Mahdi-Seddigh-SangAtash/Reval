import QtQuick 2.15
import QtQuick.Layouts 1.15

Item {
    id: hub
    objectName: "hubView"

    signal openView(string viewName)
    signal openAdd()

    // Smooth uniform scale that preserves exact proportions on maximize
    readonly property real s: Math.min(Math.max(hub.width / 1100.0, 0.9), 1.3)

    ColumnLayout {
        anchors.centerIn: parent
        spacing: Math.round(36 * hub.s)

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "What You Gonna Do?"
            color: theme.textPrimary
            font.pixelSize: Math.round(44 * hub.s)
            font.bold: true
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: Math.round(16 * hub.s)

            // Large Add New card (Square: 180 x 180 at s=1)
            Rectangle {
                width: Math.round(180 * hub.s)
                height: Math.round(180 * hub.s)
                radius: Math.round(16 * hub.s)
                color: theme.accentPurple

                Text {
                    anchors.centerIn: parent
                    text: "Add New"
                    color: "white"
                    font.pixelSize: Math.round(22 * hub.s)
                    font.bold: true
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: parent.opacity = 0.92
                    onExited: parent.opacity = 1.0
                    onClicked: hub.openAdd()
                }
            }

            // Center Column: Date spans (2 cards: height 82 each + 16 spacing = 180 total height!)
            ColumnLayout {
                spacing: Math.round(16 * hub.s)

                Rectangle {
                    width: Math.round(240 * hub.s)
                    height: Math.round(82 * hub.s)
                    radius: Math.round(14 * hub.s)
                    color: theme.accentBlue
                    Text {
                        anchors.centerIn: parent
                        text: "This week"
                        color: "white"
                        font.pixelSize: Math.round(19 * hub.s)
                        font.bold: true
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onEntered: parent.opacity = 0.92
                        onExited: parent.opacity = 1.0
                        onClicked: hub.openView("week")
                    }
                }

                Rectangle {
                    width: Math.round(240 * hub.s)
                    height: Math.round(82 * hub.s)
                    radius: Math.round(14 * hub.s)
                    color: theme.accentCyan
                    Text {
                        anchors.centerIn: parent
                        text: "This Month"
                        color: "white"
                        font.pixelSize: Math.round(19 * hub.s)
                        font.bold: true
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onEntered: parent.opacity = 0.92
                        onExited: parent.opacity = 1.0
                        onClicked: hub.openView("month")
                    }
                }
            }

            // Right Column: Quick filters (2 cards: height 82 each + 16 spacing = 180 total height!)
            ColumnLayout {
                spacing: Math.round(16 * hub.s)

                Rectangle {
                    width: Math.round(110 * hub.s)
                    height: Math.round(82 * hub.s)
                    radius: Math.round(14 * hub.s)
                    color: theme.accentGreen
                    Text {
                        anchors.centerIn: parent
                        text: "Today"
                        color: "white"
                        font.pixelSize: Math.round(19 * hub.s)
                        font.bold: true
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onEntered: parent.opacity = 0.92
                        onExited: parent.opacity = 1.0
                        onClicked: hub.openView("day")
                    }
                }

                Rectangle {
                    width: Math.round(110 * hub.s)
                    height: Math.round(82 * hub.s)
                    radius: Math.round(14 * hub.s)
                    color: "#20bf6b"
                    Text {
                        anchors.centerIn: parent
                        text: "All"
                        color: "white"
                        font.pixelSize: Math.round(19 * hub.s)
                        font.bold: true
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onEntered: parent.opacity = 0.92
                        onExited: parent.opacity = 1.0
                        onClicked: hub.openView("all")
                    }
                }
            }
        }
    }
}
