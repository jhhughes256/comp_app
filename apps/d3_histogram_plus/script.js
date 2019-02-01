// Javascript for d3 object for histogram
// Look at d3_histogram app for extensive comments on how this d3 object works

var barPadding = 5;
var barWidth = Math.floor(width / data.length);

// Adding a scaling factor to height so there is space above the histogram
var heightScale = 0.9;

var hist = r2d3.svg.selectAll("rect")
  .data(r2d3.data);
  
var htext = r2d3.svg.selectAll("text")
  .data(r2d3.data);
  
// When referring to our data in functions you will notice we now call it 
//   using "d.prop". This is because our data has more than two groups of
//   objects: val and prop, which just happen to be the column names of the
//   data.frame made in our reactive dataset in server.R
hist.enter()
  .append("rect")
  .attr("x", function(d, i) { return i * barWidth; })
  .attr("y", function(d) { return height - d.prop * height * heightScale; }) 
  .attr("height", function(d) { return d.prop * height; })
  .attr("width", barWidth - barPadding)
// This makes the rectangles blue
  .attr("fill", "steelblue")
  
// But this makes the rectangles brown when the mouse hovers over them
// .on() is like observe in Shiny, but it waits for a specific command like 
//   the mouse hovering over an the rectangle, a mouse click etc.
// d3.select() is how we determine what is going to be changed once the
//   condition is met
  .on("mouseover", function() {
    d3.select(this)
      .attr("fill", "brown");
  })
// This cleans up our mess, as without a mouseout condition, all our rectangles
//   would stay brown after the mouse hovers over them for the first time.
  .on("mouseout", function() {
    d3.select(this)
      .attr("fill", "steelblue");
  })
  
// But what if we want to send data back to Shiny?
// So on a click lets make shiny reveal what the value of the number is
// Well first we make an attribute that is equal to the data (strange I know)
// This is done within the .on() function so that it recalculates whenever
//   the user clicks. If it was outside, it would only be equal to the initial
//   value!!!
// Then we look out for any clicks that occur on the plot
// Shiny.setInputValue is the function that will send things back to shiny
// The first argument is the id which Shiny will recognise
// The second argument is the data that we want to send back
// The third argument sets the priority to event, so that Shiny recognises it
//   as an event that it needs to act upon
  .on("click", function() {
    d3.select(this)
      .attr("d", function(d) {return d.val; });
    Shiny.setInputValue(
      "bar_clicked",
      d3.select(this).attr("d"),
      {priority: "event"}
    );
  });
  
hist.exit().remove();

// New element for our image, new variable, new .enter() new .append()!
// Going to make the x variable equal to the mean of the index and index plus 
//   1 starting points. This results in the text placed in the centre of the 
//   column.
// The y variable is placed 16 units above (therefore -16 units) the column
htext.enter()
  .append("text")
  .text(function(d) { return d.val + " cats"; })
  .attr("x", function(d, i) { return (i * barWidth + (i + 1) * barWidth) / 2; })
  .attr("y", function(d) { return height - d.prop * height * heightScale - 16; })
  .attr("text-anchor", "middle")
  .attr("font-size", "20px")
  .attr("font-weight", "700")
  .attr("fill", "black");
  
htext.exit().remove();

hist.transition()
  .duration(500)
  .attr("y", function(d) { return height - d.prop * height * heightScale; })
  .attr("height", function(d) { return d.prop * height; })
  .text(function(d) { return d.val + " cats"; });
  
// Separate transition for the text
htext.transition()
  .duration(500)
  .text(function(d) { return d.val + " cats"; })
  .attr("y", function(d) {return height - d.prop * height * heightScale - 16});
  