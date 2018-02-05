<template>
<fixed-fab-layout>
  <mdl-button primary fab
              class="mdl-js-ripple-effect"
              icon="create">
  </mdl-button>
</fixed-fab-layout>
</template>

<script>
import FixedFabLayout from '@/components/atoms/FixedFabLayout';
export default {
  name: 'NewEntryButtonForm',
  components: {
    FixedFabLayout
  }
}
</script>
