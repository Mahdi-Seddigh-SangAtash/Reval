import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "../utils/JalaliDate.js" as Jalali

Item {
    id: monthView
    signal navigateToDate(var targetDate)

    property bool isShamsi: true
    property int currentShamsiYear: 1405
    property int currentShamsiMonth: 8      // Aban
    property int currentGregorianYear: 2026
    property int currentGregorianMonth: 11  // November

    property int selectedDayNumber: 14
    property var daysMatrix: []

    readonly property var shamsiWeekDays: [
        "Shanbe", "YekShanbe", "DoShanbe", "SeShanbe", "CharShanbe", "PanjShanbe", "Jome"
    ]
    readonly property var gregorianWeekDays: [
        "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"
    ]

    function initFromCurrentDate() {
        var now = new Date();
        var jInfo = Jalali.getJalaliDateInfo(now);
        currentShamsiYear = jInfo.year;
        currentShamsiMonth = jInfo.month;
        currentGregorianYear = now.getFullYear();
        currentGregorianMonth = now.getMonth() + 1;
        selectedDayNumber = jInfo.day;
        rebuildMonthGrid();
    }

    function rebuildMonthGrid() {
        var cells = [];
        var now = new Date();

        if (isShamsi) {
            var totalDays = Jalali.jalaliMonthDays(currentShamsiYear, currentShamsiMonth);
            var firstDayDate = Jalali.jalaliToGregorian(currentShamsiYear, currentShamsiMonth, 1);
            var startCol = Jalali.getShamsiDayOfWeekIndex(firstDayDate); // 0 = Shanbe ... 6 = Jome

            var todayJalali = Jalali.getJalaliDateInfo(now);
            var isCurrentMonth = (todayJalali.year === currentShamsiYear && todayJalali.month === currentShamsiMonth);

            for (var i = 0; i < 42; i++) {
                var dayNum = i - startCol + 1;
                if (dayNum >= 1 && dayNum <= totalDays) {
                    var cellDate = Jalali.jalaliToGregorian(currentShamsiYear, currentShamsiMonth, dayNum);
                    cells.push({
                        dayNumber: dayNum,
                        isValid: true,
                        isToday: isCurrentMonth && (dayNum === todayJalali.day),
                        dateObj: cellDate
                    });
                } else {
                    cells.push({ dayNumber: 0, isValid: false, isToday: false, dateObj: null });
                }
            }
        } else {
            var daysInMonth = new Date(currentGregorianYear, currentGregorianMonth, 0).getDate();
            var firstGDate = new Date(currentGregorianYear, currentGregorianMonth - 1, 1);
            var startGCol = firstGDate.getDay(); // 0 = Sun ... 6 = Sat

            var isCurrentGMonth = (now.getFullYear() === currentGregorianYear && (now.getMonth() + 1) === currentGregorianMonth);

            for (var j = 0; j < 42; j++) {
                var gDayNum = j - startGCol + 1;
                if (gDayNum >= 1 && gDayNum <= daysInMonth) {
                    var gCellDate = new Date(currentGregorianYear, currentGregorianMonth - 1, gDayNum);
                    cells.push({
                        dayNumber: gDayNum,
                        isValid: true,
                        isToday: isCurrentGMonth && (gDayNum === now.getDate()),
                        dateObj: gCellDate
                    });
                } else {
                    cells.push({ dayNumber: 0, isValid: false, isToday: false, dateObj: null });
                }
            }
        }
        daysMatrix = cells;
    }

    function prevMonth() {
        if (isShamsi) {
            currentShamsiMonth--;
            if (currentShamsiMonth < 1) {
                currentShamsiMonth = 12;
                currentShamsiYear--;
            }
        } else {
            currentGregorianMonth--;
            if (currentGregorianMonth < 1) {
                currentGregorianMonth = 12;
                currentGregorianYear--;
            }
        }
        rebuildMonthGrid();
    }

    function nextMonth() {
        if (isShamsi) {
            currentShamsiMonth++;
            if (currentShamsiMonth > 12) {
                currentShamsiMonth = 1;
                currentShamsiYear++;
            }
        } else {
            currentGregorianMonth++;
            if (currentGregorianMonth > 12) {
                currentGregorianMonth = 1;
                currentGregorianYear++;
            }
        }
        rebuildMonthGrid();
    }

    Component.onCompleted: initFromCurrentDate()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16

        // Calendar Header & Switcher
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 4

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: monthView.isShamsi ? monthView.currentShamsiYear.toString() : monthView.currentGregorianYear.toString()
                color: theme.textSecondary
                font.pixelSize: 16
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: monthView.isShamsi ? Jalali.jalaliMonthNames[monthView.currentShamsiMonth - 1] : Jalali.gregorianMonthNames[monthView.currentGregorianMonth - 1]
                color: theme.textPrimary
                font.pixelSize: 36
                font.bold: true
            }

            RowLayout {
                spacing: 24
                Layout.alignment: Qt.AlignHCenter

                Text {
                    text: "< Prev"
                    color: theme.textSecondary
                    font.pixelSize: 15
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: monthView.prevMonth()
                    }
                }

                Rectangle {
                    width: 116; height: 32; radius: 16
                    color: theme.bgInput
                    border.color: theme.borderLight

                    Text {
                        anchors.centerIn: parent
                        text: monthView.isShamsi ? "▼ Shamsi" : "▼ Gregorian"
                        color: theme.accentTeal
                        font.pixelSize: 13
                        font.bold: true
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            monthView.isShamsi = !monthView.isShamsi;
                            monthView.rebuildMonthGrid();
                        }
                    }
                }

                Text {
                    text: "Next >"
                    color: theme.textSecondary
                    font.pixelSize: 15
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: monthView.nextMonth()
                    }
                }
            }
        }

        // Responsive Calendar Sheet (Expands comfortably when window maximizes)
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: 920
            Layout.maximumHeight: 560
            color: theme.bgSurface
            radius: 14
            border.color: theme.border
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 10

                // Weekday Headers
                RowLayout {
                    Layout.fillWidth: true
                    height: 24
                    Repeater {
                        model: monthView.isShamsi ? monthView.shamsiWeekDays : monthView.gregorianWeekDays
                        Item {
                            Layout.fillWidth: true
                            height: parent.height
                            Text {
                                anchors.centerIn: parent
                                text: modelData
                                color: theme.textSecondary
                                font.pixelSize: 12
                                font.bold: true
                            }
                        }
                    }
                }

                // 42-cell Dynamic Grid (6 rows x 7 cols)
                GridLayout {
                    columns: 7
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    rowSpacing: 6
                    columnSpacing: 6

                    Repeater {
                        model: monthView.daysMatrix
                        Rectangle {
                            readonly property var cellInfo: modelData
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 8

                            color: cellInfo.isToday ? theme.accentCyan : (cellInfo.isValid ? theme.bgCard : "transparent")
                            border.color: (cellInfo.isValid && cellInfo.dayNumber === monthView.selectedDayNumber) ? theme.accentTeal : theme.borderLight
                            border.width: (cellInfo.isValid && cellInfo.dayNumber === monthView.selectedDayNumber) ? 2 : 1

                            Text {
                                anchors.centerIn: parent
                                visible: cellInfo.isValid
                                text: cellInfo.isValid ? cellInfo.dayNumber.toString() : ""
                                color: cellInfo.isToday ? "white" : theme.textPrimary
                                font.bold: true
                                font.pixelSize: 15
                            }

                            MouseArea {
                                anchors.fill: parent
                                enabled: cellInfo.isValid
                                cursorShape: Qt.PointingHandCursor
                                onClicked: monthView.selectedDayNumber = cellInfo.dayNumber
                                onDoubleClicked: {
                                    if (cellInfo.dateObj) {
                                        monthView.navigateToDate(cellInfo.dateObj);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}