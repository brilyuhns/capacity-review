// Predefined color palette
const colorPalette = [
  "#2E86AB", // Blue
  "#A23B72", // Purple
  "#F18F01", // Orange
  "#C73E1D", // Red
  "#3B7A57", // Green
  "#7768AE", // Light Purple
  "#1B998B", // Teal
  "#ED217C", // Pink
  "#2F9599", // Cyan
  "#FF9B71", // Coral
  "#E9B44C", // Gold
  "#50514F", // Dark Gray
];

// Function to get a color from the palette
function getColor(index) {
  return colorPalette[index % colorPalette.length];
}

// Function to get multiple colors
function getColors(count) {
  return Array.from({ length: count }, (_, i) => getColor(i));
}

// Function to generate random colors
function getRandomColor() {
  const letters = "0123456789ABCDEF";
  let color = "#";
  for (let i = 0; i < 6; i++) {
    color += letters[Math.floor(Math.random() * 16)];
  }
  return color;
}

// Function to get multiple random colors
function getRandomColors(count) {
  return Array.from({ length: count }, () => getRandomColor());
}
