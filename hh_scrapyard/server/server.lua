QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local NPC                               = 0
local NPCspawned                        = false

local scrapVeh1, scrapVeh2, scrapVeh3 = nil, nil, nil
local car1, car2, car3 = 0, 0, 0


Citizen.CreateThread(function()
        Citizen.Wait(1000)
        while not NPCspawned do
                -- Locate the NPC:
                print("PapaDuce")
                NPC = math.random(1,#Config.Scrapyards)
                -- Find 3 random cars:
                car1 = math.random(1,#Config.FreeroamCars)
                scrapVeh1 = Config.FreeroamCars[car1]
                car2 = math.random(1,#Config.FreeroamCars)
                while car1 == car2 do
                    car2 = math.random(1,#Config.FreeroamCars)
                end
                scrapVeh2 = Config.FreeroamCars[car2]
                car3 = math.random(1,#Config.FreeroamCars)
                while car1 == car3 or car2 == car3 do
                    car3 = math.random(1,#Config.FreeroamCars)
                end
                scrapVeh3 = Config.FreeroamCars[car3]
                TriggerClientEvent("hh_scrap:spawnNPC",-1,Config.Scrapyards[NPC], scrapVeh1, scrapVeh2, scrapVeh3)
                NPCspawned = true
                Citizen.Wait(60000 * Config.PedMinutes)
                NPCspawned = false
        end
end)

AddEventHandler('QBCore:Server:OnPlayerLoaded', function(playerId)
    TriggerClientEvent("hh_scrap:spawnNPC",playerId,Config.Scrapyards[NPC], scrapVeh1, scrapVeh2, scrapVeh3)
end)



-- Server Event for Job Reward:
RegisterServerEvent("hh_scrap:Payment")
AddEventHandler("hh_scrap:Payment",function(scrapCar, Percent)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    local DirtyCash = false
    local CashReward = math.floor((scrapCar.VehPrice/2) * (Percent/100))
    local NewChance = (math.random(1,10) * 10)

    if Config.EnableItemRewards then
        local k = 0
        for k,v in pairs(scrapCar.BodyParts) do
            if v.chance >= NewChance then
                local itemAmount = math.random(v.min,v.max)
                xPlayer.Functions.AddItem(v.item, tonumber(itemAmount))
            end
            k = (k + 1)
        end
    end

    if Config.EnableCashRewards then
        if Config.ReceiveDirtyCash then
            DirtyCash = true
        else
            DirtyCash = false
        end
        if DirtyCash then
          --  xPlayer.addAccountMoney('black_money', CashReward)
        else
            xPlayer.Functions.AddMoney('cash',CashReward) 
        end
        TriggerClientEvent("QBCore:Notify", source, "You received "..CashReward.." in cash for the car", "success", 5000)
    end

end)


QBCore.Functions.CreateCallback("Krliya:server:scraplode", function(source, cb, plate)
    QBCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            cb(true)
        else
            cb(false)
        end
    end)
end)



RegisterServerEvent("Krliya:scraplode")
AddEventHandler("Krliya:scraplode",function()
    DropPlayer(source, "Sorry, You Have Been Kicked Due to Exploting Scrap Yard")
    print("Kicked Due to Scrap Exploit")
end)
