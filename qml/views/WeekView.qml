import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "../utils/JalaliDate.js" as Jalali

Item {
    id: weekView
    property real hourWidth: 75.0
    property int weekOffset: 0
    property var tasks: []
    signal editTask(var taskData)

    property var weekDaysData: []

    function computeWeekDays() {
        var today = new Date();
        var d = new Date(today.getTime());
        var shamsiDayIdx = Jalali.getShamsiDayOfWeekIndex(d);
        d.setDate(d.getDate() - shamsiDayIdx + (weekView.weekOffset * 7));

        var arr = [];
        var now = new Date();
        for (var i = 0; i < 7; i++) {
            var dayObj = new Date(d.getTime());
            dayObj.setDate(dayObj.getDate() + i);
            var jInfo = Jalali.getJalaliDateInfo(dayObj);
            var isCurrentDay = (dayObj.getFullYear() === now.getFullYear() &&
                                dayObj.getMonth() === now.getMonth() &&
                                dayObj.getDate() === now.getDate());
            arr.push({
                name: jInfo.weekDayName,
                date: jInfo.day + " " + jInfo.monthName + " " + jInfo.year,
                isoDate: jInfo.isoDate,
                isToday: isCurrentDay
            });
        }
        weekView.weekDaysData = arr;
    }

    Component.onCompleted: computeWeekDays()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 12

        // Header Navigation Area
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 4

            // "This Week" appears only when viewing the active week
            Text {
                Layout.alignment: Qt.AlignHCenter
                visible: weekView.weekOffset === 0
                text: "This Week"
                color: theme.textPrimary
                font.pixelSize: 34
                font.bold: true
            }

            RowLayout {
                spacing: 30
                Layout.alignment: Qt.AlignHCenter

                Text {
                    text: "< Previous Week"
                    color: theme.textSecondary
                    font.pixelSize: 15
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            weekView.weekOffset -= 1;
                            weekView.computeWeekDays();
                        }
                    }
                }

                Text {
                    text: weekView.weekDaysData.length > 0 ? (weekView.weekDaysData[0].date + "  —  " + weekView.weekDaysData[6].date) : ""
                    color: theme.textPrimary
                    font.pixelSize: 16
                    font.bold: true
                }

                Text {
                    text: "Next Week >"
                    color: theme.textSecondary
                    font.pixelSize: 15
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            weekView.weekOffset += 1;
                            weekView.computeWeekDays();
                        }
                    }
                }
            }
        }

        // Timeline Grid Area
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 12

            Flickable {
                id: flick
                Layout.fillWidth: true
                Layout.fillHeight: true
                contentWidth: Math.max(flick.width, 130 + 24 * weekView.hourWidth)
                contentHeight: 38 + 7 * 64
                clip: true

                Item {
                    width: flick.contentWidth
                    height: flick.contentHeight

                    // 1. Top Hour Ruler
                    Row {
                        x: 130
                        z: 2
                        Repeater {
                            model: 24
                            Item {
                                width: weekView.hourWidth
                                height: 34

                                Text {
                                    anchors.horizontalCenter: parent.left
                                    y: 2
                                    text: (index < 10 ? "0" : "") + index + ":00"
                                    color: theme.textSecondary
                                    font.pixelSize: 11
                                    font.bold: true
                                }

                                Rectangle {
                                    width: 1.5
                                    height: 8
                                    color: theme.borderLight
                                    anchors.bottom: parent.bottom
                                    anchors.horizontalCenter: parent.left
                                }
                            }
                        }
                    }

                    // 2. Full-Height Vertical Grid Lines across all 7 rows
                    Item {
                        x: 130
                        y: 36
                        width: 24 * weekView.hourWidth
                        height: 7 * 64
                        z: 0

                        Repeater {
                            model: 25 // 00:00 to 24:00
                            Rectangle {
                                x: index * weekView.hourWidth - 0.5
                                width: 1
                                height: parent.height
                                color: theme.isDark ? "#16162a" : "#cbd1da"
                            }
                        }
                    }

                    // 3. 7 Day Rows & Task Blocks
                    Column {
                        y: 36
                        z: 1
                        Repeater {
                            model: weekView.weekDaysData
                            Rectangle {
                                readonly property var dayInfo: modelData
                                width: flick.contentWidth
                                height: 64
                                color: dayInfo.isToday ? (theme.isDark ? "#172b4d" : "#cbe4f7") : (index % 2 === 0 ? theme.bgSurface : theme.bgCard)
                                opacity: 0.94
                                border.color: dayInfo.isToday ? theme.accentCyan : theme.border
                                border.width: dayInfo.isToday ? 1.5 : 0.5

                                Column {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 2
                                    Text {
                                        text: dayInfo.name
                                        color: dayInfo.isToday ? theme.accentCyan : theme.textPrimary
                                        font.bold: true
                                        font.pixelSize: 13
                                    }
                                    Text {
                                        text: dayInfo.date
                                        color: theme.textSecondary
                                        font.pixelSize: 10
                                    }
                                }

                                Item {
                                    x: 130
                                    width: parent.width - 130
                                    height: parent.height

                                    Repeater {
                                        model: weekView.tasks
                                        Rectangle {
                                            readonly property var t: modelData
                                            visible: t.date === dayInfo.isoDate
                                            x: (t.startHour !== undefined ? t.startHour : 9) * weekView.hourWidth
                                            y: 8
                                            width: (t.duration !== undefined ? t.duration : 1) * weekView.hourWidth
                                            height: 48
                                            radius: 6
                                            color: t.color || "#ff9f43"
                                            clip: true

                                            Text {
                                                anchors.centerIn: parent
                                                text: t.title || ""
                                                color: "white"
                                                font.bold: true
                                                font.pixelSize: 12
                                                elide: Text.ElideRight
                                            }

                                            MouseArea {
                                                anchors.fill: parent
                                                cursorShape: Qt.PointingHandCursor
                                                onDoubleClicked: weekView.editTask(t)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Zoom Sidebar (+ / -)
            ColumnLayout {
                spacing: 8
                Rectangle {
                    width: 36; height: 36; radius: 8; color: theme.bgRailBtn
                    Text { anchors.centerIn: parent; text: "+"; color: theme.textPrimary; font.pixelSize: 20 }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: weekView.hourWidth = Math.min(160, weekView.hourWidth + 15)
                    }
                }
                Rectangle {
                    width: 36; height: 36; radius: 8; color: theme.bgRailBtn
                    Text { anchors.centerIn: parent; text: "-"; color: theme.textPrimary; font.pixelSize: 20 }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: weekView.hourWidth = Math.max(45, weekView.hourWidth - 15)
                    }
                }
            }
        }
    }
}