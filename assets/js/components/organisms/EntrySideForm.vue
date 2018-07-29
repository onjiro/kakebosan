<template>
<div>
  <md-toolbar>{{title}}</md-toolbar>

  <div v-for="entry in value">
    <div class="md-layout md-gutter">
      <div class="md-layout-item">
        <md-field>
          <label for="item">科目</label>
          <md-select name="item" v-model="entry.item_id">
            <md-option v-for="item in items" :value="item.id">{{item.name}}</md-option>
          </md-select>
        </md-field>
      </div>
      <div class="md-layout-item">
        <md-field>
          <label for="item">金額</Label>
          <md-input v-model="entry.amount" />
        </md-field>
      </div>
    </div>
  </div>
  <md-button @click="addEntryLine"><md-icon>add</md-icon></md-button>
</div>
</template>

<style>
.md-menu-content.md-select-menu {
    z-index: 11;
}
</style>

<script>
export default {
  name: 'EntrySideForm',
  props: {
    value: Array,
    title: String,
    items: Array
  },
  methods: {
    /**
     * 新規行を追加します
     */
    addEntryLine: function() {
      this.$emit('input', this.value.concat({ item_id: null, amount: null }));
    }
  }
}
</script>
