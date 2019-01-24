<template>
<div>
  <div class="md-title">集計</div>
  
  {{ notice }}
  
  <summarize-period-form />
  <summary-results />
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
    }
  },
  created: function() {
  },
  methods: {
  }
}
</script>
