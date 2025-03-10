const Paper = require("../models/paper");

class PaperRepository {
  async createPaper(paperData) {
    const paper = new Paper(paperData);
    return await paper.save();
  }

}

module.exports = PaperRepository;
