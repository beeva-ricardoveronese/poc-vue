<template>
  <f7-grid>

    <f7-col v-for="item in info">
      <health-info :name="item.name" :value="item.value"></health-info>
    </f7-col>

  </f7-grid>
</template>

<script>
  import firebase from '../services/firebase'
  import eventHub from '../events/hub.js'
  import healthInfo from '../components/HealthInfo'

  export default {
    name: 'topbar',
    components: {
      healthInfo: healthInfo
    },
    firebase: {
      info: firebase.database.ref('healthinfo')
    },
    mounted () {
      eventHub.$on('nutrient', (val) => {
        const item = {name: this.info[0].name, value: this.info[0].value + val}
        const key = this.info[0]['.key']
        this.$firebaseRefs.info.child(key).set(item)
      })
    }
  }
</script>
