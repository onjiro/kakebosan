<template>
<div>
  <div class="md-title">設定</div>
  
  {{ notice }}
  
  <inventory-opposite-item-settings />
  <accounting-item-settings />
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
