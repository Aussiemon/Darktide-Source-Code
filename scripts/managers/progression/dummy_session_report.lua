-- chunkname: @scripts/managers/progression/dummy_session_report.lua

local Mastery = require("scripts/utilities/mastery")
local DummySessionReport = {}

DummySessionReport.fetch_session_report = function (account_id)
	account_id = account_id or math.uuid()

	local session_report = {
		sessionId = "7aef2764-1c91-5aee-92bc-82285fa9653a",
		mission = {
			appliedEvent = "",
			challenge = 1,
			missionName = "the-mission-name",
			passedXpLimit = true,
			playTimeSeconds = 274.189002990723,
			resistance = 1,
			startTime = "1618834762768",
			win = false,
			sideMissions = {},
		},
		serverDetails = {
			type = "local",
			properties = {
				ipAddress = "127.0.0.1",
				serverId = "4141e272-249f-428a-836a-1f5152097b86",
			},
		},
		team = {
			sessionStatistics = {},
			participants = {
				{
					characterId = "3fae375d-1345-4145-a5a9-e06da58a94c3",
					progression = {
						{
							currentLevel = 10,
							currentXp = 5890,
							currentXpInLevel = 5890,
							eligibleForLevel = true,
							id = "3fae375d-1345-4145-a5a9-e06da58a94c3",
							neededXpForNextLevel = 0,
							startLevel = 9,
							startXp = 4553,
							type = "character",
						},
						{
							currentLevel = 1,
							currentXp = 5158,
							currentXpInLevel = 5158,
							eligibleForLevel = false,
							id = "ef46ae26-d846-4544-9dea-be337ad12445",
							neededXpForNextLevel = 14842,
							startLevel = 1,
							startXp = 4553,
							type = "account",
						},
					},
					sessionStatistics = {
						{
							typePath = "team_deaths",
							sessionValue = {
								none = 3,
							},
						},
						{
							typePath = "team_kills",
							sessionValue = {
								none = 33,
							},
						},
					},
					accountId = account_id,
					rewardCards = {
						{
							kind = "xp",
							rewards = {
								{
									amount = 1337,
									rewardType = "xp",
									source = "salary",
									details = {
										fromCircumstance = 735,
										fromSideMission = 0,
										fromSideMissionBonus = 250,
										fromTotalBonus = 0,
										total = 1337,
									},
								},
							},
						},
						{
							kind = "track",
							target = "account",
							rewards = {
								{
									rewardType = "track",
									source = "skill",
									trackId = "a6117884-cbd1-42ed-bd55-fd6bad9f7361",
									trackType = "mastery",
									reward = {
										xp = 2500,
									},
									current = {
										tier = 1,
										xp = 5375,
									},
									trackDetails = {
										mastery = "bespoke_powermaul_p1",
										slot = "slot_primary",
									},
								},
							},
						},
						{
							kind = "havocOrder",
							target = "account",
							rewards = {
								{
									charges = 3,
									rank = 5,
									rewardType = "havocOrder",
									source = "skill",
								},
							},
						},
						{
							kind = "havocOrder",
							target = "account",
							rewards = {
								{
									rank = 5,
									rewardType = "havocHighestRank",
									statType = "week",
								},
							},
						},
						{
							kind = "havocOrder",
							target = "account",
							rewards = {
								{
									rank = 5,
									rewardType = "havocHighestRank",
									statType = "all-time",
								},
							},
						},
						{
							kind = "levelUp",
							level = 9,
							target = "character",
							rewards = {
								{
									gearId = "ef2ae1dc-09ca-49e4-9722-1899c15ab326",
									masterId = "content/items/characters/player/human/gear_head/astra_upperbody_a_01_helmet",
									rewardType = "item",
									overrides = {
										rarity = 2,
									},
								},
								{
									gearId = "ef2ae1dd-09ca-49e4-9722-1899c15ab326",
									masterId = "content/items/characters/player/human/gear_head/astra_upperbody_a_02_helmet",
									rewardType = "item",
								},
							},
						},
						{
							kind = "levelUp",
							level = 10,
							target = "character",
							rewards = {},
						},
						{
							kind = "levelUp",
							level = 5,
							target = "account",
							rewards = {},
						},
						{
							kind = "salary",
							rewards = {
								{
									amount = 3780,
									currency = "credits",
									rewardType = "currency",
									source = "salary",
									details = {
										fromCircumstance = 1103,
										fromSideMission = 0,
										fromSideMissionBonus = 0,
										fromTotalBonus = 0,
										total = 3780,
									},
								},
								{
									amount = 10,
									currency = "plasteel",
									rewardType = "currency",
									source = "missionPickup",
									details = {
										total = 10,
									},
								},
								{
									amount = 0,
									currency = "diamantine",
									rewardType = "currency",
									source = "missionPickup",
									details = {
										total = 5,
									},
								},
							},
						},
						{
							kind = "weaponDrop",
							rewards = {
								{
									gearId = "80157266-b9c3-4668-8460-5e679adacb30",
									masterId = "content/items/weapons/player/melee/chainsword_p1_m1",
									rewardType = "gear",
									source = "weaponDrop",
									overrides = {
										itemLevel = 9000,
										rarity = 3,
									},
								},
							},
						},
						{
							kind = "weaponDrop",
							rewards = {
								{
									gearId = "80157266-b9c3-4668-8460-5e679adacb30",
									masterId = "content/items/gadgets/defensive_gadget_2",
									rewardType = "gear",
									source = "weaponDrop",
									overrides = {
										rarity = 5,
									},
								},
							},
						},
					},
					characterDetails = {
						breed = "human",
						class = "zealot",
						gender = "male",
						hair_color = "hair_green_03",
						id = "3fae375d-1345-4145-a5a9-e06da58a94c3",
						selected_voice = "veteran_male_a",
						skin_color = "skin_dark_02",
						lore = {
							backstory = {},
						},
						abilities = {
							combat_ability = "zealot_dash",
							grenade_ability = "fire_grenade",
						},
						inventory = {
							slot_body_arms = "cosmetic-3fae375d-1345-4145-a5a9-e06da58a94c3-slot_body_arms",
							slot_body_face = "cosmetic-3fae375d-1345-4145-a5a9-e06da58a94c3-slot_body_face",
							slot_body_hair = "cosmetic-3fae375d-1345-4145-a5a9-e06da58a94c3-slot_body_hair",
							slot_body_legs = "cosmetic-3fae375d-1345-4145-a5a9-e06da58a94c3-slot_body_legs",
							slot_body_torso = "cosmetic-3fae375d-1345-4145-a5a9-e06da58a94c3-slot_body_torso",
							slot_gear_arms = "default-zealot-slot_gear_arms",
							slot_gear_gloves = "default-zealot-slot_gear_gloves",
							slot_gear_head = "default-zealot-slot_gear_head",
							slot_gear_legs = "default-zealot-slot_gear_legs",
							slot_gear_shoes = "default-zealot-slot_gear_shoes",
							slot_gear_torso = "default-zealot-slot_gear_torso",
							slot_primary = "default-zealot-slot_primary",
							slot_secondary = "default-zealot-slot_secondary",
						},
					},
				},
			},
		},
	}

	return session_report
end

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
		7560,
	},
	account = {
		0,
		20000,
		41500,
		64500,
		89000,
	},
	weapon = Mastery.get_dummy_weapon_xp_per_level(),
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
