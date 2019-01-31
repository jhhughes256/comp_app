// Javascript for d3 object for histogram
// width and height are determined according to the CSS provided to d3
// in this example we have not specifed CSS, so it defaults to "auto"
// x and y refer to coordinates in that space
// the rectangle begins at the x and y coordinates
// x is measured left to right, y is measured top to bottom
// d refers to the data, while i is the index number of the current data point

// Create a variable called barPadding
// this variable will ensure there is space between the histogram bars
var barPadding = 5;

// Create a variable called barWidth
// this will set how wide each of the rectangles that make up the histogram 
//   will be. Here we have taken the width of the workspace and divided it by 
//   the number of datapoints in our dataset
var barWidth = Math.floor(width / data.length);

// Create a variable called hist which will be our histogram of our data
// This will parse the data to hist.enter() below
// The dataset consists of values between 0 and 1.0
var hist = r2d3.svg.selectAll('rect')
  .data(r2d3.data);

// Here we begin to define our histogram, this is done for EACH data point
// Therefore EACH datapoint draws a rectangle
// the rectangle is drawn from left to right and top to bottom
hist.enter()
  .append('rect')
// x is set to the index of the current data point (i) multiplied by the 
//   barWidth variable defined earlier. This ensures the bars don't overlap.
// While d isn't used in the function, it is required to access the index
  .attr('x', function(d, i) { return i * barWidth; })
// y is equal to the height minus d * height of the draw space
// because the rectange is drawn from top to bottom, we set the y coordinate
//   to the top of the histogram. the top of the histogram is equal to the 
//   height of the drawspace minus the height of the rectangle.
  .attr('y', function(d) { return height - d * height; }) 
// the object is as wide and high as the width and height variables
// height is set to the data, as that's how large we want the rectangle to be
  .attr('height', function(d) { return d * height; })
// width is set to the barWidth variable minus the barpadding variable to ensure
//   there are gaps between rectangles
  .attr('width', barWidth - barPadding)
// This makes the rectangles blue
  .attr('fill', 'steelblue');

// Once finished parsing the data we exit the variable
hist.exit().remove();

// Setting a transition for a variable allows the histogram to smoothly 
//   "transition" between states as userinput changes it
// duration changes the speed of this transition
hist.transition()
  .duration(200)
// Here the same logic is repeated for y and height as the values for d are
//   reactive objects in our shiny app.
// x and width are not mentioned here because they are based on the index of
//   the dataset (which doesn't change in this example) and the variables we
//   we define at the start of the script (which are not linked to reactive 
//   objects)
  .attr('y', function(d) { return height - d * height; })
  .attr('height', function(d) { return d * height; });
  
  