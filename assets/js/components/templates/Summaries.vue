<template>
<div>
  <div class="md-title">集計</div>
  
  {{ notice }}
  
  <summarize-period-form v-model="period" @change="onPeriodChange"/>
  <div>
    <md-subheader>{{periodDisplayFormat[0]}} 〜 {{periodDisplayFormat[1]}}</md-subheader>
    <summary-results v-model="summaries"/>
  </div>
</div>
</template>

<style scoped>
</style>

<script>
import moment from "moment";
import axios from "axios";
import _ from "lodash";
import SummarizePeriodForm from '../organisms/SummarizePeriodForm'
import SummaryResults from '../organisms/SummaryResults'

export default {
  name: 'Summaries',
  components: {
    SummarizePeriodForm,
    SummaryResults
  },
  data: function() {
    return {
      period: [
        moment().subtract(1, 'month').startOf('day').toDate(),
        moment().startOf('day').toDate()
      ],
      summaries: [],
    }
  },
  created: function() {
    this.reload();
  },
  computed: {
    periodDisplayFormat() {
      return this.period && this.period.map((date) => moment(date).format("YYYY/MM/DD"))
    }
  },
  methods: {
    onPeriodChange() {
      this.reload();
    },
    reload() {
      Promise.all([
        axios.get('api/summaries', {
          params: {
            fromDate: this.period[0].toISOString(),
            toDate: this.period[1].toISOString(),
          }
        }),
      ]).then(([{ data: { data: summaries }}]) => {
        this.data = summaries;
      });
    }
  }
}
</script>
