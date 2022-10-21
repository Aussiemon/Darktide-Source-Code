local MissionTemplates = require("scripts/settings/mission/mission_templates")
local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local SideMissionObjectiveTemplate = require("scripts/settings/mission_objective/templates/side_mission_objective_template")

local function random_element(t)
	local n = #t

	if n > 1 then
		return t[math.random(#t)]
	end
end

local function random_sub_set(source, count)
	local result = {}

	table.append_non_indexed(result, source)
	table.shuffle(result)
	table.remove_sequence(result, count + 1, #result)

	return result
end

local function random_mission()
	local missions = {}

	for mission_name, mission_template in pairs(MissionTemplates) do
		if not mission_template.is_dev_mission and mission_template.mechanism_name == "adventure" and mission_template.mission_brief_vo then
			missions[#missions + 1] = mission_name
		end
	end

	return missions[math.random(#missions)]
end

local function make_mockup_mission(happening, make_complete)
	local has_side_mission = make_complete or math.random() < 0.5
	local has_circumstance = make_complete or math.random() < 0.5
	local is_flash = make_complete or math.random() < 0.333
	local danger = 1 + math.random(0, 1) + math.random(0, 1) + math.random(0, 1) + math.random(0, 1)
	local required_level = math.random() < 0.1 and math.random(30) or 1

	return {
		displayIndex = math.random(12),
		id = math.uuid(),
		requiredLevel = required_level,
		extraRewards = {
			circumstance = has_circumstance and {
				credits = math.random(100, 9999),
				xp = math.random(100, 9999)
			},
			sideMission = {
				credits = math.random(100, 9999),
				xp = math.random(100, 9999)
			}
		},
		map = random_mission(),
		flags = {
			side = has_side_mission,
			flash = is_flash
		},
		sideMission = has_side_mission and random_element(happening.sideMissions),
		circumstance = has_circumstance and random_element(happening.circumstances) or "default",
		credits = math.random(100, 9999),
		xp = math.random(100, 9999),
		challenge = danger,
		resistance = has_circumstance and danger or math.random(1, 5),
		start_game_time = Managers.time:time("main"),
		expiry_game_time = Managers.time:time("main") + 5
	}
end

local valid_circumstances = {}

for c_name, c_settings in pairs(CircumstanceTemplates) do
	if c_settings.ui then
		valid_circumstances[#valid_circumstances + 1] = c_name
	end
end

local function make_mockup_mission_board_data(make_complete)
	local happening = {
		dynamic = true,
		circumstances = random_sub_set(valid_circumstances, math.random(0, 3)),
		sideMissions = random_sub_set(table.keys(SideMissionObjectiveTemplate.side_mission.objectives), math.random(1, 3)),
		expiry_game_time = Managers.time:time("main") + math.random(900, 1800)
	}
	local missions = {}

	for i = 1, make_complete and 12 or math.random(3, 12) do
		missions[i] = make_mockup_mission(happening, make_complete)
	end

	return {
		expiry_game_time = Managers.time:time("main") + (make_complete and 60 or 10),
		missions = missions,
		happening = happening
	}
end

return make_mockup_mission_board_data
