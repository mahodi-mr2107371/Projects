const mongoose = require("mongoose");

const PaperSchema = new mongoose.Schema({
  title: { type: String, required: true },
  abstract: { type: String, required: true },
  authors: [
    {
      name: { type: String, required: true },
      email: { type: String, required: true },
      affiliation: { type: String, required: true },
      presenter: { type: Boolean, required: true },
    },
  ],
  file: { type: String, required: true },
  status: { type: String, required: true },
  reviewers: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },
  ],
});

module.exports = mongoose.model("Paper", PaperSchema);
