-- chunkname: @scripts/settings/ability/archetype_specializations/archetype_specializations.lua

local ArchetypeTalents = require("scripts/settings/ability/archetype_talents/archetype_talents")
local archetype_specializations_name = "ArchetypeSpecializations"
local specializations = {}

local function _include_speciality_definition(file_name, base_specialization)
	local definition = require(file_name)
	local player_archetype = definition.archetype

	if not specializations[player_archetype] then
		specializations[player_archetype] = {}
	end

	local specialization_name = definition.name
	local entry = definition
	local archetype_specializations = specializations[player_archetype]

	if base_specialization then
		local base_talent_group_definitions = base_specialization and table.shallow_copy(base_specialization.talent_groups)

		definition.talent_groups = table.append(base_talent_group_definitions, definition.talent_groups)
	end

	archetype_specializations[specialization_name] = entry

	return entry
end

local base_specialization = _include_speciality_definition("scripts/settings/ability/archetype_specializations/base_specialization")
local ogryn_base_specialization = _include_speciality_definition("scripts/settings/ability/archetype_specializations/ogryn_no_specialization", base_specialization)

_include_speciality_definition("scripts/settings/ability/archetype_specializations/ogryn_bonebreaker_specialization_new", ogryn_base_specialization)

local psyker_base_specialization = _include_speciality_definition("scripts/settings/ability/archetype_specializations/psyker_no_specialization", base_specialization)

_include_speciality_definition("scripts/settings/ability/archetype_specializations/psyker_biomancer_specialization_new", psyker_base_specialization)

local veteran_base_specialization = _include_speciality_definition("scripts/settings/ability/archetype_specializations/veteran_no_specialization", base_specialization)

_include_speciality_definition("scripts/settings/ability/archetype_specializations/veteran_ranger_specialization_new", veteran_base_specialization)

local zealot_base_specialization = _include_speciality_definition("scripts/settings/ability/archetype_specializations/zealot_no_specialization", base_specialization)

_include_speciality_definition("scripts/settings/ability/archetype_specializations/zealot_maniac_specialization_new", zealot_base_specialization)

return settings(archetype_specializations_name, specializations)
