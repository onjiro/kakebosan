<template>
<md-card>
  <md-card-header>棚卸反対科目</md-card-header>
  <md-card-content>
    <div class="md-layout">
      <md-field class="md-layout-item">
        <label>貸方増大時</label>
        <md-select v-model="value.credit_item_id" @change="onChange($event, 'credit')">
          <md-option v-for="item in items" :value="item.id">{{item.name}}</md-option>
        </md-select>
      </md-field>
      <md-field class="md-layout-item">
        <label>借方増大時</label>
        <md-select v-model="value.debit_item_id" @change="onChange($event, 'debit')">
          <md-option v-for="item in items" :value="item.id">{{item.name}}</md-option>
        </md-select>
      </md-field>
    </div>
  </md-card-content>
</md-card>
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
