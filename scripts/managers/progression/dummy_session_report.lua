local DummySessionReport = {
	fetch_session_report = function (account_id)
		account_id = account_id or math.uuid()
		local session_report = {
			sessionId = "7aef2764-1c91-5aee-92bc-82285fa9653a",
			mission = {
				passedXpLimit = true,
				startTime = "1618834762768",
				playTimeSeconds = 274.189002990723,
				win = false,
				resistance = 1,
				appliedEvent = "",
				challenge = 1,
				missionName = "the-mission-name",
				sideMissions = {}
			},
			serverDetails = {
				type = "local",
				properties = {
					serverId = "4141e272-249f-428a-836a-1f5152097b86",
					ipAddress = "127.0.0.1"
				}
			},
			team = {
				sessionStatistics = {},
				participants = {
					{
						characterId = "3fae375d-1345-4145-a5a9-e06da58a94c3",
						progression = {
							{
								currentXpInLevel = 5890,
								startLevel = 9,
								eligibleForLevel = true,
								type = "character",
								currentLevel = 10,
								currentXp = 5890,
								id = "3fae375d-1345-4145-a5a9-e06da58a94c3",
								neededXpForNextLevel = 0,
								startXp = 4553
							},
							{
								currentXpInLevel = 5158,
								startLevel = 1,
								eligibleForLevel = false,
								type = "account",
								currentLevel = 1,
								currentXp = 5158,
								id = "ef46ae26-d846-4544-9dea-be337ad12445",
								neededXpForNextLevel = 14842,
								startXp = 4553
							}
						},
						sessionStatistics = {
							{
								typePath = "team_deaths",
								sessionValue = {
									none = 3
								}
							},
							{
								typePath = "team_kills",
								sessionValue = {
									none = 33
								}
							}
						},
						accountId = account_id,
						rewardCards = {
							{
								kind = "xp",
								rewards = {
									{
										source = "salary",
										rewardType = "xp",
										amount = 1337,
										details = {
											fromTotalBonus = 0,
											fromSideMissionBonus = 250,
											total = 1337,
											fromCircumstance = 735,
											fromSideMission = 0
										}
									}
								}
							},
							{
								kind = "levelUp",
								target = "character",
								level = 9,
								rewards = {
									{
										gearId = "ef2ae1dc-09ca-49e4-9722-1899c15ab326",
										masterId = "content/items/characters/player/human/gear_head/astra_upperbody_a_01_helmet",
										rewardType = "item",
										overrides = {
											rarity = 2
										}
									},
									{
										gearId = "ef2ae1dd-09ca-49e4-9722-1899c15ab326",
										masterId = "content/items/characters/player/human/gear_head/astra_upperbody_a_02_helmet",
										rewardType = "item"
									}
								}
							},
							{
								kind = "levelUp",
								target = "character",
								level = 10,
								rewards = {}
							},
							{
								kind = "levelUp",
								target = "account",
								level = 5,
								rewards = {}
							},
							{
								kind = "salary",
								rewards = {
									{
										rewardType = "currency",
										currency = "credits",
										source = "salary",
										amount = 3780,
										details = {
											fromTotalBonus = 0,
											fromSideMissionBonus = 0,
											total = 3780,
											fromCircumstance = 1103,
											fromSideMission = 0
										}
									},
									{
										rewardType = "currency",
										currency = "plasteel",
										source = "missionPickup",
										amount = 10,
										details = {
											total = 10
										}
									},
									{
										rewardType = "currency",
										currency = "diamantine",
										source = "missionPickup",
										amount = 0,
										details = {
											total = 5
										}
									}
								}
							},
							{
								kind = "weaponDrop",
								rewards = {
									{
										masterId = "content/items/weapons/player/melee/chainsword_p1_m1",
										rewardType = "gear",
										gearId = "80157266-b9c3-4668-8460-5e679adacb30",
										source = "weaponDrop",
										overrides = {
											itemLevel = 9000,
											rarity = 3
										}
									}
								}
							},
							{
								kind = "weaponDrop",
								rewards = {
									{
										masterId = "content/items/gadgets/defensive_gadget_2",
										rewardType = "gear",
										gearId = "80157266-b9c3-4668-8460-5e679adacb30",
										source = "weaponDrop",
										overrides = {
											rarity = 5
										}
									}
								}
							}
						},
						characterDetails = {
							selected_voice = "veteran_male_a",
							skin_color = "skin_dark_02",
							gender = "male",
							hair_color = "hair_green_03",
							class = "zealot",
							id = "3fae375d-1345-4145-a5a9-e06da58a94c3",
							breed = "human",
							lore = {
								backstory = {}
							},
							abilities = {
								combat_ability = "zealot_dash",
								grenade_ability = "fire_grenade"
							},
							inventory = {
								slot_body_legs = "cosmetic-3fae375d-1345-4145-a5a9-e06da58a94c3-slot_body_legs",
								slot_secondary = "default-zealot-slot_secondary",
								slot_gear_shoes = "default-zealot-slot_gear_shoes",
								slot_body_arms = "cosmetic-3fae375d-1345-4145-a5a9-e06da58a94c3-slot_body_arms",
								slot_gear_arms = "default-zealot-slot_gear_arms",
								slot_gear_legs = "default-zealot-slot_gear_legs",
								slot_body_face = "cosmetic-3fae375d-1345-4145-a5a9-e06da58a94c3-slot_body_face",
								slot_body_torso = "cosmetic-3fae375d-1345-4145-a5a9-e06da58a94c3-slot_body_torso",
								slot_primary = "default-zealot-slot_primary",
								slot_gear_head = "default-zealot-slot_gear_head",
								slot_gear_gloves = "default-zealot-slot_gear_gloves",
								slot_gear_torso = "default-zealot-slot_gear_torso",
								slot_body_hair = "cosmetic-3fae375d-1345-4145-a5a9-e06da58a94c3-slot_body_hair"
							}
						}
					}
				}
			}
		}

		return session_report
	end
}
local xp_tables = {
	character = {
		0,
		100,
		200,
		500,
		1085,
		1755,
		2510,
		3350,
		4275,
		5285,
		6380,
		7560
	},
	account = {
		0,
		20000,
		41500,
		64500,
		89000
	}
}

DummySessionReport.fetch_xp_table = function (entity_type)
	local xp_table = xp_tables[entity_type]

	return xp_table
end

DummySessionReport.fetch_inventory = function (session_report)
	local inventory = session_report.team.participants[1].characterDetails.inventory

	return inventory
end

return DummySessionReport
