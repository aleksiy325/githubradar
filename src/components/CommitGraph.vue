


<template>
    <div  v-if="loading" class="loading">
      Loading...
    </div>

    <div v-else-if="post" class="content">
        <LineGraph :lineData="LineGraphData"></LineGraph>
    </div>

</template>


<script>
import github from 'octonode';
import LineGraph from './LineGraph';
export default {
  name: 'CommitGraph',
  components: {
      LineGraph
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
  },
  data () {
    return {
        LineGraphData : null,
        loading : false,
        post : null
    }
  },  

  methods: {
    initGithub () {
    //   console.log(this.repo);
      this.client = github.client();
      this.loading = true;
      this.post = null;
      this.client.get('/repos/' + this.repo.full_name + '/stats/participation', {}, (err, status, body, headers) => {
          console.log(headers);
          console.log(err);          
          this.LineGraphData = Array.from(body["all"], x => x);
        //   console.log("Done query");
        //   console.log(this.LineGraphData);
          this.loading = false;
          this.post = true;
        //   this.LineGraphData = [this.LineGraphData]
      });
    },  
  }
}
</script>
