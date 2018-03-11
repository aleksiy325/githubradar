
<template>
    <div  v-if="loading" class="loading">
      Loading...
    </div>

    <div v-else-if="post" class="content">
        <line-chart
        :chartData="commitDataGraph"
        :options="{responsive: true, maintainAspectRatio: false}"
        :width="600"
        :height="400">
        </line-chart>
    </div>
</template>

<script>
import github from 'octonode'
import moment from 'moment'
import _ from 'lodash'
import {Line} from 'vue-chartjs'
import LineChart from './LineChart'

export default {
  name: 'IssueGraph',
  components: {
    LineChart
  },
  props: {
    repo: {
      type: Object,
      required: true,
      default: () => ({})
    }
  },

  created () {
    this.initGithub()
    this.query()
  },

  data () {
    return {
      commitData: [],
      commitDataGraph: {},
      loading: false,
      post: null
    }
  },

  methods: {
    initGithub () {
      this.client = github.client()
      this.loading = true
      this.post = null
    },

    query () {
      this.client = github.client()
      this.loading = true
      this.post = null
      this.client.get('/repos/' + this.repo.full_name + '/stats/participation', {}, (err, status, body, headers) => {
        this.commitData = Array.from(body['all'], x => x)
        this.post = true
        this.fillData()
        this.loading = false
      })
    },

    fillData () {
      let i = 0
      let y = _.map(this.commitData, () => {
        i += 1
        return 'Week ' + i.toString()
      })

      this.commitDataGraph = {
        labels: y,
        datasets: [
          {
            data: this.commitData,
            label: 'all commits',
            borderColor: '#0dc466',
            fill: false
          }
        ]
      }
    }
  }
}
</script>
