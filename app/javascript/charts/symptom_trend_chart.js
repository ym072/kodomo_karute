export function renderSymptomTrendChart(canvas, chartData) {
  if (!canvas) return;

  const existing = Chart.getChart(canvas);
  if (existing) existing.destroy();

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
          borderColor: COLORS.temperature,
          pointBackgroundColor: COLORS.temperature,
          tension: 0.3,
          fill: true,
          backgroundColor: "rgba(167, 91, 138, 0.12)"
        },
        {
          label: "嘔吐",
          data: chartData.vomit,
          yAxisID: "y-count",
          borderColor: COLORS.vomit,
          pointBackgroundColor: COLORS.vomit,
          tension: 0.3,
          fill: true,
          backgroundColor: "rgba(184, 115, 51, 0.15)"
        },
        {
          label: "便",
          data: chartData.stool,
          yAxisID: "y-count",
          borderColor: COLORS.stool,
          pointBackgroundColor: COLORS.stool,
          tension: 0.3,
          fill: true,
          backgroundColor: "rgba(143, 122, 74, 0.15)"
        }
      ]
    },
    options: {
      responsive: true,
      plugins: {
        legend: {
          labels: { color: COLORS.mainText }
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
          title: {
            display: true,
            text: "体温（℃）",
            color: COLORS.mainText
          },
          ticks: { color: COLORS.mainText }
        },
        "y-count": {
          type: "linear",
          position: "right",
          min: 0,
          title: {
            display: true,
            text: "回数",
            color: COLORS.mainText
          },
          ticks: { color: COLORS.mainText },
          grid: { drawOnChartArea: false }
        }
      }
    }
  });
}
