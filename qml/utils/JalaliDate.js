function isLeapJalali(jy) {
    var r = (jy - 474) % 2820;
    if (r < 0) r += 2820;
    return (((r + 474 + 38) * 682) % 2816) < 682;
}

function jalaliMonthDays(jy, jm) {
    if (jm <= 6) return 31;
    if (jm <= 11) return 30;
    return isLeapJalali(jy) ? 30 : 29;
}

function gregorianToJalali(gy, gm, gd) {
    var g_d_m = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
    var gy2 = (gm > 2) ? (gy + 1) : gy;
    var days = 355666 + (365 * gy) + Math.floor((gy2 + 3) / 4) - Math.floor((gy2 + 99) / 100) + Math.floor((gy2 + 399) / 400) + gd + g_d_m[gm - 1];
    var jy = -1595 + (33 * Math.floor(days / 12053));
    days %= 12053;
    jy += 4 * Math.floor(days / 1461);
    days %= 1461;
    if (days > 365) {
        jy += Math.floor((days - 1) / 365);
        days = (days - 1) % 365;
    }
    var jm = (days < 186) ? 1 + Math.floor(days / 31) : 7 + Math.floor((days - 186) / 30);
    var jd = 1 + ((days < 186) ? (days % 31) : ((days - 186) % 30));
    return { jy: jy, jm: jm, jd: jd };
}

function jalaliToGregorian(jy, jm, jd) {
    var sal_a = [0, 31, 31, 31, 31, 31, 31, 30, 30, 30, 30, 30, 29];
    var jy2 = jy + 1595;
    var days = -355668 + (365 * jy2) + Math.floor(jy2 / 33) * 8 + Math.floor(((jy2 % 33) + 3) / 4) + jd;
    for (var i = 1; i < jm; ++i) days += sal_a[i];

    var gy = 400 * Math.floor(days / 146097);
    days %= 146097;
    if (days > 36524) {
        days--;
        gy += 100 * Math.floor(days / 36524);
        days %= 36524;
        if (days >= 365) days++;
    }
    gy += 4 * Math.floor(days / 1461);
    days %= 1461;
    if (days > 365) {
        gy += Math.floor((days - 1) / 365);
        days = (days - 1) % 365;
    }

    var gd_m = [0, 31, ((gy % 4 === 0 && gy % 100 !== 0) || (gy % 400 === 0)) ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    var gm = 0;
    while (gm < 12 && days >= gd_m[gm + 1]) {
        days -= gd_m[++gm];
    }
    // Return standard Date object with JS 0-indexed month (gm)
    return new Date(gy, gm, days + 1);
}

var jalaliMonthNames = [
    "Farvardin", "Ordibehesht", "Khordad",
    "Tir", "Mordad", "Shahrivar",
    "Mehr", "Aban", "Azar",
    "Dey", "Bahman", "Esfand"
];

var gregorianMonthNames = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
];

var jalaliWeekDayNames = [
    "YekShanbe", "DoShanbe", "SeShanbe", "CharShanbe", "PanjShanbe", "Jome", "Shanbe"
];

var gregorianWeekDayNames = [
    "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
];

function getJalaliDateInfo(dateObj) {
    var gy = dateObj.getFullYear();
    var gm = dateObj.getMonth() + 1;
    var gd = dateObj.getDate();
    var j = gregorianToJalali(gy, gm, gd);
    var dayOfWeek = dateObj.getDay();
    var weekDayName = jalaliWeekDayNames[dayOfWeek];
    var monthName = jalaliMonthNames[j.jm - 1];
    return {
        year: j.jy,
        month: j.jm,
        day: j.jd,
        monthName: monthName,
        weekDayName: weekDayName,
        formatted: weekDayName + ", " + j.jd + " " + monthName + " " + j.jy,
        isoDate: j.jy + "/" + (j.jm < 10 ? "0" : "") + j.jm + "/" + (j.jd < 10 ? "0" : "") + j.jd
    };
}

function getGregorianDateInfo(dateObj) {
    var gy = dateObj.getFullYear();
    var gm = dateObj.getMonth() + 1;
    var gd = dateObj.getDate();
    var dayOfWeek = dateObj.getDay();
    var weekDayName = gregorianWeekDayNames[dayOfWeek];
    var monthName = gregorianMonthNames[gm - 1];
    return {
        year: gy,
        month: gm,
        day: gd,
        monthName: monthName,
        weekDayName: weekDayName,
        formatted: weekDayName + ", " + gd + " " + monthName + " " + gy,
        isoDate: gy + "-" + (gm < 10 ? "0" : "") + gm + "-" + (gd < 10 ? "0" : "") + gd
    };
}

function getShamsiDayOfWeekIndex(dateObj) {
    var jsDay = dateObj.getDay();
    return (jsDay + 1) % 7;
}
