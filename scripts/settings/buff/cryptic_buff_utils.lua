-- chunkname: @scripts/settings/buff/cryptic_buff_utils.lua

local FixedFrame = require("scripts/utilities/fixed_frame")
local Breeds = require("scripts/settings/breed/breeds")
local CrypticBuffUtils = {}

CrypticBuffUtils.bespoke_monster_hunter_keystone_hit_tracking_start = function (template_data, template_context)
	template_data.tagged_enemies = {}
	template_data.untagged_enemies = {}

	local unit_data_extension = ScriptUnit.has_extension(template_context.unit, "unit_data_system")

	template_data.inventory = unit_data_extension:read_component("inventory")
end

CrypticBuffUtils.bespoke_monster_hunter_keystone_hit_tracking_update = function (tracking_grace_frames, template_data, template_context, dt, t)
	local frame = FixedFrame.to_fixed_frame(t)

	for unit, tagged_frame in pairs(template_data.tagged_enemies) do
		if frame > tagged_frame + tracking_grace_frames then
			template_data.untagged_enemies[unit] = true
		end
	end

	for unit, _ in pairs(template_data.untagged_enemies) do
		template_data.tagged_enemies[unit] = nil
	end

	table.clear(template_data.untagged_enemies)
end

CrypticBuffUtils.bespoke_monster_hunter_keystone_hit_tracking_is_tagged_check = function (target_unit, template_data, template_context)
	local is_server = template_context.is_server
	local is_target_tagged = template_data.tagged_enemies[target_unit]

	return is_server and is_target_tagged
end

CrypticBuffUtils.bespoke_monster_hunter_keystone_hit_tracking_proc = function (params, template_data, template_context, t)
	local is_server = template_context.is_server
	local hit_unit = params.attacked_unit
	local is_target_hit_alive = HEALTH_ALIVE[hit_unit]
	local breed = params.breed_name and Breeds[params.breed_name]
	local is_valid_breed = breed and breed.tags and (breed.tags.monster or breed.tags.ogryn or breed.tags.captain)

	if is_server and is_target_hit_alive and is_valid_breed then
		local frame = FixedFrame.to_fixed_frame(t)

		template_data.tagged_enemies[hit_unit] = frame
	end
end

CrypticBuffUtils.bespoke_monster_hunter_keystone_hit_tracking_proc_on_minion_death = function (params, template_data, template_context, t)
	if params.dying_unit then
		template_data.tagged_enemies[params.dying_unit] = nil
	end
end

return CrypticBuffUtils
