import express from 'express';
import Client from '../models/Client.js';
import auth from '../middleware/auth.js';

const router = express.Router();

// Get all clients for a trainer
router.get('/', auth, async (req, res) => {
    try {
        const clients = await Client.find({ trainer: req.user.id })
            .populate('sessions')
            .populate('completedSessions');
        res.json(clients);
    } catch (error) {
        res.status(500).json({ message: 'Server error' });
    }
});

// Create a new client
router.post('/', auth, async (req, res) => {
    try {
        const { name, age, height, weight, medicalHistory, goals, goalNotes } = req.body;
        
        const client = await Client.create({
            trainer: req.user.id,
            name,
            age,
            height,
            weight,
            medicalHistory,
            goals,
            goalNotes
        });

        res.status(201).json(client);
    } catch (error) {
        res.status(500).json({ message: 'Server error' });
    }
});

// Update a client
router.put('/:id', auth, async (req, res) => {
    try {
        const client = await Client.findById(req.params.id);
        
        if (!client) {
            return res.status(404).json({ message: 'Client not found' });
        }

        // Check if client belongs to trainer
        if (client.trainer.toString() !== req.user.id) {
            return res.status(401).json({ message: 'Not authorized' });
        }

        const updatedClient = await Client.findByIdAndUpdate(
            req.params.id,
            { $set: req.body },
            { new: true }
        ).populate('sessions').populate('completedSessions');

        res.json(updatedClient);
    } catch (error) {
        res.status(500).json({ message: 'Server error' });
    }
});

// Delete a client
router.delete('/:id', auth, async (req, res) => {
    try {
        const client = await Client.findById(req.params.id);
        
        if (!client) {
            return res.status(404).json({ message: 'Client not found' });
        }

        // Check if client belongs to trainer
        if (client.trainer.toString() !== req.user.id) {
            return res.status(401).json({ message: 'Not authorized' });
        }

        await client.remove();
        res.json({ message: 'Client removed' });
    } catch (error) {
        res.status(500).json({ message: 'Server error' });
    }
});

export default router; 