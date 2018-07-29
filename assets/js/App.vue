<template>
<div id="app">
  <router-view/>
</div>
</template>

<script>
import Vue from 'vue';
import VueMoment from 'vue-moment';
import { MdButton, MdField, MdContent, MdDatepicker, MdTable, MdSubheader, MdToolbar, MdDialog } from 'vue-material/dist/components';
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
</style>
