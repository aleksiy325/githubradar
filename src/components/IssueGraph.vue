
<template>
    <div  v-if="loading" class="loading">
      Loading...
    </div>

    <div v-else-if="post" class="content">
        <line-chart
        :chartData="IssueData"
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
  extends: Line,
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
      IssueData: null,
      loading: false,
      post: null,
      openIssues: null,
      closedIssues: null
    }
  },

  methods: {
    initGithub () {
      this.client = github.client()
      this.loading = true
      this.post = null
    },
    query () {
      this.client.get('/repos/' + this.repo.full_name + '/issues', {state: 'open', per_page: '100'}, (err, status, body, headers) => {
        this.openIssues = body
        this.client.get('/repos/' + this.repo.full_name + '/issues', {state: 'closed', per_page: '100'}, (err, status, body, headers) => {
          this.loading = false
          this.post = true
          this.closedIssues = body
          this.fillData()
        })
      })
    },

    fillData () {
      let allDates = {}
      let openIssuesData = {}
      let closedIssuesData = {}

      for (let issue of this.openIssues) {
        let date = moment(issue.created_at).format('YYYYMMDD')
        allDates[date] = 0
        if (!(date in openIssuesData)) {
          openIssuesData[date] = 0
        }
        openIssuesData[date] += 1
      }

      for (let issue of this.closedIssues) {
        let date = moment(issue.closed_at).format('YYYYMMDD')
        allDates[date] = 0
        if (!(date in closedIssuesData)) {
          closedIssuesData[date] = 0
        }
        closedIssuesData[date] += 1
      }

      let allDatesArr = Object.keys(allDates).sort()
      let openX = []
      let closedX = []
      let openRunX = []
      let curAmount = 0
      let totalX = []

      for (let date of allDatesArr) {
        if (!(date in openIssuesData)) {
          openIssuesData[date] = 0
        }
        if (!(date in closedIssuesData)) {
          closedIssuesData[date] = 0
        }
        openX.push(openIssuesData[date])
        closedX.push(closedIssuesData[date])
        curAmount += openIssuesData[date]
        curAmount -= closedIssuesData[date]
        totalX.push(curAmount)
      }

      this.IssueData = {
        labels: allDatesArr,
        datasets: [
          {
            data: openX,
            label: 'open',
            borderColor: '#800000',
            fill: false
          },
          {
            data: closedX,
            label: 'closed',
            borderColor: '#008000',
            fill: false
          },
          {
            data: totalX,
            label: 'total',
            borderColor: '#000008',
            fill: false
          }
        ]
      }
      console.log('IssueData', this.IssueData)
    }
  }
}
</script>
