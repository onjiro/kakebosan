<template>
<div>
  {{ notice }}
  <recent-history/>
  <entry-modal ref="entryModal"/>
  <new-entry-button-form @click.native="openEntryModal" />
</div>
</template>

<style scoped>
</style>

<script>
import Vue from 'vue';
import VueMdl from 'vue-mdl';
Vue.use(VueMdl);

import NewEntryButtonForm from '@/components/organisms/NewEntryButtonForm';
import RecentHistory from '@/components/organisms/RecentHistory';
import EntryModal from '@/components/organisms/EntryModal';

export default {
  name: 'DashBoard',
  components: {
    NewEntryButtonForm,
    RecentHistory,
    EntryModal
  },
  methods: {
    /**
     * 登録モーダルを開きます
     */
    openEntryModal: function() {
      this.$refs.entryModal.open();
    }
  }
}
</script>
