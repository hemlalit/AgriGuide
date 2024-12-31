const Product = require('../models/productModel');
const Vendor = require('../models/vendorModel');
const Cart = require('../models/cartModel');
const User = require('../models/profileModel'); // Assuming you have a User model for managing favorites

exports.getProducts = async (req, res) => {
  try {
    const products = await Product.find();
    res.status(200).json(products);
  } catch (error) {
    console.error('Error fetching products:', error);
    res.status(500).json({ error: 'Failed to fetch products', details: error.message });
  }
};

exports.addProduct = async (req, res) => {
  try {
    const product = new Product(req.body);
    await product.save();
    res.status(201).json(product);
  } catch (error) {
    console.error('Error adding product:', error);
    res.status(400).json({ error: 'Failed to add product', details: error.message });
  }
};

exports.fetchVendorDetails = async (req, res) => {
  try {
    id = req.params.id
    const vendor = await Vendor.findById(id).select('-password');
    res.status(200).json(vendor);
  } catch (error) {
    console.error('Error fetching products:', error);
    res.status(500).json({ error: 'Failed to fetch products', details: error.message });
  }
}

exports.deleteProduct = async (req, res) => {
  try {
    const { productId } = req.params;
    const product = await Product.findByIdAndDelete(productId);
    if (!product) {
      return res.status(404).json({ error: 'Product not found' });
    }
    res.status(200).json({ message: 'Product deleted successfully' });
  } catch (error) {
    console.error('Error deleting product:', error);
    res.status(500).json({ error: 'Failed to delete product', details: error.message });
  }
};

exports.getCart = async (req, res) => {
  try {
    const cart = await Cart.findOne({ userId: req.params.userId }).populate('items.productId');
    res.status(200).json(cart);
  } catch (error) {
    console.error('Error fetching cart:', error);
    res.status(500).json({ error: 'Failed to fetch cart', details: error.message });
  }
};

exports.addToCart = async (req, res) => {
  try {
    const { userId, productId, quantity } = req.body;
    let cart = await Cart.findOne({ userId });
    if (!cart) {
      cart = new Cart({ userId, items: [] });
    }
    const itemIndex = cart.items.findIndex(item => item.productId.equals(productId));
    if (itemIndex > -1) {
      cart.items[itemIndex].quantity += quantity;
    } else {
      cart.items.push({ productId, quantity });
    }
    await cart.save();
    res.status(200).json(cart);
  } catch (error) {
    console.error('Error adding to cart:', error);
    res.status(400).json({ error: 'Failed to add to cart', details: error.message });
  }
};

exports.updateProduct = async (req, res) => {
  try {
    const { productId } = req.params;
    const updatedData = req.body;
    const product = await Product.findByIdAndUpdate(productId, updatedData, {
      new: true,
    });
    if (!product) {
      return res.status(404).json({ error: 'Product not found' });
    }
    res.status(200).json(product);
  } catch (error) {
    console.error('Error updating product:', error);
    res.status(400).json({ error: 'Failed to update product', details: error.message });
  }
};

exports.removeFromCart = async (req, res) => {
  try {
    const { userId, productId } = req.params;
    const cart = await Cart.findOne({ userId });
    if (!cart) {
      return res.status(404).json({ error: 'Cart not found' });
    }
    cart.items = cart.items.filter(item => !item.productId.equals(productId));
    await cart.save();
    res.status(200).json(cart);
  } catch (error) {
    console.error('Error removing item from cart:', error);
    res.status(500).json({ error: 'Failed to remove item from cart', details: error.message });
  }
};

exports.clearCart = async (req, res) => {
  try {
    const { userId } = req.params;
    const cart = await Cart.findOne({ userId });
    if (!cart) {
      return res.status(404).json({ error: 'Cart not found' });
    }
    cart.items = [];
    await cart.save();
    res.status(200).json(cart);
  } catch (error) {
    console.error('Error clearing cart:', error);
    res.status(500).json({ error: 'Failed to clear cart', details: error.message });
  }
};

exports.toggleFavorite = async (req, res) => {
  try {
    const { productId } = req.params;
    const product = await Product.findById(productId);
    if (!product) {
      return res.status(404).json({ error: 'product not found' });
    }
    if (product.likes.includes(productId)) {
      product.likes = product.likes.filter(id => id !== productId);
    } else {
      product.likes.push(productId);
    }
    await product.save();
    res.status(200).json(user.favorites);
  } catch (error) {
    console.error('Error toggling favorite status:', error);
    res.status(500).json({ error: 'Failed to toggle favorite status', details: error.message });
  }
};

exports.incrementLikes = async (req, res) => {
  try {
    const { productId } = req.params;
    const product = await Product.findById(productId);
    if (!product) {
      return res.status(404).json({ error: 'Product not found' });
    }
    product.likes += 1;
    await product.save();
    res.status(200).json(product);
  } catch (error) {
    console.error('Error incrementing likes:', error);
    res.status(500).json({ error: 'Failed to increment likes', details: error.message });
  }
};
