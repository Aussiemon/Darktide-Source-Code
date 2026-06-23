-- chunkname: @scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_live_event_endless_hordes.lua

local Navigation = require("scripts/extension_systems/navigation/utilities/navigation")

require("scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_base")

local MutatorGameplayLiveEventEndlessHordes = class("MutatorGameplayLiveEventEndlessHordes", "MutatorGameplayBase")

MutatorGameplayLiveEventEndlessHordes.init = function (self, owner, settings, triggered_by_level)
	MutatorGameplayLiveEventEndlessHordes.super.init(self, owner, settings, triggered_by_level)
	Managers.state.pacing:set_auto_event_template("live_event_endless_hordes_auto_event_template")
end

MutatorGameplayLiveEventEndlessHordes.update = function (self, dt, t)
	local is_pacing_enabled = Managers.state.pacing:is_enabled()
	local in_safe_zone = Managers.state.pacing:get_in_safe_zone()
	local path_completed = Managers.state.main_path:furthest_travel_percentage(1)
	local nav_world = Managers.state.nav_mesh:nav_world()
	local position = Vector3(0, 0, 0)
	local in_no_spawn_zone = false
	local _, _, ahead_position = Managers.state.main_path:ahead_unit(1)

	if nav_world and ahead_position then
		local layer_ids = Managers.state.nav_mesh:nav_tag_volume_layer_ids_by_volume_type("content/volume_types/nav_tag_volumes/no_spawn")

		position = ahead_position

		for i = 1, #layer_ids do
			local layer_id = layer_ids[i]
			local nav_tag_data = Navigation.inside_nav_tag_volume_layer(nav_world, position, 0.5, 0.5, layer_id)

			if nav_tag_data then
				in_no_spawn_zone = true

				break
			end
		end
	end

	local can_spawn_enemies = path_completed > 0 and not in_safe_zone and (is_pacing_enabled or not is_pacing_enabled and Managers.state.terror_event:num_active_events() > 0) and (not in_no_spawn_zone or in_no_spawn_zone and Managers.state.terror_event:num_active_events() > 0)

	if can_spawn_enemies ~= self._can_spawn_enemies then
		if not can_spawn_enemies and self._auto_event_id then
			Managers.state.pacing:request_auto_event_end(self._auto_event_id)

			self._auto_event_id = nil
		elseif can_spawn_enemies and not self._auto_event_id then
			local auto_event_context = {
				composition = "default",
				inject_captain = false,
				inject_monster = false,
				inject_twin = false,
				size = "default",
				worldposition = position,
				node_id = self._node_id,
			}

			self._auto_event_id = Managers.state.pacing:request_auto_event(auto_event_context)
		end
	end

	self._can_spawn_enemies = can_spawn_enemies
end

MutatorGameplayLiveEventEndlessHordes.destroy = function (self)
	MutatorGameplayLiveEventEndlessHordes.super.destroy(self)
	Managers.state.pacing:restore_auto_event_template()
end

return MutatorGameplayLiveEventEndlessHordes
