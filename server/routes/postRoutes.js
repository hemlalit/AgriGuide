const express = require("express");
const {
    createTweet, retweetTweet, getHomeFeed, likeTweet, getComments, addComment, getPost  } = require("../controllers/postController");
const authMiddleware = require("../middlewares/authenticateToken");
const postMiddleware = require("../middlewares/postMiddleware");

const router = express.Router();

// Route for creating a new tweet
router.post("/", authMiddleware, createTweet);

// Route for fetching the home feed
router.get("/feed", postMiddleware, getHomeFeed);
router.get("/getPost/:id", getPost);

// Route for liking a tweet
router.put("/like/:id", authMiddleware, likeTweet);

// Route for adding a comment to a tweet
router.post("/comments/add/:tweetId", authMiddleware, addComment);

// Route for fetching comments to a tweet
router.get("/comments/:tweetId", authMiddleware, getComments);

// Route for retweet
router.post("/:tweetId/retweet", authMiddleware, retweetTweet);

module.exports = router;
