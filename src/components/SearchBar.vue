<template>
  <div>
    <div style="position:relative" class="search-margin">
      <input class="form-control" type="text" v-model="searchtext"/>
        <ul style="width:100%" class="list-group dropdown">
            <li v-for="suggestion in suggestions" class="list-group-item">
                <a href="#" v-on:click="select(suggestion)">{{ suggestion.full_name }}</a>
            </li>
        </ul>
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
    }, 300),


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
.dropdown{
  z-index: 10;
  position: absolute;
  background-color: white;
  border: 1px;
}

.search-margin {
  margin-bottom: 20px;
}

.list-group-item {
  padding: 5px;
  margin: 0px;
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
