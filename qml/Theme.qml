import QtQuick 2.15

QtObject {
    id: theme
    property bool isDark: true

    // Backgrounds
    readonly property color bgMain: isDark ? "#070710" : "#d9dade"       // Soft silver
    readonly property color bgSurface: isDark ? "#0e0e1a" : "#cdd1d8"    // Muted light grey sheet
    readonly property color bgCard: isDark ? "#141424" : "#bdc2cb"       // Neutral card tone
    readonly property color bgInput: isDark ? "#1e1e30" : "#b5bac4"      // Soft slate input
    readonly property color bgRail: isDark ? "#0a0a14" : "#c4c8d0"
    readonly property color bgRailBtn: isDark ? "#1c1c2e" : "#b0b6c1"

    // Borders
    readonly property color border: isDark ? "#1c1c2e" : "#9ea5b1"
    readonly property color borderLight: isDark ? "#2a2a45" : "#a8afbc"

    // Text colors
    readonly property color textPrimary: isDark ? "#ffffff" : "#1e252d"
    readonly property color textSecondary: isDark ? "#8395a7" : "#4e5968"
    readonly property color textMuted: isDark ? "#57606f" : "#727d8d"

    // Neon & Pastel accents remain vivid in both modes
    readonly property color accentTeal: "#00d2d3"
    readonly property color accentPurple: "#9C42A6"
    readonly property color accentBlue: "#3867d6"
    readonly property color accentCyan: "#00a8ff"
    readonly property color accentGreen: "#2ecc71"
    readonly property color accentRed: "#e74c3c"
}