<template>
<div>
  <md-subheader>棚卸反対科目</md-subheader>
  <span>貸方増大時</span>
  <select></select>
  <span>借方増大時</span>
  <select></select>
</div>
</template>

<style scoped>
</style>

<script>
import moment from "moment";
import axios from "axios";
import _ from "lodash";

export default {
  name: 'InventoryOppositeItemSettings',
  components: {
  },
  data: function() {
    return {
    }
  },
  created: function() {
  },
  methods: {
  }
}
</script>
