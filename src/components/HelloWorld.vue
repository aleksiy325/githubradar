<template>
    <div class="hello">
      <h1>{{ msg }}</h1>
      <h2>Essential Links</h2>
      <SearchBar v-on:selected="visualizeRepo"/>
      <h2> {{ repository.name }} </h2>
    </div>
</template>

<script>
import github from 'octonode';
import SearchBar from './SearchBar'

export default {
  name: 'HelloWorld',
  components: {
    SearchBar
  },

  data () {
    return {
      msg: 'Welcome to Your Vue.js App',
      loading: false,
      post: null,
      error: null,
      repository: {},
    }
  },

  created () {
    this.initGithub();
  },

  methods: {
    initGithub () {
      this.client = github.client();
    },

    visualizeRepo (repo) {
      this.repository = repo;
    }

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
