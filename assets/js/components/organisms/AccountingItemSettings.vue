<template>
<div>
  <md-subheader>勘定科目設定</md-subheader>
  <div>
    <input name="name" type="text" placeholder="科目名"/>
    <select name="type">
      <option>資産</option>
      <option>費用</option>
      <option>負債</option>
      <option>資本</option>
      <option>収益</option>
    </select>
    <input name="name" type="text" placeholder="説明"/>
    <button>決定</button>
  </div>

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
        <button>編集</button>
        <button>無効化</button>
        <button>有効化</button>
      </md-table-cell>
    </md-table-row>
  </md-table>
</div>
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
