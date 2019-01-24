<template>
<div>
  <md-subheader>yyyy/MM/dd 〜 yyyy/MM/dd</md-subheader>
  <md-table>
    <md-table-row>
      <md-table-head>科目名</md-table-head>
      <md-table-head>分類</md-table-head>
      <md-table-head>借方</md-table-head>
      <md-table-head>貸方</md-table-head>
      <md-table-head>増減</md-table-head>
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
  name: 'SummaryResults',
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
