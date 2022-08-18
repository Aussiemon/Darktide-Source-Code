local archetype_talents_name = "ArchetypeTalents"
local talents = {}

local function _include_talents_definition(file_name, archetype_base_talents)
	local definition = require(file_name)
	local player_archetype = definition.archetype

	if not talents[player_archetype] then
		talents[player_archetype] = {}
	end

	local archetype_talents = talents[player_archetype]
	local specialization_name = definition.specialization

	if not archetype_talents[specialization_name] then
		archetype_talents[specialization_name] = {}
	end

	local specialization_talents = archetype_talents[specialization_name]

	if archetype_base_talents then
		for talent_name, talent in pairs(archetype_base_talents) do
			specialization_talents[talent_name] = talent
		end
	end

	for talent_name, entry_data in pairs(definition.talents) do
		fassert(not specialization_talents[talent_name], "%s.%s failed adding ability %q from file %q. Key already exists.", archetype_talents_name, player_archetype, talent_name, file_name)

		local entry = entry_data
		specialization_talents[talent_name] = entry
	end

	return specialization_talents
end

local base_talents = _include_talents_definition("scripts/settings/ability/archetype_talents/base_talents")
local ogryn_base_talents = _include_talents_definition("scripts/settings/ability/archetype_talents/ogryn_talents")

_include_talents_definition("scripts/settings/ability/archetype_talents/ogryn_bonebreaker_talents", ogryn_base_talents)
_include_talents_definition("scripts/settings/ability/archetype_talents/ogryn_gun_lugger_talents", ogryn_base_talents)

local psyker_base_talents = _include_talents_definition("scripts/settings/ability/archetype_talents/psyker_talents", base_talents)

_include_talents_definition("scripts/settings/ability/archetype_talents/psyker_biomancer_talents", psyker_base_talents)
_include_talents_definition("scripts/settings/ability/archetype_talents/psyker_protectorate_talents", psyker_base_talents)

local veteran_base_talents = _include_talents_definition("scripts/settings/ability/archetype_talents/veteran_talents", base_talents)

_include_talents_definition("scripts/settings/ability/archetype_talents/veteran_squad_leader_talents", veteran_base_talents)
_include_talents_definition("scripts/settings/ability/archetype_talents/veteran_ranger_talents", veteran_base_talents)

local zealot_base_talents = _include_talents_definition("scripts/settings/ability/archetype_talents/zealot_talents", base_talents)

_include_talents_definition("scripts/settings/ability/archetype_talents/zealot_preacher_talents", zealot_base_talents)
_include_talents_definition("scripts/settings/ability/archetype_talents/zealot_maniac_talents", zealot_base_talents)

return settings(archetype_talents_name, talents)
