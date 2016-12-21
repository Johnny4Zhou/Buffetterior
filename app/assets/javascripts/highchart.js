

var high = JSON.parse(gon.highdata);
var symbol = gon.symbol;


var i;
for (i in high) {
    high[i][0] = Date.parse(high[i][0]);
}

$(function () {


        // Create the chart
        Highcharts.stockChart('high-chart', {


            rangeSelector: {
                selected: 1
            },

            title: {
                text: symbol + ' Stock Price'
            },

            series: [{
                name: symbol + ' Stock Price',
                data: high,
                type: 'area',
                threshold: null,
                tooltip: {
                    valueDecimals: 2
                },
                fillColor: {
                    linearGradient: {
                        x1: 0,
                        y1: 0,
                        x2: 0,
                        y2: 1
                    },
                    stops: [
                        [0, Highcharts.getOptions().colors[0]],
                        [1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
                    ]
                }
            }]
        });

});

Morris.Donut({
  element: 'morris-donut-chart',
  data: gon.donuts
});




$(document).ready(function() {


});
