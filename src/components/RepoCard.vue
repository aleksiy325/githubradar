<template>
    <div class= "col">
      <b-card>
      <div class="row">
        <span> {{ community.health_percentage }} </span>
        <span class="offset-1"> {{ repo.full_name }} </span>
      </div>
      <CommitGraph :repo="repo"></CommitGraph>
      <ul class="list-group col-2">
        <li v-for="(file, filename) in community.files" class="list-group-item">
            <span class="float-left">{{ filename }}</span>
            <span class="float-right">
              <icon v-if="file" name="check"></icon>
              <icon v-else name="times"></icon>
            </span>
        </li>
      </ul>
    </div>
</template>

<script>
import github from 'octonode';
import request from 'request';
import CommitGraph from './CommitGraph';

export default {
  name: 'RepoCard',
  components: {
    CommitGraph
  },  

  props: {
    repo: {
      type: Object,
      required: true,
      default: () => ({}),
    }
  },

  data () {
    return {
      community: {},
      tags: {},
      readme: {},
    }
  },
  created () {
    this.initGithub();
  },

  methods: {
    initGithub () {
      this.client = github.client();
      this.ghrepo = this.client.repo(this.repo.full_name);
      this.ghrepo.tags((err, data, headers) => {
        this.tags = data;
      });
      this.ghrepo.readme((err, data, headers) => {
        this.readme = data;
      });

      let uri = "https://api.github.com/repos/"+ this.repo.full_name + "/community/profile";
      let headers = {"Accept": "application/vnd.github.black-panther-preview+json"};
      let req = {uri:uri, headers: headers, json:true};

      request(req, (err, res, body) => {
          this.community = body;
          console.log(this.community.files);
      });
    },

  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h1, h2 {
  font-weight: normal;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
