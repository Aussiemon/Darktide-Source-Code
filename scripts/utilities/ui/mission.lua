local BuffSettings = require("scripts/settings/buff/buff_settings")
local WeaponMovementState = require("scripts/extension_systems/weapon/utilities/weapon_movement_state")
local Missions = {
	get_narrative_mission_values = function (mission)
		local mission_book, mission_chapter, mission_page = nil

		if mission and mission.category == "narrative" then
			for id, _ in pairs(mission.flags) do
				if string.find(id, "book-") then
					mission_book = tonumber(string.sub(id, -1))
				end

				if id:find("chapter-") then
					mission_chapter = tonumber(string.sub(id, -1))
				end

				if id:find("page-") then
					mission_page = tonumber(string.sub(id, -1))
				end
			end
		end

		return mission_book, mission_chapter, mission_page
	end
}

Missions.is_mission_same_as_narrative_mission_values = function (mission, book, chapter, page)
	local mission_book, mission_chapter, mission_page = Missions.get_narrative_mission_values(mission)

	if book and mission_book ~= nil and mission_book == book and (not chapter or mission_chapter ~= nil and mission_chapter == chapter) and (not page or mission_page ~= nil and mission_page == page) then
		return true
	else
		return false
	end
end

Missions.get_latest_narrative_mission = function (missions)
	local book = 0
	local chapter = 0
	local page = 0
	local current_narrative_mission = nil

	for i = 1, #missions do
		local mission = missions[i]
		local mission_book, mission_chapter, mission_page = nil
		local mission_book, mission_chapter, mission_page = Missions.get_narrative_mission_values(mission)

		if mission_book and book < mission_book then
			book = mission_book
			chapter = -1
			page = -1
		end

		if mission_chapter and chapter < mission_chapter then
			chapter = mission_chapter
			page = -1
		end

		if mission_page and page < mission_page then
			page = mission_page
		end

		if mission_book ~= nil and mission_book == book and mission_chapter ~= nil and mission_chapter == chapter and mission_page ~= nil and mission_page == page then
			current_narrative_mission = mission
		end
	end

	return current_narrative_mission
end

Missions.filter_narrative_mission_by_values = function (missions, book, chapter, page)
	local story_missions = {}

	for i = 1, #missions do
		local mission = missions[i]
		local available = Missions.is_mission_same_as_narrative_mission_values(mission, book, chapter, page)

		if available then
			story_missions[#story_missions + 1] = mission
		end
	end

	return story_missions
end

Missions.get_latest_narrative_mission_values = function (missions)
	local mission = Missions.get_latest_narrative_mission(missions)

	return Missions.get_narrative_mission_values(mission)
end

Missions.filter_latest_narrative_missions = function (missions)
	local book, chapter, page = Missions.get_latest_narrative_mission_values(missions)

	return Missions.filter_narrative_mission_by_values(missions, book, chapter, page)
end

return Missions
