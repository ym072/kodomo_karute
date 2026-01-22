import { renderSymptomTrendChart } from "charts/symptom_trend_chart";

const drawIfReady = () => {
  const canvas = document.getElementById("symptomTrendChart");
  if (!canvas) return;

  let tries = 0;
  const maxTries = 20;

  const tick = () => {
    tries += 1;

    const w = canvas.offsetWidth;
    const h = canvas.offsetHeight;

    if (w > 0 && h > 0 && canvas.isConnected) {
      try {
        const data = JSON.parse(canvas.dataset.chart || "{}");
        renderSymptomTrendChart(canvas, data);
      } catch (e) {
        console.error("chart data parse error:", e, canvas.dataset.chart);
      }
      return;
    }

    if (tries < maxTries) setTimeout(tick, 50);
  };

  tick();
};

document.addEventListener("turbo:load", drawIfReady);
