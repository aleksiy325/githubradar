<template>
    <div class= "col">
      <div class="card">
        <div class="card-header">
          <span :style="healthStyle" class="health float-left"> <icon style="margin-right: 5px" scale="1.25" name="heartbeat"></icon>{{ community.health_percentage }} %</span>
          <span class="name"> {{ repo.full_name }} </span>
          <span v-if="current" class="other card-subtitle mb-2 text-muted"> {{ current.name }}  </span>
          <span class="other float-right"> {{ repo.stargazers_count }} <icon name="star"></icon> </span>
        </div>
        <div class="card-body">
          <CommitGraph :repo="repo"/>
          <IssueGraph :repo="repo"/>
          <div class="row">
            <CommunityFiles class="col-6" :files="community.files"/>
            <Badges class="col-6" :repo="repo"/>
            <Referers :repo="repo"/>
          </div>
        </div>
      </div>
    </div>
</template>

<script>
import github from 'octonode'
import request from 'request'
import CommitGraph from './CommitGraph'
import IssueGraph from './IssueGraph'
import CommunityFiles from './CommunityFiles'
import Badges from './Badges'
import Referers from './Referers'

export default {
  name: 'RepoCard',
  components: {
    CommitGraph,
    CommunityFiles,
    Badges,
    IssueGraph,
    Referers
  },

  props: {
    repo: {
      type: Object,
      required: true,
      default: () => ({})
    }
  },

  data () {
    return {
      community: {},
      tags: {},
      current: {}
    }
  },

  created () {
    this.initGithub()
  },

  computed: {
    healthStyle () {
      if (this.community.health_percentage <= 33) {
        return {color: 'red'}
      } else if (this.community.health_percentage <= 66) {
        return {color: 'orange'}
      }
      return {color: 'green'}
    }
  },

  methods: {
    initGithub () {
      this.client = github.client()
      this.ghrepo = this.client.repo(this.repo.full_name)
      this.getTags()
      this.getCommunity()
    },

    getTags () {
      this.ghrepo.tags((err, data, headers) => {
        this.tags = data
        if (this.tags.length > 0) {
          this.current = this.tags[0]
        }
      })
    },

    getCommunity () {
      let uri = 'https://api.github.com/repos/' + this.repo.full_name + '/community/profile'
      let headers = {'Accept': 'application/vnd.github.black-panther-preview+json'}
      let req = {uri: uri, headers: headers, json: true}

      request(req, (err, res, body) => {
        this.community = body
      })
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.health {
  font-size: 30px;
  color: green;
}
.name {
  font-size: 30px;
}
.other {
  font-size: 20px;
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
