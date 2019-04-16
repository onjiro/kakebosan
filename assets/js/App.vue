<template>
<div id="app">
  <router-view/>
  <div class="spacer"></div>
  <bottom-nav />
</div>
</template>

<script>
import Vue from 'vue';
import VueMoment from 'vue-moment';
import { MdButton, MdField, MdContent, MdCard, MdDatepicker, MdTable, MdSubheader, MdToolbar, MdDialog, MdBottomBar, MdMenu, MdList } from 'vue-material/dist/components';
import 'vue-material/dist/vue-material.min.css'
import 'vue-material/dist/theme/default.css'
import BottomNav from './components/organisms/BottomNav'

Vue.use(VueMoment);
Vue.use(MdButton);
Vue.use(MdField);
Vue.use(MdContent);
Vue.use(MdCard);
Vue.use(MdDatepicker);
Vue.use(MdTable);
Vue.use(MdSubheader);
Vue.use(MdToolbar);
Vue.use(MdDialog);
Vue.use(MdBottomBar);
Vue.use(MdMenu);
Vue.use(MdList);

export default {
  name: 'app',
  components: {
    BottomNav
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
.spacer {
    height: 100px;
}
</style>
