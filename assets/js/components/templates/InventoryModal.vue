<template>
<md-dialog :md-active.sync="isShow" md-fullscreen="false">
  <md-dialog-title>
    <span>棚卸高登録</span>
  </md-dialog-title>

  <md-toolbar>{{ item.name }}@{{ date | utc('YYYY/MM/DD') }}</md-toolbar>
  <md-field>
    <label for="amount">棚卸高</label>
    <md-input v-model="amount" />
  </md-field>

  <md-dialog-actions>
    <md-button class="" @click="close">キャンセル</md-button>
    <md-button class="md-primary" @click="submit">登録</md-button>
  </md-dialog-actions>
</md-dialog>
</template>

<script>
import moment from 'moment';
import axios from "axios";

export default {
  name: 'InventoryModal',
  components: {},
  props: {
    title: String
  },
  data: () => ({
    isShow: false,
    item: {},
    date: new Date(),
    amount: 0,
  }),
  methods: {
    /**
     * このモーダルを表示します
     */
    open: function(inventory) {
      this.isShow = true;
      this.item = inventory.item;
      this.date = inventory.date || moment().startOf('day').toDate();
      this.amount = inventory.amount;
    },
    /**
     * このモーダルを除去します
     */
    close: function() {
      this.isShow = false;
    },
    /**
     * このモーダルの入力内容を登録します
     */
    submit: function() {
      // TODO
      // let data = {
      //   transaction: {
      //     id: this.id,
      //     date: moment(this.date).format('YYYY-MM-DDTHH:mm:ss.SSS') + 'Z',
      //     entries: ([]).concat(
      //       this.debits.map((e) => ({side_id: 1, item_id: e.item_id, amount: e.amount})),
      //       this.credits.map((e) => ({side_id: 2, item_id: e.item_id, amount: e.amount})),
      //     ),
      //     description: this.description,
      //   }
      // };

      // ((this.id)
      //  ? axios.put(`api/transactions/${this.id}`, data)
      //  : axios.post('api/transactions', data)
      // ).then((res) => {
      //   this.close();
      //   this.$emit('submitted', res.data.data);
      // });
    }
  },
  filters: {
    utc: function(date, formatString) {
      return moment.utc(date).format(formatString);
    },
  },
}
</script>
