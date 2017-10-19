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
          <f7-button >{{item.name}}</f7-button>
        </div>

        <f7-fab color="pink" @click="">
          <span>GO!</span>
        </f7-fab>

      </draggable>

    </f7-grid>
  </f7-block>
</template>

<script>
  import draggable from 'vuedraggable'
  import eventHub from '../events/hub.js'

  export default {
    name: 'card',
    components: {
      draggable
    },
    data () {
      return {
        disabled: false,
        shoppingList: [
          { id: 1, name: 'Oranges', healthInfo: [{name: 'CHO', value: 5}, {name: 'Protein', value: 2}, {name: 'Vitamin', value: 20}, {name: 'Fat', value: 0}] },
          { id: 2, name: 'Egs', healthInfo: [{name: 'CHO', value: 10}, {name: 'Protein', value: 15}, {name: 'Vitamin', value: 10}, {name: 'Fat', value: 5}] },
          { id: 3, name: 'Lettuce', healthInfo: [{name: 'CHO', value: 5}, {name: 'Protein', value: 5}, {name: 'Vitamin', value: 12}, {name: 'Fat', value: 2}] },
          { id: 4, name: 'Chicken', healthInfo: [{name: 'CHO', value: 10}, {name: 'Protein', value: 20}, {name: 'Vitamin', value: 10}, {name: 'Fat', value: 3}] },
          { id: 5, name: 'Salmon', healthInfo: [{name: 'CHO', value: 15}, {name: 'Protein', value: 18}, {name: 'Vitamin', value: 15}, {name: 'Fat', value: 8}] },
          { id: 6, name: 'Olive Oil', healthInfo: [{name: 'CHO', value: 20}, {name: 'Protein', value: 5}, {name: 'Vitamin', value: 15}, {name: 'Fat', value: 15}] },
          { id: 7, name: 'Turkey', healthInfo: [{name: 'CHO', value: 12}, {name: 'Protein', value: 20}, {name: 'Vitamin', value: 14}, {name: 'Fat', value: 3}] },
          { id: 8, name: 'Avocado', healthInfo: [{name: 'CHO', value: 12}, {name: 'Protein', value: 12}, {name: 'Vitamin', value: 25}, {name: 'Fat', value: 12}] },
          { id: 9, name: 'Potato', healthInfo: [{name: 'CHO', value: 20}, {name: 'Protein', value: 10}, {name: 'Vitamin', value: 10}, {name: 'Fat', value: 5}] },
          { id: 10, name: 'Apples', healthInfo: [{name: 'CHO', value: 5}, {name: 'Protein', value: 2}, {name: 'Vitamin', value: 25}, {name: 'Fat', value: 0}] },
          { id: 11, name: 'Beef', healthInfo: [{name: 'CHO', value: 25}, {name: 'Protein', value: 22}, {name: 'Vitamin', value: 10}, {name: 'Fat', value: 10}] }
        ]
      }
    },
    methods: {
      afterAdd (evt) {
        this.shoppingList.splice(evt.oldIndex, 1)
        const healthInfo = evt.moved.element.healthInfo.slice(0)
        eventHub.$emit('nutrient', healthInfo)
      },

      start () {
        this.disabled = true
      },

      end () {
        this.disabled = false
      },

      removeItem (shoppingList, index) {
        // Remove job from GUI
        shoppingList.splice(index, 1)
      }
    }
  }
</script>

<style>

  .dragArea {
    width: 100%;
    margin-top: -30px;
  }

  .dragArea .button {
    margin: 25px;
    height: 50px;
  }

  .inline-block {
    display: inline-block;
  }

  /*.dragArea .container-button:nth-child(-n+2) .button {*/
    /*margin-top: inherit;*/
  /*}*/

  /*.dragArea .container-button:nth-child(11) .button {*/
    /*margin-bottom: inherit;*/
  /*}*/

</style>
