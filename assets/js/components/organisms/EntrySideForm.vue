<template>
<div>
  <md-toolbar>{{title}}</md-toolbar>

  <div v-for="entry in value">
    <div class="md-layout md-gutter">
      <div class="md-layout-item">
        <md-field>
          <label for="type">科目</label>
          <md-select name="type" v-model="entry.type">
            <md-option>-</md-option>
            <md-option>-</md-option>
            <md-option>-</md-option>
            <md-option>-</md-option>
          </md-select>
        </md-field>
      </div>
      <div class="md-layout-item">
        <md-field>
          <label for="type">金額</Label>
          <md-input v-model="entry.amount" />
        </md-field>
      </div>
    </div>
  </div>
  <md-button @click="addEntryLine"><md-icon>add</md-icon></md-button>
</div>
</template>

<script>
export default {
  name: 'EntrySideForm',
  props: {
    'value': Array,
    'title': String
  },
  methods: {
    /**
     * 新規行を追加します
     */
    addEntryLine: function() {
      this.$emit('input', this.value.concat({ type: 0, amount: null }));
    }
  }
}
</script>
