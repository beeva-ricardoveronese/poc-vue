// Import Firebase
import Firebase from 'firebase'

// Setup Firebase
import configFirebase from '../../config/firebase'

const config = {
  apiKey: configFirebase.API_KEY,
  authDomain: configFirebase.PROJECT_ID + '.firebaseapp.com',
  databaseURL: 'https://' + configFirebase.DATABASE_NAME + '.firebaseio.com',
  projectId: configFirebase.PROJECT_ID,
  storageBucket: configFirebase.BUCKET + '.appspot.com',
  messagingSenderId: configFirebase.MESSAGING_SENDER_ID
}

const firebase = Firebase.initializeApp(config)

export default {
  database: firebase.database()
}
