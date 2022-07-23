--[[--------------------------------------------------
---------☄️Créé par zoyy0☄️---------------
------------------------------------------------------]]
ESX = nil

local MenuPosition = "right"

rightPosition = {x = 1350, y = 100}
leftPosition = {x = 0, y = 100}
menuPosition = {x = 1350, y = 200}

_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Staff Menu", "~b~Créé par zoyy0", menuPosition["x"], menuPosition["y"])
_menuPool:Add(mainMenu)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent("zoyy0-failed")
AddEventHandler("zoyy0-failed", function()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			print("^2[zoyy0-Menu]-^1 Échec de l'authentification^0")
		end
	end)
end)

whitelisted = false
whiteCheck = true

Citizen.CreateThread(function()
	while whiteCheck == true do
		Citizen.Wait(1000)
		if ESX.IsPlayerLoaded(PlayerId) then
			TriggerServerEvent('Menu:Whitelist', GetPlayerServerId(PlayerId()))
			whiteCheck = false
		end
	end
end)

superCheck = true
superadmin = false

Citizen.CreateThread(function()
	while superCheck == true do
		Citizen.Wait(2000)
		if ESX.IsPlayerLoaded(PlayerId) then
			TriggerServerEvent('Menu:Superadmin', GetPlayerServerId(PlayerId()))
			superCheck = false
		end
	end
end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLength)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
	blockinput = true 
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

function admin_give_dirty()
	local amount = KeyboardInput("Mettez de l'argent sale et appuyez sur Entrée", '   ', "   ", 9)
	if amount ~= nil then
		amount = tonumber(amount)
		if type(amount) == 'number' then
			TriggerServerEvent('zoyy0_Menu:giveDirtyMoney', amount)
		end
	end
end

local function TeleportToCoords()
	local pizdax = KeyboardInput("Entrez X pos", "", 100)
	local pizday = KeyboardInput("Entrez Y pos", "", 100)
	local pizdaz = KeyboardInput("Entrez Z pos", "", 100)
	if pizdax ~= "" and pizday ~= "" and pizdaz ~= "" then
			if	IsPedInAnyVehicle(GetPlayerPed(-1), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), 0), -1) == GetPlayerPed(-1)) then
					entity = GetVehiclePedIsIn(GetPlayerPed(-1), 0)
			else
					entity = GetPlayerPed(-1)
			end
			if entity then
				SetEntityCoords(entity, pizdax + 0.5, pizday + 0.5, pizdaz + 0.5, 1, 0, 0, 1)
				notify("~g~Téléporté aux coordonnées!", false)
			end
else
	notify("~b~Coordonnées invalides!", true)
	end
end

function TeleportToWaypoint()
    if DoesBlipExist(GetFirstBlipInfoId(8)) then
        local blipIterator = GetBlipInfoIdIterator(8)
        local blip = GetFirstBlipInfoId(8, blipIterator)
        WaypointCoords = Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ResultAsVector()) 
        wp = true
        local zHeigt = 0.0
        height = 1000.0
        while true do
            Citizen.Wait(0)
            if wp then
                if
                    IsPedInAnyVehicle(GetPlayerPed(-1), 0) and
                        (GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), 0), -1) == GetPlayerPed(-1))
                then
                    entity = GetVehiclePedIsIn(GetPlayerPed(-1), 0)
                else
                    entity = GetPlayerPed(-1)
                end

                SetEntityCoords(entity, WaypointCoords.x, WaypointCoords.y, height)
                FreezeEntityPosition(entity, true)
                local Pos = GetEntityCoords(entity, true)

                if zHeigt == 0.0 then
                    height = height - 25.0
                    SetEntityCoords(entity, Pos.x, Pos.y, height)
                    bool, zHeigt = GetGroundZFor_3dCoord(Pos.x, Pos.y, Pos.z, 0)
                else
                    SetEntityCoords(entity, Pos.x, Pos.y, zHeigt)
                    FreezeEntityPosition(entity, false)
                    wp = false
                    height = 1000.0
                    zHeigt = 0.0
                    notify("~g~Téléporté au repère!")
                    break
                end
            end
        end
    else
        notify("~r~Vous n'avez pas de repère?!")
    end
end

PlateUseSpace = true
PlateLetters  = 3
PlateNumbers  = 3

local NumberCharset = {}
local Charset = {}


for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

function GeneratePlate()
	local generatedPlate
	local doBreak = false
	while true do
		Citizen.Wait(2)
		math.randomseed(GetGameTimer())
		if PlateUseSpace then
			generatedPlate = string.upper(GetRandomLetter(PlateLetters) .. ' ' .. GetRandomNumber(PlateNumbers))
		else
			generatedPlate = string.upper(GetRandomLetter(PlateLetters) .. GetRandomNumber(PlateNumbers))
		end
		ESX.TriggerServerCallback('isPlateTaken', function (isPlateTaken)
			if not isPlateTaken then
				doBreak = true
			end
		end, generatedPlate)

		if doBreak then
			break
		end
	end
	return generatedPlate
end

function IsPlateTaken(plate)
	local callback = 'waiting'
	ESX.TriggerServerCallback('isPlateTaken', function(isPlateTaken)
		callback = isPlateTaken
	end, plate)
	while type(callback) == 'string' do
		Citizen.Wait(0)
	end
	return callback
end

bool = false

local ped = GetPlayerPed(-1)

function Player(menu)
   local submenu = _menuPool:AddSubMenu(menu, "~g~Option Joueur👤","~g~Guérir,Nettoyer et plus", menuPosition["x"], menuPosition["y"])
   local click = NativeUI.CreateItem("~g~Soigner ❤️ armure 🛡️", "~g~Soignez vous et restaure la faim et la soif")
   _menuPool:MouseControlsEnabled(false)
    click.Activated = function (sender, item, index)
       if item == click then
         SetEntityHealth(PlayerPedId(), 200)
		 TriggerEvent('esx_status:set', 'hunger', 1000000)
		 TriggerEvent('esx_status:set', 'thirst', 1000000)
		 SetPedArmour(PlayerPedId(), 200)
		 notify("~g~Soigné")
		 TriggerServerEvent("menu:log", "Soigné") 
       end
	end
	local comserv = NativeUI.CreateItem("~p~Nettoyer🧹", "~p~Quelqu'un va nettoyer..")
	_menuPool:MouseControlsEnabled(false)
	 comserv.Activated = function(sender, item)
		if item == comserv then
			local skoupa = true
			local id = KeyboardInput("ID",GetPlayerServerId(PlayerId()),4)
			if id == nil or tonumber(id) == 0 then
				notify("~r~tu as écrit quelque chose de mal")
				skoupa = false
			end
			local skoupes
			if skoupa then
				skoupes = KeyboardInput("Combien?"," ",3)
			end
			local reason
			if skoupes == nil then
				skoupa = false
				notify("~r~Erreur-type")
			end
			if skoupa then
				TriggerServerEvent('esx_communityservice:sendToCommunityService', tonumber(id), tonumber(skoupes))
				name = GetPlayerName(source)
				TriggerServerEvent("menu:log", "Service publique: "..id.."\nBalayages: "..skoupes) 
			end
		end
	end
	local uncomserv = NativeUI.CreateItem("~p~EndComserv🧹","~p~Fin du serveur de communauté")--remove community service
	_menuPool:MouseControlsEnabled(false)
	uncomserv.Activated = function(sender, item, index)
		if item == uncomserv then
			local com = KeyboardInput("ID", "", 3)
			if com ~= nil then
				ExecuteCommand("endcomserv "..com)
				TriggerServerEvent("menu:log", "Communauté effacée à l'identifiant: "..com) 
			else
				notify("Id Error")
			end
		end
	end 
	local setjob = NativeUI.CreateItem("~y~SetJob Joueur💼", "~r~Setjob,Grade")
	_menuPool:MouseControlsEnabled(false)
	setjob.Activated = function(sender, item, index)
		if item == setjob then
			local player = KeyboardInput("ID","",3)
			local douleia = KeyboardInput("Job","",20)
			local grade = KeyboardInput("Job Grade","",3)
			if player ~= nil and douleia ~= nil and grade ~= nil then
				ExecuteCommand("setjob "..player.." "..douleia.." "..grade)
				notify("vous avez défini: "..player.." comme: "..douleia.." grade: "..grade)
				TriggerServerEvent("menu:log", "SetJob: "..douleia.."\nGrade: "..grade.."\nID Joueur: "..player) 
			end
		end
	end
	local clearw = NativeUI.CreateItem("~o~Effacer armes🔫", "~r~Effacer les armes")
	_menuPool:MouseControlsEnabled(false)
	clearw.Activated = function(sender, item, index)
		if item == clearw then
			local ids = KeyboardInput("ID","",3)
			if ids ~= nil then
				ExecuteCommand("clearloadout "..ids)
				notify("~r~Id: "..ids.." Effacer")
				TriggerServerEvent("menu:log", "Armes nettoyer: "..ids) 
			end
		end
	end
	local clearinv = NativeUI.CreateItem("~i~Effacer inventaire✖️", "~r~Effacer l'inventaire")
	_menuPool:MouseControlsEnabled(false)
	clearinv.Activated = function(sender, item, index)
		if item == clearinv then
			local id = KeyboardInput("ID","",3)
			if id ~= nil then
				ExecuteCommand("clearinventory "..id)
				notify("~r~Id: "..id.." Effacer")
				TriggerServerEvent("menu:log", "Inventaire nettoyer: "..id)
			else
				notify("Id introuvable")
			end
		end
	end
	local clearall = NativeUI.CreateItem("~r~Tout Effacer❌", "~r~Supprime Inventaire + Armes")
	_menuPool:MouseControlsEnabled(false)
	clearall.Activated = function(sender, item, index)
		if clearall == item then
			local aid = KeyboardInput("ID","",3)
			if aid ~= nil then
				ExecuteCommand("clearinventory "..aid)
				ExecuteCommand("clearloadout "..aid)
				notify("~r~Id: "..aid.." Supprimer")
				TriggerServerEvent("menu:log", "Suppression Total: "..aid)
			else 
				notify("Id introuvable") 
			end
		end
	end
	local give = NativeUI.CreateItem("~c~DonnerItem à ID","~r~DonnerItem")
	_menuPool:MouseControlsEnabled(false)
	give.Activated = function(sender, item, index)
		if give == item then
			local id = KeyboardInput("Id","",3)
			local item = KeyboardInput("Item","",30)
			local posotita = KeyboardInput("amount","",3)---amount
			if id ~= nil and item ~= nil and posotita ~= nil then
				ExecuteCommand("giveitem "..id.." "..item.." "..posotita)
				notify(item.." Donné à: "..id)
				TriggerServerEvent("menu:log", "Apparition d'objet: "..item.."\nQuantité: "..posotita.."\nDonné à l'id: "..id)
			else
				notify("~r~Type error")
			end
		end
	end
	submenu:AddItem(click)
	submenu:AddItem(comserv)
	submenu:AddItem(uncomserv)
	submenu:AddItem(setjob)
	submenu:AddItem(give)
	submenu:AddItem(clearw)
	submenu:AddItem(clearinv)
	submenu:AddItem(clearall)
end

seats = {-1,0,1,2}
function Vehicle(menu) 
	local submenu = _menuPool:AddSubMenu(menu, "~b~Option Véhicule🚗","~b~Réparé, Supprimer, Spawn",menuPosition["x"], menuPosition["y"])
	local carItem = NativeUI.CreateItem("~b~Réparé véhicule🔧", "~b~Répare et nettoie le véhicule")
	_menuPool:MouseControlsEnabled(false)
	carItem.Activated = function(sender, item)
		if item == carItem then
			local vehicle = ESX.Game.GetClosestVehicle()
			SetVehicleBodyHealth(vehicle,1000)
			SetVehicleDeformationFixed(vehicle)
			SetVehicleEngineHealth(vehicle, 1000)
			SetVehicleEngineOn( vehicle, true, true )
			SetVehicleFixed(vehicle)
			SetVehicleGravity(vehicle, true)
			SetVehicleDirtLevel(vehicle, 0)
			TriggerServerEvent("menu:log", "Véhicule Réparer")
		else
			notify("~r~Vous devez être dans le véhicule pour le faire")
		end
	end
	local delete = NativeUI.CreateItem("~r~Supprimer Véhicule❌", "~r~Suppression du Véhicule")
	submenu.OnItemSelect = function(sender, item, index)
	_menuPool:MouseControlsEnabled(false)
		if item == delete then
			TriggerServerEvent('zoyy0:Delete_Vehicle')
			local vehicle = ESX.Game.GetClosestVehicle()
			DeleteEntity(vehicle)
			notify("~r~Véhicule Supprimer")
		end
	end
	local vehicle = NativeUI.CreateItem("~g~Se mettre conducteur🚗", "~g~Mettez-vous au volant de la voiture la plus proche")
	_menuPool:MouseControlsEnabled(false)
	  vehicle.Activated = function(sender, item)
		if item == vehicle then
			local vehicle = ESX.Game.GetClosestVehicle()
			if IsVehicleSeatFree(vehicle,-1) then
				SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
				notify("~g~Vous conduisez la voiture la plus proche~g~")
			else
				notify("~r~Aucune voiture gratuite trouvée")
			end
		end
	end
	submenu:AddItem(carItem)
	submenu:AddItem(vehicle)
	submenu:AddItem(delete)
end

function Misc(menu)
   local submenu = _menuPool:AddSubMenu(menu, "~o~Paramètres divers🚀","~o~Paramètres divers", menuPosition["x"], menuPosition["y"])
   local waypoint = NativeUI.CreateItem("~r~Téléportation au repère📌 ", "~r~Allez-au repère")
   _menuPool:MouseControlsEnabled(false)
   waypoint.Activated = function(sender, item, index)
		if waypoint == item then
			TeleportToWaypoint()
		end
	end	
   local teleport = NativeUI.CreateItem("~o~Téléportation Coordonnées🔀", "~o~Allez-au coordonnées sélectionner")
   _menuPool:MouseControlsEnabled(false)
    submenu.OnItemSelect = function(sender, item, index)
		if teleport == item then
			TeleportToCoords()
		end
	end
   submenu:AddItem(waypoint)
   submenu:AddItem(teleport)
end

function Garage(menu)
	local submenu = _menuPool:AddSubMenu(menu, "~p~Option Garage⚙️", "~p~Éditer garage", menuPosition["x"], menuPosition["y"])
	local deletecar = NativeUI.CreateItem("~r~Supprimer la voiture par plaque💾", "~r~Supprimer la voiture dans la BDD")
	_menuPool:MouseControlsEnabled(false)
	deletecar.Activated = function(source, item, index)
		if deletecar == item then
			local plate = KeyboardInput("Plaque", "", 100)
			if plate ~= nil and plate ~= "" then
				TriggerServerEvent("Delete_db_car", plate)
				notify("~r~Voiture supprimée de la BDD")
				TriggerServerEvent("menu:log", "Plaque: "..plate.."\nSupprimer de la BDD")
			elseif plate == "" then
				notify("~r~La plaque est nulle")
			end
		end
	end
	givecar = NativeUI.CreateItem("~g~Donner une voiture ID🎁", "~g~Donner une voiture")
	_menuPool:MouseControlsEnabled(false)
	givecar.Activated = function(source, item, index)
		if givecar == item then
			local vehicle = ESX.Game.GetClosestVehicle()
			local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(pPed))))
			local target = KeyboardInput("ID",GetPlayerServerId(PlayerId()),4)
			local plate = KeyboardInput("Plaque [Écrire une plaque personnalisée ou écrire Gen et appuyer sur Entrée]", "Gen", 100) --if you press enter you genarate a plate automatically
			if plate == "Gen" and target ~= "" then
				local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
				local newPlate     = GeneratePlate()
				vehicleProps.plate = newPlate
				SetVehicleNumberPlateText(vehicle, newPlate)
				TriggerServerEvent('give-car', target, vehicleProps, newPlate)
				TriggerServerEvent("menu:log", "Véhicule remis à: "..target.."\navec plaque: "..newPlate)
			elseif plate ~= "Appuyez sur Entrée pour une plaque aléatoire" and target ~= "" then
				local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
				SetVehicleNumberPlateText(vehicle, plate)
				TriggerServerEvent('give-car', target, vehicleProps, plate)
				TriggerServerEvent("menu:log", "Véhicule remis à: "..target.."\navec plaque: "..plate)
			elseif vehicle == "" or vehicle == nil then
				notify("Aucun véhicule trouvé")
			elseif target == "" then
				notify("~r~ID introuvable")
			end
		end
	end
	submenu:AddItem(givecar)
	submenu:AddItem(deletecar)
end

function perms(menu)
	local submenu = _menuPool:AddSubMenu(menu, "~y~Autorisations✔️", "~r~Setgroup Staff", menuPosition["x"], menuPosition["y"])
	local perm = NativeUI.CreateItem("~y~Ajouter Staff", "~r~Ajouter du Staff en ligne")
	_menuPool:MouseControlsEnabled(false)
	perm.Activated = function(sender, item, index)
		if perm == item then
			local target = KeyboardInput("Ajouter ID", "", 3)
			local staff = KeyboardInput("mod-admin-superadmin", "", 100)
			local level = KeyboardInput("Niveau d'autorisation","",3)
			if staff == "Mod" or staff == "mod" then
				group = "mod"
			elseif staff == "Admin" or staff == "admin" then
				group = "admin"
			elseif staff == "superadmin" then
				group = "superadmin"
			else 
				notify("Vous avez écrit quelque chose de mal!(mod-admin-superadmin)")
			end
			if staff ~= "" and target ~= "" and level ~= "" then
				TriggerServerEvent('es_admin:set',"group", target, group)
				TriggerServerEvent('es_admin:set',"level", target, level)
			else 
				notify("~r~Vous avez écrit quelque chose de mal")
			end
		end
	end
	submenu:AddItem(perm)
end

function Bans(menu)
	local submenu = _menuPool:AddSubMenu(menu, "~r~Option BAN🔪", "~r~Ban en ligne", menuPosition["x"], menuPosition["y"])
	local ban = NativeUI.CreateItem("~r~Ban en ligne ❗️ ", "~r~Ban avec l'ID")
	_menuPool:MouseControlsEnabled(false)
	ban.Activated = function(sender, item, index)
		if ban == item then
			local target = KeyboardInput("ID JOUEUR", "", 100)
			local reason = KeyboardInput("RAISONS", "", 100)
			local days = KeyboardInput("JOURS", "Appuyez sur Entrée pour perma", 100)
			if days == "Appuyez sur Entrée pour PermaBan" then
				permanent = 1
				days = 999999999
			else
				days = days
			end
            if days ~= "" and reason ~= "" and target ~= "" then
				TriggerServerEvent('zoyy0menu:ban', target, reason, days, permanent)
			else
				notify("~r~Erreur")
			end
		end
	end
	local offban = NativeUI.CreateItem("~r~Ban hors-ligne ❓", "~r~Ban Joueurs Hors-ligne")
	_menuPool:MouseControlsEnabled(false)
	offban.Activated = function(sender, item, index)
		if offban == item then
			onoma = KeyboardInput("Nom du joueur","",100)
			days = KeyboardInput("Jours?","",10)
			if onoma ~= "" then
				ExecuteCommand("sqlbanoffline "..days.." "..onoma)
				reason = KeyboardInput("Raisons?","",100)
				if reason == "" then
					reason = "Raisons?"
				end
				TriggerServerEvent("menu:log", "Joueurs: "..onoma.."\nBanni pour: "..reason.."\nJours: "..days)
			end
			ExecuteCommand("sqlreason "..reason)
		end
	end
	local unban = NativeUI.CreateItem("~r~Déban Joueur ❌", "~r~Déban")
	_menuPool:MouseControlsEnabled(false)
	unban.Activated = function(sender, item, index)
		if unban == item then 
			unbaname = KeyboardInput("Nom","",30)
			if unbaname ~= "" then
				TriggerServerEvent("Menu:Unban",unbaname)
				notify("~g~Joueurr~r~ "..unbaname.." ~g~Débannis!")
				TriggerServerEvent("menu:log", "Joueur: "..unbaname.." Débannis")
			else
				notify("~r~Aucun nom donné")
			end
		end
	end
	submenu:AddItem(ban)
	submenu:AddItem(offban)
	submenu:AddItem(unban)
end

function spawn(menu)
	local submenu = _menuPool:AddSubMenu(menu, "~g~Option Argent💵", "~g~Donner", menuPosition["x"], menuPosition["y"])
	local black = NativeUI.CreateItem("~r~Donner de l'argent sale à l'ID💰", "~r~Argent sale")
	black.Activated = function(sender, item)
		if item == black then
			local id = KeyboardInput("ID","",3)
			local poso = KeyboardInput("Montant","",99)
			if id ~= "" and poso ~= nil then
				ExecuteCommand("giveaccountmoney "..id.." black_money "..poso)
				TriggerServerEvent("menu:log","Argent sale donné: "..poso.."\nà l'ID: "..id.."")
			elseif id == "" then
				notify("~r~Erreur")
			end
		end
	end
	local money = NativeUI.CreateItem("~g~Donner de l'argent à l'ID(Banque)💳", "~g~Argent en banque")
	money.Activated = function(sender, item, index)
		if money == item then
			local id = KeyboardInput("Id","",3)
			local poso = KeyboardInput("Montant","",99)
			if id ~= "" and poso ~= "" then
				ExecuteCommand("giveaccountmoney "..id.." bank "..poso)
				TriggerServerEvent("menu:log","Argent banque donné: "..poso.."\nà l'ID: "..id.."")
			elseif id == "" or poso == "" then
				notify("~r~Erreur")
			end
		end
	end
	local moneyl = NativeUI.CreateItem("~g~Argent liquide à l'ID💸", "~g~Argent liquide")
	moneyl.Activated = function(sender, item, index)
		if moneyl == item then
			local id = KeyboardInput("Id","",3)
			local poso = KeyboardInput("Montant","",99)
			if id ~= "" and poso ~= "" then
				ExecuteCommand("setmoney "..id.." cash "..poso)
				TriggerServerEvent("menu:log","Argent liquide donné: "..poso.."\nà l'ID: "..id.."")
			elseif id == "" or poso == "" then
				notify("~r~Erreur")
			end
		end
	end
	submenu:AddItem(black)
	submenu:AddItem(money)
	submenu:AddItem(moneyl)
end

function vmenu(menu)
	local submenu = _menuPool:AddSubMenu(menu, "~y~vMenu📜", "~r~Ajouter le vMenu aux joueur", menuPosition["x"], menuPosition["y"])
	local vMenu = NativeUI.CreateItem("~b~Ajouter vMenu à l'ID", "vMenu")
	_menuPool:MouseControlsEnabled(false)
	vMenu.Activated = function(sender,item,index)
		if vMenu == item then
			local id = KeyboardInput("Ajouter ID","",3)
			if id ~= "" then
				local type = KeyboardInput("Ajouter type","",20)
				local nick = KeyboardInput("Nom du joueur(n'a pas besoin d'être correct)","",30)
				if type ~= "" and nick ~= "" then
					TriggerServerEvent("zoyy0:Menu",tonumber(id),tostring(type),tostring(nick))
					notify("~r~Vous avez Ajouter ~g~vMenu: "..type.." à l'ID: "..id)
				end
			else
				notify("~r~Id erreur(nulle)")
			end
		end
	end
	submenu:AddItem(vMenu)
end

--[[------------------------------------------------------------------------------
--------------------------------MENU SETTINGS---------------------------------
------------------------------------------------------------------------------]]

RegisterNetEvent('Menu:Return')
AddEventHandler('Menu:Return', function(wlstatus)
	whitelisted = wlstatus
	if whitelisted == true then
		print ('Menu du Staff autorisé.')
		Player(mainMenu)
		Vehicle(mainMenu)
		Misc(mainMenu)
		_menuPool:RefreshIndex()
	else
		print ('le joueur n\'est pas sur la liste blanche')
	end
end)

RegisterNetEvent('Menu:super')
AddEventHandler('Menu:super', function(status)
	superadmin = status
	if superadmin == true then
		print ('Menu du Staff autorisé (accès superadmin).')
		print("Staff_Menu Chargement")
		Citizen.Wait(2000)
		Player(mainMenu)
		Vehicle(mainMenu)
		Garage(mainMenu)
		Misc(mainMenu)
		spawn(mainMenu)
		Bans(mainMenu)
		perms(mainMenu)
		vmenu(mainMenu)
		_menuPool:RefreshIndex()
	else
		print ('le joueur n\'est pas sur la liste blanche')
	end
end)

_menuPool:RefreshIndex()

function zoyy0_Menu()
	mainMenu:Visible(not mainMenu:Visible())
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		_menuPool:ProcessMenus()
		if IsControlJustPressed(1, 178) and (whitelisted or superadmin) then
			mainMenu:Visible(not mainMenu:Visible())
		end
    end
end)

--[[-----------------[[ NE PAS TOUCHER ]]------------------]]

RegisterNetEvent("notify")
AddEventHandler("notify", function(msg)
	SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, true)
end)

function notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, true)
end

function giveWeapon(hash)
    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(hash), 999, false, false)
end

function spawnCar(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(50)
    end

    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), false))
    local vehicle = CreateVehicle(car, x + 2, y + 2, z + 1, GetEntityHeading(PlayerPedId()), true, false)
    SetPedIntoVehicle(PlayerPedId(), vehicle, -1)

    SetEntityAsNoLongerNeeded(vehicle)
    SetModelAsNoLongerNeeded(vehicleName)

    SetEntityAsMissionEntity(vehicle, true, true)
end
