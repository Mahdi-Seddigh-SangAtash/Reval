import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Item {
    id: allTasksView
    property var tasks: []
    signal editTask(var taskData)

    property string sortOrder: "newest"

    function getFilteredTasks() {
        var list = allTasksView.tasks.slice();
        var query = searchField.text.trim().toLowerCase();

        // Strict search filter
        if (query.length > 0) {
            list = list.filter(function(t) {
                var title = (t.title || "").toLowerCase();
                var notes = (t.notes || "").toLowerCase();
                return title.indexOf(query) !== -1 || notes.indexOf(query) !== -1;
            });
        }

        // From / To date range filter
        var fromVal = fromField.text.trim();
        var toVal = toField.text.trim();
        if (fromVal.length > 0) {
            list = list.filter(function(t) { return !t.date || t.date >= fromVal; });
        }
        if (toVal.length > 0) {
            list = list.filter(function(t) { return !t.date || t.date <= toVal; });
        }

        // Sorting
        if (sortOrder === "newest") {
            list.sort(function(a, b) { return (b.date || "").localeCompare(a.date || ""); });
        } else if (sortOrder === "oldest") {
            list.sort(function(a, b) { return (a.date || "").localeCompare(b.date || ""); });
        } else if (sortOrder === "title") {
            list.sort(function(a, b) { return (a.title || "").localeCompare(b.title || ""); });
        }

        return list;
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 22
        spacing: 16

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "All Of It!"
            color: theme.textPrimary
            font.pixelSize: 34
            font.bold: true
        }

        // Filter / Search Row
        RowLayout {
            spacing: 16
            Layout.alignment: Qt.AlignHCenter

            // Search Bar
            RowLayout {
                spacing: 8
                Text { text: "Search:"; color: theme.textPrimary; font.pixelSize: 14 }
                TextField {
                    id: searchField
                    Layout.preferredWidth: 190
                    placeholderText: "Search title or notes..."
                    color: theme.textPrimary
                    placeholderTextColor: theme.textMuted
                    background: Rectangle { color: theme.bgInput; radius: 6; border.color: theme.borderLight }
                }
            }

            // From Date Filter
            RowLayout {
                spacing: 6
                Text { text: "From:"; color: theme.textSecondary; font.pixelSize: 13 }
                TextField {
                    id: fromField
                    Layout.preferredWidth: 110
                    placeholderText: "1405/01/01"
                    color: theme.textPrimary
                    placeholderTextColor: theme.textMuted
                    background: Rectangle { color: theme.bgInput; radius: 6; border.color: theme.borderLight }
                }
            }

            // To Date Filter
            RowLayout {
                spacing: 6
                Text { text: "To:"; color: theme.textSecondary; font.pixelSize: 13 }
                TextField {
                    id: toField
                    Layout.preferredWidth: 110
                    placeholderText: "1405/12/29"
                    color: theme.textPrimary
                    placeholderTextColor: theme.textMuted
                    background: Rectangle { color: theme.bgInput; radius: 6; border.color: theme.borderLight }
                }
            }

            // Sort Toggle
            Rectangle {
                width: 110; height: 34; radius: 6
                color: theme.bgRailBtn
                border.color: theme.borderLight
                Text {
                    anchors.centerIn: parent
                    text: allTasksView.sortOrder === "newest" ? "Sort: Newest" : (allTasksView.sortOrder === "oldest" ? "Sort: Oldest" : "Sort: A-Z")
                    color: theme.textPrimary
                    font.pixelSize: 11
                    font.bold: true
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (allTasksView.sortOrder === "newest") allTasksView.sortOrder = "oldest";
                        else if (allTasksView.sortOrder === "oldest") allTasksView.sortOrder = "title";
                        else allTasksView.sortOrder = "newest";
                    }
                }
            }
        }

        // Table Container
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: theme.bgSurface
            radius: 10
            border.color: theme.border

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 4

                // RIGID HEADER COLUMNS: Perfectly matching delegate widths
                RowLayout {
                    Layout.fillWidth: true
                    height: 32
                    spacing: 0

                    Item {
                        Layout.preferredWidth: 240
                        height: parent.height
                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 12
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Name"
                            color: theme.textSecondary
                            font.bold: true
                            font.pixelSize: 13
                        }
                    }

                    Item {
                        Layout.preferredWidth: 200
                        height: parent.height
                        Text {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Date / Time"
                            color: theme.textSecondary
                            font.bold: true
                            font.pixelSize: 13
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                        height: parent.height
                        Text {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Note"
                            color: theme.textSecondary
                            font.bold: true
                            font.pixelSize: 13
                        }
                    }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: theme.borderLight }

                // LIST VIEW DELEGATES: Using the exact same rigid column geometry
                ListView {
                    id: taskListView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: allTasksView.getFilteredTasks()
                    clip: true
                    spacing: 4

                    delegate: Rectangle {
                        width: taskListView.width
                        height: 44
                        color: index % 2 === 0 ? theme.bgCard : "transparent"
                        radius: 6

                        RowLayout {
                            anchors.fill: parent
                            spacing: 0

                            // 1. Column Name (240px rigid)
                            Item {
                                Layout.preferredWidth: 240
                                height: parent.height

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 12
                                    anchors.rightMargin: 12
                                    spacing: 10

                                    Rectangle {
                                        width: 10; height: 10; radius: 5
                                        color: modelData.color || "#ff9f43"
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        text: modelData.title || ""
                                        color: theme.textPrimary
                                        font.bold: true
                                        font.pixelSize: 13
                                        elide: Text.ElideRight
                                    }
                                }
                            }

                            // 2. Column Date / Time (200px rigid)
                            Item {
                                Layout.preferredWidth: 200
                                height: parent.height

                                Text {
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: (modelData.date || "") + (modelData.startHour !== undefined ? " (" + Math.floor(modelData.startHour) + ":" + (Math.round((modelData.startHour % 1)*60) < 10 ? "0" : "") + Math.round((modelData.startHour % 1)*60) + ")" : "")
                                    color: theme.textSecondary
                                    font.pixelSize: 12
                                }
                            }

                            // 3. Column Note (remaining flexible space)
                            Item {
                                Layout.fillWidth: true
                                height: parent.height

                                Text {
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.rightMargin: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: modelData.notes || ""
                                    color: theme.textPrimary
                                    font.pixelSize: 12
                                    elide: Text.ElideRight
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onDoubleClicked: allTasksView.editTask(modelData)
                        }
                    }
                }
            }
        }
    }
}
