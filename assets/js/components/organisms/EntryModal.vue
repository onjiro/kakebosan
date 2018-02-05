<template>
<mdl-dialog ref="dialog">
  <div className="form-group">
    <InputDate value={this.state.date} onChange={this.handleChangeDate} ref="date"/>
  </div>
  
  <legend>借方</legend>
  <div className="form-group">{debits}</div>
  
  <legend>貸方</legend>
  <div className="form-group">{credits}</div>
  
  <template slot="actions">
    <mdl-button primary @click.native="submit">登録</mdl-button>
    <mdl-button @click.native="close">キャンセル</mdl-button>
  </template>
</mdl-dialog>
</template>

<script>
export default {
  name: 'EntryModal',
  props: ['title'],
  methods: {
    /**
     * このモーダルを表示します
     */
    open: function() {
      this.$refs.dialog.open();
    },
    /**
     * このモーダルを除去します
     */
    close: function() {
      // TODO 入力がある場合に確認を行う
      this.$refs.dialog.close();
    },
    /**
     * このモーダルの入力内容を登録します
     */
    submit: function() {
      // TODO
    }
  }
}
</script>
