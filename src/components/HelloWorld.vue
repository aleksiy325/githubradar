<template>
    <div class="main">
      <h1>Welcome to Github Radar</h1>
      <h2>Enter a repository name</h2>
      <SearchBar class="col-6 offset-3" v-on:selected="addRepo"/>
      <div class="row offset-1 col-10">
        <RepoCard v-bind:class="size()" v-for="repo in repos" :repo="repo"/>
      </div>
    </div>
</template>

<script>
import github from 'octonode'
import SearchBar from './SearchBar'
import RepoCard from './RepoCard'

export default {
  name: 'HelloWorld',
  components: {
    SearchBar,
    RepoCard
  },

  data () {
    return {
      loading: false,
      post: null,
      error: null,
      repos: []
    }
  },

  created () {
    this.initGithub()
  },

  methods: {
    initGithub () {
      this.client = github.client()
    },

    addRepo (repo) {
      this.repos.push(repo)
    },

    size () {
      if(this.repos.length > 1){
        console.log(this.repos.length);
        return "col-6";
      }
      return "";
    },

  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
#main{
  text-align: center;

}

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
