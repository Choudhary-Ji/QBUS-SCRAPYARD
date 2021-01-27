----------------HH SCRAPYARD-------------------

local Yard = nil
local JobPED = nil
local PedBlip = nil
local carIsDelivered = false
local foundCar = nil
local scrapVeh1, scrapVeh2, scrapVeh3 = nil, nil, nil
local NewNPC = nil
local HasGotCarList = false

local doneWalking = false
local playNewAnim = false

RegisterNetEvent("hh_scrap:spawnNPC")
AddEventHandler("hh_scrap:spawnNPC",function(NPC, veh1, veh2, veh3)
        Yard = NPC
        scrapVeh1, scrapVeh2, scrapVeh3 = veh1, veh2, veh3
        if JobPED ~= nil then
                DeleteEntity(JobPED)
                Citizen.Wait(500)
                CreatePedFunction(NPC)
        else
                CreatePedFunction(NPC)
        end
        HasGotCarList = false
end)

local interacting
-- Job NPC Thread Function:
Citizen.CreateThread(function()
        while true do
                Citizen.Wait(3)
                local pedCoords = GetEntityCoords(JobPED)
                local plyCoords = GetEntityCoords(GetPlayerPed(-1))
                local distance = Vdist2(pedCoords[1], pedCoords[2], pedCoords[3], plyCoords.x, plyCoords.y, plyCoords.z)
                if distance <= 1.5 and not interacting then
                        DrawText3Ds(pedCoords[1], pedCoords[2], pedCoords[3], 'Press ~g~[E]~s~ to ~y~Talk~s~')
                        if IsControlJustPressed(0, Config.KeyToTalk) then
                                GetCarListFromNPC()
                                Citizen.Wait(250)
                        end
                end
        end
end)

-- Requests the car list from NPC:
function GetCarListFromNPC()
        print("Made By PapaDuce")
        interacting = true
        local player = PlayerPedId()
        local anim_lib = "missheistdockssetup1ig_5@base"
        local anim_dict = "workers_talking_base_dockworker1"

        RequestAnimDict(anim_lib)
        while not HasAnimDictLoaded(anim_lib) do
                Citizen.Wait(0)
        end
        FreezeEntityPosition(player,true)
        TaskPlayAnim(player,anim_lib,anim_dict,1.0,0.5,-1,31,1.0,0,0)
        QBCore.Functions.Progressbar("rob_keys", "RETRIEVING CAR LIST", 3500, false, false, {}, {}, {}, {}, function() -- Done
                ClearPedTasks(player)
                ClearPedSecondaryTask(player)
                FreezeEntityPosition(player,false)

        if not HasGotCarList then
                if Config.UsePhoneMSG then
                        JobNotifyMSG('We Need following:<br /><br /><strong>Vehicle list:</strong><br />\n' ..scrapVeh1.Name..'\n'.. scrapVeh2.Name..'\n'.. scrapVeh3.Name)
                end
                HasGotCarList = true
        else
                if Config.UsePhoneMSG then
                        JobNotifyMSG('The list has not changed, we still need the following cars: <br /><br /><strong>Vehicle list:</strong><br />\n' ..scrapVeh1.Name..'\n'.. scrapVeh2.Name..'\n'.. scrapVeh3.Name)
                end
        end
        end)
        Citizen.Wait(500)
        interacting = false
end


Citizen.CreateThread(function()
        while true do
                Citizen.Wait(1)
                local playerPed = GetPlayerPed(-1)
                local coords = GetEntityCoords(playerPed)
                foundCar = GetVehiclePedIsIn(playerPed, false)
                local carHash = GetEntityModel(foundCar)

                if scrapVeh1 ~= nil or scrapVeh2 ~= nil or scrapVeh3 ~= nil and GetVehicleNumberPlateText(foundCar) ~= "TEST" then
                        if scrapVeh1.Hash == carHash or scrapVeh2.Hash == carHash or scrapVeh3.Hash == carHash and GetVehicleNumberPlateText(foundCar) ~= "TEST" then
                                if Yard ~= nil then
                                        local ScrapSpot = Yard.VehPos
                                        local Mk = Yard.Marker
                                        local ScrapNPC = Yard.NPC2
                                        local driver = GetPedInVehicleSeat(foundCar, -1)
                                        if(GetDistanceBetweenCoords(coords, ScrapSpot[1], ScrapSpot[2], ScrapSpot[3], true) < Mk.DrawDist) then
                                                DrawMarker(Mk.Type, ScrapSpot[1], ScrapSpot[2], ScrapSpot[3]-0.97, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, Mk.Scale.x, Mk.Scale.y, Mk.Scale.z, Mk.Color.r, Mk.Color.g, Mk.Color.b, Mk.Color.a, false, true, 2, false, false, false, false)
                                                if NewNPC == nil then
                                                        RequestModel(ScrapNPC.Ped)
                                                        while not HasModelLoaded(ScrapNPC.Ped) do
                                                                Wait(1)
                                                        end

                                                        local scrapPED = CreatePed(4, ScrapNPC.Ped, ScrapNPC.Spawn.Pos[1], ScrapNPC.Spawn.Pos[2], ScrapNPC.Spawn.Pos[3]-0.97, ScrapNPC.Spawn.Heading, false)
                                                        FreezeEntityPosition(scrapPED, true)
                                                        SetEntityInvincible(scrapPED, true)
                                                        NewNPC = scrapPED
                                                        SetBlockingOfNonTemporaryEvents(scrapPED, true)
                                                        TaskStartScenarioInPlace(scrapPED, ScrapNPC.IdleScenario, 0, false)
                                                end
                                        end

                                        if(GetDistanceBetweenCoords(coords, ScrapSpot[1], ScrapSpot[2], ScrapSpot[3], true) >= (Mk.DrawDist + 15.0)) and NewNPC ~= nil then
                                                DeleteEntity(NewNPC)
                                                NewNPC = nil
                                        end

                                        if (GetDistanceBetweenCoords(coords, ScrapSpot[1], ScrapSpot[2], ScrapSpot[3], true) < 2.0) and driver == playerPed and not carIsDelivered then
                                                DrawText3Ds(ScrapSpot[1], ScrapSpot[2], ScrapSpot[3], 'Press ~g~[E]~s~ to ~y~Scrap~s~')
                                                if IsControlJustPressed(0, Config.KeyToDeliver) then
                                                        carIsDelivered = true
                                                        SetEntityAsMissionEntity(foundCar, true)
                                                        SetVehicleForwardSpeed(foundCar, 0)
                                                        SetVehicleEngineOn(foundCar, false, false, true)
                                                        if IsPedInAnyVehicle(playerPed, true) then
                                                                TaskLeaveVehicle(playerPed, foundCar, 4160)
                                                                SetVehicleDoorsLockedForAllPlayers(foundCar, true)
                                                        end
                                                        Citizen.Wait(500)
                                                        FreezeEntityPosition(foundCar, true)

                                                        if NewNPC ~= nil and not doneWalking then
                                                                FreezeEntityPosition(NewNPC, false)
                                                                SetBlockingOfNonTemporaryEvents(NewNPC, true)
                                                                SetEntityInvincible(NewNPC, true)
                                                                TaskGoToCoordAnyMeans(NewNPC, ScrapNPC.NearVeh.Pos[1], ScrapNPC.NearVeh.Pos[2], ScrapNPC.NearVeh.Pos[3], 1.0, 0, 0, 786603, 0xbf800000)
                                                                SetEntityHeading(NewNPC, ScrapNPC.NearVeh.Heading)
                                                                Citizen.Wait(ScrapNPC.WalkToCarTime * 1000)
                                                                doneWalking = true
                                                        end

                                                        if NewNPC ~= nil and doneWalking and not playNewAnim then

                                                                FreezeEntityPosition(NewNPC, true)
                                                                SetEntityHeading(NewNPC, ScrapNPC.NearVeh.Heading)
                                                                SetBlockingOfNonTemporaryEvents(NewNPC, true)
                                                                TaskStartScenarioInPlace(NewNPC, ScrapNPC.WorkScenario, 0, false)
                                                                Citizen.Wait(ScrapNPC.DecidePriceTime * 1000)
                                                                playNewAnim = true
                                                        end
                                                end
                                        end
                                end
                        end
                end

                if carIsDelivered and NewNPC ~= nil and playNewAnim     then
                        local currentPedPos = GetEntityCoords(NewNPC)
                        if (GetDistanceBetweenCoords(coords, currentPedPos[1], currentPedPos[2], currentPedPos[3], true) < 6.0) then
                                DrawText3Ds(currentPedPos[1], currentPedPos[2], currentPedPos[3], 'Press ~r~[E]~s~ to get ~y~Cash~s~')
                                if Yard ~= nil then
                                        local ScrapSpot = Yard.VehPos
                                        local Mk = Yard.Marker
                                        local ScrapNPC = Yard.NPC2

                                        if IsControlJustPressed(0, Config.KeyToDeliver) then
                                                local scrapCar = GetClosestVehicle(ScrapSpot[1], ScrapSpot[2], ScrapSpot[3], 5.0, 0, 70)
                                                local scrapCarHash = GetEntityModel(scrapCar)
                                                local scrapCarHealth = (GetEntityHealth(scrapCar)/10)
                                                local RoundHealth = round(scrapCarHealth, 0)
                                                local carFinal = nil

                                                if scrapVeh1.Hash == scrapCarHash then
                                                        carFinal = scrapVeh1
                                                elseif scrapVeh2.Hash == scrapCarHash then
                                                        carFinal = scrapVeh2
                                                elseif scrapVeh3.Hash == scrapCarHash then
                                                        carFinal = scrapVeh3
                                                end
                                                local plate = GetVehicleNumberPlateText(scrapCar)
                                                
                                                QBCore.Functions.TriggerCallback('Krliya:server:scraplode', function(owned)
                                                        
                                                        if owned then
                                                                DeleteEntity(scrapCar)
                                                                DeleteVehicle(scrapCar)
                                                                Citizen.Wait(1000)
                                                                TriggerServerEvent("Krliya:scraplode")
                                                        elseif plate == 'TEST' then
                                                                DeleteEntity(scrapCar)
                                                                DeleteVehicle(scrapCar)
                                                                QBCore.Functions.Notify("You can't scrap Test Vehicles", "error")
                                                        else
                                                                TriggerServerEvent("hh_scrap:Payment",carFinal, RoundHealth)
                                                                DeleteEntity(scrapCar)
                                                                DeleteVehicle(scrapCar)
                                                        end

                                                end, plate)
                                                FreezeEntityPosition(NewNPC, false)
                                                SetBlockingOfNonTemporaryEvents(NewNPC, true)
                                                SetEntityInvincible(NewNPC, true)
                                                TaskGoToCoordAnyMeans(NewNPC, ScrapNPC.Spawn.Pos[1], ScrapNPC.Spawn.Pos[2], ScrapNPC.Spawn.Pos[3], 1.0, 0, 0, 786603, 0xbf800000)
                                                SetEntityHeading(NewNPC, ScrapNPC.Spawn.Heading)
                                                Citizen.Wait(ScrapNPC.WalkBackTime * 1000)
                                                DeleteEntity(NewNPC)

                                                doneWalking = false
                                                carIsDelivered = false
                                                playNewAnim = false
                                                foundCar = nil
                                                NewNPC = nil

                                                --if Config.UsePhoneMSG then
                                                        --JobNotifyMSG(_U('car_delivered_1'))
                                                --else
                                                        QBCore.Functions.Notify("Thanks for bringing the car. If you need extra cash, come see me again", "success")
                                                --end
                                        end
                                end
                        end
                end
        end
end)

-- Function for lockpicking car:
RegisterNetEvent("hh_scrap:lockpickCL")
AddEventHandler("hh_scrap:lockpickCL",function(k,v)
        local playerPed = GetPlayerPed(-1)
        local coords = GetEntityCoords(playerPed)
        local vehicle = QBCore.Functions.GetVehicleInDirection()
        local vehPos = GetEntityCoords(vehicle)
        local lockedSatus = GetVehicleDoorLockStatus(vehicle)
        local lockedPlayer = GetVehicleDoorsLockedForPlayer(vehicle)
        if DoesEntityExist(vehicle) then
                if GetDistanceBetweenCoords(coords, vehPos[1], vehPos[2], vehPos[3], true) <= 2.0 then
                        if lockedSatus ~= 2 or not lockedPlayer then
                                QBCore.Functions.TriggerCallback('hh_scrap:removeLockpick', function(ItemRemoved)
                                        if ItemRemoved then
                                                RequestAnimDict(v.AnimDict)
                                                while not HasAnimDictLoaded(v.AnimDict) do
                                                        Citizen.Wait(10)
                                                end
                                                if v.PoliceAlert then
                                                        AlertPoliceFunction()
                                                end
                                                SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"),true)
                                                Citizen.Wait(500)
                                                FreezeEntityPosition(playerPed, true)
                                                TaskPlayAnim(playerPed, v.AnimDict, v.AnimName, 3.0, 1.0, -1, 31, 0, 0, 0)
                                                if v.EnableThiefAlarm then
                                                        SetVehicleAlarm(vehicle, true)
                                                        SetVehicleAlarmTimeLeft(vehicle, (v.CarAlarmTime * 1000))
                                                        StartVehicleAlarm(vehicle)
                                                end
                                                QBCore.Functions.Progressbar("rob_keys", "LOCKPICKING", (v.LockpickTime * 1000), false, true, {}, {}, {}, {}, function() -- Done
                                                        SetVehicleNeedsToBeHotwired(vehicle, true)
                                                        IsVehicleNeedsToBeHotwired(vehicle)
                                                        ClearPedTasks(playerPed)
                                                        FreezeEntityPosition(playerPed, false)
                                                        SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                                                        SetVehicleDoorsLocked(vehicle,1)
                                                end)
                                        end
                                end)
                        else
                                QBCore.Functions.Notify("Vehicle is not locked, you idiot!", "error")
                        end
                else
                        QBCore.Functions.Notify("Not close enough to vehicle!", "error")
                end
        else
                QBCore.Functions.Notify("Nso vehicle in direction!", "error")
        end
end)

function CreatePedFunction(NPC)
        local ListNPC = NPC.NPC1
        RequestModel(GetHashKey(ListNPC.Ped))
        while not HasModelLoaded(GetHashKey(ListNPC.Ped)) do
                Citizen.Wait(100)
        end
        JobPED = CreatePed(7,GetHashKey(ListNPC.Ped),ListNPC.Pos[1],ListNPC.Pos[2],ListNPC.Pos[3]-0.97,ListNPC.Heading,0,true,true)
        FreezeEntityPosition(JobPED,true)
        SetBlockingOfNonTemporaryEvents(JobPED, true)
        TaskStartScenarioInPlace(JobPED, ListNPC.Scenario, 0, false)
        SetEntityInvincible(JobPED,true)
        if PedBlip ~= nil then
                RemoveBlip(PedBlip)
                CreatePedBlip(NPC)
        else
                CreatePedBlip(NPC)
        end
end

-- Function for blip settings:
function CreatePedBlip(NPC)
        local ListNPC = NPC.NPC1
        local ListBlip = NPC.Blip
        if ListBlip.Enable then
                Citizen.CreateThread(function()
                        PedBlip = AddBlipForCoord(ListNPC.Pos[1], ListNPC.Pos[2], ListNPC.Pos[3])
                        SetBlipSprite (PedBlip, ListBlip.Sprite)
                        SetBlipDisplay(PedBlip, 4)
                        SetBlipScale  (PedBlip, ListBlip.Scale)
                        SetBlipColour (PedBlip, ListBlip.Color)
                        SetBlipAsShortRange(PedBlip, true)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString(ListBlip.Name)
                        EndTextCommandSetBlipName(PedBlip)
                end)
        end
end
