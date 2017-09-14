<template>

  <f7-block class="content-block-health-info" inner>
    <span>{{name}}</span>
    <f7-progressbar class="progressbar-health-info" :progress="value"></f7-progressbar>
    <span>{{value}} %</span>
  </f7-block>

</template>

<script>
  export default {
    name: 'healthInfo',
    props: ['name', 'value']
  }
</script>

<style>
  .content-block-health-info {
    margin: inherit;
    padding: 0px 5px 0px 5px;
    text-align: center;
  }

  .progressbar-health-info {
    padding-top: 5px;
    padding-bottom: 5px;
  }

</style>
