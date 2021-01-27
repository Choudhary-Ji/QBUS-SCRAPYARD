Config 						= {}

-- Police Settings:
Config.PoliceJobName 		= "police"		-- set the exact name for police job from jobs table in DB
Config.PoliceBlipShow 		= true			-- enable or disable blip on map on police notify
Config.PoliceBlipTime 		= 30			-- miliseconds that blip is active on map (this value is multiplied with 4 in the script)
Config.PoliceBlipRadius 	= 50.0			-- set radius of the police notify blip
Config.PoliceBlipAlpha 		= 250			-- set alpha of the blip
Config.PoliceBlipColor 		= 5				-- set blip color

-- Scrapyard Settings:
Config.PedMinutes 			= 30				-- set timer in minutes for when NPC switches location. (48 minutes is 24 hours in game time)
Config.KeyToTalk 			= 38				-- set button/key to press to talk to NPC
Config.KeyToLockpick 		= 47				-- set button/key to press to lockpick vehicle
Config.KeyToDeliver 		= 38				-- set button/key to press to deliver vehicle
Config.UsePhoneMSG 			= true 				-- Enable to receive job msg through phone, disable to use ESX.ShowNotification or anything else you'd like.
Config.ScrapYardNPC 		= "Scrap Wala"
Config.ReceiveDirtyCash 	= false
Config.EnableItemRewards 	= true
Config.EnableCashRewards 	= true

-- Scrap Yards: 
Config.Scrapyards = {
	[1] = {
		NPC1 = {	-- NPC that u retrieve car list from
			Ped = 's_m_y_xmech_02_mp',
			Name = "UncleG",
			Pos = {-469.42,-1718.28,18.69},
			Heading = 281.9,
			Scenario = "WORLD_HUMAN_AA_SMOKE"
		},
		NPC2 = {																	-- NPC that gives reward upon delivery
			Ped 				= 's_m_y_xmech_02_mp',								-- Set npc model name here						
			Name 				= "UncleG",										-- Give your NPC a name	
			Spawn = {Pos 		= {-465.77,-1707.58,18.8}, Heading = 252.19},		-- Set NPC spawn pos & heading
			NearVeh = {Pos 		= {-459.98,-1712.81,18.67}, Heading = 240.04},		-- Set NPC walk to pos & heading
			IdleScenario 		= "WORLD_HUMAN_AA_SMOKE",							-- Set NPC idle scenario
			WorkScenario 		= "WORLD_HUMAN_CLIPBOARD",							-- Set NPC work scenario while deciding price
			WalkToCarTime 		= 6, 												-- Set NPC time taken to walk to car										
			DecidePriceTime 	= 4, 												-- Set NPC time taken for NPC to decide price/reward												
			WalkBackTime 		= 5, 												-- Set NPC time to walk back before despawning												
		},
		VehPos = {-457.29,-1713.84,18.64},
		Marker = {
			DrawDist = 35.0,
			Type = 27,
			Scale = {x = 5.0, y = 5.0, z = 1.0},
			Color = {r = 240, g = 52, b = 52, a = 100},
		},
		Blip = { Sprite = 280, Color = 5, Name = "Scrapyard", Scale = 0.8, Enable = true },
	},
	[2] = {
		NPC1 = {
			Ped = 's_m_y_xmech_02_mp',
			Name = "UncleG",
			Pos = {483.88, -1311.32,29.22},
			Heading = 274.01,
		},
		NPC2 = {
			Ped = 's_m_y_xmech_02_mp',
			Name = "UncleG",
			Spawn = {Pos = {475.19,-1313.36,29.21}, Heading = 231.3},
			NearVeh = {Pos ={478.35,-1316.21,29.2}, Heading = 238.97},
			IdleScenario = "WORLD_HUMAN_AA_SMOKE",
			WorkScenario = "WORLD_HUMAN_CLIPBOARD",							
			WalkToCarTime 		= 4.5, 																	
			DecidePriceTime 	= 4, 																						
			WalkBackTime 		= 4.5, 										
		},
		VehPos = {481.05,-1317.67,29.2},
		Marker = {
			DrawDist = 35.0,
			Type = 27,
			Scale = {x = 5.0, y = 5.0, z = 1.0},
			Color = {r = 240, g = 52, b = 52, a = 100},
		},
		Blip = { Sprite = 280, Color = 5, Name = "Scrapyard", Scale = 0.8, Enable = true },
	},
}


Config.FreeroamCars = {
	[1] = {
		Name = "Prairie", Hash = -1450650718, VehPrice = 850,
		BodyParts = {
			[1] = {item = "copper", min = 2, max = 4, chance = 75},
			[2] = {item = "glass", min = 3, max = 5, chance = 40},
			[3] = {item = "water_bottel", min = 1, max = 2, chance = 86},
			[4] = {item = "iron", min = 3, max = 5, chance = 38},
			[5] = {item = "burger", min = 5, max = 10, chance = 17},
		},
	},
	[2] = {Name = "Ingot", Hash = -1289722222, VehPrice = 650,
		BodyParts = {
			[1] = {item = "copper", min = 2, max = 4, chance = 75},
			[2] = {item = "water_bottel", min = 1, max = 2, chance = 40},
			[3] = {item = "glass", min = 3, max = 5, chance = 91},
			[4] = {item = "donut", min = 5, max = 12, chance = 38},
			[5] = {item = "iron", min = 3, max = 4, chance = 17},
		},
	},
	[3] = {Name = "Tailgater", Hash = -1008861746, VehPrice = 950,
		BodyParts = {
			[1] = {item = "phone", min = 1, max = 2, chance = 86},
			[2] = {item = "glass", min = 3, max = 5, chance = 91},
			[3] = {item = "donut", min = 5, max = 12, chance = 38},
			[4] = {item = "water_bottel", min = 1, max = 3, chance = 17},
		},
	},
	[4] = {Name = "F620", Hash = -591610296, VehPrice = 1250,
		BodyParts = {
			[1] = {item = "thermite", min = 1, max = 1, chance = 30},
			[2] = {item = "glass", min = 1, max = 4, chance = 40},
			[3] = {item = "water_bottel", min = 1, max = 2, chance = 86},
			[4] = {item = "water", min = 6, max = 14, chance = 91},
			[5] = {item = "phone", min = 1, max = 2, chance = 38},
			[6] = {item = "bluechip", min = 1, max = 1, chance = 37},
		},
	},
	[5] = {Name = "Jester", Hash = -1297672541, VehPrice = 1650,
		BodyParts = {
			[1] = {item = "water_bottel", min = 1, max = 2, chance = 86},
			[2] = {item = "glass", min = 3, max = 4, chance = 91},
			[3] = {item = "copper", min = 4, max = 8, chance = 38},
		},
	},
	[6] = {Name = "Massacro", Hash = -142942670, VehPrice = 1950,
		BodyParts = {
			[1] = {item = "water_bottel", min = 1, max = 2, chance = 75},
			[2] = {item = "thermite", min = 1, max = 1, chance = 20},
			[3] = {item = "copper", min = 3, max = 7, chance = 38},
			[4] = {item = "iron", min = 3, max = 6, chance = 17},
			[5] = {item = "thermal_charge", min = 1, max = 1, chance = 40},
		},
	},
	[7] = {Name = "Akuma", Hash = 1672195559, VehPrice = 250,                
		BodyParts = {
			[1] = {item = "water_bottel", min = 1, max = 2, chance = 75},
			[2] = {item = "thermite", min = 1, max = 1, chance = 10},
			[3] = {item = "copper", min = 3, max =6, chance = 38},
			[4] = {item = "iron", min = 2, max = 5, chance = 17},
			[5] = {item = "thermal_charge", min = 1, max = 1, chance = 40},
		},
	},
	[8] = {Name = "Zentorno", Hash = -1403128555, VehPrice = 2500,
		BodyParts = {
			[1] = {item = "water_bottel", min = 2, max = 4, chance = 75},
			[2] = {item = "thermite", min = 1, max = 1, chance = 50},
			[3] = {item = "copper", min = 2, max = 6, chance = 68},
			[4] = {item = "iron", min = 4, max = 8, chance = 67},
			[5] = {item = "bluechip", min = 1, max = 1, chance = 25},
			[6] = {item = "water", min = 8, max = 12, chance = 87},
			[7] = {item = "thermal_charge", min = 1, max = 1, chance = 45},
		},
	},
	[9] = {Name = "Infernus", Hash = 418536135, VehPrice = 2600,
		BodyParts = {
			[1] = {item = "water_bottel", min = 1, max = 4, chance = 75},
			[2] = {item = "thermite", min = 1, max = 1, chance = 25},
			[3] = {item = "copper", min = 4, max = 8, chance = 58},
			[4] = {item = "iron", min = 7, max = 12, chance = 77},
			[5] = {item = "bluechip", min = 1, max = 1, chance = 13},
		},
	},
	[10] = {Name = "Adder", Hash = -1216765807, VehPrice = 3000,
		BodyParts = {
			[1] = {item = "water_bottel", min = 3, max = 5, chance = 75},
			[2] = {item = "thermite", min = 1, max = 1, chance = 80},
			[3] = {item = "copper", min = 7, max = 13, chance = 88},
			[4] = {item = "iron", min = 7, max = 15, chance = 79},
			[5] = {item = "bluechip", min = 1, max = 1, chance = 59},
			[6] = {item = "phone", min = 1, max = 2, chance = 97},
			[7] = {item = "thermal_charge", min = 1, max = 1, chance = 50},
		},
	},
	[11] = {Name = "Sultan", Hash = 970598228, VehPrice = 1500,
		BodyParts = {
			[1] = {item = "water_bottel", min = 1, max = 4, chance = 75},
			[2] = {item = "thermite", min = 1, max = 1, chance = 20},
			[3] = {item = "copper", min = 6, max = 12, chance = 88},
			[4] = {item = "iron", min = 4, max = 8, chance = 87},
		},
	},
	[12] = {Name = "Dubsta", Hash = 1177543287, VehPrice = 1000,
		BodyParts = {
			[1] = {item = "water_bottel", min = 1, max = 2, chance = 75},
			[2] = {item = "thermite", min = 1, max = 1, chance = 25},
			[3] = {item = "copper", min = 5, max = 12, chance = 78},
			[4] = {item = "iron", min = 4, max = 9, chance = 87},
		},
	},
	[13] = {Name = "T20", Hash = 1663218586, VehPrice = 2100,
		BodyParts = {
			[1] = {item = "water_bottel", min = 2, max = 4, chance = 75},
			[2] = {item = "thermite", min = 1, max = 1, chance = 20},
			[3] = {item = "copper", min = 7, max = 15, chance = 88},
			[4] = {item = "iron", min = 7, max = 12, chance = 87},
			[5] = {item = "phone", min = 1, max = 2, chance = 88},
			[6] = {item = "bluechip", min = 1, max = 1, chance = 15},
		},
	},
}



