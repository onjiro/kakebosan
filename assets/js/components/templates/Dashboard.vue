<template>
<div>
  <div class="md-title">ダッシュボード</div>

  {{ notice }}
  <recent-history v-model="transactions" @selected="openSelectedTransaction"/>

  <entry-modal title="登録" ref="entryModal" :items="items" />
  <new-entry-button-form @click.native="openNewTransaction" />
</div>
</template>

<style scoped>
.fixed-bottom {
    position: fixed;
    bottom: 0;
}
</style>

<script>
import moment from "moment";
import axios from "axios";
import _ from "lodash";
import NewEntryButtonForm from '@/components/organisms/NewEntryButtonForm';
import RecentHistory from '@/components/templates/RecentHistory';
import EntryModal from '@/components/templates/EntryModal';

export default {
  name: 'DashBoard',
  components: {
    NewEntryButtonForm,
    RecentHistory,
    EntryModal
  },
  data: function() {
    return {
      dateFrom: moment().subtract(7, 'days').toISOString(),
      dateTo: null,
      transactions: []
    }
  },
  created: function() {
    Promise.all([
      axios.get('api/transactions', {
        data: {
          dateFrom: this.dateFrom,
          dateTo: this.dateTo
        }
      }),
      axios.get('api/items')
    ]).then(([{ data: { data: transactions }}, { data: { data: items }}]) => {
      this.transactions = transactions;
      this.items = items;
    })
  },
  methods: {
    /**
     * 新しい取引登録モーダルを開きます
     */
    openNewTransaction: function() {
      this.$refs.entryModal.open();
    },
    /**
     * 選択された取引詳細をモーダルで開きます
     */
    openSelectedTransaction: function(transaction) {
      this.$refs.entryModal.open(transaction);
    }
  }
}
</script>
