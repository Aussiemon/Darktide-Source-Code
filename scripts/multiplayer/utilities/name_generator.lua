-- chunkname: @scripts/multiplayer/utilities/name_generator.lua

local NameGenerator = NameGenerator or {}

NameGenerator.generate_lobby_name = function ()
	local adj = {
		"Aggressive",
		"Serious",
		"Humiliating",
		"Sub-par",
		"Humorous",
		"Scary",
		"Humdrum",
		"Crazy",
		"Intense",
	}
	local loc = {
		"Beach",
		"Forest",
		"Knoll",
		"Mountain",
		"Sea",
		"Cave",
		"Castle",
		"Lava",
		"Winter",
		"Desert",
	}
	local act = {
		"Fight",
		"Skirmish",
		"Party",
		"Gathering",
		"Ruckus",
		"Dance",
		"Showdown",
		"Trouble",
		"Conundrum",
	}

	local function r(t)
		return t[math.random(1, #t)]
	end

	return string.format("The %s %s %s", r(adj), r(loc), r(act))
end

return NameGenerator
