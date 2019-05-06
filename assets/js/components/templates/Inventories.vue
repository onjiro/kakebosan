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
      <md-table-head><!-- メニュー --></md-table-head>
    </md-table-row>
    <md-table-row v-for="inventory in inventories" :key="inventory.item.id">
      <md-table-cell>{{ inventory.item.name }}</md-table-cell>
      <md-table-cell>{{ inventory.item.type.name }}</md-table-cell>
      <md-table-cell class="md-xsmall-hide">{{ inventory.item.description }}</md-table-cell>
      <md-table-cell md-numeric>
        {{ inventory.amount }}
      </md-table-cell>
      <md-table-cell class="md-table-cell-selection">
        <md-menu md-direction="bottom-start">
          <md-button class="md-icon-button" md-menu-trigger>
            <md-icon>more_vert</md-icon>
          </md-button>
          <md-menu-content>
            <md-menu-item><a @click="openInventoryModal(inventory)">棚卸高登録</a></md-menu-item>
          </md-menu-content>
        </md-menu>
      </md-table-cell>
    </md-table-row>

  </md-table>

  <!-- 棚卸高登録モーダル -->
  <inventory-modal ref="inventoryModal" @submitted="onInventorySubmitted" />
</div>
</template>

<style scoped>
</style>

<script>
import moment from "moment";
import axios from "axios";
import _ from "lodash";
import InventoryModal from "@/components/templates/InventoryModal";

export default {
  name: 'Inventories',
  components: {
    InventoryModal
  },
  data: function() {
    return {
      date: moment().startOf('day'),
      inventories: [],
      inventory: null
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
    /**
     * 棚卸高登録モーダルを開く
     */
    openInventoryModal: function(inventory) {
      console.log("fuga", inventory);
      this.$refs.inventoryModal.open(inventory);
    },
    /**
     * 棚卸高登録後のコールバック
     */
    onInventorySubmitted: function() {
      this.$refs.inventoryModal.close();
      this.reload();
    }
  }
}
</script>
