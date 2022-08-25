local ACTION_RUN, ACTION_BREAK, ACTION_NONE, ACTION_ALL = 1, 2, 3, 4
local TYPE_MONSTER, TYPE_NPC, TYPE_ITEM, TYPE_ACTION, TYPE_UNIQUE = 1, 2, 3, 4, 5

local config = {
	[5907]	=	{NAME = 'urso',					ID = 3,		TYPE = TYPE_MONSTER,	CHANCE = 20,	FAIL_MSG = { {1, 'O urso fugiu...'}, {2, 'Ah não o slingshot quebrou!'}, {3, 'O urso se assustou...'} },SUCCESS_MSG = 'Voce domou o urso!'},
	[13295]	=	{NAME = 'ovelha negra',				ID = 4,		TYPE = TYPE_MONSTER,	CHANCE = 25,	FAIL_MSG = { {1, 'Ele fugiu!.'}, {2, 'Oh não! Quebrou!!.'}, {3, 'Não foi dessa vez...'} },SUCCESS_MSG = 'Voce domou a Ovelha Negra!.'},
	[13293]	=	{NAME = 'pantera negra',			ID = 5,		TYPE = TYPE_MONSTER,	CHANCE = 40,	FAIL_MSG = { {1, 'A pantera escapou.'}, {2, 'QUEBROU...'} },SUCCESS_MSG = 'Você domou a Pantera!'},
	[13298]	=	{NAME = 'ave do terror',				ID = 2,		TYPE = TYPE_MONSTER,	CHANCE = 15,	FAIL_MSG = { {1, 'A ave fugiu.'}, {3, 'A ave esta te desafiando.'} }, SUCCESS_MSG = 'Você domou o passaro.'},
	[13247]	=	{NAME = 'Boar',					ID = 10,	TYPE = TYPE_MONSTER,	CHANCE = 40,	FAIL_MSG = { {1, 'The boar has run away'}, {3, 'The boar attacks you.'} }, SUCCESS_MSG = 'You have tamed the boar.'},
	[13305]	=	{NAME = 'Crustacea Gigantica',			ID = 7,		TYPE = TYPE_MONSTER,	CHANCE = 40,	FAIL_MSG = { {1, 'The crustacea has run away.'}, {2, 'The crustacea ate the shrimp.'} }, SUCCESS_MSG = 'You have tamed the crustacea.'},
	[13291]	=	{NAME = 'urso esqueleto',			ID = 12,	TYPE = TYPE_MONSTER,	CHANCE = 40,	FAIL_MSG = { {1, 'O urso esqueleto fugiu!'} }, SUCCESS_MSG = 'Você domou o urso esqueleto.'},
	[13307]	=	{NAME = 'Wailing Widow',			ID = 1,		TYPE = TYPE_MONSTER,	CHANCE = 40,	FAIL_MSG = { {1, 'The widow has run away.'}, {2, 'The widow has eaten the sweet bait.'} }, SUCCESS_MSG = 'You have tamed the widow.'},
	[13292]	=	{NAME = 'inoperative tin lizzard',		ID = 8,		TYPE = TYPE_ITEM,	CHANCE = 40,	FAIL_MSG = { {2, 'The key broke inside.'} }, SUCCESS_MSG = 'You wind up the tin lizzard.'},
	[13294]	=	{NAME = 'Draptor',				ID = 6,		TYPE = TYPE_MONSTER,	CHANCE = 40,	FAIL_MSG = { {1, 'The draptor has run away.'}, {3, 'The draptor has fled.'} }, SUCCESS_MSG = 'You have tamed the draptor.'},
	[13536]	=	{NAME = 'Crystal Wolf',				ID = 16,	TYPE = TYPE_MONSTER,	CHANCE = 40,	FAIL_MSG = { {1, 'The wolf has run away.'} }, SUCCESS_MSG = 'You have tamed the wolf.'},
	[13539]	=	{NAME = 'cervo branco',			ID = 18,	TYPE = TYPE_MONSTER,	CHANCE = 40,	FAIL_MSG = { {2, 'O cone quebrou.'}, {3, 'O cervo ficou com medo!'} }, SUCCESS_MSG = 'Você domou o cervo'},
	[13538]	=	{NAME = 'panda',				ID = 19,	TYPE = TYPE_MONSTER,	CHANCE = 40,	FAIL_MSG = { {4, 'Panda comeu as folhas e fugiu.'} }, SUCCESS_MSG = 'Você domou o panda!.'},
	[13535]	=	{NAME = 'Dromedary',				ID = 20,	TYPE = TYPE_MONSTER,	CHANCE = 40,	FAIL_MSG = { {1, 'Dromedary has run away.'} }, SUCCESS_MSG = 'You have tamed the dromedary.'},
	[13498]	=	{NAME = 'Sandstone Scorpion',			ID = 21,	TYPE = TYPE_MONSTER,	CHANCE = 40,	FAIL_MSG = { {1, 'The scorpion has vanished.'}, {2, 'Scorpion broken the sceptre.'} }, SUCCESS_MSG = 'You have tamed the scorpion.'},
	[13537]	=	{NAME = 'jegue',				ID = 13,	TYPE = TYPE_MONSTER,	CHANCE = 40,	FAIL_MSG = { {1, 'O jegue escapou!'} }, SUCCESS_MSG = 'Voce domou a mula!.'},
	[13938]	=	{NAME = 'inoperative uniwheel',			ID = 15,	TYPE = TYPE_ITEM,	CHANCE = 40,	FAIL_MSG = { {3, 'The oil have no effect.'}, {2, 'Splosh!'} }, SUCCESS_MSG = 'The strange wheel seems to vibrate and slowly starts turning continuously.'},
	[13508]	=	{NAME = 'Slug',					ID = 14,	TYPE = TYPE_MONSTER,	CHANCE = 40,	FAIL_MSG = { {1, 'The slug has run away.'}, {3, 'The drug had no effect.'} }, SUCCESS_MSG = 'You have tamed the slug.'},
	[13939]	=	{NAME = 'Wild Horse',				ID = 17,	TYPE = TYPE_MONSTER,	CHANCE = 15,	FAIL_MSG = { {1, 'The horse runs away.'}, {2, 'The horse ate the oats.'} }, SUCCESS_MSG = 'You have tamed the horse.'},
	[15545]	=	{NAME = 'Manta Ray',				ID = 28,	TYPE = TYPE_MONSTER,	CHANCE = 30,	FAIL_MSG = { {1, 'The manta ray fled.'}, {3, 'The manta ray is trying to escape.'} }, SUCCESS_MSG = 'You have tamed the manta ray.'},
	[15546]	=	{NAME = 'joaninha',				ID = 27,	TYPE = TYPE_MONSTER,	CHANCE = 30,	FAIL_MSG = { {1, 'A joaninha se assustou e fugiu.'}, {3, 'A joaninha está tentando mordiscar.'} }, SUCCESS_MSG = 'Você domou a joaninha!.'},
	[18447]	=	{NAME = 'Ironblight',				ID = 29,	TYPE = TYPE_MONSTER,	CHANCE = 30,	FAIL_MSG = { {1, 'The ironblight managed to run away.'}, {2, 'Oh no! The magnet lost its power!'}, {3, 'The ironblight is fighting against the magnetic force.'} }, SUCCESS_MSG = 'You tamed the ironblight.'},
	[18449] =       {NAME = 'Dragonling',                  	        ID = 31,        TYPE = TYPE_MONSTER,    CHANCE = 30,    FAIL_MSG = { {1, "The dragonling got scared and ran away."}, {3, "The dragonling is trying to nibble."} }, SUCCESS_MSG = "You tamed a dragonling."},
	[18448]	=	{NAME = 'Magma Crawler',			ID = 30,	TYPE = TYPE_MONSTER,	CHANCE = 30,	FAIL_MSG = { {1, 'The magma crawler refused to drink wine and vanishes into thin air.'}, {2, 'Argh! The magma crawler pushed you and you spilled the glow wine!'}, {3, 'The magma crawler is smelling the glow wine suspiciously.'} }, SUCCESS_MSG = 'The magma crawler will accompany you as a friend from now on.'},
	[18516]	=	{NAME = 'Modified Gnarlhound', 			ID = 32,	TYPE = TYPE_MONSTER,	CHANCE = 100,	FAIL_MSG = { }, SUCCESS_MSG = 'You now own a modified gnarlhound.'},
	[21452] =       {NAME = 'Gravedigger',      		        ID = 39,        TYPE = TYPE_MONSTER,    CHANCE = 40,    FAIL_MSG = { {1, "The gravedigger got scared and ran away."}, {3, "The gravedigger is trying to nibble."} }, SUCCESS_MSG = "You tamed the hellgrip."},
	[20138]	=	{NAME = 'Water Buffalo',			ID = 35,	TYPE = TYPE_MONSTER,	CHANCE = 30,	FAIL_MSG = { {1, 'The water buffalo got scared and ran away.'}, {3, 'The water buffalo is trying to nibble.'} }, SUCCESS_MSG = 'You tamed a water buffalo.'},
	[22608]	=	{NAME = 'Shock Head', 				ID = 42,	TYPE = TYPE_MONSTER,	CHANCE = 30,	FAIL_MSG = { {1, 'The shock head ran away.'}, {3, 'The shock head is growling at you.'} }, SUCCESS_MSG = 'You tamed the shock head.'},
	[23557]	=	{NAME = 'Walker', 				ID = 43,	TYPE = TYPE_MONSTER,	CHANCE = 30,	FAIL_MSG = { {2, 'This walker is incompatible with your control unit.'}, {4, 'This walker is incompatible with your control unit.'} }, SUCCESS_MSG = 'You tamed the walker.'},
	[23810]	=	{NAME = 'Noble Lion', 				ID = 40,	TYPE = TYPE_MONSTER,	CHANCE = 30,	FAIL_MSG = { {2, 'The lion got scared and ran away.'}, {4, 'The lion is trying to nibble.'} }, SUCCESS_MSG = 'You tamed the lion.'}
}

local function doFailAction(cid, mount, pos, item, itemEx)
	local action, effect = mount.FAIL_MSG[math.random(#mount.FAIL_MSG)], CONST_ME_POFF
	if(action[1] == ACTION_RUN) then
		Creature(itemEx.uid):remove()
	elseif(action[1] == ACTION_BREAK) then
		effect = CONST_ME_BLOCKHIT
		Item(item.uid):remove(1)
	elseif(action[1] == ACTION_ALL) then
		Creature(itemEx.uid):remove()
		Item(item.uid):remove(1)
	end

	pos:sendMagicEffect(effect)
	Player(cid):say(action[2], TALKTYPE_MONSTER_SAY)
	return action
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
	local player = Player(cid)
	local targetMonster = Monster(itemEx.uid)
	local targetNpc = Npc(itemEx.uid)
	local targetItem = Item(itemEx.uid)
	local mount = config[item.itemid]
	if mount == nil or player:hasMount(mount.ID) then
		return false
	end
    if getCreatureHealth(targetMonster) >= getCreatureMaxHealth(targetMonster)*0.3 then
	player:say('Está muito forte para ser domado!!', TALKTYPE_MONSTER_SAY)
	end
	local rand = math.random(100)
	--Monster Mount
	
	if targetMonster ~= nil and mount.TYPE == TYPE_MONSTER then
		if Creature(itemEx.uid):getMaster() then
			player:say('Você não pode domar uma criatura sumonada!', TALKTYPE_MONSTER_SAY)
			return true
		end

		if mount.NAME == targetMonster:getName() then
			if rand > mount.CHANCE then
				doFailAction(cid, mount, toPosition, item, itemEx)
				return true
			end

			player:addMount(mount.ID)
			player:say(mount.SUCCESS_MSG, TALKTYPE_MONSTER_SAY)
			targetMonster:remove()

			toPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
			Item(item.uid):remove(1)
			return true
		end
	--NPC Mount
	elseif targetNpc ~= nil and mount.TYPE == TYPE_NPC then
		if mount.NAME == targetNpc:getName() then
			if rand > mount.CHANCE then
				doFailAction(cid, mount, toPosition, item, itemEx)
				return true
			end

			player:addMount(mount.ID)
			player:say(mount.SUCCESS_MSG, TALKTYPE_MONSTER_SAY)

			toPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
			Item(item.uid):remove(1)
			return true
		end
	--Item Mount
	elseif targetItem ~= nil and mount.TYPE == TYPE_ITEM then
		if mount.NAME == targetItem:getName() then
			if rand > mount.CHANCE then
				doFailAction(cid, mount, toPosition, item, itemEx)
				return true
			end

			player:addMount(mount.ID)
			player:say(mount.SUCCESS_MSG, TALKTYPE_MONSTER_SAY)

			toPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
			Item(item.uid):remove(1)
			return true
		end
	--Action Mount
	elseif itemEx.actionid > 0 and mount.TYPE == TYPE_ACTION then
		if(mount.NAME == itemEx.actionid) then
			if rand > mount.CHANCE then
				doFailAction(cid, mount, toPosition, item, itemEx)
				return true
			end

			player:addMount(mount.ID)
			player:say(mount.SUCCESS_MSG, TALKTYPE_MONSTER_SAY)

			toPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
			Item(item.uid):remove(1)
			return true
		end
	--Unique Mount
	elseif itemEx.uid <= 65535 and mount.TYPE == TYPE_UNIQUE then
		if mount.NAME == itemEx.uid then
			if rand > mount.CHANCE then
				doFailAction(cid, mount, toPosition, item, itemEx)
				return true
			end

			player:addMount(mount.ID)
			player:say(mount.SUCCESS_MSG, TALKTYPE_MONSTER_SAY)

			toPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
			Item(item.uid):remove(1)
			return true
		end
	end
	return false
end