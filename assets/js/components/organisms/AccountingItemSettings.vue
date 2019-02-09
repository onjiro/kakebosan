<template>
<md-card>
  <md-card-header>勘定科目設定</md-card-header>
  <md-card-content>
    <form>
      <div class="md-layout md-gutter">
        <md-field class="md-layout-item md-size-30">
          <md-input name="name" type="text" placeholder="科目名"/>
        </md-field>
        <md-field class="md-layout-item md-size-10">
          <label>分類</label>
          <md-select name="type">
            <md-option>資産</md-option>
            <md-option>費用</md-option>
            <md-option>負債</md-option>
            <md-option>資本</md-option>
            <md-option>収益</md-option>
          </md-select>
        </md-field>
        <md-field class="md-layout-item md-size-60">
        <md-input name="name" type="text" placeholder="説明"/>
        </md-field>
      </div>
      <md-button>決定</md-button>
    </form>

    <md-table>
      <md-table-row>
        <md-table-head>科目名</md-table-head>
        <md-table-head>分類</md-table-head>
        <md-table-head>説明</md-table-head>
        <md-table-head><!-- 操作 --></md-table-head>
      </md-table-row>
      <md-table-row v-for="item in value">
        <md-table-cell>{{item.name}}</md-table-cell>
        <md-table-cell>{{item.type && item.type.name}}</md-table-cell>
        <md-table-cell>{{item.description}}</md-table-cell>
        <md-table-cell>
          <md-button>編集</md-button>
          <md-button>無効化</md-button>
          <md-button>有効化</md-button>
        </md-table-cell>
      </md-table-row>
    </md-table>
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
  name: 'AccountingItemSettings',
  components: {
  },
  props: {
    value: Array, // [{ id, name, type, type_id, description, selectable }, ...]
  },
  methods: {
  }
}
</script>
