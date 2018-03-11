<template>
  <div>
    <ul>
      <li v-for="html in badges" >
            <span v-html="html"></span>
      </li>
    </ul>
  </div>
</template>

<script>
import github from 'octonode';
import showdown from 'showdown';

export default {
  name: 'Badges',
  props: {
    repo: {
      type: Object,
      required: true,
      default: () => ({}),
    }
  },

  data () {
    return {
      badges: [],
    }
  },
  created () {
    this.initGithub();
  },

  methods: {
    initGithub () {
      this.client = github.client();
      this.ghrepo = this.client.repo(this.repo.full_name);
      this.parseBadges();
    },

    parseBadges () {
      let re = /\[!\[.*?]\(.*?\)]\(.*?\)/g;
      let converter = new showdown.Converter();
      this.ghrepo.readme((err, data, headers) => {
        this.readme = data;
        let markdown = atob(this.readme.content);
        console.log(markdown);
        let test = markdown.match(re);
        var matches;
        this.badges = [];
        while(matches = re.exec(markdown)){
          let html = converter.makeHtml(matches[0]);
          console.log(html);
          html = html.replace("<p>", "").replace("</p>", "");
          this.badges.push(html);
        }
      });
    },

  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
p{
  margin-bottom: 2px;
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
  margin: 0 2px;
}
a {
  color: #42b983;
}
</style>
