<template>
  <ul class="list-group">
    <li v-for="(file, filename) in files" class="list-group-item">
        <span class="float-left">{{ filename }}</span>
        <span class="float-right">
          <icon v-if="file" name="check"></icon>
          <icon v-else name="times"></icon>
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
      default: () => ({}),
    }
  },
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
  margin: 0 15x;
}
a {
  color: #42b983;
}
</style>
