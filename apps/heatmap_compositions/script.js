// Javascript for d3 object for histogram

// Set padding, barWidth and proportional max height of histogram
var barPadding = 5;
var barWidth = Math.floor(width / data.length);
var heightScale = 0.9;

// Create picture elements
var hist = r2d3.svg.selectAll("rect")
  .data(r2d3.data);
var htext = r2d3.svg.selectAll("text")
  .data(r2d3.data);
  
// Define histogram column attributes
hist.enter()
  .append("rect")
  .attr("x", function(d, i) { return i * barWidth; })
  .attr("y", function(d) { return height - d.comp * height * heightScale; }) 
  .attr("height", function(d) { return d.comp * height; })
  .attr("width", barWidth - barPadding)
  .attr("fill", "steelblue")
// Turn brown on mouseover
  .on("mouseover", function() {
    d3.select(this)
      .attr("fill", "brown");
  })
// Return to blue when done
  .on("mouseout", function() {
    d3.select(this)
      .attr("fill", "steelblue");
  });
  
hist.exit().remove();

// Define text attributes
htext.enter()
  .append("text")
  .text(function(d) { return d.val + " hours"; })
  .attr("x", function(d, i) { return (i * barWidth + (i + 1) * barWidth) / 2; })
  .attr("y", function(d) { return height - d.comp * height * heightScale - 16; })
  .attr("text-anchor", "middle")
  .attr("font-size", "20px")
  .attr("font-weight", "700")
  .attr("fill", "black");
  
htext.exit().remove();

//  Create transitions for histogram and text
hist.transition()
  .duration(500)
  .attr("y", function(d) { return height - d.comp * height * heightScale; })
  .attr("height", function(d) { return d.comp * height; });
  
htext.transition()
  .duration(500)
  .text(function(d) { return d.val + " hours"; })
  .attr("y", function(d) {return height - d.comp * height * heightScale - 16});
  