import Vue from 'vue';
import Router from 'vue-router';

import Histories from '@/components/templates/Histories';
import Inventories from '@/components/templates/Inventories';
import Summaries from '@/components/templates/Summaries';
import Settings from '@/components/templates/Settings';

Vue.use(Router);

export default new Router({
  routes: [
    {
      path: '/',
      name: 'histories',
      component: Histories,
    },
    {
      path: '/inventories',
      name: 'inventories',
      component: Inventories
    },
    {
      path: '/summaries',
      name: 'summaries',
      component: Summaries
    },
    {
      path: '/settings',
      name: 'settings',
      component: Settings
    },
  ]
})
