<template>
    <div>
      <b-card :title="repo.full_name">
        
      </b-card>
    </div>
</template>

<script>
import github from 'octonode';
import request from 'request';

export default {
  name: 'RepoCard',

  props: {
    repo: {
      type: Object,
      required: true,
      default: () => ({}),
    }
  },

  data () {
    return {

    }
  },

  created () {
    this.initGithub();
    console.log(this.repo);
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
      let req = {uri:uri, headers: headers};

      request(req, (err, res, body) => {
          this.community = body;
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
