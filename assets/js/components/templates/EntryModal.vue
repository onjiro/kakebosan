<template>
<md-dialog :md-active.sync="isShow" md-fullscreen="false">
  <md-dialog-title>{{title}}</md-dialog-title>

  <md-datepicker v-model="date" />

  <entry-side-form title="借方" v-model="debits" :items="items"/>

  <entry-side-form title="貸方" v-model="credits" :items="items"/>

  <md-field>
    <label>備考</label>
    <md-textarea v-model="description" md-autogrow></md-textarea>
  </md-field>

  <md-dialog-actions>
    <md-button class="" @click="close">キャンセル</md-button>
    <md-button class="md-primary" @click="submit">登録</md-button>
  </md-dialog-actions>
</md-dialog>
</template>

<script>
import EntrySideForm from '@/components/organisms/EntrySideForm';
import moment from 'moment';
import axios from "axios";

export default {
  name: 'EntryModal',
  components: { EntrySideForm },
  props: {
    title: String,
    items: Array
  },
  data: () => ({
    isShow: false,
    id: null,
    date: null,
    debits:  [{item_id: null, amount: null}],
    credits: [{item_id: null, amount: null}],
    description: ""
  }),
  methods: {
    /**
     * このモーダルを表示します
     */
    open: function(transaction) {
      this.isShow = true;
      if (transaction) {
        this.id = transaction.id;
        this.date = transaction.date;
        this.debits = (transaction.entries || []).filter((entry) => entry.side_id === 2).map((e) => ({
          id: e.id,
          item_id: e.item.id,
          amount: e.amount,
        }));
        this.credits = (transaction.entries || []).filter((entry) => entry.side_id === 1).map((e) => ({
          id: e.id,
          item_id: e.item.id,
          amount: e.amount,
        }));
        this.description = transaction.description;
      } else {
        this.id = null;
        this.date = null;
        this.debits = [{item_id: null, amount: null}];
        this.credits = [{item_id: null, amount: null}];
        this.description = "";
      }
    },
    /**
     * このモーダルを除去します
     */
    close: function() {
      // TODO 入力がある場合に確認を行う
      this.isShow = false;
    },
    /**
     * このモーダルの入力内容を登録します
     */
    submit: function() {
      let data = {
        transaction: {
          id: this.id,
          date: this.date,
          entries: ([]).concat(
            this.debits.map((e) => ({side_id: 1, item_id: e.item_id, amount: e.amount})),
            this.credits.map((e) => ({side_id: 2, item_id: e.item_id, amount: e.amount})),
          ),
          description: this.description,
        }
      };

      ((this.id)
       ? axios.put(`api/transactions/${this.id}`, data)
       : axios.post('api/transactions', data)
      ).then((res) => {
        console.log(res);
        this.close();
        this.$emit('submitted', res.data.data);
      });
    }
  }
}
</script>
