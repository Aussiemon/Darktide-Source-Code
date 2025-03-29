-- chunkname: @scripts/extension_systems/mood/player_unit_mood_extension.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local MoodSettings = require("scripts/settings/camera/mood/mood_settings")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local WarpCharge = require("scripts/utilities/warp_charge")
local buff_keywords = BuffSettings.keywords
local moods = MoodSettings.moods
local mood_types = MoodSettings.mood_types
local mood_status = MoodSettings.status
local num_moods = MoodSettings.num_moods
local CLIENT_RPCS = {
	"rpc_trigger_timed_mood",
	"rpc_remove_mood",
}
local PlayerUnitMoodExtension = class("PlayerUnitMoodExtension")

PlayerUnitMoodExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data, nil_or_game_object_id)
	self._world = extension_init_context.world
	self._unit = unit

	local is_server = extension_init_context.is_server

	self._is_server = is_server

	local player = extension_init_data.player

	self._player = player
	self._is_local_human = not player.remote and self._player:is_human_controlled()

	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

	self._buff_extension = ScriptUnit.extension(unit, "buff_system")
	self._unit_data_extension = unit_data_extension
	self._character_state_read_component = unit_data_extension:read_component("character_state")
	self._warp_charge_read_component = unit_data_extension:read_component("warp_charge")
	self._lunge_character_state_read_component = unit_data_extension:read_component("lunge_character_state")
	self._combat_ability_action_read_component = unit_data_extension:read_component("combat_ability_action")
	self._sprint_character_state_read_component = unit_data_extension:read_component("sprint_character_state")
	self._combat_ability_read_component = unit_data_extension:read_component("combat_ability")
	self._first_person_component = unit_data_extension:read_component("first_person")
	self._health_extension = ScriptUnit.has_extension(unit, "health_system")
	self._toughness_extension = ScriptUnit.extension(unit, "toughness_system")
	self._suppression_extension = ScriptUnit.extension(unit, "suppression_system")
	self._force_field_system = Managers.state.extension:system("force_field_system")

	local moods_data = Script.new_map(num_moods)

	for mood_type, _ in pairs(mood_types) do
		moods_data[mood_type] = {
			entered_t = math.huge,
			removed_t = math.huge,
			status = mood_status.inactive,
		}
	end

	self._moods_data = moods_data

	if not is_server then
		local network_event_delegate = extension_init_context.network_event_delegate

		self._network_event_delegate = network_event_delegate
		self._game_object_id = nil_or_game_object_id

		network_event_delegate:register_session_unit_events(self, nil_or_game_object_id, unpack(CLIENT_RPCS))

		self._unit_rpcs_registered = true
	end

	self._was_alive = true
end

PlayerUnitMoodExtension.destroy = function (self)
	if not self._is_server and self._unit_rpcs_registered then
		self._network_event_delegate:unregister_unit_events(self._game_object_id, unpack(CLIENT_RPCS))

		self._unit_rpcs_registered = false
	end
end

PlayerUnitMoodExtension.game_object_initialized = function (self, game_session, game_object_id)
	self._game_object_id = game_object_id
	self._game_session = game_session
end

PlayerUnitMoodExtension.hot_join_sync = function (self, unit, sender, channel)
	local moods_data = self._moods_data

	for mood_type, mood_data in pairs(moods_data) do
		local mood_settings = moods[mood_type]
		local is_active = mood_data.status == mood_status.active

		if is_active and mood_settings.active_time then
			local mood_type_id = NetworkLookup.moods_types[mood_type]

			RPC.rpc_trigger_timed_mood(channel, self._game_object_id, mood_type_id)
		end
	end
end

local CRITICAL_HEALTH_LIMIT = 0.3

PlayerUnitMoodExtension.update = function (self, unit, dt, t)
	self:_update_active_moods(t)
	self:_update_timed_moods(t)
	self:_update_removing_moods(t)
end

PlayerUnitMoodExtension._update_active_moods = function (self, t)
	local health_extension = self._health_extension

	if not health_extension:is_alive() and self._was_alive then
		self._was_alive = false

		self:remove_all_moods()

		return
	elseif not health_extension:is_alive() and not self._was_alive then
		return
	end

	self._was_alive = true

	local toughness_extension = self._toughness_extension
	local is_knocked_down = PlayerUnitStatus.is_knocked_down(self._character_state_read_component)
	local is_in_critical_health, critical_health_status = PlayerUnitStatus.is_in_critical_health(health_extension, toughness_extension)
	local critical_health = is_in_critical_health and critical_health_status >= CRITICAL_HEALTH_LIMIT
	local no_toughness_left = PlayerUnitStatus.no_toughness_left(toughness_extension)
	local entered_toughness_cooldown = self._entered_toughness_cooldown and t < self._entered_toughness_cooldown
	local is_suppressed = self._suppression_extension:has_high_suppression()
	local player = self._player
	local buff_extension = self._buff_extension
	local base_warp_charge_template = WarpCharge.archetype_warp_charge_template(player)
	local weapon_warp_charge_template = WarpCharge.weapon_warp_charge_template(player.player_unit)
	local base_low_threshold = base_warp_charge_template.low_threshold
	local low_threshold_modifier = weapon_warp_charge_template.low_threshold_modifier or 1
	local warped_low_threshold = base_low_threshold * low_threshold_modifier
	local base_high_threshold = base_warp_charge_template.high_threshold
	local high_threshold_modifier = weapon_warp_charge_template.high_threshold_modifier or 1
	local warped_high_threshold = base_high_threshold * high_threshold_modifier
	local base_critical_threshold = base_warp_charge_template.critical_threshold
	local critical_threshold_modifier = weapon_warp_charge_template.critical_threshold_modifier or 1
	local warped_critical_threshold = base_critical_threshold * critical_threshold_modifier
	local current_warp_percentage = self._warp_charge_read_component.current_percentage
	local warped = current_warp_percentage > 0
	local warped_low_to_high = warped_low_threshold < current_warp_percentage
	local warped_high_to_critical = warped_high_threshold < current_warp_percentage
	local warped_critical = warped_critical_threshold < current_warp_percentage
	local num_wounds = health_extension:num_wounds()
	local max_wounds = health_extension:max_wounds()
	local last_wound = num_wounds == 1 and max_wounds > 1
	local archetype_name = self._player:archetype_name()
	local is_aiming_lunge = PlayerUnitStatus.is_aiming_lunge(self._combat_ability_action_read_component)
	local veteran_combat_ability_stance_active = buff_extension:has_keyword(buff_keywords.veteran_combat_ability_stance)
	local ogryn_combat_ability_stance_active = buff_extension:has_keyword(buff_keywords.ogryn_combat_ability_stance)
	local has_invisible_keyword = buff_extension:has_keyword(buff_keywords.invisible)
	local is_in_stealth = archetype_name == "zealot" and has_invisible_keyword
	local is_in_veteran_stealth = archetype_name == "veteran" and has_invisible_keyword
	local is_in_veteran_stealth_and_stance = is_in_veteran_stealth and veteran_combat_ability_stance_active
	local is_in_stealth_from_outside_source = archetype_name ~= "zealot" and archetype_name ~= "veteran" and has_invisible_keyword
	local syringe_ability = buff_extension:has_keyword(buff_keywords.syringe_ability)
	local syringe_power = buff_extension:has_keyword(buff_keywords.syringe_power)
	local syringe_speed = buff_extension:has_keyword(buff_keywords.syringe_speed)
	local is_in_psyker_force_field, _, force_field_extension = self._force_field_system:is_object_inside_force_field(self._first_person_component.position, 0.05, true)
	local is_in_psyker_force_field_sphere = is_in_psyker_force_field and force_field_extension:is_sphere_shield()

	if is_in_veteran_stealth_and_stance then
		is_in_veteran_stealth = false
		veteran_combat_ability_stance_active = false
	end

	local psyker_combat_ability_shout_active, ogryn_combat_ability_shout_active
	local combat_ability_active = self._combat_ability_read_component.active

	if combat_ability_active then
		if archetype_name == "psyker" then
			psyker_combat_ability_shout_active = true
		elseif archetype_name == "ogryn" then
			ogryn_combat_ability_shout_active = true
		end
	end

	local sprint_character_state_component = self._sprint_character_state_read_component
	local is_sprinting = sprint_character_state_component.is_sprinting
	local have_sprint_overtime = sprint_character_state_component.sprint_overtime > 0
	local is_effective_sprinting = is_sprinting and not have_sprint_overtime
	local is_overtime_sprinting = is_sprinting and have_sprint_overtime

	if last_wound then
		self:_add_mood(t, mood_types.last_wound)
	elseif not last_wound then
		self:_remove_mood(t, mood_types.last_wound)
	end

	if critical_health then
		self:_add_mood(t, mood_types.critical_health)
	elseif not critical_health then
		self:_remove_mood(t, mood_types.critical_health)
	end

	if is_knocked_down then
		self:_add_mood(t, mood_types.knocked_down)
	elseif not is_knocked_down then
		self:_remove_mood(t, mood_types.knocked_down)
	end

	local use_toughness_mood = no_toughness_left and not critical_health and not is_knocked_down

	if use_toughness_mood then
		if not entered_toughness_cooldown then
			self:_add_mood(t, mood_types.no_toughness)

			self._entered_toughness_cooldown = t + 2
		end
	elseif not use_toughness_mood then
		self:_remove_mood(t, mood_types.no_toughness)
	end

	if is_suppressed then
		self:_add_mood(t, mood_types.suppression_ongoing)
	elseif not is_suppressed then
		self:_remove_mood(t, mood_types.suppression_ongoing)
	end

	if is_effective_sprinting then
		self:_add_mood(t, mood_types.sprinting)
	elseif not is_effective_sprinting then
		self:_remove_mood(t, mood_types.sprinting)
	end

	if is_overtime_sprinting then
		self:_add_mood(t, mood_types.sprinting_overtime)
	elseif not is_overtime_sprinting then
		self:_remove_mood(t, mood_types.sprinting_overtime)
	end

	if is_aiming_lunge and archetype_name == "zealot" then
		self:_add_mood(t, mood_types.zealot_combat_ability_dash)
	elseif not is_aiming_lunge or archetype_name ~= "zealot" then
		self:_remove_mood(t, mood_types.zealot_combat_ability_dash)
	end

	if is_aiming_lunge and archetype_name == "ogryn" then
		self:_add_mood(t, mood_types.ogryn_combat_ability_charge)
	elseif not is_aiming_lunge or archetype_name ~= "ogryn" then
		self:_remove_mood(t, mood_types.ogryn_combat_ability_charge)
	end

	if ogryn_combat_ability_shout_active then
		self:_add_mood(t, mood_types.ogryn_combat_ability_shout)
	elseif not ogryn_combat_ability_shout_active then
		self:_remove_mood(t, mood_types.ogryn_combat_ability_shout)
	end

	if ogryn_combat_ability_stance_active then
		self:_add_mood(t, mood_types.ogryn_combat_ability_stance)
	elseif not ogryn_combat_ability_stance_active then
		self:_remove_mood(t, mood_types.ogryn_combat_ability_stance)
	end

	if veteran_combat_ability_stance_active then
		self:_add_mood(t, mood_types.veteran_combat_ability_stance)
	elseif not veteran_combat_ability_stance_active then
		self:_remove_mood(t, mood_types.veteran_combat_ability_stance)
	end

	if is_in_stealth then
		self:_add_mood(t, mood_types.stealth)
	elseif not is_in_stealth then
		self:_remove_mood(t, mood_types.stealth)
	end

	if is_in_veteran_stealth then
		self:_add_mood(t, mood_types.veteran_stealth)
	elseif not is_in_veteran_stealth then
		self:_remove_mood(t, mood_types.veteran_stealth)
	end

	if is_in_veteran_stealth_and_stance then
		self:_add_mood(t, mood_types.veteran_stealth_and_stance)
	elseif not is_in_veteran_stealth_and_stance then
		self:_remove_mood(t, mood_types.veteran_stealth_and_stance)
	end

	if psyker_combat_ability_shout_active then
		self:_add_mood(t, mood_types.psyker_combat_ability_shout)
	elseif not psyker_combat_ability_shout_active then
		self:_remove_mood(t, mood_types.psyker_combat_ability_shout)
	end

	if warped then
		self:_add_mood(t, mood_types.warped)
	elseif not warped then
		self:_remove_mood(t, mood_types.warped)
	end

	if warped_low_to_high then
		self:_add_mood(t, mood_types.warped_low_to_high)
	elseif not warped_low_to_high then
		self:_remove_mood(t, mood_types.warped_low_to_high)
	end

	if warped_high_to_critical then
		self:_add_mood(t, mood_types.warped_high_to_critical)
	elseif not warped_high_to_critical then
		self:_remove_mood(t, mood_types.warped_high_to_critical)
	end

	if warped_critical then
		self:_add_mood(t, mood_types.warped_critical)
	elseif not warped_critical then
		self:_remove_mood(t, mood_types.warped_critical)
	end

	if is_in_psyker_force_field_sphere then
		self:_add_mood(t, mood_types.psyker_force_field_sphere)
	elseif not warped_critical then
		self:_remove_mood(t, mood_types.psyker_force_field_sphere)
	end

	if syringe_ability then
		self:_add_mood(t, mood_types.syringe_ability)
	elseif not syringe_ability then
		self:_remove_mood(t, mood_types.syringe_ability)
	end

	if syringe_power then
		self:_add_mood(t, mood_types.syringe_power)
	elseif not syringe_power then
		self:_remove_mood(t, mood_types.syringe_power)
	end

	if syringe_speed then
		self:_add_mood(t, mood_types.syringe_speed)
	elseif not syringe_speed then
		self:_remove_mood(t, mood_types.syringe_speed)
	end

	if is_in_stealth_from_outside_source then
		self:_add_mood(t, mood_types.generic_stealth)
	elseif not is_in_stealth_from_outside_source then
		self:_remove_mood(t, mood_types.generic_stealth)
	end
end

PlayerUnitMoodExtension._update_timed_moods = function (self, t)
	local moods_data = self._moods_data

	for mood_type, mood_data in pairs(moods_data) do
		local mood_settings = moods[mood_type]
		local active_time = mood_settings and mood_settings.active_time

		if active_time and mood_data.status == mood_status.active then
			local blend_in_time = mood_settings.blend_in_time
			local time_since_enter = t - mood_data.entered_t
			local should_start_removing = active_time < time_since_enter - blend_in_time

			if should_start_removing then
				self:_remove_mood(t, mood_type)
			end
		end
	end
end

PlayerUnitMoodExtension._update_removing_moods = function (self, t)
	local moods_data = self._moods_data

	for mood_type, mood_data in pairs(moods_data) do
		local mood_settings = moods[mood_type]

		if mood_data.status == mood_status.removing then
			local blend_out_time = mood_settings.blend_out_time
			local time_since_removed = t - mood_data.removed_t
			local should_remove = not blend_out_time or blend_out_time <= time_since_removed

			if should_remove then
				mood_data.entered_t = math.huge
				mood_data.removed_t = math.huge
				mood_data.status = mood_status.inactive
			end
		end
	end
end

PlayerUnitMoodExtension.moods_data = function (self)
	return self._moods_data
end

PlayerUnitMoodExtension.remove_all_moods = function (self)
	local moods_data = self._moods_data

	for mood_type, mood_data in pairs(moods_data) do
		if mood_data.status ~= mood_status.inactive then
			mood_data.entered_t = math.huge
			mood_data.removed_t = math.huge
			mood_data.status = mood_status.inactive
		end
	end
end

PlayerUnitMoodExtension._add_mood = function (self, t, mood_type, reset_time)
	local moods_data = self._moods_data
	local mood_data = moods_data[mood_type]

	if mood_data.status == mood_status.active then
		return
	end

	mood_data.entered_t = t
	mood_data.status = mood_status.active
end

PlayerUnitMoodExtension._remove_mood = function (self, t, mood_type)
	local mood_data = self._moods_data[mood_type]

	if mood_data.status == mood_status.removing or mood_data.status == mood_status.inactive then
		return
	end

	mood_data.removed_t = t
	mood_data.status = mood_status.removing
end

PlayerUnitMoodExtension.add_timed_mood = function (self, t, mood_type)
	self:_add_mood(t, mood_type, true)

	if self._is_server then
		local mood_type_id = NetworkLookup.moods_types[mood_type]

		Managers.state.game_session:send_rpc_clients("rpc_trigger_timed_mood", self._game_object_id, mood_type_id)
	end
end

PlayerUnitMoodExtension.rpc_trigger_timed_mood = function (self, channel_id, go_id, mood_type_id)
	local t = Managers.time:time("gameplay")
	local mood_type = NetworkLookup.moods_types[mood_type_id]

	self:add_timed_mood(t, mood_type)
end

PlayerUnitMoodExtension.remove_mood = function (self, t, mood_type)
	self:_remove_mood(t, mood_type)

	if self._is_server then
		local mood_type_id = NetworkLookup.moods_types[mood_type]

		Managers.state.game_session:send_rpc_clients("rpc_remove_mood", self._game_object_id, mood_type_id)
	end
end

PlayerUnitMoodExtension.rpc_remove_mood = function (self, channel_id, go_id, mood_type_id)
	local mood_type = NetworkLookup.moods_types[mood_type_id]
	local t = Managers.time:time("gameplay")

	self:_remove_mood(t, mood_type)
end

return PlayerUnitMoodExtension
