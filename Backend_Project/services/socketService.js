module.exports = (io) => {
  io.on('connection', (socket) => {
    console.log(`New connection: ${socket.id}`);

    // Rejoindre la salle de l'utilisateur
    socket.on('joinUser', (userId) => {
      socket.join(userId);
      console.log(`User ${userId} joined room`);
    });

    // Message privé
    socket.on('privateMessage', async (data) => {
      try {
        const { content, senderId, receiverId, type, fileUrl } = data;
        
        // Enregistrer en base de données
        const message = await db.Message.create({
          content,
          type,
          fileUrl,
          senderId,
          receiverId
        });

        // Récupérer le message avec les infos de l'expéditeur
        const newMessage = await db.Message.findByPk(message.id, {
          include: [
            { model: db.User, as: 'sender', attributes: ['id', 'username', 'profileImage'] }
          ]
        });

        // Envoyer au destinataire
        io.to(receiverId).emit('newMessage', newMessage);
        
        // Envoyer aussi à l'expéditeur pour mise à jour UI
        io.to(senderId).emit('newMessage', newMessage);
      } catch (err) {
        console.error('Socket error:', err);
      }
    });

    socket.on('disconnect', () => {
      console.log(`User disconnected: ${socket.id}`);
    });
  });
};