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
	"rpc_trigger_timed_mood"
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
	self._character_state_read_component = unit_data_extension:read_component("character_state")
	self._warp_charge_component = unit_data_extension:read_component("warp_charge")
	self._lunge_character_state_component = unit_data_extension:read_component("lunge_character_state")
	self._sprint_character_state_component = unit_data_extension:read_component("sprint_character_state")
	self._combat_ability_component = unit_data_extension:read_component("combat_ability")
	self._unit_data_extension = unit_data_extension
	self._health_extension = ScriptUnit.has_extension(unit, "health_system")
	self._toughness_extension = ScriptUnit.extension(unit, "toughness_system")
	local moods_data = Script.new_map(num_moods)

	for mood_type, _ in pairs(mood_types) do
		moods_data[mood_type] = {
			entered_t = math.huge,
			removed_t = math.huge,
			status = mood_status.inactive
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
	local is_knocked_down = PlayerUnitStatus.is_knocked_down(self._character_state_read_component)
	local is_in_critical_health, critical_health_status = PlayerUnitStatus.is_in_critical_health(self._health_extension, self._toughness_extension)
	local critical_health = is_in_critical_health and CRITICAL_HEALTH_LIMIT <= critical_health_status
	local no_toughness_left = PlayerUnitStatus.no_toughness_left(self._toughness_extension)
	local player = self._player
	local specialization_warp_charge_template = WarpCharge.specialization_warp_charge_template(player)
	local weapon_warp_charge_template = WarpCharge.weapon_warp_charge_template(player.player_unit)
	local base_low_threshold = specialization_warp_charge_template.low_threshold
	local low_threshold_modifier = weapon_warp_charge_template.low_threshold_modifier or 1
	local warped_low_threshold = base_low_threshold * low_threshold_modifier
	local base_high_threshold = specialization_warp_charge_template.high_threshold
	local high_threshold_modifier = weapon_warp_charge_template.high_threshold_modifier or 1
	local warped_high_threshold = base_high_threshold * high_threshold_modifier
	local base_critical_threshold = specialization_warp_charge_template.critical_threshold
	local critical_threshold_modifier = weapon_warp_charge_template.critical_threshold_modifier or 1
	local warped_critical_threshold = base_critical_threshold * critical_threshold_modifier
	local current_warp_percentage = self._warp_charge_component.current_percentage
	local warped = current_warp_percentage > 0
	local warped_low_to_high = warped_low_threshold < current_warp_percentage
	local warped_high_to_critical = warped_high_threshold < current_warp_percentage
	local warped_critical = warped_critical_threshold < current_warp_percentage
	local num_wounds = self._health_extension:num_wounds()
	local last_wound = num_wounds == 1
	local is_in_lunging, lunging_template = PlayerUnitStatus.is_in_lunging_aim_or_combat_ability(self._lunge_character_state_component)
	local lunging_mood = is_in_lunging and lunging_template.mood
	local buff_extension = ScriptUnit.extension(self._unit, "buff_system")
	local is_in_veteran_ranger_stance = buff_extension:has_keyword(buff_keywords.veteran_ranger_combat_ability)
	local is_in_stealth = buff_extension:has_keyword(buff_keywords.invisible)
	local combat_ability_active = self._combat_ability_component.active
	local is_in_psyker_biomancer_combat_ability = nil

	if combat_ability_active then
		local specialization_extension = ScriptUnit.extension(self._unit, "specialization_system")
		local specialization_name = specialization_extension:get_specialization_name()
		local archetype_name = self._player:archetype_name()

		if archetype_name == "psyker" and (specialization_name == "none" or specialization_name == "psyker_2") then
			is_in_psyker_biomancer_combat_ability = true
		end
	end

	local sprint_character_state_component = self._sprint_character_state_component
	local is_sprinting = sprint_character_state_component.is_sprinting
	local have_sprint_overtime = sprint_character_state_component.sprint_overtime > 0
	local is_effective_sprinting = is_sprinting and not have_sprint_overtime
	local is_overtime_spriting = is_sprinting and have_sprint_overtime

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
		self:_add_mood(t, mood_types.no_toughness)
	elseif not use_toughness_mood then
		self:_remove_mood(t, mood_types.no_toughness)
	end

	if is_effective_sprinting then
		self:_add_mood(t, mood_types.sprinting)
	elseif not is_effective_sprinting then
		self:_remove_mood(t, mood_types.sprinting)
	end

	if is_overtime_spriting then
		self:_add_mood(t, mood_types.sprinting_overtime)
	elseif not is_overtime_spriting then
		self:_remove_mood(t, mood_types.sprinting_overtime)
	end

	if lunging_mood == mood_types.zealot_maniac_combat_ability then
		self:_add_mood(t, mood_types.zealot_maniac_combat_ability)
	elseif lunging_mood ~= mood_types.zealot_maniac_combat_ability then
		self:_remove_mood(t, mood_types.zealot_maniac_combat_ability)
	end

	if is_in_veteran_ranger_stance then
		self:_add_mood(t, mood_types.veteran_ranger_combat_ability)
	elseif not is_in_veteran_ranger_stance then
		self:_remove_mood(t, mood_types.veteran_ranger_combat_ability)
	end

	if is_in_stealth then
		self:_add_mood(t, mood_types.stealth)
	elseif not is_in_stealth then
		self:_remove_mood(t, mood_types.stealth)
	end

	if is_in_psyker_biomancer_combat_ability then
		self:_add_mood(t, mood_types.psyker_biomancer_combat_ability)
	elseif not is_in_psyker_biomancer_combat_ability then
		self:_remove_mood(t, mood_types.psyker_biomancer_combat_ability)
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

return PlayerUnitMoodExtension
