



<template>
    <div class="fork">
        <div v-if="thirty">
            At least {{fork_in_day}} forks in the past 3 days
            <div v-if="hasRelease">
                Latest Release: {{ releaseTime}}
            </div>            
        </div>
        <div v-else>
            {{fork_in_day}} forks in the last 3 days  
            <div v-if="hasRelease">
                Latest Release: {{releaseTime}}
            </div>         
        </div>
    </div>


</template>


<script>

import github from 'octonode';
import moment from 'moment';


export default {
  name : 'Referers',
  props: {
      repo: {
          type: Object,
          required: true,
          default: () => ({})
      }
  },
  data (){
      return {
          fork_in_day : 0,
          thirty : false,
          hasRelease : false,
          releaseTime : 0
      }
  },
  created(){
      this.initGithub();
  },
  methods: {
      initGithub(){
        //   console.log("Reach here");
          this.client = github.client();
          this.ghrepo = this.client.get('/repos/' + this.repo.full_name + '/forks', 
          (err, status, body, headers) => {
              var timeNow = moment().format('MM/DD/YYYY');

            //   console.log(body);
              for(var i = 0; i < body.length; i++){
                  var entry = body[i];
                  var timeThen = moment(entry['created_at']).format('MM/DD/YYYY');
                  var diff = moment(timeThen, 'MM/DD/YYYY').diff(timeNow, 'days');
                  diff = Math.abs(diff);                  
                  if (diff <= 3){
                      this.fork_in_day += 1;
                  } 
              }
              if (this.fork_in_day == 30){
                  this.thirty = true;
              }
            //   console.log(this.fork_in_day);
          });
          this.ghrepo = this.client.get('/repos/' + this.repo.full_name + '/releases', 
          (err, status, body, headers) => {
              console.log(body, body.length);
              
              if (body.length != 0){
                  this.hasRelease = true;
                  var timeNow = moment().format('MM/DD/YYYY');
                  var entry = body[0];
                  var timeThen = moment(entry['created_at']).format('MM/DD/YYYY');
                  this.releaseTime = timeThen;
              }
          });
          
      }
  }
}
</script>
