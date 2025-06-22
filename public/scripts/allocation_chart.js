// Get the canvas element
const allocation_ctx = document
  .getElementById("allocationChart")
  .getContext("2d");

// Create Project Allocations Chart
new Chart(allocation_ctx, {
  type: "line",
  data: {
    labels: allocationData.labels,
    datasets: allocationData.datasets.map((dataset) => ({
      label: dataset.label,
      data: dataset.data,
      borderWidth: 2,
      fill: false,
      tension: 0.1,
    })),
  },
  options: {
    responsive: true,
    plugins: {
      title: { display: false },
      legend: { position: "top" },
    },
    scales: {
      y: {
        beginAtZero: true,
        max: 100,
        title: {
          display: true,
          text: "Allocation %",
        },
      },
    },
  },
});
