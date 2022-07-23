-----------------------------------------------------
---------☄️Créé par zoyy0☄️----------
-----------------------------------------------------

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function SendWebhookMessageMenuStaff(webhook,message)
	if Config.webhook ~= "none" then
		PerformHttpRequest(Config.webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

RegisterServerEvent("menu:log") -- Anti-Bypass logger
AddEventHandler("menu:log", function(reason)
  	local name = GetPlayerName(source)
      local connect = {
            {
                ["color"] = 47479,
                ["title"] = reason,
                ["description"] = "Admin: "..name.."\n ID: "..source.." ",
                ["footer"] = {
                ["text"] = "zoyy0-Menu",
                },
            }
        }
      PerformHttpRequest(Config.webhook, function(err, text, headers) end, 'POST', json.encode({username = "zoyy0-Menu-Logs", embeds = connect, avatar_url = Config.image}), { ['Content-Type'] = 'application/json' })  
end)

RegisterServerEvent('Menu:Whitelist')
AddEventHandler('Menu:Whitelist', function(playerId)
	local _source = source
	local deets = getIdentity(playerId)
	if deets.group == 'admin' or deets.group == "mod" then
		TriggerClientEvent('Menu:Return', _source, true)
	end
end)

RegisterServerEvent("Menu:Superadmin")
AddEventHandler("Menu:Superadmin", function(playerId)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(playerId)
	if xPlayer.getGroup() == "superadmin" then
		TriggerClientEvent("Menu:super", _source, true)
	end
end)

function inArray(value, array)
	for _,v in pairs(array) do
		if v == value then
			return true
		end
	end
	return false
end

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]
		return {
			identifier = identity['identifier'],
			name = identity['name'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height'],
			job = identity['job'],
			group = identity['group']
		}
	else
		return nil
	end
end
------------------------------------------------------------------------
-------------------------------Argent Sale------------------------------
------------------------------------------------------------------------

RegisterServerEvent("zoyy0_Menu:giveDirtyMoney")
AddEventHandler("zoyy0_Menu:giveDirtyMoney", function(money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addAccountMoney('black_money', money)
	TriggerClientEvent('esx:showNotification', _source, 'Donné ~r~'..total..'€ ~s~montant.')
	TriggerEvent("esx:admingivemoneyalert",xPlayer.name,total)
end)

------------------------------------------------------------------------
--------------------------------COMSERV---------------------------------
------------------------------------------------------------------------

RegisterServerEvent('esx_communityservice:sendToCommunityService')
AddEventHandler('esx_communityservice:sendToCommunityService', function(target, actions_count)
	local identifier = GetPlayerIdentifiers(target)[1]
	MySQL.Async.fetchAll('SELECT * FROM communityservice WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] then
			MySQL.Async.execute('UPDATE communityservice SET actions_remaining = @actions_remaining WHERE identifier = @identifier', {
				['@identifier'] = identifier,
				['@actions_remaining'] = actions_count
			})
		else
			MySQL.Async.execute('INSERT INTO communityservice (identifier, actions_remaining) VALUES (@identifier, @actions_remaining)', {
				['@identifier'] = identifier,
				['@actions_remaining'] = actions_count
			})
		end
	end)
	name = GetPlayerName(source)
	targetid = GetPlayerName(target)
	TriggerClientEvent('chat:addMessage', -1, { args = { _U('judge'), _U('comserv_msg', GetPlayerName(target), actions_count) }, color = { 147, 196, 109 } })
	TriggerClientEvent('esx_policejob:unrestrain', target)
	TriggerClientEvent('esx_communityservice:inCommunityService', target, actions_count)
end)

local BanList         = {}
local BanListLoad        = false
local BanListHistory     = {}
local BanListHistoryLoad = false
local Text               = {}

function loadBanListHistory()
	MySQL.Async.fetchAll(
		'SELECT * FROM banlisthistory',
		{},
		function (data)
		  BanListHistory = {}
		  for i=1, #data, 1 do
			table.insert(BanListHistory, {
				identifier       = data[i].identifier,
				license          = data[i].license,
				liveid           = data[i].liveid,
				xblid            = data[i].xblid,
				discord          = data[i].discord,
				playerip         = data[i].playerip,
				targetplayername = data[i].targetplayername,
				sourceplayername = data[i].sourceplayername,
				reason           = data[i].reason,
				added            = data[i].added,
				expiration       = data[i].expiration,
				permanent        = data[i].permanent,
				timeat           = data[i].timeat
			  })
		  end
    end)
end

function loadBanList()
	MySQL.Async.fetchAll(
		'SELECT * FROM banlist',
		{},
		function (data)
		  BanList = {}
		  for i=1, #data, 1 do
			table.insert(BanList, {
				identifier = data[i].identifier,
				license    = data[i].license,
				liveid     = data[i].liveid,
				xblid      = data[i].xblid,
				discord    = data[i].discord,
				playerip   = data[i].playerip,
				reason     = data[i].reason,
				expiration = data[i].expiration,
                permanent  = data[i].permanent,
                timeat     = data[i].timeat,
                targetplayername = data[i].targetplayername,
				sourceplayername = data[i].sourceplayername,
			  })
		  end
    end)
end

CreateThread(function()
	while true do
		Wait(1000)
        if BanListLoad == false then
			loadBanList()
			if BanList ~= {} then
				BanListLoad = true
			else
				print("erreur")
			end
		end
		if BanListHistoryLoad == false then
			loadBanListHistory()
            if BanListHistory ~= {} then
				BanListHistoryLoad = true
			else
				print("erreur")
			end
		end
	end
end)

MultiServerSync = true

CreateThread(function()
	while MultiServerSync do
		Wait(30000)
		MySQL.Async.fetchAll(
		'SELECT * FROM banlist',
		{},
		function (data)
			if #data ~= #BanList then
			  BanList = {}

			  for i=1, #data, 1 do
				table.insert(BanList, {
					identifier = data[i].identifier,
					license    = data[i].license,
					liveid     = data[i].liveid,
					xblid      = data[i].xblid,
					discord    = data[i].discord,
					playerip   = data[i].playerip,
					reason     = data[i].reason,
					added      = data[i].added,
					expiration = data[i].expiration,
					permanent  = data[i].permanent
				  })
			  end
			loadBanListHistory()
			end
		end
		)
	end
end)

function deletebanned(identifier) 
	MySQL.Async.execute(
		'DELETE FROM banlist WHERE identifier=@identifier',
		{
		  ['@identifier']  = identifier
		},
		function ()
			loadBanList()
	end)
end

Text = {
	start         = "La BanList et l'historique ont été chargés avec succès.",
	starterror    = "ERREUR: la liste des bannissements et l'historique n'ont pas été chargés, nouvel essai.",
	banlistloaded = "La BanList a été chargée avec succès.",
	historyloaded = "Le BanListHistory a été chargé avec succès.",
	loaderror     = "ERREUR: La liste d'interdiction n'a pas été chargée.",
	forcontinu    = " jours. Pour continuer à saisir /sqlreason (raison de l'interdiction)",
	noreason      = "raison inconnue",
	during        = " durant : ",
	noresult      = "Il n'y a pas autant de résultats!",
	isban         = " a été ban",
	isunban       = " a été débannis",
	invalidsteam  =  "Tu devrais ouvrir steam",
	invalidid     = "ID joueur incorrecte",
	invalidname   = "Le nom est non valide",
	invalidtime   = "Mauvaise durée de ban",
	yourban       = "Tu a été bannis pour : ",
	yourpermban   = "Tu a été bannis permanent pour : ",
	youban        = "Tu à bannis : ",
	forr          = " jours. Pour : ",
	permban       = " permanent pour : ",
	timeleft      = ". Temps restant : ",
	toomanyresult = "Trop de résultats, veillez à être plus précis.",
	day           = " Jours ",
	hour          = " Heures ",
	minute        = " Minutes ",
	by            = "par",
	ban           = "Bannir un joueur en ligne",
	banoff        = "Bannir un joueur hors ligne",
	dayhelp       = "Nombre de jours",
	reason        = "Raison du ban",
	history       = "Afficher tous les ban d'un joueur",
	reload        = "Recharger la BanList et l'historique de la BanList",
	unban         = "Supprimer un ban de la liste",
	steamname     = "(Nom Steam)",
}


AddEventHandler('playerConnecting', function (playerName,setKickReason)
	local steamID  = "empty"
	local license  = "empty"
	local liveid   = "empty"
	local xblid    = "empty"
	local discord  = "empty"
	local playerip = "empty"
	for k,v in ipairs(GetPlayerIdentifiers(source))do
		if string.sub(v, 1, string.len("steam:")) == "steam:" then
			steamID = v
		elseif string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		elseif string.sub(v, 1, string.len("live:")) == "live:" then
			liveid = v
		elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
			xblid  = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			playerip = v
		end
	end
	--Banlist 
	if (Banlist == {}) then
		Citizen.Wait(1000)
	end
    if steamID == false then
		setKickReason("invalidsteam")
		CancelEvent()
    end
	for i = 1, #BanList, 1 do
		if 
			((tostring(BanList[i].identifier)) == tostring(steamID) 
			or (tostring(BanList[i].license)) == tostring(license) 
			or (tostring(BanList[i].liveid)) == tostring(liveid) 
			or (tostring(BanList[i].xblid)) == tostring(xblid) 
			or (tostring(BanList[i].discord)) == tostring(discord) 
			or (tostring(BanList[i].playerip)) == tostring(playerip)) 
		then
            if (tonumber(BanList[i].permanent)) == 1 then
                
                yourpermban = "Banni :"    
				setKickReason(yourpermban .. BanList[i].reason)
				CancelEvent()
				break
			elseif (tonumber(BanList[i].expiration)) > os.time() then
				local tempsrestant     = (((tonumber(BanList[i].expiration)) - os.time())/60)
				if tempsrestant >= 1440 then
					local day        = (tempsrestant / 60) / 24
					local hrs        = (day - math.floor(day)) * 24
					local minutes    = (hrs - math.floor(hrs)) * 60
					local txtday     = math.floor(day)
					local txthrs     = math.floor(hrs)
					local txtminutes = math.ceil(minutes)
						setKickReason(Text.yourban .. BanList[i].reason .. Text.timeleft .. txtday .. Text.day ..txthrs .. Text.hour ..txtminutes .. Text.minute)
						CancelEvent()
						break
				elseif tempsrestant >= 60 and tempsrestant < 1440 then
					local day        = (tempsrestant / 60) / 24
					local hrs        = tempsrestant / 60
					local minutes    = (hrs - math.floor(hrs)) * 60
					local txtday     = math.floor(day)
					local txthrs     = math.floor(hrs)
					local txtminutes = math.ceil(minutes)
						setKickReason(Text.yourban .. BanList[i].reason .. Text.timeleft .. txtday .. Text.day .. txthrs .. Text.hour .. txtminutes .. Text.minute)
						CancelEvent()
						break
				elseif tempsrestant < 60 then
					local txtday     = 0
					local txthrs     = 0
					local txtminutes = math.ceil(tempsrestant)
						setKickReason(Text.yourban .. BanList[i].reason .. Text.timeleft .. txtday .. Text.day .. txthrs .. Text.hour .. txtminutes .. Text.minute)
						CancelEvent()
						break
				end
			elseif (tonumber(BanList[i].expiration)) < os.time() and (tonumber(BanList[i].permanent)) == 0 then
				deletebanned(steamID)
				break
			end
		end
	end
end)

RegisterServerEvent("zoyy0menu:ban")
AddEventHandler("zoyy0menu:ban", function(target, reason, days, permanent)
	local target1 = GetPlayerName(target)
	local name = GetPlayerName(source)
	if days == 999999999 then 
		SendWebhookMessageMenuStaff(Config.webhook,"**zoyy0_Menu** \n```diff\nAdmin: "..name.." Banni: "..target1.."\nRaison: "..reason.."\nDurée: Ban Perms```")
		SqlBan(target, reason, days)
		DropPlayer(target, "Tu a été ban Perma:"..reason)
	elseif days ~= 999999999 then
		SendWebhookMessageMenuStaff(Config.webhook,"**zoyy0_Menu** \n```diff\nAdmin: "..name.." Banni: "..target1.."\nRaison: "..reason.."\nDurée:" ..days.."```")
		SqlBan(target, reason, days)
		DropPlayer(target, "Tu a été ban pour:"..reason)
	end
end)

function SqlBan(target, reason, days)
    local identifier    = nil
    local license       = nil
    local playerip      = nil
    local playerdiscord = nil
    local liveid        = nil
    local xbl       = nil
	local sourceplayername = GetPlayerName(source)
	local targerplayername = GetPlayerName(target)
    local timeat     = os.time()
  
    for k,v in pairs(GetPlayerIdentifiers(target))do
      if string.sub(v, 1, string.len("steam:")) == "steam:" then
        identifier = v
      elseif string.sub(v, 1, string.len("license:")) == "license:" then
        license = v
      elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
        xbl  = v
      elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
        playerip = v
      elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
        playerdiscord = v
      elseif string.sub(v, 1, string.len("live:")) == "live:" then
        liveid = v
      end
    end
    if playerip == nil then
      playerip = GetPlayerEndpoint(target)
      if playerip == nil then
        playerip = 'not found'
      end
    end
    if playerdiscord == nil then
      playerdiscord = 'not found'
    end
    if liveid == nil then
      liveid = 'not found'
    end
    if xbl == nil then
      xbl = 'not found'
	end
	if days == 999999999 then
		permanent = 1
	else
		permanent = 0
	end
	local expiration = days * 86400
	if expiration < os.time() then
		expiration = os.time()+expiration
	end
  
    MySQL.Async.execute(
      'INSERT INTO banlist (identifier,license,playerip,discord,targetplayername,liveid,xblid,reason,permanent,sourceplayername,expiration,timeat) VALUES (@identifier,@license,@playerip,@discord,@targetplayername,@liveid,@xblid,@reason,@permanent,@sourceplayername,@expiration,@timeat)', {
        ['@identifier'] = identifier,
        ['@license'] = license,
        ['@playerip'] = playerip,
        ['@discord'] = playerdiscord,
        ['@targetplayername'] = targerplayername,
        ['@liveid'] = liveid,
        ['@xblid'] = xbl,
        ['@reason'] = reason,
        ['@permanent'] = permanent,
        ['@sourceplayername'] = sourceplayername,
        ['@expiration'] = expiration,
        ['@timeat'] = os.time()
      },
      function ()
    end)
end
          
------------------------------------------
--------------Give-Car-To-ID--------------
------------------------------------------

ESX.RegisterServerCallback('isPlateTaken', function (source, cb, plate)
	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function (result)
		cb(result[1] ~= nil)
	end)
end)

RegisterServerEvent('give-car')
AddEventHandler('give-car', function (target, vehicleProps, plate)
	local identifier = GetPlayerIdentifiers(target)[1]
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local targetid = GetPlayerName(target)
	local name = GetPlayerName(_source)
	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, state, vehicle, stored, job) VALUES (@owner, @plate, @state, @vehicle, @stored, @job)',
	{
		['@owner']   = identifier,
		['@plate']   = plate,
		['@state']	 = "1",
		['@stored'] = "1",
		['@job'] = "civ",
		['@vehicle'] = json.encode(vehicleProps)
	})
end)

RegisterServerEvent("Delete_db_car")
AddEventHandler("Delete_db_car", function(plate)
	local name = GetPlayerName(source)
	MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	})
end)

RegisterServerEvent("Menu:Unban")
AddEventHandler("Menu:Unban", function(unbaname)
	local target = table.concat(unbaname, " ")
	MySQL.Async.fetchAll('SELECT * FROM banlist WHERE targetplayername like @playername', 
	{
		['@playername'] = ("%"..target.."%")
	}, function(data)
		if data[1] then
			if #data > 1 then
				TriggerClientEvent("notify", "Plus d'un nom trouvé dans la BDD")
				for i=1, #data, 1 do
					TriggerEvent('bansql:sendMessage', source, data[i].targetplayername)
				end
			else
				MySQL.Async.execute(
				'DELETE FROM banlist WHERE targetplayername = @name',
				{
				  ['@name']  = data[1].targetplayername
				},
					function ()
					loadBanList()
					local sourceplayername = GetPlayerName(source)
					local message = (data[1].targetplayername .. Text.isunban .." ".. Text.by .." ".. sourceplayername)
				end)
			end
		else
			TriggerClientEvent("notify", "Nom incorrecte")
		end
    end)
end)

RegisterServerEvent("setgroup")
AddEventHandler("setgroup", function(USER, GROUP)
	local _source = source
	local name = GetPlayerName(_source)
	local target = GetPlayerName(USER)
	TriggerClientEvent('es_admin:setGroup', USER, GROUP)
end)

RegisterServerEvent("zoyy0:Menu")
AddEventHandler("zoyy0:Menu", function(target, type, nick)
	local identifier = GetPlayerIdentifiers(target)[1]
	local name = GetPlayerName(source)
	local targetp = GetPlayerName(target)
	local data = LoadResourceFile("vMenu", "/config/permissions.cfg")
	local data = data .."\nadd_principal identifier."..identifier.." group."..type.." #"..nick 
	SaveResourceFile("vMenu", "/config/permissions.cfg", data, -1)
	local name = GetPlayerName(source)
    local connect = {
        {
            ["color"] = 47479,
            ["title"] = "vMenu Add\nTo Player: "..targetp.."\nType: "..type.."",
            ["description"] = "Admin: "..name.."\n ID: "..source.." ",
            ["footer"] = {
            ["text"] = "zoyy0-Menu",
            },
        }
    }
    PerformHttpRequest(Config.webhook, function(err, text, headers) end, 'POST', json.encode({username = "zoyy0-Menu-Logs", embeds = connect, avatar_url = Config.image}), { ['Content-Type'] = 'application/json' })  
end)

RegisterServerEvent('es_admin:set')
AddEventHandler('es_admin:set', function(t, USER, GROUP)
	local Source = source
	TriggerEvent('es:getPlayerFromId', source, function(user)
		TriggerEvent('es:canGroupTarget', user.getGroup(), "admin", function(available)
			if available then
			if t == "group" then
				if(GetPlayerName(USER) == nil)then
					TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Joueur introuvable")
				else
					TriggerEvent("es:getAllGroups", function(groups)
						if(groups[GROUP])then
							TriggerEvent("es:setPlayerData", USER, "group", GROUP, function(response, success)
								TriggerClientEvent('es_admin:setGroup', USER, GROUP)
								TriggerClientEvent('chatMessage', -1, "CONSOLE", {0, 0, 0}, "Groupe de ^2^*" .. GetPlayerName(tonumber(USER)) .. "^r^0 a été mis à ^2^*" .. GROUP)
							end)
						else
							TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Groupe introuvable")
						end
					end)
				end
			elseif t == "level" then
				if(GetPlayerName(USER) == nil)then
					TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Joueur introuvable")
				else
					GROUP = tonumber(GROUP)
					if(GROUP ~= nil and GROUP > -1)then
						TriggerEvent("es:setPlayerData", USER, "permission_level", GROUP, function(response, success)
							if(true)then
								TriggerClientEvent('chatMessage', -1, "CONSOLE", {0, 0, 0}, "Niveau d'autorisation de ^2" .. GetPlayerName(tonumber(USER)) .. "^0 a été mis à ^2 " .. tostring(GROUP))
							end
						end)	
					else
						TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Entier non valide saisi")
					end
				end
			elseif t == "money" then
				if(GetPlayerName(USER) == nil)then
					TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Joueur introuvable")
				else
					GROUP = tonumber(GROUP)
					if(GROUP ~= nil and GROUP > -1)then
						TriggerEvent('es:getPlayerFromId', USER, function(target)
							target.setMoney(GROUP)
						end)
					else
						TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Entier non valide saisi")
					end
				end
			elseif t == "bank" then
				if(GetPlayerName(USER) == nil)then
					TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Joueur introuvable")
				else
					GROUP = tonumber(GROUP)
					if(GROUP ~= nil and GROUP > -1)then
						TriggerEvent('es:getPlayerFromId', USER, function(target)
							target.setBankBalance(GROUP)
						end)
					else
						TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Entier non valide saisi")
					end
				end
			end
			else
				TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "superadmin requis pour faire cela")
			end
		end)
	end)	
end)
