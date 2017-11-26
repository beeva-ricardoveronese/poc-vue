<template>
  <f7-block>
    <f7-grid>

      <section id="drag" class="dragArea">
        <div v-for="item in shoppingList" v-draggable.shoppingList="item"
             class="container-button inline-block col-50">
          <card :name="item.name"></card>
        </div>
      </section>

      <section id="drop" v-droppable.shoppingList="afterAdd">
        <f7-fab color="pink" @click="">
          <span>GO!</span>
        </f7-fab>
      </section>

    </f7-grid>
  </f7-block>
</template>




<script>
  import eventHub from '../events/hub.js'
  import firebase from '../services/firebase'
  import card from '../components/Card'

  export default {
    name: 'board',
    components: {
      card: card
    },
    firebase: {
      shoppingList: firebase.database.ref('shoppingList')
    },
    data () {
      return {
        home: []
      }
    },
    methods: {
      afterAdd (item) {
        item = JSON.parse(item)
        // Remove the shoppingList element
        this.shoppingList.splice(this.shoppingList.findIndex(o => item.id === o.id), 1)
        const healthInfo = item.healthInfo
        eventHub.$emit('nutrient', healthInfo)
      }
    }
  }
</script>




<style>

  .dragArea {
    width: 100%;
    margin-top: -30px;
  }

  .dragArea .card {
    margin: 25px;
    height: 50px;
  }

  .inline-block {
    display: inline-block;
  }

</style>
