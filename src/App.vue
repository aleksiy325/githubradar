<template>
  <div id="app">
    <img src="./assets/logo.png">
    <HelloWorld/>
    <D3Example/>
  </div>
</template>

<script>
import HelloWorld from './components/HelloWorld'
import D3Example from './components/D3Example'
export default {
  name: 'App',
  components: {
    HelloWorld,
    D3Example
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
