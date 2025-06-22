// Get the canvas element
const ctx = document.getElementById("capacityChart").getContext("2d");
console.log("capacity_data in scripts/capacity_chart.js");
console.log(capacity_data);
console.log("done");

// const capacityData = {
//   labels: ["Dec", "Jan", "Feb"],
//   data: {
//     capacityExcludingHolidays: [500, 178, 200],
//     netCapacity: [400, 157.5, 182.5],
//     leaves: [50, 20.5, 17.5],
//     unplannedLeaves: [50, 1, 4],
//   },
// };

const labels = capacity_data.labels;

// Create the chart configuration
const config = {
  type: "bar", // This creates the bar chart base
  data: {
    labels: labels,
    datasets: [
      // Line dataset for "Capacity excluding Public Holidays"
      {
        type: "line",
        label: "Capacity excluding Public Holidays",
        data: capacity_data.data.capacityExcludingHolidays,
        borderColor: "rgb(79, 129, 242)",
        backgroundColor: "rgba(79, 129, 242, 0.2)",
        borderWidth: 2,
        fill: false,
        tension: 0.1,
        order: 0, // Lower order to display on top
      },
      // "Net Capacity" bars (green)
      {
        type: "bar",
        label: "Net Capacity",
        data: capacity_data.data.netCapacity,
        backgroundColor: "rgb(111, 174, 92)",
        stack: "Stack 0",
        order: 1,
      },
      // "Leaves" bars (yellow)
      {
        type: "bar",
        label: "Leaves",
        data: capacity_data.data.leaves,
        backgroundColor: "rgb(236, 198, 75)",
        stack: "Stack 0",
        order: 1,
      },
      // "Unplanned Leaves" bars (red)
      {
        type: "bar",
        label: "Unplanned Leaves",
        data: capacity_data.data.unplannedLeaves,
        backgroundColor: "rgb(233, 75, 67)",
        stack: "Stack 0",
        order: 1,
      },
    ],
  },
  options: {
    responsive: true,
    plugins: {
      title: {
        display: true,
        text: "Capacity and Leaves Chart",
      },
      legend: {
        position: "top",
      },
    },
    scales: {
      x: {
        stacked: true,
        grid: {
          color: "rgba(200, 200, 200, 0.3)",
        },
      },
      y: {
        stacked: true,
        min: 0,
        ticks: {
          stepSize: 25,
        },
        grid: {
          color: "rgba(200, 200, 200, 0.3)",
        },
      },
    },
  },
};

// Create the chart
const myChart = new Chart(ctx, config);
