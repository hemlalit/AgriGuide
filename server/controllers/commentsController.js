const Tweet = require("../models/postModel");

// Add a comment to a tweet
exports.addComment = async (req, res) => {
  const { tweetId } = req.params;
  const { userId, text } = req.body;

  try {
    const tweet = await Tweet.findById(tweetId);
    if (!tweet) {
      return res.status(404).json({ message: "Tweet not found" });
    }

    const comment = { userId, text };
    tweet.comments.push(comment);
    await tweet.save();

    res.status(201).json({ message: "Comment added successfully", comment });
  } catch (err) {
    res.status(500).json({ message: "Server error", error: err.message });
  }
};

// Get comments for a tweet
exports.getComments = async (req, res) => {
  const { tweetId } = req.params;

  try {
    const tweet = await Tweet.findById(tweetId).populate("comments.userId", "username");
    if (!tweet) {
      return res.status(404).json({ message: "Tweet not found" });
    }

    res.json({ comments: tweet.comments });
  } catch (err) {
    res.status(500).json({ message: "Server error", error: err.message });
  }
};
