<template>
    <div class="main">
      <h1>{{ msg }}</h1>
      <h2>Essential Links</h2>
      <SearchBar v-on:selected="addRepo"/>
      <div class="row">
        <RepoCard  v-for="repo in repos" :repo="repo"/>
      </div>
    </div>
</template>

<script>
import github from 'octonode';
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
      msg: 'Welcome to Your Vue.js App',
      loading: false,
      post: null,
      error: null,
      repos: [],
    }
  },

  created () {
    this.initGithub();
  },

  methods: {
    initGithub () {
      this.client = github.client();
    },

    addRepo (repo) {
      this.repos.push(repo);
    }

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
