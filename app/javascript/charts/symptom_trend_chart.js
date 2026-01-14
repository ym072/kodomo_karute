export function renderSymptomTrendChart(canvas, chartData) {
  if (!canvas) return;

  const COLORS = {
    mainText: "#da6220",
    grid: "#ede8d1",
    temperature: "#a75b8a",
    vomit: "#b87333",
    stool: "#8f7a4a"
  };

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
          spanGaps: true,
          borderColor: COLORS.temperature,
          pointBackgroundColor: COLORS.temperature,
          pointBorderColor: COLORS.temperature,
          backgroundColor: "transparent",
          tension: 0.3,
          pointRadius: 3,
          fill: true,
          backgroundColor: "rgba(167, 91, 138, 0.12)"
        },
        {
          label: "嘔吐",
          data: chartData.vomit,
          yAxisID: "y-count",
          borderWidth: 2,
          borderColor: COLORS.vomit,
          pointBackgroundColor: COLORS.vomit,
          pointBorderColor: COLORS.vomit,
          backgroundColor: "transparent",
          tension: 0.3,
          pointRadius: 3,
          fill: true,
          backgroundColor: "rgba(184, 115, 51, 0.15)"
        },
        {
          label: "便",
          data: chartData.stool,
          yAxisID: "y-count",
          borderWidth: 2,
          borderColor: COLORS.stool,
          pointBackgroundColor: COLORS.stool,
          pointBorderColor: COLORS.stool,
          backgroundColor: "transparent",
          tension: 0.3,
          pointRadius: 3,
          fill: true,
          backgroundColor: "rgba(143, 122, 74, 0.15)"
        }
      ]
    },
    options: {
      responsive: true,
      plugins: {
        legend: {
          labels: {
            color: COLORS.mainText
          }
        }
      },
      scales: {
        x: {
          ticks: { color: COLORS.mainText },
          grid: { color: COLORS.grid }
        },
        "y-temp": {
          type: "linear",
          position: "left",
          min: 36,
          max: 41,
          ticks: {
            stepSize: 1,
            color: COLORS.mainText,
            callback: (v) => v.toFixed(1)
          },
          grid: { color: COLORS.grid },
          title: {
            display: true,
            text: "体温（℃）",
            color: COLORS.mainText,
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
            stepSize: 1,
            color: COLORS.mainText
          },
          grid: {
            drawOnChartArea: false
          },
          title: {
            display: true,
            text: "回数",
            color: COLORS.mainText,
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
