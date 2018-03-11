<template>
  <ul class="list-group">
    <li v-for="(file, filename) in files" class="list-group-item">
        <span class="float-left" >{{ formatName(filename) }} </span>
        <span class="float-right">
          <a v-if="file && file.name" class="font-weight-bold" :href="file.html_url"> {{ file.name }} </a>
          <a v-if="file" :href="file.html_url || '#'"><icon name="check" class="checkmark"></icon></a>
          <a v-else href="#"><icon name="times" class="cross"></icon></a>
        </span>
    </li>
  </ul>
</template>

<script>
export default {
  name: 'CommunityFiles',
  props: {
    files: {
      type: Object,
      required: true,
      default: () => ({})
    }
  },

  methods: {
    formatName (name) {
      name = name.replace(/_/g, ' ')
      let words = name.split(' ')
      console.log(words)
      let capWords = []
      for (let word of words) {
        if (word != 'of') {
          word = word.charAt(0).toUpperCase() + word.slice(1)
        }
        capWords.push(word)
      }
      return capWords.join(' ')
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.checkmark {
  color: green;
}

.cross {
  color: red;
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
  margin: 0 15x;
}
a {
  color: #42b983;
}
</style>
