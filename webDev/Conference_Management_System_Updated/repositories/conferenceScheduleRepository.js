const mongoose = require("mongoose");

const ConferenceScheduleSchema = new mongoose.Schema({
  date: String,
  sessions: [
    {
      title: String,
      startTime: String,
      endTime: String,
      presentations: [
        {
          title: String,
          presenter: String,
        },
      ],
    },
  ],
});

const ConferenceScheduleModel = mongoose.model("ConferenceSchedule", ConferenceScheduleSchema);

class ConferenceScheduleRepository {
  async getConferenceSchedule() {
    return await ConferenceScheduleModel.find().exec();
  }

  async updateConferenceSchedule(schedule) {
    const result = await ConferenceScheduleModel.replaceOne({ _id: schedule._id }, schedule);
    if (result.n === 0) {
      const newSchedule = new ConferenceScheduleModel(schedule);
      await newSchedule.save();
      return newSchedule;
    }
    return schedule;
  }
}

module.exports = ConferenceScheduleRepository;
