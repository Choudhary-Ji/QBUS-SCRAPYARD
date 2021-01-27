QBCore = nil

Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(0)
    end
end)

-- Outlaw Notify:
local streetName
local _



-- [[ POLICE ALERTS ]] --
function AlertPoliceFunction()
	TriggerServerEvent('hh_scrap:OutlawNotifySV',GetEntityCoords(PlayerPedId()),streetName)
	
	-- If you want to use your own alert:
	-- 1) Comment out the 'TriggerServerEvent('t1ger_carthief:OutlawNotifySV',GetEntityCoords(PlayerPedId()),streetName)'
	-- 2) replace whatever even you use to trigger your alert.
	
end
-- Thread for Police Notify
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3000)
		local pos = GetEntityCoords(GetPlayerPed(-1), false)
		streetName,_ = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
		streetName = GetStreetNameFromHashKey(streetName)
	end
end)

-- [[ PHONE MESSAGES ]] --
function JobNotifyMSG(msg)
	local phoneNr = Config.ScrapYardNPC
    PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Default", true)
	--HHCore.ShowNotification(_U('new_msg_from', phoneNr))
	--TriggerServerEvent('gcPhone:sendMessage', phoneNr, msg)
	TriggerServerEvent('qb-phone:server:sendNewMail', {
		sender = phoneNr,
		subject = "Vehicle list",
		message = msg,
		button = {}
	})
	
	-- If you use GCPhone and have not changed in it, do not touch this!
	-- If you use another phone or customized gcphone functions etc:
	-- 1) Edit the TriggerServerEvent to your likings
		
end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

-- Function for 3D text:
function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 500
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end

