<template>
<div>
  <span>集計期間</span>
  <input type="date" :value="period[0]" @change="onChange($event, 0)"/>
  <span>〜</span>
  <input type="date" :value="period[1]" @change="onChange($event, 1)"/>
</div>
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
  computed: {
    // value を表示フォーマットに変換する
    period: function() {
      return this.value.map((date) => moment(date).format('YYYY-MM-DD'))
    },
  },
  methods: {
    // 選択変更時に変更イベントを emit する
    onChange(e, index) {
      const date = moment(e.target.value, 'YYYY-MM-DD').toDate();
      this.value.splice(index, 1, date);
      this.$emit('change', this.value);
    },
  }
}
</script>
