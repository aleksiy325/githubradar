<style>
.axis path {
    fill : none;
    stroke: #777;
    shape-rendering: crispEdges;
}

.axis text {
    font-family: Lato;
    font-size : 13px;
}
</style>


<script>
import * as d3 from 'd3';

// const data = {
//     'all': [1,2,3,4,5,45, 65, 65, 34, 34, 76, 34],
//     'owner':[1,2,3,4,5,6,7,7,8,9,22,10]
// };
const data = [{
    "sale": "152",
    "year": "2000"
}, {
    "sale": "189",
    "year": "2002"
}, {
    "sale": "179",
    "year": "2004"
}, {
    "sale": "199",
    "year": "2006"
}, {
    "sale": "134",
    "year": "2008"
}, {
    "sale": "176",
    "year": "2010"
}];

const margins = {
    top : 20,
    right : 20,
    bottom : 20,
    left : 50
};
const width = 960 - margins.left  - margins.right;
const height = 500 - margins.top - margins.bottom;



export default {
  name: 'D3example',
  template: '<div></div>',

  mounted(){

      // Scaling 
      const xScale = d3.scaleLinear().range([0, width]).domain([2000, 2010]);
      const yScale = d3.scaleLinear().range([height , 0]).domain([100,500]);

    var lineGen = d3.line()
    .x(function(d) {
        return xScale(d.year);
    })
    .y(function(d) {
        return yScale(d.sale);
    })
    .curve(d3.curveBasis);
    
      // Create axes
      const xAxis = d3.axisBottom().scale(xScale);
      const yAxis =  d3.axisBottom().scale(yScale);

      const commit_graph = d3.select("body").append('svg')
        .attr('width', width + margins.left + margins.right)
        .attr('height', height + margins.top + margins.bottom)
        .append("g")
        .attr("transform", "translate(" + margins.left + "," + margins.top + ")");
      
      // Add the X Axis
      commit_graph.append("g")
        .attr("transform", "translate(0," + height + ")")
        .call(d3.axisBottom(xScale));

      // Add the Y Axis
      commit_graph.append("g")
        .call(d3.axisLeft(yScale)); 

      // Add data
      commit_graph.append("svg:path")
        .attr('d',lineGen(data))
        .attr('stroke', 'green')
        .attr('stroke-width',2)
        .attr('fill','none');
  },
};
</script>

