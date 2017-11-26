<template>
  <f7-block>
    <f7-grid>

      <section id="drag" class="dragArea">
        <div v-for="item in shoppingList" v-draggable.shoppingList="item" class="container-button inline-block col-50">
          <card :name="item.name"></card>
        </div>
      </section>

      <section id="drop" v-droppable.shoppingList="afterAdd">
        <f7-fab>
          <icon name="shopping-cart"></icon>
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

  .fa-icon {
    user-select: none;
    pointer-events: none;
    width: auto;
    height: 1em; /* or any other relative font sizes */

    /* You would have to include the following two lines to make this work in Safari */
    max-width: 100%;
    max-height: 100%;
  }

  .dragArea {
    width: 100%;
    margin-top: -30px;
  }

  .dragArea .card {
    margin: 15px 10px;
    height: 50px;
  }

  .inline-block {
    display: inline-block;
  }

  .floating-button {
    width: 100px;
    height: 100px;
    font-size: 40px;
    color: #7362b1;
    border: none;
  }
  .floating-button.dragover,
  .floating-button .dragover  {
    font-size: 200px;
  }

  .floating-button,
  .floating-button.active-state, 
  .floating-button:active {
    background-color: transparent;
  }


</style>
