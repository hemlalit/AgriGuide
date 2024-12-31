const express = require('express');
const router = express.Router();
const {
  getProducts,
  addProduct,
  updateProduct,
  deleteProduct,
  getCart,
  addToCart,
  removeFromCart,
  clearCart,
  toggleFavorite,
  incrementLikes,
  fetchVendorDetails
} = require('../controllers/marketplaceController');

router.get('/:id', fetchVendorDetails); // Fetch all products

// Product routes
router.get('/', getProducts); // Fetch all products
router.post('/', addProduct); // Add a new product
router.put('/:productId', updateProduct); // Update a specific product
router.delete('/:productId', deleteProduct); // Delete a specific product

// Cart routes
router.get('/cart/:userId', getCart); // Fetch user's cart
router.post('/cart/add', addToCart); // Add a product to the cart
router.delete('/cart/remove/:userId/:productId', removeFromCart); // Remove a product from the cart
router.delete('/cart/clear/:userId', clearCart); // Clear user's cart

// Favorites and likes routes
router.post('/favorite/toggle/:productId', toggleFavorite); // Toggle favorite status for a product
router.post('/likes/increment/:productId', incrementLikes); // Increment likes for a product

module.exports = router;
