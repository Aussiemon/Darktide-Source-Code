local DaemonhostSettings = require("scripts/settings/specials/daemonhost_settings")
local Vo = require("scripts/utilities/vo")
local STAGES = DaemonhostSettings.stages
local vo_settings = {
	vo_event = "chaos_daemonhost_aggro",
	cooldown_duration = {
		9,
		11
	}
}
local template = {
	name = "chaos_daemonhost",
	start = function (template_data, template_context)
		local unit = template_data.unit
		template_data.game_session = Managers.state.game_session:game_session()
		template_data.game_object_id = Managers.state.unit_spawner:game_object_id(unit)
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		template_data.breed = unit_data_extension:breed()
		template_data.next_vo_trigger_t = 0
	end,
	update = function (template_data, template_context, dt, t)
		if not template_context.is_server then
			return
		end

		local game_session = template_data.game_session
		local game_object_id = template_data.game_object_id
		local stage = GameSession.game_object_field(game_session, game_object_id, "stage")

		if stage ~= STAGES.aggroed then
			return
		end

		local next_vo_trigger_t = template_data.next_vo_trigger_t

		if next_vo_trigger_t < t then
			local vo_event = vo_settings.vo_event

			if type(vo_event) == "table" then
				vo_event = math.random_array_entry(vo_event)
			end

			local unit = template_data.unit
			local breed = template_data.breed

			Vo.enemy_generic_vo_event(unit, vo_event, breed.name)

			local cooldown_duration = vo_settings.cooldown_duration

			if type(cooldown_duration) == "table" then
				cooldown_duration = math.random_range(cooldown_duration[1], cooldown_duration[2])
			end

			template_data.next_vo_trigger_t = t + cooldown_duration
		end
	end,
	stop = function (template_data, template_context)
		return
	end
}

return template
