<template>
<div>
  <div class="md-title">棚卸</div>

  {{ notice }}

  <md-subheader>{{ date.format('YYYY/MM/DD') }}</md-subheader>
  <md-table>
    <md-table-row>
      <md-table-head>科目名</md-table-head>
      <md-table-head>分類</md-table-head>
      <md-table-head class="md-xsmall-hide">説明</md-table-head>
      <md-table-head>残高</md-table-head>
      <md-table-head><!-- コントロール --></md-table-head>
    </md-table-row>
    <md-table-row v-for="inventory in inventories" :key="inventory.item.id">
      <md-table-cell>{{ inventory.item.name }}</md-table-cell>
      <md-table-cell>{{ inventory.item.type.name }}</md-table-cell>
      <md-table-cell class="md-xsmall-hide">{{ inventory.item.description }}</md-table-cell>
      <md-table-cell>{{ inventory.amount }}</md-table-cell>
      <md-table-cell></md-table-cell>
    </md-table-row>
</md-table>
</div>
</template>

<style scoped>
.fixed-bottom {
    position: fixed;
    bottom: 0;
}
</style>

<script>
import moment from "moment";
import axios from "axios";
import _ from "lodash";

export default {
  name: 'Inventories',
  components: {
  },
  data: function() {
    return {
      date: moment().startOf('day'),
      inventories: [],
    }
  },
  created: function() {
    this.reload();
  },
  methods: {
    reload: function() {
      Promise.all([
        axios.get('api/inventories/current', {}),
      ]).then(([{data: {data: inventories}}]) => {
        this.inventories = inventories;
      });
    },
  }
}
</script>
