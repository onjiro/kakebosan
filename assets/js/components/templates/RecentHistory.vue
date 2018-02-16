<template>
<div>
  <md-subheader>取引履歴</md-subheader>
  <md-table>
    <md-table-row>
      <md-table-head>日付</md-table-head>
      <md-table-head>借方</md-table-head>
      <md-table-head class="md-xsmall-hide">金額</md-table-head>
      <md-table-head class="md-xsmall-hide">貸方</md-table-head>
      <md-table-head>金額</md-table-head>
    </md-table-row>
    <md-table-row v-for="transaction in value" :key="transaction.id" @click.native="onSelected(transaction)">
      <md-table-cell>{{ transaction.date | moment('YYYY/MM/DD') }}</md-table-cell>
      <md-table-cell>{{ transaction.entries | debits | displayItemNames }}</md-table-cell>
      <md-table-cell class="md-xsmall-hide">{{ transaction.entries | debits | amountSum }}</md-table-cell>
      <md-table-cell class="md-xsmall-hide">{{ transaction.entries | credits | displayItemNames }}</md-table-cell>
      <md-table-cell>{{ transaction.entries | credits | amountSum }}</md-table-cell>
  </md-table-row>
  </md-table>
</div>
</template>

<style scoped>
</style>

<script>
export default {
  name: 'RecentHistory',
  props: {
    value: Array
  },
  methods: {
    /**
     * 行を選択された際のハンドラー
     */
    onSelected: function(transaction) {
      this.$emit("selected", transaction);
    }
  },
  filters: {
    debits: function(entries) {
      return (entries || []).filter((entry) => entry.side_id === 2);
    },
    credits: function(entries) {
      return (entries || []).filter((entry) => entry.side_id === 1);
    },
    displayItemNames: function(entries) {
      return (entries || []).map((entry) => entry.item.name).join(", ");
    },
    amountSum: function(entries) {
      return (entries || []).reduce((sum, entry) => sum + Number(entry.amount), 0)
    }
  }
}
</script>
