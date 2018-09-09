<template>
<div>
  <div class="md-title">棚卸</div>

  {{ notice }}
  todo
</div>
</template>

<style scoped>
.fixed-bottom {
    position: fixed;
    bottom: 0;
}
</style>

<script>
import moment from "moment";
import axios from "axios";
import _ from "lodash";

export default {
  name: 'Inventories',
  components: {
  },
  data: function() {
    return {
    }
  },
  created: function() {
    this.reload();
  },
  methods: {
    reload: function() {
      Promise.all([
        axios.get('api/inventories/current', {}),
      ]).then(() => {
      });
    },
  }
}
</script>
