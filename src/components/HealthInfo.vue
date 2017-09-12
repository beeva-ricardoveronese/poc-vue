<template>

  <f7-col>
    <f7-block-title>{{name}}</f7-block-title>
    <f7-progressbar :progress="value"></f7-progressbar>
  </f7-col>

</template>

<script>
  export default {
    name: 'healthInfo',
    props: ['name', 'value']
  }
</script>
