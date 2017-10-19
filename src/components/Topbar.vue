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
        val.forEach(item => {
          let el = this.info.find(o => o.name === item.name)
          el.value += item.value
          if (el.value > 100) el.value = 0

          // Save in firebase
          this.$firebaseRefs.info.child(el['.key']).set({name: el.name, value: el.value})
        })
      })
    }
  }
</script>
