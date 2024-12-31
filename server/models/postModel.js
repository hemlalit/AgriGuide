const mongoose = require("mongoose");

const commentSchema = new mongoose.Schema({
  commentedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  content: {
    type: String,
    required: true
  },
  timestamp: {
    type: Date,
    default: Date.now
  }
});

const tweetSchema = new mongoose.Schema(
  {
    content: { type: String, trim: true }, // Content of the tweet
    author: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    likes: [{ type: mongoose.Schema.Types.ObjectId, ref: "User" }], // Array of user IDs for likes
    comments: [commentSchema],
    retweetedBy: [{ type: mongoose.Schema.Types.ObjectId, ref: "User" }], // Users who retweeted this tweet
    retweetCount: { type: Number, default: 0 }, // Count of retweets
    originalTweet: { type: mongoose.Schema.Types.ObjectId, ref: "Tweet" }, // Reference to the original tweet (if this is a retweet)
  },
  { timestamps: true } // Automatically adds `createdAt` and `updatedAt`
);

module.exports = mongoose.model("Tweet", tweetSchema);
