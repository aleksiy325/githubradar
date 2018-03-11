
<script>
import { Line, mixins } from 'vue-chartjs'
const { reactiveProp } = mixins

export default {
  extends: Line,
  mixins: [reactiveProp],
  // props: ["chartData", "options"],
  data () {
    return {
    }
  },
  props: {
    chartData: {
      type: Object,
      required: true
    },
    options: {
      type: Object,
      required: true,
      default: {responsive: false, maintainAspectRatio: false}
    }

  },
  mounted () {
    // this.chartData is created in the mixin.
    // If you want to pass options please create a local options object
    this.renderChart(this.chartData, this.options)
  }
}
</script>
