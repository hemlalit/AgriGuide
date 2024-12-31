const mongoose = require('mongoose');
const bcrypt = require("bcryptjs");

const vendorSchema = new mongoose.Schema({
  name: { type: String },
  username: { type: String, unique: true },
  email: { type: String, unique: true },
  phone: { type: String },
  password: { type: String },
  compName: { type: String },
  address: {
    street: { type: String },
    city: { type: String },
    state: { type: String },
    zipCode: { type: String },
  },
  products: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Product' }],
}, { timestamps: true });

vendorSchema.pre("save", async function (next) {
  if (!this.isModified("password")) return next();
  this.password = await bcrypt.hash(this.password, 10);
  next();
});

module.exports = mongoose.model('Vendor', vendorSchema);
