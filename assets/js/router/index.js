import Vue from 'vue';
import Router from 'vue-router';

import Dashboard from '@/components/templates/Dashboard';
import Inventories from '@/components/templates/Inventories';

Vue.use(Router);

export default new Router({
  routes: [
    {
      path: '/',
      name: 'dashboard',
      component: Dashboard,
    },
    {
      path: '/inventories',
      name: 'inventories',
      component: Inventories
    },
  ]
})
