<template>
  <div>
    <div style="position:relative">
      <input class="form-control" type="text" v-model="searchtext"/>
      <div style="width:100%">
          <b-dropdown-item v-for="suggestion in suggestions">
              <a href="#" v-on:click="select(suggestion)">{{ suggestion.full_name }}</a>
          </b-dropdown-item>
      </div>
    </div>
  </div>
</template>

<script>
import github from 'octonode';
import _ from 'lodash'; 

export default {
  name: 'SearchBar',

  data () {
    return { 
      current: {},
      searchtext: "",
      suggestions: [],
    }
  },

  created () {
    this.initGithub();
  },

  watch: {
    searchtext: _.debounce( function (text) {
      if(text){
        this.client.get('/search/repositories', { q: text }, (err, status, body, headers) => {
          this.suggestions = body.items.splice(0, 5);
        });
      }
    }, 50),


  },

  methods: {
    initGithub () {
      this.client = github.client();
    },

    select (repo) {
      this.current = repo;
      this.suggestions = [];
      this.searchtext = "";
      this.$emit('selected', repo);
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
