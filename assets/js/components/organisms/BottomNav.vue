<template>
  <md-bottom-bar md-sync-route>
    <md-bottom-bar-item to="/" md-label="履歴" md-icon="list"></md-bottom-bar-item>
    <md-bottom-bar-item to="/inventories" md-label="棚卸" md-icon="assignment_turned_in"></md-bottom-bar-item>
  </md-bottom-bar>
</template>

<style>
.md-bottom-bar {
    position: fixed;
    bottom: 0;
}
</style>

<script>
export default {
  name: 'bottom-nav'
}
</script>
