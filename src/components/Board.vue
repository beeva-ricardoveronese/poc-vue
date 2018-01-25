<template>
  <f7-block>
    <f7-grid>

      <draggable
        class="dragArea"
        :options="{group:'cards'}"
        @change="afterAdd"
        @click=""
        @start="start()"
        @end="end()"
        :value="shoppingList">

        <div v-for="(item, index) in shoppingList"
             class="container-button inline-block col-50"
             :disabled="disabled">
          <card :name="item.name"></card>
        </div>

        <f7-fab>
          <icon name="shopping-cart"></icon>
        </f7-fab>

      </draggable>

    </f7-grid>
  </f7-block>
</template>

<script>
  import eventHub from '../events/hub.js'
  import firebase from '../services/firebase'
  import card from '../components/Card'
  import draggable from 'vuedraggable'

  export default {
    name: 'board',
    components: {
      card: card,
      draggable
    },
    firebase: {
      shoppingList: firebase.database.ref('shoppingList')
    },
    data () {
      return {
        disabled: false,
        home: []
      }
    },
    methods: {
      afterAdd (item) {
        this.shoppingList.splice(item.oldIndex, 1)
        const healthInfo = item.moved.element.healthInfo.slice(0)
        eventHub.$emit('nutrient', healthInfo)
      },
      start () {
        this.disabled = true
      },
      end () {
        this.disabled = false
      },
      removeItem (shoppingList, index) {
        shoppingList.splice(index, 1)
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

  .dragArea .card-content-inner {
    text-align: center;
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
