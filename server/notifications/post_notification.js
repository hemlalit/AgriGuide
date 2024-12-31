const admin = require('firebase-admin');
const serviceAccount = require('path/to/your/serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const message = {
  notification: {
    title: 'New Post',
    body: 'Someone has posted something new!'
  },
  topic: 'your-topic-name'
};

admin.messaging().send(message)
  .then((response) => {
    console.log('Successfully sent message:', response);
  })
  .catch((error) => {
    console.log('Error sending message:', error);
  });
