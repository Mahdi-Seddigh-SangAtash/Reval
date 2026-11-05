import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"
import "views"
import "utils/JalaliDate.js" as Jalali

ApplicationWindow {
    id: window
    width: 1100
    height: 680
    minimumWidth: 850
    minimumHeight: 520
    visible: true
    title: "Reval"
    color: theme.bgMain

    Theme { id: theme }

    // Initial clean mock tasks
    property var taskList: [
        {
            id: 101,
            title: "Class",
            notes: "Room 304 • Algorithms & Complexity",
            date: Jalali.getJalaliDateInfo(new Date()).isoDate,
            startHour: 9.0,
            duration: 1.75,
            color: "#f1c40f"
        },
        {
            id: 102,
            title: "Meeting",
            notes: "Review ICPC team practice schedule and timeline tasks.",
            date: Jalali.getJalaliDateInfo(new Date()).isoDate,
            startHour: 12.5,
            duration: 2.25,
            color: "#e67e22"
        },
        {
            id: 103,
            title: "Gym",
            notes: "Leg day & 20 min cardio",
            date: Jalali.getJalaliDateInfo(new Date()).isoDate,
            startHour: 7.0,
            duration: 1.5,
            color: "#00a8ff"
        },
        {
            id: 104,
            title: "Code Sprint",
            notes: "Push latest Reval UI branch to repository",
            date: Jalali.getJalaliDateInfo(new Date()).isoDate,
            startHour: 18.0,
            duration: 2.5,
            color: "#2ecc71"
        }
    ]

    function saveTask(task) {
        var list = taskList.slice();
        var index = list.findIndex(function(t) { return t.id === task.id; });
        if (index >= 0) {
            list[index] = task;
        } else {
            list.push(task);
        }
        taskList = list;
    }

    function deleteTask(taskId) {
        taskList = taskList.filter(function(t) { return t.id !== taskId; });
    }

    TaskDialog {
        id: taskModal
        anchors.centerIn: parent
        onTaskSaved: function(task) { window.saveTask(task); }
        onTaskDeleted: function(taskId) { window.deleteTask(taskId); }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        NavRail {
            id: rail
            Layout.fillHeight: true
            visible: stackView.depth > 1
            onNavigate: function(page) {
                if (page === "hub") stackView.pop(null);
                else if (page === "add") taskModal.openForNew();
                else if (page === "day") stackView.replace(dayComponent);
                else if (page === "week") stackView.replace(weekComponent);
                else if (page === "month") stackView.replace(monthComponent);
                else if (page === "all") stackView.replace(allComponent);
            }
        }

        StackView {
            id: stackView
            Layout.fillWidth: true
            Layout.fillHeight: true

            initialItem: HubView {
                onOpenView: function(viewName) {
                    if (viewName === "day") stackView.push(dayComponent);
                    else if (viewName === "week") stackView.push(weekComponent);
                    else if (viewName === "month") stackView.push(monthComponent);
                    else if (viewName === "all") stackView.push(allComponent);
                }
                onOpenAdd: taskModal.openForNew()
            }
        }
    }

    Component {
        id: dayComponent
        DayView {
            tasks: window.taskList
            onEditTask: function(task) { taskModal.openForEdit(task); }
        }
    }

    Component {
        id: weekComponent
        WeekView {
            tasks: window.taskList
            onEditTask: function(task) { taskModal.openForEdit(task); }
        }
    }

    Component {
        id: monthComponent
        MonthView {
            onNavigateToDate: function(targetDate) {
                var dayItem = dayComponent.createObject(null, { initialCustomDate: targetDate });
                stackView.replace(dayItem);
            }
        }
    }

    Component {
        id: allComponent
        AllTasksView {
            tasks: window.taskList
            onEditTask: function(task) { taskModal.openForEdit(task); }
        }
    }
}
