<template>
  <f7-block>
    <f7-grid>
      <div>
        <h3>History:</h3>
        <ul>
          <li v-for="msg in history">{{msg}}</li>
        </ul>
      </div>
      <draggable 
        class="dragArea" 
        :options="{group:'people'}"
        @change="afterAdd"
        @click="addNutrient"
        :list="items">
        <div
          class="card-item"
          v-for="(item, index) in items" 
          :key="index">
          <h3>{{item.name}}</h3>
          <button class="remove-item" v-on:click="removeJob(items, index)">Remove</button>
        </div>
      </draggable>

    </f7-grid>
  </f7-block>
</template>

<script>
  import draggable from 'vuedraggable'

  export default {
    name: 'card',
    components: {
      draggable
    },
    data () {
      return {
        items: [
          { name: 'Alan', content: 'a' },
          { name: 'Blake', content: 'b' },
          { name: 'Chris', content: 'c' },
          { name: 'Dora', content: 'd' },
          { name: 'Ellen', content: 'e' }
        ],
        history: []
      }
    },
    methods: {
      afterAdd (evt) {
        console.log(evt)
        const element = evt.moved.element
        const oldIndex = evt.moved.oldIndex
        const newIndex = evt.moved.newIndex
        this.history.push(`${element.name} is moved from position ${oldIndex} to ${newIndex}`)
      },

      removeJob (items, index) {
        // Remove job from GUI
        items.splice(index, 1)
      }
    }
  }
</script>

<style>
  .dragArea {
    width: 100%;
  }

  .dragArea .card-item {
    position: relative;
    display: block;
    text-align: center;
    border: 1px solid #b6b6b6;
    border-radius: 5px;
    color: #000;
    background: #f7f7f8;
    cursor: pointer;
    padding: 0 10px;
    margin: 10px 0;
  }

  .dragArea .card-item .remove-item {
    position: absolute;
    bottom: 0;
    left: 0;
  }
</style>