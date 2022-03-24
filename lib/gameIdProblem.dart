/*
Q1) How do we get the same gameId in both the devices?
  we store the gameId in the GameRoom.gameId and use the same gameId as a doc in GameRoom.
  So each group has a unique gameId.
  But gameId can be multiple ri8? Bcoz 2 or more players might be playing the game.

Reason it was not working:
  bcoz when we click on next, a new gameId is created. Then the old player cant play, bcoz he has the old gameId.
  Remidy is there, to show the client. but not work in real app.

*/
