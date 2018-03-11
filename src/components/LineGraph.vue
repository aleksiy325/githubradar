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





export default {
  name: 'LineGraph',
  template: '<div></div>',

  props: {
      lineData: {
          type: Array,
          required: true,
          default: () => ({})
      },
      totalHeight : {
          type: Number,
          default: 300
      },
      totalWidth : {
          type: Number,
          default: 420
      }
  },

  created(){
      this.setScale();
      this.prepData();
  },

  data(){
      return{
          minX : 0,
          maxX : 0,
          minY : 0,
          maxY : 0,
          sanitizedData : [],
        //   totalWidth : 0,
        //   totalHeight :0,
          margins : {
            top : 20,
            right : 20,
            bottom : 20,
            left : 50
          }          

      }
  },

  methods: {
      setScale(){
          console.log("Raech");
          console.log(this.lineData);
          this.minX = 0;
          this.maxX = this.lineData.length;
          this.minY = Math.min(...this.lineData.map(o => o));
          this.maxY = Math.max(...this.lineData.map(o => o));
      },
      prepData(){
          this.sanitizedData =  []
          for (var index = 0; index < this.lineData.length; index++) {
            var entry = { 'xVal' : index, 'yVal' : this.lineData[index] }
            this.sanitizedData.push(entry);
          }
      }
  },

  mounted(){
    var width = this.totalWidth - this.margins.left  - this.margins.right;
    var height = this.totalHeight - this.margins.top - this.margins.bottom;      

    // Scaling 
    const xScale = d3.scaleLinear().range([0, width]).domain([this.minX, this.maxX]);
    const yScale = d3.scaleLinear().range([height , 0]).domain([this.minY,this.maxY]);

    var lineGen = d3.line()
    .x(function(d) {
        return xScale(d.xVal);
    })
    .y(function(d) {
        return yScale(d.yVal);
    })
    .curve(d3.curveBasis);
    
      // Create axes
      const xAxis = d3.axisBottom().scale(xScale);
      const yAxis =  d3.axisBottom().scale(yScale);

      const commit_graph = d3.select("body").append('svg')
        .attr('width', width + this.margins.left + this.margins.right)
        .attr('height', height + this.margins.top + this.margins.bottom)
        .append("g")
        .attr("transform", "translate(" + this.margins.left + "," + this.margins.top + ")");
      
      // Add the X Axis
      commit_graph.append("g")
        .attr("transform", "translate(0," + height + ")")
        .call(d3.axisBottom(xScale));

      // Add the Y Axis
      commit_graph.append("g")
        .call(d3.axisLeft(yScale)); 

      // Add data

      commit_graph.append("svg:path")
        .attr('d',lineGen(this.sanitizedData))
        .attr('stroke', 'green')
        .attr('stroke-width',2)
        .attr('fill','none');
  },
};
</script>

