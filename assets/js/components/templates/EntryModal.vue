<template>
<md-dialog :md-active.sync="isShow" md-fullscreen="false">
  <md-dialog-title>{{title}}</md-dialog-title>

  <md-datepicker v-model="date" />

  <entry-side-form title="借方" v-model="debits"/>

  <entry-side-form title="貸方" v-model="credits"/>

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

export default {
  name: 'EntryModal',
  components: { EntrySideForm },
  props: ['title'],
  data: () => ({
    isShow: false,

    date: null,
    debits:  [{type: 0, amount: null}],
    credits: [{type: 0, amount: null}],
    description: ""
  }),
  methods: {
    /**
     * このモーダルを表示します
     */
    open: function() {
      this.isShow = true;
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
      // TODO
      console.log(this.date, this.debits, this.credits, this.description);
    }
  }
}
</script>
