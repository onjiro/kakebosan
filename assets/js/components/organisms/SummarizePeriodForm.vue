<template>
  <md-content>
    <md-sub-header>集計期間</md-sub-header>
    <div class="md-layout">
      <span class="md-layout-item">
        <md-datepicker :value="value[0]" @input="onChange($event, 0)" md-immediately>
          <label>From</label>
        </md-datepicker>
      </span>
      <span class="md-layout-item">
        <md-datepicker :value="value[1]" @input="onChange($event, 1)" md-immediately>
          <label>To</label>
        </md-datepicker>
      </span>
    </div>
  </md-content>
</template>

<style scoped>
</style>

<script>
import moment from "moment";
import axios from "axios";
import _ from "lodash";

export default {
  name: 'SummarizePeriodForm',
  components: {
  },
  props: {
    value: Array // Date[] にてやりとりする
  },
  methods: {
    // 選択変更時に変更イベントを emit する
    onChange(value, index) {
      // md-datepicker では値選択時、連続して数回同じ値で change イベントを送ってくることがある。
      // イベントから送出された値が現在の設定値と同じ場合、処理したくないので無視する。
      if (value.valueOf() === this.value[index].valueOf()) {
        return;
      }
      this.value.splice(index, 1, value);
      this.$emit('change', this.value);
    },
  }
}
</script>
