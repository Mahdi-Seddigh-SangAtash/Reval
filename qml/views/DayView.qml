import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "../utils/JalaliDate.js" as Jalali

Item {
    id: dayView
    property real hourWidth: 120.0
    property int dayOffset: 0
    property var displayedDate: new Date()
    property real currentTimeInHours: 0.0
    property var initialCustomDate: null

    property var tasks: []
    signal editTask(var taskData)

    function updateDate() {
        if (dayView.initialCustomDate && dayView.dayOffset === 0) {
            dayView.displayedDate = new Date(dayView.initialCustomDate);
        } else {
            var base = dayView.initialCustomDate ? new Date(dayView.initialCustomDate) : new Date();
            var d = new Date(base.getTime());
            d.setDate(d.getDate() + dayView.dayOffset);
            dayView.displayedDate = d;
        }
    }

    function isViewingToday() {
        var now = new Date();
        return now.getFullYear() === dayView.displayedDate.getFullYear() &&
               now.getMonth() === dayView.displayedDate.getMonth() &&
               now.getDate() === dayView.displayedDate.getDate();
    }

    function updateCurrentTime() {
        var now = new Date();
        dayView.currentTimeInHours = now.getHours() + (now.getMinutes() / 60.0) + (now.getSeconds() / 3600.0);
    }

    function scrollToNow() {
        if (isViewingToday()) {
            var targetX = (dayView.currentTimeInHours * dayView.hourWidth) - (timelineFlick.width / 2);
            timelineFlick.contentX = Math.max(0, Math.min(targetX, timelineFlick.contentWidth - timelineFlick.width));
        } else {
            timelineFlick.contentX = 0;
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: dayView.updateCurrentTime()
    }

    Component.onCompleted: {
        updateDate();
        updateCurrentTime();
        Qt.callLater(scrollToNow);
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 6

            Text {
                Layout.alignment: Qt.AlignHCenter
                visible: dayView.isViewingToday()
                text: "Today"
                color: theme.textPrimary
                font.pixelSize: 34
                font.bold: true
            }

            RowLayout {
                spacing: 30
                Layout.alignment: Qt.AlignHCenter

                Text {
                    text: "< Yesterday"
                    color: theme.textSecondary
                    font.pixelSize: 15
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            dayView.dayOffset -= 1;
                            dayView.updateDate();
                        }
                    }
                }

                Text {
                    text: Jalali.getJalaliDateInfo(dayView.displayedDate).formatted
                    color: theme.textPrimary
                    font.pixelSize: 18
                    font.bold: true
                }

                Text {
                    text: "Tomorrow >"
                    color: theme.textSecondary
                    font.pixelSize: 15
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            dayView.dayOffset += 1;
                            dayView.updateDate();
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 12

            Flickable {
                id: timelineFlick
                Layout.fillWidth: true
                Layout.fillHeight: true
                contentWidth: Math.max(timelineFlick.width, 24 * dayView.hourWidth)
                clip: true

                MouseArea {
                    anchors.fill: parent
                    onWheel: function(wheel) {
                        var oldWidth = dayView.hourWidth;
                        var newWidth = wheel.angleDelta.y > 0 ? Math.min(260, oldWidth + 15) : Math.max(50, oldWidth - 15);
                        if (newWidth !== oldWidth) {
                            var mouseTimelineX = timelineFlick.contentX + wheel.x;
                            var ratio = mouseTimelineX / (24 * oldWidth);
                            dayView.hourWidth = newWidth;
                            timelineFlick.contentX = Math.max(0, (ratio * (24 * newWidth)) - wheel.x);
                        }
                    }

                    Rectangle {
                        width: timelineFlick.contentWidth
                        height: timelineFlick.height
                        color: theme.bgSurface
                        radius: 12
                        border.color: theme.border
                        border.width: 1

                        // Time Ruler on Top
                        Rectangle {
                            id: timeRuler
                            width: parent.width
                            height: 48
                            color: theme.isDark ? "#0f0f20" : "#d2d5dc"
                            radius: 12

                            Repeater {
                                model: 24
                                Item {
                                    x: index * dayView.hourWidth
                                    width: dayView.hourWidth
                                    height: 48

                                    Text {
                                        anchors.horizontalCenter: parent.left
                                        y: 6
                                        text: (index < 10 ? "0" : "") + index + ":00"
                                        color: theme.textSecondary
                                        font.pixelSize: 12
                                        font.bold: true
                                    }
                                    Rectangle {
                                        width: 1.5; height: 12
                                        color: theme.borderLight
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.left
                                    }

                                    // :30 marker
                                    Item {
                                        visible: dayView.hourWidth >= 85
                                        x: dayView.hourWidth * 0.5
                                        width: 1
                                        height: parent.height

                                        Text {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            y: 8
                                            text: ":30"
                                            color: theme.textMuted
                                            font.pixelSize: 10
                                        }
                                        Rectangle {
                                            width: 1; height: 8
                                            color: theme.borderLight
                                            anchors.bottom: parent.bottom
                                            anchors.horizontalCenter: parent.horizontalCenter
                                        }
                                    }

                                    // :15 and :45 markers
                                    Item {
                                        visible: dayView.hourWidth >= 150
                                        x: dayView.hourWidth * 0.25
                                        Rectangle {
                                            width: 1; height: 6
                                            color: theme.borderLight
                                            anchors.bottom: parent.bottom
                                            anchors.horizontalCenter: parent.horizontalCenter
                                        }
                                        Text {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            y: 10
                                            text: ":15"
                                            color: theme.textMuted
                                            font.pixelSize: 9
                                        }
                                    }
                                    Item {
                                        visible: dayView.hourWidth >= 150
                                        x: dayView.hourWidth * 0.75
                                        Rectangle {
                                            width: 1; height: 6
                                            color: theme.borderLight
                                            anchors.bottom: parent.bottom
                                            anchors.horizontalCenter: parent.horizontalCenter
                                        }
                                        Text {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            y: 10
                                            text: ":45"
                                            color: theme.textMuted
                                            font.pixelSize: 9
                                        }
                                    }

                                    Rectangle {
                                        x: 0
                                        y: 48
                                        width: 1
                                        height: timelineFlick.height - 48
                                        color: theme.isDark ? "#141426" : "#e2e4e8"
                                    }
                                }
                            }
                        }

                        // Task Cards Area (with strict clipping and text wrapping)
                        Item {
                            id: cardsLayer
                            anchors.top: timeRuler.bottom
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 30
                            width: parent.width

                            Repeater {
                                model: dayView.tasks
                                Rectangle {
                                    readonly property var itemData: modelData
                                    visible: {
                                        var curIso = Jalali.getJalaliDateInfo(dayView.displayedDate).isoDate;
                                        return !itemData.date || itemData.date === curIso;
                                    }
                                    x: (itemData.startHour !== undefined ? itemData.startHour : 9) * dayView.hourWidth
                                    y: 20
                                    width: (itemData.duration !== undefined ? itemData.duration : 1) * dayView.hourWidth
                                    height: Math.min(220, Math.max(140, cardsLayer.height - 50))
                                    radius: 12
                                    color: itemData.color || "#ff9f43"
                                    clip: true // Prevents text or contents from bleeding outside the card boundaries!

                                    ColumnLayout {
                                        anchors.fill: parent
                                        anchors.margins: 10
                                        spacing: 4

                                        Text {
                                            text: itemData.title || ""
                                            color: "white"
                                            font.pixelSize: Math.min(18, Math.max(13, parent.width / 8))
                                            font.bold: true
                                            Layout.fillWidth: true
                                            elide: Text.ElideRight
                                        }
                                        Text {
                                            text: itemData.notes || ""
                                            color: "#f5f6fa"
                                            font.pixelSize: 12
                                            Layout.fillWidth: true
                                            wrapMode: Text.WrapAnywhere // Safely wraps URLs or words that don't have spaces!
                                            elide: Text.ElideRight
                                            maximumLineCount: 4
                                        }
                                        Item { Layout.fillHeight: true }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onDoubleClicked: dayView.editTask(itemData)
                                    }
                                }
                            }
                        }

                        // Current Time Indicator
                        Item {
                            id: nowIndicator
                            visible: dayView.isViewingToday()
                            x: dayView.currentTimeInHours * dayView.hourWidth
                            y: 0
                            width: 1
                            height: parent.height
                            z: 10

                            Rectangle {
                                width: 2
                                anchors.horizontalCenter: parent.horizontalCenter
                                y: 36
                                height: parent.height - 62
                                color: theme.accentTeal
                            }

                            Canvas {
                                id: triangleCanvas
                                width: 18; height: 12
                                anchors.bottom: nowLabel.top
                                anchors.horizontalCenter: parent.horizontalCenter
                                onPaint: {
                                    var ctx = getContext("2d");
                                    ctx.reset();
                                    ctx.fillStyle = theme.accentTeal;
                                    ctx.beginPath();
                                    ctx.moveTo(width / 2, 0);
                                    ctx.lineTo(width, height);
                                    ctx.lineTo(0, height);
                                    ctx.closePath();
                                    ctx.fill();
                                }
                            }

                            Text {
                                id: nowLabel
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 4
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "Now"
                                color: theme.accentTeal
                                font.pixelSize: 11
                                font.bold: true
                            }
                        }
                    }
                }
            }

            // Zoom Sidebar (+ / -)
            ColumnLayout {
                spacing: 8
                Rectangle {
                    width: 38; height: 38; radius: 8; color: theme.bgRailBtn
                    Text { anchors.centerIn: parent; text: "+"; color: theme.textPrimary; font.pixelSize: 22 }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: dayView.hourWidth = Math.min(260, dayView.hourWidth + 20)
                    }
                }
                Rectangle {
                    width: 38; height: 38; radius: 8; color: theme.bgRailBtn
                    Text { anchors.centerIn: parent; text: "-"; color: theme.textPrimary; font.pixelSize: 22 }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: dayView.hourWidth = Math.max(50, dayView.hourWidth - 20)
                    }
                }
            }
        }
    }
}
