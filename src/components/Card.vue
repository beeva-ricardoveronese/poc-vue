<template>
  <f7-block>
    <f7-grid>

      <section id="drag" class="dragArea">
        <div v-for="item in shoppingList" v-draggable.shoppingList="item"
             class="container-button inline-block col-50">
          <f7-button >{{item.name}}</f7-button>
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

  export default {
    name: 'card',
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
        ],
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

  .dragArea .button {
    margin: 25px;
    height: 50px;
  }

  .inline-block {
    display: inline-block;
  }

</style>
