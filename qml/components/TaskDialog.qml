import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../utils/JalaliDate.js" as Jalali

Popup {
    id: dialog
    width: 460
    height: 560
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    signal taskSaved(var task)
    signal taskDeleted(int taskId)

    property bool isEditing: false
    property int currentId: -1
    property string selectedColor: "#ff9f43"

    background: Rectangle {
        color: theme.bgSurface
        radius: 14
        border.color: theme.borderLight
        border.width: 1
    }

    function openForNew(defaultDate) {
        isEditing = false;
        currentId = -1;
        titleInput.text = "";
        notesInput.text = "";
        var d = defaultDate ? defaultDate : new Date();
        var jInfo = Jalali.getJalaliDateInfo(d);
        dateInput.text = jInfo.isoDate;
        startTimeInput.text = "09:00";
        durationInput.text = "1.5";
        selectedColor = "#ff9f43";
        dialog.open();
        titleInput.forceActiveFocus();
    }

    function openForEdit(task) {
        if (!task) return;
        isEditing = true;
        currentId = task.id;
        titleInput.text = task.title || "";
        notesInput.text = task.notes || "";
        dateInput.text = task.date || Jalali.getJalaliDateInfo(new Date()).isoDate;
        startTimeInput.text = (task.startHour !== undefined) ? formatHour(task.startHour) : "09:00";
        durationInput.text = (task.duration !== undefined) ? task.duration.toString() : "1.0";
        selectedColor = task.color || "#ff9f43";
        dialog.open();
        titleInput.forceActiveFocus();
    }

    function formatHour(h) {
        var hour = Math.floor(h);
        var min = Math.round((h - hour) * 60);
        return (hour < 10 ? "0" : "") + hour + ":" + (min < 10 ? "0" : "") + min;
    }

    function parseHour(timeStr) {
        var parts = timeStr.split(":");
        if (parts.length >= 2) {
            var h = parseFloat(parts[0]) || 0;
            var m = parseFloat(parts[1]) || 0;
            return h + (m / 60.0);
        }
        return parseFloat(timeStr) || 9.0;
    }

    function commitSave() {
        if (titleInput.text.trim().length === 0) return;
        var taskObj = {
            id: dialog.isEditing ? dialog.currentId : Date.now(),
            title: titleInput.text.trim(),
            notes: notesInput.text.trim(),
            date: dateInput.text.trim(),
            startHour: parseHour(startTimeInput.text.trim()),
            duration: Math.max(0.25, parseFloat(durationInput.text.trim()) || 1.0),
            color: dialog.selectedColor
        };
        dialog.taskSaved(taskObj);
        dialog.close();
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 22
        spacing: 12

        RowLayout {
            Layout.fillWidth: true
            Text {
                text: dialog.isEditing ? "Edit Task" : "Add New Task"
                color: theme.textPrimary
                font.pixelSize: 20
                font.bold: true
            }
            Item { Layout.fillWidth: true }
            Button {
                visible: dialog.isEditing
                text: "Delete"
                contentItem: Text {
                    text: "Delete"
                    color: "white"
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                }
                background: Rectangle {
                    color: "#e74c3c"
                    radius: 6
                }
                onClicked: {
                    dialog.taskDeleted(dialog.currentId);
                    dialog.close();
                }
            }
        }

        TextField {
            id: titleInput
            Layout.fillWidth: true
            placeholderText: "Task Title *"
            color: theme.textPrimary
            placeholderTextColor: theme.textMuted
            background: Rectangle { color: theme.bgInput; radius: 8 }
            Keys.onReturnPressed: dialog.commitSave()
            Keys.onEnterPressed: dialog.commitSave()
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4
                Text { text: "Date (Shamsi)"; color: theme.textSecondary; font.pixelSize: 11; font.bold: true }
                TextField {
                    id: dateInput
                    Layout.fillWidth: true
                    placeholderText: "1405/08/09"
                    color: theme.textPrimary
                    placeholderTextColor: theme.textMuted
                    background: Rectangle { color: theme.bgInput; radius: 6 }
                    Keys.onReturnPressed: dialog.commitSave()
                    Keys.onEnterPressed: dialog.commitSave()
                }
            }

            ColumnLayout {
                Layout.preferredWidth: 90
                spacing: 4
                Text { text: "Start Time"; color: theme.textSecondary; font.pixelSize: 11; font.bold: true }
                TextField {
                    id: startTimeInput
                    Layout.fillWidth: true
                    placeholderText: "09:00"
                    color: theme.textPrimary
                    placeholderTextColor: theme.textMuted
                    background: Rectangle { color: theme.bgInput; radius: 6 }
                    Keys.onReturnPressed: dialog.commitSave()
                    Keys.onEnterPressed: dialog.commitSave()
                }
            }

            ColumnLayout {
                Layout.preferredWidth: 80
                spacing: 4
                Text { text: "Duration (h)"; color: theme.textSecondary; font.pixelSize: 11; font.bold: true }
                TextField {
                    id: durationInput
                    Layout.fillWidth: true
                    placeholderText: "1.5"
                    color: theme.textPrimary
                    placeholderTextColor: theme.textMuted
                    background: Rectangle { color: theme.bgInput; radius: 6 }
                    Keys.onReturnPressed: dialog.commitSave()
                    Keys.onEnterPressed: dialog.commitSave()
                }
            }
        }

        Text { text: "Color Accent"; color: theme.textSecondary; font.pixelSize: 11; font.bold: true }
        RowLayout {
            spacing: 12
            Repeater {
                model: ["#ff9f43", "#00d2d3", "#ff6b6b", "#54a0ff", "#a29bfe", "#2ecc71"]
                Rectangle {
                    width: 28; height: 28; radius: 14
                    color: modelData
                    border.color: dialog.selectedColor === modelData ? (theme.isDark ? "white" : "#2f3640") : "transparent"
                    border.width: 2
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: dialog.selectedColor = modelData
                    }
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 4
            Text { text: "Notes (optional)"; color: theme.textSecondary; font.pixelSize: 11; font.bold: true }
            TextArea {
                id: notesInput
                Layout.fillWidth: true
                Layout.fillHeight: true
                placeholderText: "Write details or reminders..."
                color: theme.textPrimary
                placeholderTextColor: theme.textMuted
                wrapMode: Text.WordWrap
                background: Rectangle { color: theme.bgInput; radius: 8 }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignRight
            spacing: 12
            Button {
                text: "Cancel"
                contentItem: Text { text: "Cancel"; color: theme.textSecondary; font.bold: true }
                background: Rectangle { color: "transparent"; radius: 6; border.color: theme.borderLight }
                onClicked: dialog.close()
            }
            Button {
                text: dialog.isEditing ? "Save Changes" : "Create Task"
                contentItem: Text { text: dialog.isEditing ? "Save Changes" : "Create Task"; color: "white"; font.bold: true }
                background: Rectangle {
                    color: theme.accentPurple
                    radius: 6
                }
                onClicked: dialog.commitSave()
            }
        }
    }
}
