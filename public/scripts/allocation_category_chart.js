// Get the canvas element
const allocation_category_ctx = document
  .getElementById("allocationCategoryChart")
  .getContext("2d");
console.log("allocationCategoryData in scripts/allocation_category_chart.js");
console.log(allocationCategoryData);
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

const all_cat_labels = allocationCategoryData.labels;
const all_cat_datasets = allocationCategoryData.data.map((item) => {
  return {
    type: "bar",
    label: item.label,
    data: item.data,
    backgroundColor: getColor(item.index),
    borderWidth: 1,
    stack: "Stack 0",
    order: 1,
  };
});

console.log("all_cat_labels");
console.log(all_cat_labels);
console.log("all_cat_datasets");
console.log(all_cat_datasets);

//Create the chart configuration
const all_cat_chart_config = {
  type: "bar", // This creates the bar chart base
  data: {
    labels: all_cat_labels,
    datasets: all_cat_datasets,
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
const allocation_category_chart = new Chart(
  allocation_category_ctx,
  all_cat_chart_config
);
