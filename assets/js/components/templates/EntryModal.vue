<template>
<md-dialog :md-active.sync="isShow" md-fullscreen="false">
  <md-dialog-title>
    <span>{{title}}</span>
    <md-button v-if="!isNew" @click="remove"
               class="md-icon-button md-dense"
               style="position: absolute; top: 22px; right: 0;">
      <md-icon>delete</md-icon>
    </md-button>
  </md-dialog-title>

  <md-datepicker v-model="date" md-immediately />

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
  computed: {
    isNew() {
      return this.id === null;
    },
  },
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
        this.date = moment().startOf('day').toDate();
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
          date: moment(this.date).format('YYYY-MM-DDTHH:mm:ss.SSS') + 'Z',
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
        this.close();
        this.$emit('submitted', res.data.data);
      });
    },
    /**
     * 取引を削除します
     */
    remove: function() {
      if (!window.confirm("この取引を削除しますか？")) return;

      axios.delete(`api/transactions/${this.id}`).then((res) => {
        this.close();
        this.$emit('deleted', res.data.data);
      });
    }
  }
}
</script>
