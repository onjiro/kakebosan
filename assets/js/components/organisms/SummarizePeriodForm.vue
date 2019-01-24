<template>
<div>
  <span>集計期間</span>
  <input type="date"/>
  <span>〜</span>
  <input type="date"/>
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
  data: function() {
    return {
    }
  },
  created: function() {
  },
  methods: {
  }
}
</script>
