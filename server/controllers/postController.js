const Tweet = require("../models/postModel");
const mongoose = require('mongoose');

// Create a new Tweet
exports.createTweet = async (req, res) => {
  const { content } = req.body;
  const userId = req.userId; // User ID from JWT token

  try {
    const newTweet = await Tweet.create({ content, author: userId });

    // Populate the author field to include the author's name
    const populatedTweet = await newTweet.populate('author', 'name');

    // Return the tweetId along with the newTweet data and author name
    res.status(201).json({
      postId: newTweet._id,
      authorName: populatedTweet.author.name,
      tweet: newTweet,
    });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};


// Get Tweets for Home Feed
exports.getHomeFeed = async (req, res) => {
  // const userId = req.userId;

  try {
    const tweets = await Tweet.find()
      .populate('author', 'name username profileImage')
      .populate('comments.commentedBy', 'username')
      .sort({ createdAt: -1 });
    res.status(200).json(tweets);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

// Get a specific post
exports.getPost = async (req, res) => {
  const postId = req.params.id;

  try {
    const tweet = await Tweet.findById(postId)
      .populate('author', 'name username profileImage')
      .populate('comments.commentedBy', 'username')

    if (!tweet) {
      return res.status(404).json({ error: 'Post not found' });
    }

    res.status(200).json(tweet);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

// Like or Unlike a Tweet
exports.likeTweet = async (req, res) => {
  const tweetId = req.params.id;
  const userId = req.userId;

  try {
    const tweet = await Tweet.findById(tweetId);
    if (!tweet) return res.status(404).json({ message: "Tweet not found" });

    const isLiked = tweet.likes.includes(userId);
    if (isLiked) {
      tweet.likes.pull(userId);
    } else {
      tweet.likes.push(userId);
    }

    await tweet.save();
    res.status(200).json({ message: isLiked ? "Unliked" : "Liked" });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.getComments = async (req, res) => {
  try {
    const { tweetId } = req.params;

    // Check if the tweetId is valid
    if (!mongoose.Types.ObjectId.isValid(tweetId)) {
      console.log('Invalid tweet ID:', tweetId);
      return res.status(400).json({ message: 'Invalid tweet ID' });
    }

    // Log the request
    console.log(`Fetching comments for tweet ID: ${tweetId}`);

    // Find the tweet by ID
    const tweet = await Tweet.findById(tweetId).populate('comments.commentedBy', 'name username profileImage');
    if (!tweet) {
      return res.status(404).json({ message: 'Tweet not found' });
    }

    // Log the number of comments found
    console.log(`Number of comments found: ${tweet.comments.length}`);

    // Respond with the comments
    res.status(200).json(tweet.comments);
  } catch (error) {
    // Log the error
    console.error(`Error fetching comments: ${error.message}`);

    // Send a server error response
    res.status(500).json({ message: 'Server Error' });
  }
};


// Fetch comments for a specific tweet
exports.addComment = async (req, res) => {
  const { content } = req.body;
  const { tweetId } = req.params;
  const commentedBy = req.userId; // From auth middleware

  try {
    // Check if the tweetId is valid
    if (!mongoose.Types.ObjectId.isValid(tweetId)) {
      console.log('Invalid tweet ID:', tweetId);
      return res.status(400).json({ message: 'Invalid tweet ID' });
    }

    // Log the comment content and user ID
    console.log('Adding comment:', { content, tweetId, commentedBy });

    // Find the tweet by ID and add the comment
    const tweet = await Tweet.findById(tweetId);
    if (!tweet) {
      return res.status(404).json({ message: 'Tweet not found' });
    }

    // Add the comment to the tweet
    const newComment = {
      commentedBy,
      content,
      timestamp: new Date()
    };
    tweet.comments.push(newComment);

    // Save the updated tweet
    await tweet.save();

    // Log success and return the new comment
    console.log('Comment added successfully:', newComment);
    res.status(201).json(newComment);
  } catch (error) {
    // Log the error
    console.error('Error adding comment:', error.message);

    // Send a server error response
    res.status(500).json({ message: 'Server Error' });
  }
};



// Retweet a Tweet
exports.retweetTweet = async (req, res) => {
  const { tweetId } = req.params; // Original tweet ID
  const userId = req.userId; // User performing the retweet

  try {
    // Find the original tweet
    const originalTweet = await Tweet.findById(tweetId);
    if (!originalTweet) {
      return res.status(404).json({ message: "Tweet not found" });
    }

    // Check if the user has already retweeted this tweet
    const hasAlreadyRetweeted = originalTweet.retweetedBy.includes(userId);
    if (hasAlreadyRetweeted) {
      return res
        .status(400)
        .json({ message: "You have already retweeted this tweet." });
    }

    // Increment retweet count and add user to retweetedBy list
    originalTweet.retweetCount += 1;
    originalTweet.retweetedBy.push(userId);
    await originalTweet.save();

    // Optionally: Create a new "retweet" for the user’s feed (if needed)
    const retweet = await Tweet.create({
      content: originalTweet.content, // Use the original tweet's content
      author: userId, // The user who retweeted
      originalTweet: tweetId, // Reference to the original tweet
    });

    res.status(201).json({
      message: "Retweet successful",
      retweet,
    });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

