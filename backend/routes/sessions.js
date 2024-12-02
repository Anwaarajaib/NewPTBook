import express from 'express';
import Session from '../models/Session.js';
import Client from '../models/Client.js';
import auth from '../middleware/auth.js';

const router = express.Router();

// Get all sessions for a client
router.get('/client/:clientId', auth, async (req, res) => {
    try {
        const client = await Client.findById(req.params.clientId);
        if (!client) {
            return res.status(404).json({ message: 'Client not found' });
        }

        if (client.trainer.toString() !== req.user.id) {
            return res.status(401).json({ message: 'Not authorized' });
        }

        const sessions = await Session.find({ client: req.params.clientId });
        res.json(sessions);
    } catch (error) {
        res.status(500).json({ message: 'Server error' });
    }
});

// Create a new session
router.post('/client/:clientId', auth, async (req, res) => {
    try {
        const client = await Client.findById(req.params.clientId);
        if (!client) {
            return res.status(404).json({ message: 'Client not found' });
        }

        if (client.trainer.toString() !== req.user.id) {
            return res.status(401).json({ message: 'Not authorized' });
        }

        const session = await Session.create({
            ...req.body,
            client: req.params.clientId
        });

        // Add session to client's sessions array
        client.sessions.push(session._id);
        await client.save();

        res.status(201).json(session);
    } catch (error) {
        res.status(500).json({ message: 'Server error' });
    }
});

// Update a session
router.put('/:id', auth, async (req, res) => {
    try {
        const session = await Session.findById(req.params.id).populate('client');
        if (!session) {
            return res.status(404).json({ message: 'Session not found' });
        }

        if (session.client.trainer.toString() !== req.user.id) {
            return res.status(401).json({ message: 'Not authorized' });
        }

        const updatedSession = await Session.findByIdAndUpdate(
            req.params.id,
            { $set: req.body },
            { new: true }
        );

        // If session is completed, move it to completedSessions
        if (updatedSession.isCompleted && !session.isCompleted) {
            const client = await Client.findById(session.client);
            client.sessions = client.sessions.filter(s => s.toString() !== session._id.toString());
            client.completedSessions.push(session._id);
            await client.save();
        }

        res.json(updatedSession);
    } catch (error) {
        res.status(500).json({ message: 'Server error' });
    }
});

// Delete a session
router.delete('/:id', auth, async (req, res) => {
    try {
        const session = await Session.findById(req.params.id).populate('client');
        if (!session) {
            return res.status(404).json({ message: 'Session not found' });
        }

        if (session.client.trainer.toString() !== req.user.id) {
            return res.status(401).json({ message: 'Not authorized' });
        }

        // Remove session from client's arrays
        const client = await Client.findById(session.client);
        client.sessions = client.sessions.filter(s => s.toString() !== session._id.toString());
        client.completedSessions = client.completedSessions.filter(s => s.toString() !== session._id.toString());
        await client.save();

        await session.remove();
        res.json({ message: 'Session removed' });
    } catch (error) {
        res.status(500).json({ message: 'Server error' });
    }
});

export default router; 