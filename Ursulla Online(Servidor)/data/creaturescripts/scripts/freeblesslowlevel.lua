local freeBlessMaxLevel = 20

function onLogin(cid)
    local player = Player(cid)
    if player:getLevel() <= freeBlessMaxLevel then
        for i = 1, 6 do
            player:addBlessing(i)
        end
        player:say('Ben�ao!(AT� O LEVEL 20)', TALKTYPE_ORANGE_1)
        player:getPosition():sendMagicEffect(CONST_ME_HOLYDAMAGE)
    end
    return true
end


-- CASO O SERVER ESTIVER CAINDO 

--local freeBlessMaxLevel = 430

--function onLogin(cid)
  --  local player = Player(cid)
  --  if player:getLevel() <= freeBlessMaxLevel then
    --    for i = 1, 6 do
    --        player:addBlessing(i)
     --   end
      --  player:say('FREE BLESS LVL 430', TALKTYPE_ORANGE_1)
    --    player:getPosition():sendMagicEffect(CONST_ME_HOLYDAMAGE)
    --end
  --  return true
--end
