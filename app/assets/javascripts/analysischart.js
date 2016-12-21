var revenue = gon.revenue;
var earning = gon.earning;
var eps = gon.eps;
var pe = gon.pe;

var symbol = gon.symbol;

$(function () {
    Highcharts.chart('highrevenue', {
        title: {
            text: 'Revenue ',
            x: -20 //center
        },
        subtitle: {
            text: 'Source: gurufocus.com',
            x: -20
        },
        xAxis: {
            type: 'category'
        },
        yAxis: {
            title: {
                text: 'Revenue (M)'
            },
            plotLines: [{
                value: 0,
                width: 1,
                color: '#808080'
            }]
        },
        tooltip: {
            valueSuffix: 'M'
        },
        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'middle',
            borderWidth: 0
        },
        series: [{
            name: symbol,

            data: revenue
        }]
    });
});

$(function () {
    Highcharts.chart('highearning', {
        title: {
            text: 'Earning ',
            x: -20 //center
        },
        subtitle: {
            text: 'Source: gurufocus.com',
            x: -20
        },
        xAxis: {
            type: 'category'
        },
        yAxis: {
            title: {
                text: 'Earning (M)'
            },
            plotLines: [{
                value: 0,
                width: 1,
                color: '#808080'
            }]
        },
        tooltip: {
            valueSuffix: 'M'
        },
        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'middle',
            borderWidth: 0
        },
        series: [{
            name: symbol,

            data: earning
        }]
    });
});

$(function () {
    Highcharts.chart('higheps', {
        title: {
            text: 'Earning Per Share ',
            x: -20 //center
        },
        subtitle: {
            text: 'Source: gurufocus.com',
            x: -20
        },
        xAxis: {
            type: 'category'
        },
        yAxis: {
            title: {
                text: 'Earning Per Share'
            },
            plotLines: [{
                value: 0,
                width: 1,
                color: '#808080'
            }]
        },
        tooltip: {
            valueSuffix: '$'
        },
        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'middle',
            borderWidth: 0
        },
        series: [{
            name: symbol,

            data: eps
        }]
    });
});

$(function () {
    Highcharts.chart('highpe', {
        title: {
            text: 'Price Earning Ratio',
            x: -20 //center
        },
        subtitle: {
            text: 'Source: gurufocus.com',
            x: -20
        },
        xAxis: {
            type: 'category'
        },
        yAxis: {
            title: {
                text: 'Price Earning Ratio'
            },
            plotLines: [{
                value: 0,
                width: 1,
                color: '#808080'
            }]
        },
        tooltip: {
            valueSuffix: ''
        },
        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'middle',
            borderWidth: 0
        },
        series: [{
            name: symbol,

            data: pe
        }]
    });
});
