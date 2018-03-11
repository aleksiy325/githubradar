
<template>
    <div  v-if="loading" class="loading">
      Loading...
    </div>

    <div v-else-if="post" class="content">
        <line-chart
        :chartData="IssueData"
        :options="{responsive: false, maintainAspectRatio: false}"
        :width="600"
        :height="400">
        </line-chart>
    </div>
    

</template>


<script>
import github from 'octonode';
import moment from 'moment';
import _ from 'lodash';

import {Line} from 'vue-chartjs';
import LineChart from './LineChart.vue'

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
          default: () => ({}),
      }
  },
  created () {
    this.initGithub();
    this.query();
    // this.fillData();
    
  },
  data () {
    return {
        IssueData : null,
        loading : false,
        post : null,
        openIssues : null,
        closedIssues : null
    }
  },  

  methods: {
    initGithub () {
      this.client = github.client();
      this.loading = true;
      this.post = null;

    },
    query(){
      var currentTime = moment().subtract(1, 'year').format('YYYY-MM-DDTHH:MM:SSZ');
      console.log("currentTIMe", currentTime);
      this.client.get('/repos/' + this.repo.full_name + '/issues', {state : "open", per_page : "100", since : currentTime }, (err, status, body, headers) => {
        //   console.log(body);
        //   this.LineGraphData = Array.from(body["all"], x => x)
          this.loading = false;
          this.post = true;
          this.openIssues = body;
      });
      this.client.get('/repos/' + this.repo.full_name + '/issues', {state : "closed", per_page : "100", since : currentTime}, (err, status, body, headers) => {
        //   console.log(body);
        //   this.LineGraphData = Array.from(body["all"], x => x)
          this.loading = false;
          this.post = true;
          this.closedIssues = body;
          console.log("closed", this.closedIssues);
          console.log("open", this.openIssues);
          console.log("headers", headers);
          this.fillData();

      });
    },
    fillData () {
        const issues_in_year = {};
        var currentTime = moment().format('MM/DD/YYYY');
        // var storedString = currentTime.toISOString();
        // console.log(currentTime);
        var openIssuesData = {};
        var closeIssuesData = {};

        function setDay(issue) {
            var previous_time = moment(issue['created_at']).format('MM/DD/YYYY');
            var diff = moment(previous_time, 'MM/DD/YYYY').diff(currentTime, 'days');
            diff = Math.abs(diff);
            if (diff < 365){
                console.log(issue['created_at'], previous_time, currentTime, diff);
                // issue.set('from_now',365 - diff);
                var newKey = 365 - diff;
                if (newKey in issues_in_year){
                    if (issue['state'] === "open"){
                        console.log()
                        issues_in_year[newKey] += 1;
                        openIssuesData[newKey] +=  1;
                        // console.log("new value in open",issues_in_year.get(newKey));
                    }else{
                        issues_in_year[newKey] -= 1;
                        closeIssuesData[newKey] += 1;
                        // console.log("new value in closed",issues_in_year.get(newKey));

                    }                 
                }else{
                    // console.log("not in issue");
                    if (issue['state'] === "open"){
                        issues_in_year[newKey] = 1;
                        openIssuesData[newKey] = 1;
                        // console.log("new value in open",issues_in_year.get(newKey));
                    }else{
                        issues_in_year[newKey]  = -1;
                        closeIssuesData[newKey] =  1;
                        // console.log("new value in closed",issues_in_year.get(newKey));

                    }     
                }            
            }
            return issue;  
        }
        _.map(this.openIssues, setDay);
        _.map(this.closedIssues, setDay);

        console.log(closeIssuesData);
        console.log(openIssuesData);

        function getSeparateGraph(myData){
            var sortedDate = Object.keys(issues_in_year) ;
            sortedDate.sort();
            var previous_val = 0;
            // var myDataKey = Object.keys(issues_in_year);
            for(var i = 0; i < sortedDate.length; i++){
                if (sortedDate[i] in Object.keys(myData)){
                    previous_val = myData[sortedDate[i]];
                }else{
                    myData[sortedDate[i]] = previous_val;
                }
            }
            // return myData;
        }
        getSeparateGraph(closeIssuesData);
        getSeparateGraph(openIssuesData);

        console.log(closeIssuesData);
        console.log(openIssuesData);

        // console.log(issues_in_year);
        // console.log(issues_in_year.keys());
        // console.log(issues_in_year.values());

        this.IssueData = {
            labels: Object.keys(issues_in_year),
            datasets: [
                {
                    data : Object.values(openIssuesData),
                    label: 'open',
                    borderColor: "#800000",
                    fill: false
                },
                {
                    data : Object.values(closeIssuesData),
                    label: 'closed',
                    borderColor: "#008000",
                    fill: false
                }                
            ] 
            // [
            // {
            //     label: 'Data One',
            //     backgroundColor: '#f87979',
            //     data: [this.getRandomInt(), this.getRandomInt()]
            // }, {
            //     label: 'Data One',
            //     backgroundColor: '#f87979',
            //     data: [this.getRandomInt(), this.getRandomInt()]
            // }
            // ]
        }
        console.log("IssueData", this.IssueData);
    },
    getRandomInt () {
        return Math.floor(Math.random() * (50 - 5 + 1)) + 5
    }      
  },
  mounted () {
      this.fillData();      
    //   console.log(this.IssueData);
  },

}
</script>
