const Token = require('../models/fcmTokenModel');
const admin = require('firebase-admin');
const serviceAccount = require('../notifications/agriguide-21792-firebase-adminsdk-w180h-1f6e4cb3d1.json');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

exports.sendPostNotification = async (req, res) => {
    const { title, body, authorToken, postId } = req.body;

    try {
        const tokens = await Token.find({ token: { $ne: authorToken } });

        if (tokens.length === 0) {
            res.status(400).send('No valid tokens to send notifications to');
            return;
        }

        const messagePromises = tokens.map(async (token) => {
            const message = {
                notification: {
                    title,
                    body,
                },
                data: { postId }, // Include post ID in the data payload
                token: token.token, // Send notification to each token
            };

            try {
                const response = await admin.messaging().send(message);
                console.log('Successfully sent message', response);
            } catch (error) {
                // Log the error and continue to the next token
                console.error('Error sending message to:', token.token, error);
            }
        });

        await Promise.all(messagePromises);

        res.status(200).send('Notifications sent successfully');
    } catch (error) {
        // Log the error and send a response
        console.error('Error sending messages:', error);
        res.status(500).send('Error sending notifications');
    }
};


exports.registerToken = async (req, res) => {
    const { token, userId } = req.body;

    try {
        const existingToken = await Token.findOne({ token });
        if (!existingToken) {
            await Token.create({ token, userId });
            res.status(200).send('Token registered successfully');
        } else {
            res.status(400).send('Token already registered');
        }
    } catch (error) {
        console.error('Error registering token:', error);
        res.status(500).send('Error registering token');
    }
};
