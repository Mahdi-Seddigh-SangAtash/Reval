import QtQuick 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: rail
    width: 72
    color: theme.bgRail

    signal navigate(string page)
    property string activePage: "day"

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: 16
        anchors.bottomMargin: 16
        spacing: 0

        // TOP SECTION: Home ONLY
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            width: 48; height: 48; radius: 10
            color: theme.bgRailBtn
            Text { anchors.centerIn: parent; text: "⌂"; color: theme.textPrimary; font.pixelSize: 22 }
            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: rail.navigate("hub") }
        }

        // Top spacer pushes the group below to the exact vertical center
        Item { Layout.fillHeight: true }

        // CENTER SECTION: + , D , W , M , A
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 12

            // Add (+)
            Rectangle {
                width: 48; height: 48; radius: 10
                color: theme.accentPurple
                Text { anchors.centerIn: parent; text: "+"; color: "white"; font.bold: true; font.pixelSize: 26 }
                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: rail.navigate("add") }
            }

            // Day (D)
            Rectangle {
                width: 48; height: 48; radius: 10
                color: rail.activePage === "day" ? theme.accentGreen : (theme.isDark ? "#1f8a4c" : "#78c299")
                Text { anchors.centerIn: parent; text: "D"; color: "white"; font.bold: true; font.pixelSize: 20 }
                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: rail.navigate("day") }
            }

            // Week (W)
            Rectangle {
                width: 48; height: 48; radius: 10
                color: rail.activePage === "week" ? theme.accentBlue : (theme.isDark ? "#24428a" : "#7d97d4")
                Text { anchors.centerIn: parent; text: "W"; color: "white"; font.bold: true; font.pixelSize: 20 }
                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: rail.navigate("week") }
            }

            // Month (M)
            Rectangle {
                width: 48; height: 48; radius: 10
                color: rail.activePage === "month" ? theme.accentTeal : (theme.isDark ? "#00838f" : "#5ac5c6")
                Text { anchors.centerIn: parent; text: "M"; color: "white"; font.bold: true; font.pixelSize: 20 }
                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: rail.navigate("month") }
            }

            // All (A)
            Rectangle {
                width: 48; height: 48; radius: 10
                color: rail.activePage === "all" ? "#20bf6b" : (theme.isDark ? "#137341" : "#58b584")
                Text { anchors.centerIn: parent; text: "A"; color: "white"; font.bold: true; font.pixelSize: 20 }
                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: rail.navigate("all") }
            }
        }

        // Bottom spacer
        Item { Layout.fillHeight: true }

        // BOTTOM SECTION: Theme Toggle
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            width: 48; height: 48; radius: 24
            color: theme.bgRailBtn
            border.color: theme.borderLight
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: theme.isDark ? "☀️" : "🌙"
                font.pixelSize: 20
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: theme.isDark = !theme.isDark
            }
        }
    }
}