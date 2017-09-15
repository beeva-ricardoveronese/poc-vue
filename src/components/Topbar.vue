<template>
  <f7-grid>

    <f7-col v-for="item in info">
      <health-info :name="item.name" :value="item.value"></health-info>
    </f7-col>

  </f7-grid>
</template>

<script>
  import eventHub from '../events/hub.js'
  import healthInfo from '../components/HealthInfo'

  export default {
    name: 'topbar',
    components: {
      healthInfo: healthInfo
    },
    data () {
      return {
        info: [
          {name: 'CHO', value: 15},
          {name: 'Protein', value: 25},
          {name: 'Vitamin', value: 30},
          {name: 'Fat', value: 80}]
      }
    },
    mounted () {
      eventHub.$on('nutrient', (val) => {
        this.info[0].value += val
      })
    }
  }
</script>
