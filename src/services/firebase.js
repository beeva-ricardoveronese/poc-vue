// Import Firebase
import Firebase from 'firebase'

// Setup Firebase
const config = {
  apiKey: 'AIzaSyA7SSwMNTL3qBmvVwgythV5K81yCMvMczs',
  authDomain: 'testproject-c24bd.firebaseapp.com',
  databaseURL: 'https://testproject-c24bd.firebaseio.com',
  projectId: 'testproject-c24bd',
  storageBucket: 'testproject-c24bd.appspot.com',
  messagingSenderId: '1003297550753'
}

const firebase = Firebase.initializeApp(config)

export default {
  database: firebase.database()
}
