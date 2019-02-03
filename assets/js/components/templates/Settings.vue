<template>
<div>
  <div class="md-title">設定</div>
  
  {{ notice }}
  
  <inventory-opposite-item-settings
    v-model="inventoryOppositeItemIds"
    :items="items"
    @change="onChangeInventoryOppositeItemSettings" />

  <accounting-item-settings
    v-model="items" />

</div>
</template>

<style scoped>
</style>

<script>
import moment from "moment";
import axios from "axios";
import _ from "lodash";
import InventoryOppositeItemSettings from '../organisms/InventoryOppositeItemSettings'
import AccountingItemSettings from '../organisms/AccountingItemSettings.vue'

export default {
  name: 'Settings',
  components: {
    InventoryOppositeItemSettings,
    AccountingItemSettings,
  },
  data() {
    return {
      // 勘定科目一覧
      items: [],
      // 棚卸時反対科目
      inventoryOppositeItemIds: {
        debit_item_id: null,
        credit_item_id: null,
      },
    }
  },
  created() {
    this.reload();
  },
  methods: {
    onChangeInventoryOppositeItemSettings(payload) {
      // TODO
      console.log(payload);
    },
    reload() {
      Promise.all([
        axios.get('api/items'),
        axios.get('api/inventory_setting'),
      ]).then(([
        { data: { data: items }},
        { data: { debit_item_id, credit_item_id } }
      ]) => {
        this.items = items;
        this.inventoryOppositeItemIds = {
          debit_item_id,
          credit_item_id,
        }
      });

    }
  }
}
</script>
