<template>
  <div>
    <ul class="list-group">
      <li v-for="html in badges" class="list-group-item text-left">
            <span v-html="html"></span>
      </li>
      <li v-if="badges.length == 0" class="list-group-item text-left">
            <span>No badges</span>
      </li>
    </ul>
  </div>
</template>

<script>
import github from 'octonode'
import showdown from 'showdown'

export default {
  name: 'Badges',
  props: {
    repo: {
      type: Object,
      required: true,
      default: () => ({})
    }
  },

  data () {
    return {
      badges: []
    }
  },
  created () {
    this.initGithub()
  },

  methods: {
    initGithub () {
      this.client = github.client()
      this.ghrepo = this.client.repo(this.repo.full_name)
      this.parseBadges()
    },

    parseBadges () {
      let re = /\[!\[.*?]\(.*?\)]\(.*?\)/g
      let converter = new showdown.Converter()
      this.ghrepo.readme((err, data, headers) => {
        this.readme = data
        let markdown = atob(this.readme.content)
        let test = markdown.match(re)
        var matches
        this.badges = []
        while (matches = re.exec(markdown)) {
          let html = converter.makeHtml(matches[0])
          html = html.replace('<p>', '').replace('</p>', '')
          this.badges.push(html)
        }
      })
    }

  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.list-group-item{
  padding: 5px;
  border: 0px;
}

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
