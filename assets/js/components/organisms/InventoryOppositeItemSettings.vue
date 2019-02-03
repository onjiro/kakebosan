<template>
<div>
  <md-subheader>棚卸反対科目</md-subheader>
  <span>貸方増大時</span>
  <select v-model="value.credit_item_id" @change="onChange($event, 'credit')">
    <option v-for="item in items" :value="item.id">{{item.name}}</option>
  </select>
  <span>借方増大時</span>
  <select v-model="value.debit_item_id" @change="onChange($event, 'debit')">
    <option v-for="item in items" :value="item.id">{{item.name}}</option>
  </select>
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
  props: {
    value: Object, // { debit_item_id, credit_item_id }
    items: Array, // [{ id, name, type, type_id, description, selectable }, ...]
  },
  data: function() {
    return {
    }
  },
  methods: {
    onChange(e, side) {
      this.$emit('change', (side === "debit") ?
                 { ...this.value, debit_item_id: e.target.value } :
                 { ...this.value, credit_item_id: e.target.value });
    }
  }
}
</script>
