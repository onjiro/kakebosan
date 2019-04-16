<template>
<div>
  <md-table>
    <md-table-row>
      <md-table-head>科目名</md-table-head>
      <md-table-head>分類</md-table-head>
      <md-table-head>借方</md-table-head>
      <md-table-head>貸方</md-table-head>
      <md-table-head>増減</md-table-head>
    </md-table-row>
    <md-table-row v-for="itemSummary in value" :key="itemSummary.id">
      <md-table-cell>{{itemSummary.name}}</md-table-cell>
      <md-table-cell>{{itemSummary.type.name}}</md-table-cell>
      <md-table-cell>{{itemSummary.debit_amount}}</md-table-cell>
      <md-table-cell>{{itemSummary.credit_amount}}</md-table-cell>
      <md-table-cell>{{itemSummary.amount_grow}}</md-table-cell>
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
  props: {
    value: Array
  }
}
</script>
