import mongoose from 'mongoose';

const exerciseSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    sets: {
        type: Number,
        required: true
    },
    reps: {
        type: Number,
        required: true
    },
    weight: {
        type: Number,
        required: true
    },
    notes: {
        type: String,
        default: ''
    }
});

const sessionSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    client: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Client',
        required: true
    },
    exercises: [exerciseSchema],
    isCompleted: {
        type: Boolean,
        default: false
    },
    completedAt: {
        type: Date
    }
}, { timestamps: true });

const Session = mongoose.model('Session', sessionSchema);
export default Session; 