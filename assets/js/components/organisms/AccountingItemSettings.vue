<template>
<div>
  <md-subheader>勘定科目設定</md-subheader>
  <md-table>
    <md-table-row>
      <md-table-head>科目名</md-table-head>
      <md-table-head>分類</md-table-head>
      <md-table-head>説明</md-table-head>
      <md-table-head><!-- 操作 --></md-table-head>
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
