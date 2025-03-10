const mongoose = require('mongoose');

const ReviewSchema = new mongoose.Schema({
  paperId: {
    type: String,
    required: true,
  },
  userEmail: {
    type: String,
    required: true,
  },
  overallEvaluation: {
    type: String,
    required: true,
  },
  paperContribution: {
    type: Number,
    required: true,
  },
  paperStrengths: {
    type: String,
    required: true,
  },
  paperWeaknesses: {
    type: String,
    required: true,
  },
});

const ReviewModel = mongoose.model('Review', ReviewSchema);

class ReviewRepository {
  async findReviewsByPaperId(paperId) {
    return await ReviewModel.find({ paperId });
  }

  async createReview(reviewData) {
    const review = new ReviewModel(reviewData);
    return await review.save();
  }
}

module.exports = ReviewRepository;
