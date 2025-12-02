-- chunkname: @scripts/extension_systems/visual_loadout/utilities/wieldable_slot_scripts.lua

require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/adamant_buff_drone_placement_preview_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/adamant_whistle_targeting_effects")
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
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/communication_hack_device_interface")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/deployable_device_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/device")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/flamer_gas_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/flamer_pilot_light_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/flashlight")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/force_staff_aoe_targeting_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/force_weapon_block_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/force_weapon_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/force_weapon_wind_slash_activation_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/force_weapon_wind_slash_stage_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/grimoire_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/holo_sight")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/lasgun_ammo_display")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/lasgun_iron_sight")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/luggable")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/magazine_ammo")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/melee_idling_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/missile_launcher_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/overheat_display")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/plasmagun_overheat_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/power_weapon_charges_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/power_weapon_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/power_weapon_overheat_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/psyker_force_field_placement_preview_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/psyker_single_target_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/psyker_throwing_knives_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/randomized_friend_rock_unit")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/revolver_bullets")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/revolver_speedloader")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/riot_shield_charge_display")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/riot_shield_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/saw_coating_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/servo_skull_hover")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/shock_maul_hit_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/shotgun_special_shell_carrier")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/shovel_fold_corrector")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/sticky_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/sweep_trail")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/syringe_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/target_units")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/thunder_hammer_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/tox_grenade_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/warp_charge_venting_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/weapon_temperature_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/weapon_special_display")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/zealot_relic_effects")

local MasterItems = require("scripts/backend/master_items")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local WieldableSlotScripts = {}
local _slot_scripts_to_create = {}
local EMPTY_TABLE = {}
local SCRIPT_INDEX = table.mirror_array({
	"SCRIPT_NAME",
	"UNIT_1P",
	"UNIT_3P",
	"STRIDE",
})

WieldableSlotScripts._register_script = function (script_name, unit_1p, unit_3p, num_scripts)
	if script_name == "" then
		return num_scripts
	end

	local n = num_scripts * SCRIPT_INDEX.STRIDE

	_slot_scripts_to_create[n + SCRIPT_INDEX.SCRIPT_NAME] = script_name
	_slot_scripts_to_create[n + SCRIPT_INDEX.UNIT_1P] = unit_1p
	_slot_scripts_to_create[n + SCRIPT_INDEX.UNIT_3P] = unit_3p

	return num_scripts + 1
end

WieldableSlotScripts.create = function (wieldable_slot_scripts_context, wieldable_slot_scripts, fx_sources, slot)
	local num_scripts = 0
	local root_unit_1p, root_unit_3p = slot.unit_1p, slot.unit_3p
	local item_definitions = MasterItems.get_cached()

	if slot.attachments_by_unit_1p then
		local attachments = slot.attachments_by_unit_1p[root_unit_1p]

		for attachment_i = 1, #attachments do
			local unit_1p = attachments[attachment_i]
			local item_name = slot.item_name_by_unit_1p[unit_1p]
			local item = item_definitions[item_name]

			if item then
				local slot_scripts = item.wieldable_slot_scripts

				if slot_scripts then
					for slot_script_i = 1, #slot_scripts do
						local script_name = slot_scripts[slot_script_i]
						local attachment_path = slot.attachment_id_lookup_1p[unit_1p]
						local unit_3p = slot.attachment_id_lookup_3p[attachment_path]

						num_scripts = WieldableSlotScripts._register_script(script_name, unit_1p, unit_3p, num_scripts)
					end
				end
			end
		end
	end

	local root_item = slot.item
	local weapon_template = WeaponTemplate.weapon_template_from_item(root_item)

	if root_item then
		local slot_scripts = root_item.wieldable_slot_scripts

		if slot_scripts then
			for slot_script_i = 1, #slot_scripts do
				local script_name = slot_scripts[slot_script_i]

				num_scripts = WieldableSlotScripts._register_script(script_name, root_unit_1p, root_unit_3p, num_scripts)
			end
		end

		local weapon_template_wieldable_slot_scripts = weapon_template.wieldable_slot_scripts or EMPTY_TABLE

		for ii = 1, #weapon_template_wieldable_slot_scripts do
			local script_name = weapon_template_wieldable_slot_scripts[ii]

			num_scripts = WieldableSlotScripts._register_script(script_name, root_unit_1p, root_unit_3p, num_scripts)
		end
	end

	local actual_num_scripts = 0

	for script_i = num_scripts, 1, -1 do
		local n = (script_i - 1) * SCRIPT_INDEX.STRIDE
		local script_name = _slot_scripts_to_create[n + SCRIPT_INDEX.SCRIPT_NAME]
		local script_class = CLASSES[script_name]

		if script_class then
			local unit_1p = _slot_scripts_to_create[n + SCRIPT_INDEX.UNIT_1P]
			local unit_3p = _slot_scripts_to_create[n + SCRIPT_INDEX.UNIT_3P]
			local script = script_class:new(wieldable_slot_scripts_context, slot, weapon_template, fx_sources, root_item, unit_1p, unit_3p)

			actual_num_scripts = actual_num_scripts + 1
			wieldable_slot_scripts[slot.name][actual_num_scripts] = script
		end
	end

	table.clear(_slot_scripts_to_create)
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

WieldableSlotScripts.fixed_update = function (wieldable_slot_scripts, unit, dt, t, frame)
	local num_scripts = #wieldable_slot_scripts

	for ii = 1, num_scripts do
		local wieldable_slot_script = wieldable_slot_scripts[ii]

		if wieldable_slot_script.fixed_update then
			wieldable_slot_script:fixed_update(unit, dt, t, frame)
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

WieldableSlotScripts.on_sweep_hit = function (wieldable_slot_scripts)
	local num_scripts = #wieldable_slot_scripts

	for ii = 1, num_scripts do
		local wieldable_slot_script = wieldable_slot_scripts[ii]

		if wieldable_slot_script.on_sweep_hit then
			wieldable_slot_script:on_sweep_hit()
		end
	end
end

WieldableSlotScripts.on_sweep_start = function (wieldable_slot_scripts, t)
	local num_scripts = #wieldable_slot_scripts

	for ii = 1, num_scripts do
		local wieldable_slot_script = wieldable_slot_scripts[ii]

		if wieldable_slot_script.on_sweep_start then
			wieldable_slot_script:on_sweep_start(t)
		end
	end
end

WieldableSlotScripts.on_sweep_finish = function (wieldable_slot_scripts)
	local num_scripts = #wieldable_slot_scripts

	for ii = 1, num_scripts do
		local wieldable_slot_script = wieldable_slot_scripts[ii]

		if wieldable_slot_script.on_sweep_finish then
			wieldable_slot_script:on_sweep_finish()
		end
	end
end

WieldableSlotScripts.on_exit_damage_window = function (wieldable_slot_scripts)
	local num_scripts = #wieldable_slot_scripts

	for ii = 1, num_scripts do
		local wieldable_slot_script = wieldable_slot_scripts[ii]

		if wieldable_slot_script.on_exit_damage_window then
			wieldable_slot_script:on_exit_damage_window()
		end
	end
end

WieldableSlotScripts.on_weapon_special_toggle = function (wieldable_slot_scripts)
	local num_scripts = #wieldable_slot_scripts

	for ii = 1, num_scripts do
		local wieldable_slot_script = wieldable_slot_scripts[ii]

		if wieldable_slot_script.on_weapon_special_toggle then
			wieldable_slot_script:on_weapon_special_toggle()
		end
	end
end

WieldableSlotScripts.on_weapon_special_toggle_finished = function (wieldable_slot_scripts, reason)
	local num_scripts = #wieldable_slot_scripts

	for ii = 1, num_scripts do
		local wieldable_slot_script = wieldable_slot_scripts[ii]

		if wieldable_slot_script.on_weapon_special_toggle_finished then
			wieldable_slot_script:on_weapon_special_toggle_finished(reason)
		end
	end
end

WieldableSlotScripts.on_action = function (wieldable_slot_scripts, action_settings, t)
	local num_scripts = #wieldable_slot_scripts

	for ii = 1, num_scripts do
		local wieldable_slot_script = wieldable_slot_scripts[ii]

		if wieldable_slot_script.on_action then
			wieldable_slot_script:on_action(action_settings, t)
		end
	end
end

return WieldableSlotScripts
