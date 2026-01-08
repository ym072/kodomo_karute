export function renderSymptomTrendChart(canvas, chartData) {
  if (!canvas) return;

  new Chart(canvas, {
    type: "line",
    data: {
      labels: chartData.labels,
      datasets: [
        {
          label: "体温",
          data: chartData.temperature,
          yAxisID: "y-temp",
          borderWidth: 2,
          spanGaps: true
        },
        {
          label: "嘔吐回数",
          data: chartData.vomit,
          yAxisID: "y-count",
          borderWidth: 2
        },
        {
          label: "便回数",
          data: chartData.stool,
          yAxisID: "y-count",
          borderWidth: 2
        }
      ]
    },
    options: {
      responsive: true,
      scales: {
        "y-temp": {
          type: "linear",
          position: "left",
          min: 36,
          max: 41,
          ticks: {
            stepSize: 1,
            callback: (v) => v.toFixed(1)
          },
          title: {
            display: true,
            text: "体温（℃）",
            rotation: -90,
            padding: {
              top: 10,
              bottom: 10
            }
          }
        },
        "y-count": {
          type: "linear",
          position: "right",
          min: 0,
          ticks: {
            stepSize: 1
          },
          grid: {
            drawOnChartArea: false
          },
          title: {
            display: true,
            text: "回数",
            rotation: 90,
            padding: {
              top: 10,
              bottom: 10
            }
          }
        }
      }
    }
  });
}
