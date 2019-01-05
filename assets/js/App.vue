<template>
<div id="app">
  <router-view/>
  <div class="spacer"></div>
  <md-bottom-bar md-sync-route>
    <md-bottom-bar-item to="/" md-label="Home" md-icon="home"></md-bottom-bar-item>
    <md-bottom-bar-item to="/inventories" md-label="棚卸" md-icon="assignment_turned_in"></md-bottom-bar-item>
  </md-bottom-bar>
</div>
</template>

<script>
import Vue from 'vue';
import VueMoment from 'vue-moment';
import { MdButton, MdField, MdContent, MdDatepicker, MdTable, MdSubheader, MdToolbar, MdDialog, MdBottomBar } from 'vue-material/dist/components';
import 'vue-material/dist/vue-material.min.css'
import 'vue-material/dist/theme/default.css'

Vue.use(VueMoment);
Vue.use(MdButton);
Vue.use(MdField);
Vue.use(MdContent);
Vue.use(MdDatepicker);
Vue.use(MdTable);
Vue.use(MdSubheader);
Vue.use(MdToolbar);
Vue.use(MdDialog);
Vue.use(MdBottomBar);

export default {
  name: 'app'
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
.spacer {
    height: 100px;
}
.md-bottom-bar {
    position: fixed;
    bottom: 0;
}
</style>
