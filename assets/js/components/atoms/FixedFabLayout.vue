<template>
<span class="layout">
  <slot></slot>
</span>
</template>

<style scoped>
.layout {
    position: fixed;
    bottom: 40px;
    right: 24px;
}
</style>

<script>
export default {
  name: 'FixedFabLayout'
}
</script>
