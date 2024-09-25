﻿-- chunkname: @scripts/extension_systems/visual_loadout/utilities/wieldable_slot_scripts.lua

require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/aim_luggable_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/aim_projectile_ads_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/aim_projectile_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/ammo_belt")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/ammo_count_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/auspex_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/auspex_scanning_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/chain_lightning_ability_hand_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/chain_lightning_hand_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/chain_lightning_link_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/chain_lightning_target_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/chain_weapon_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/charge_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/deployable_device_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/device")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/flamer_gas_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/flamer_pilot_light_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/flashlight")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/force_staff_aoe_targeting_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/force_weapon_block_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/force_weapon_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/grimoire_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/holo_sight")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/lasgun_ammo_display")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/lasgun_iron_sight")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/luggable")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/magazine_ammo")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/melee_idling_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/overheat_display")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/plasmagun_overheat_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/power_weapon_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/psyker_force_field_placement_preview_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/psyker_single_target_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/psyker_throwing_knives_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/randomized_friend_rock_unit")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/revolver_bullets")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/revolver_speedloader")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/servo_skull_hover")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/shock_maul_hit_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/shovel_fold_corrector")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/sticky_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/sweep_trail")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/syringe_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/target_units")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/thunder_hammer_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/warp_charge_venting_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/weapon_temperature_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/zealot_relic_effects")

local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local WieldableSlotScripts = {}
local _all_wieldable_slot_scripts = {}
local EMPTY_TABLE = {}

WieldableSlotScripts.create = function (wieldable_slot_scripts_context, wieldable_slot_scripts, fx_sources, slot, item)
	table.clear(_all_wieldable_slot_scripts)

	local item_wieldable_slot_scripts = item.wieldable_slot_scripts or EMPTY_TABLE
	local num_scripts = #item_wieldable_slot_scripts

	for ii = 1, num_scripts do
		_all_wieldable_slot_scripts[ii] = item_wieldable_slot_scripts[ii]
	end

	local weapon_template = WeaponTemplate.weapon_template_from_item(item)
	local weapon_template_wieldable_slot_scripts = weapon_template.wieldable_slot_scripts or EMPTY_TABLE

	for ii = 1, #weapon_template_wieldable_slot_scripts do
		local script_name = weapon_template_wieldable_slot_scripts[ii]
		local already_defined = table.find(_all_wieldable_slot_scripts, script_name)

		if not already_defined then
			num_scripts = num_scripts + 1
			_all_wieldable_slot_scripts[num_scripts] = script_name
		end
	end

	local actual_num_scripts = 0

	for ii = num_scripts, 1, -1 do
		local script_name = _all_wieldable_slot_scripts[ii]
		local script_class = CLASSES[script_name]

		if script_class then
			local script = script_class:new(wieldable_slot_scripts_context, slot, weapon_template, fx_sources, item)

			actual_num_scripts = actual_num_scripts + 1
			wieldable_slot_scripts[slot.name][actual_num_scripts] = script
		end
	end
end

WieldableSlotScripts.destroy = function (wieldable_slot_scripts)
	local num_scripts = #wieldable_slot_scripts

	for ii = 1, num_scripts do
		local wieldable_slot_script = wieldable_slot_scripts[ii]

		wieldable_slot_script:destroy()
	end
end

WieldableSlotScripts.extensions_ready = function (wieldable_slot_scripts_per_slot)
	for _, wieldable_slot_scripts in pairs(wieldable_slot_scripts_per_slot) do
		local num_scripts = #wieldable_slot_scripts

		for ii = 1, num_scripts do
			local wieldable_slot_script = wieldable_slot_scripts[ii]

			if wieldable_slot_script.extensions_ready then
				wieldable_slot_script:extensions_ready()
			end
		end
	end
end

WieldableSlotScripts.server_correction_occurred = function (wieldable_slot_scripts_per_slot, unit, from_frame)
	for _, wieldable_slot_scripts in pairs(wieldable_slot_scripts_per_slot) do
		local num_scripts = #wieldable_slot_scripts

		for ii = 1, num_scripts do
			local wieldable_slot_script = wieldable_slot_scripts[ii]

			if wieldable_slot_script.server_correction_occurred then
				wieldable_slot_script:server_correction_occurred(unit, from_frame)
			end
		end
	end
end

WieldableSlotScripts.update = function (wieldable_slot_scripts, unit, dt, t)
	local num_scripts = #wieldable_slot_scripts

	for ii = 1, num_scripts do
		local wieldable_slot_script = wieldable_slot_scripts[ii]

		if wieldable_slot_script.update then
			wieldable_slot_script:update(unit, dt, t)
		end
	end
end

WieldableSlotScripts.fixed_update = function (wieldable_slot_scripts, unit, dt, t)
	local num_scripts = #wieldable_slot_scripts

	for ii = 1, num_scripts do
		local wieldable_slot_script = wieldable_slot_scripts[ii]

		if wieldable_slot_script.fixed_update then
			wieldable_slot_script:fixed_update(unit, dt, t)
		end
	end
end

WieldableSlotScripts.post_update = function (wieldable_slot_scripts, unit, dt, t)
	local num_scripts = #wieldable_slot_scripts

	for ii = 1, num_scripts do
		local wieldable_slot_script = wieldable_slot_scripts[ii]

		if wieldable_slot_script.post_update then
			wieldable_slot_script:post_update(unit, dt, t)
		end
	end
end

WieldableSlotScripts.update_unit_position = function (wieldable_slot_scripts, unit, dt, t)
	local num_scripts = #wieldable_slot_scripts

	for ii = 1, num_scripts do
		local wieldable_slot_script = wieldable_slot_scripts[ii]

		if wieldable_slot_script.update_unit_position then
			wieldable_slot_script:update_unit_position(unit, dt, t)
		end
	end
end

WieldableSlotScripts.update_first_person_mode = function (wieldable_slot_scripts, first_person_mode)
	local num_scripts = #wieldable_slot_scripts

	for ii = 1, num_scripts do
		local wieldable_slot_script = wieldable_slot_scripts[ii]

		if wieldable_slot_script.update_first_person_mode then
			wieldable_slot_script:update_first_person_mode(first_person_mode)
		end
	end
end

WieldableSlotScripts.wield = function (wieldable_slot_scripts)
	local num_scripts = #wieldable_slot_scripts

	for ii = 1, num_scripts do
		local wieldable_slot_script = wieldable_slot_scripts[ii]

		wieldable_slot_script:wield()
	end
end

WieldableSlotScripts.unwield = function (wieldable_slot_scripts)
	local num_scripts = #wieldable_slot_scripts

	for ii = 1, num_scripts do
		local wieldable_slot_script = wieldable_slot_scripts[ii]

		wieldable_slot_script:unwield()
	end
end

return WieldableSlotScripts
