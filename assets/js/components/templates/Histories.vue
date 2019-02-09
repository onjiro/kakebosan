<template>
<div>
  <div class="md-title">履歴</div>

  {{ notice }}
  <recent-history v-model="transactions" @selected="openSelectedTransaction"/>

  <entry-modal title="登録" ref="entryModal" :items="items"
               @submitted="onTransactionSubmitted"
               @deleted="onTransactionDeleted" />
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
  name: 'Histories',
  components: {
    NewEntryButtonForm,
    RecentHistory,
    EntryModal
  },
  data: function() {
    return {
      dateFrom: moment().subtract(7, 'days').toISOString(),
      dateTo: null,
      transactions: [],
      notice: '',
    }
  },
  created: function() {
    this.reload();
  },
  methods: {
    /**
     * トランザクションを読み込み直す
     */
    reload: function() {
      Promise.all([
        axios.get('api/transactions', {
          data: {
            dateFrom: this.dateFrom,
            dateTo: this.dateTo
          }
        }),
        axios.get('api/items')
      ]).then(([{ data: { data: transactions }}, { data: { data: items }}]) => {
        this.transactions = transactions.reverse();
        this.items = items;
      });
    },
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
    },
    /**
     * transactionの更新があった場合の挙動
     */
    onTransactionSubmitted: function(data) {
      this.reload();
      this.notice = '登録が完了しました。'
      window.setTimeout(() => this.notice = '', 5000);
    },
    /**
     * transactionの削除があった場合の挙動
     */
    onTransactionDeleted: function(data) {
      this.reload();
      this.notice = '削除が完了しました。'
      window.setTimeout(() => this.notice = '', 5000);
    }
  }
}
</script>
