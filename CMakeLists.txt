cmake_minimum_required(VERSION 3.16)
project(Reval LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 REQUIRED COMPONENTS Quick QuickControls2 Sql)

qt_standard_project_setup()

qt_add_executable(appReval
    WIN32
    src/main.cpp
)

qt_add_qml_module(appReval
    URI Reval
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/Theme.qml
        qml/components/NavRail.qml
        qml/components/TaskDialog.qml
        qml/utils/JalaliDate.js
        qml/views/HubView.qml
        qml/views/DayView.qml
        qml/views/WeekView.qml
        qml/views/MonthView.qml
        qml/views/AllTasksView.qml
    RESOURCES
        resources/reval.png
)

target_link_libraries(appReval
    PRIVATE
        Qt6::Quick
        Qt6::QuickControls2
        Qt6::Sql
)
