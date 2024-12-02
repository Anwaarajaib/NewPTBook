import mongoose from 'mongoose';

const clientSchema = new mongoose.Schema({
    trainer: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    name: {
        type: String,
        required: true
    },
    photo: {
        type: String,
        default: ''
    },
    age: {
        type: Number,
        required: true
    },
    height: {
        type: Number,
        required: true
    },
    weight: {
        type: Number,
        required: true
    },
    medicalHistory: [{
        type: String
    }],
    goals: [{
        type: String
    }],
    goalNotes: {
        type: String,
        default: ''
    },
    sessions: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Session'
    }],
    completedSessions: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Session'
    }]
}, { timestamps: true });

const Client = mongoose.model('Client', clientSchema);
export default Client; 