<template>
  <md-content>
    <md-sub-header>集計期間</md-sub-header>
    <div class="md-layout">
      <span class="md-layout-item">
        <md-datepicker :value="period[0]" @change="onChange($event, 0)" md-immediately>
          <label>From</label>
        </md-datepicker>
      </span>
      <span class="md-layout-item">
        <md-datepicker :value="period[1]" @change="onChange($event, 1)" md-immediately>
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
