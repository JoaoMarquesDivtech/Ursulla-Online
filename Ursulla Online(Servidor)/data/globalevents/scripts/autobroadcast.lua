-- ELERA TIBIA 

function onThink(interval, lastExecution)
    local MESSAGE = {
        "[CLIENT] http://ursullaonline.ddns/?subtopic=downloads Use o client do servidor para ficar longe de bugs nas suas aventuras!.",
		"[SEGURAN�A] N�o passe sua senha para ninguem, Sua senha � s� sua!",
		"[FACEBOOK] https://www.facebook.com/UrsullaOnline/",
    }
    Game.broadcastMessage(MESSAGE[math.random(1, #MESSAGE)], MESSAGE_EVENT_ADVANCE) 
    return true
end