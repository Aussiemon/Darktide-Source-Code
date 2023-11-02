local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local wield_inputs = PlayerCharacterConstants.wield_inputs
local weapon_template = {
	action_inputs = {
		wield = {
			buffer_time = 0,
			clear_input_queue = true,
			input_sequence = {
				{
					inputs = wield_inputs
				}
			}
		}
	},
	action_input_hierarchy = {
		wield = "stay"
	},
	actions = {
		action_unwield = {
			allowed_during_sprint = true,
			anim_event = "unequip",
			start_input = "wield",
			uninterruptible = true,
			kind = "unwield",
			total_time = 0,
			allowed_chain_actions = {}
		},
		action_wield = {
			uninterruptible = true,
			anim_event = "scan_start",
			allowed_during_sprint = true,
			kind = "wield",
			total_time = 0.1
		}
	},
	ammo_template = "no_ammo",
	crosshair_type = "ironsight",
	keywords = {
		"devices"
	},
	breed_anim_state_machine_3p = {
		human = "content/characters/player/human/third_person/animations/unarmed",
		ogryn = "content/characters/player/ogryn/third_person/animations/unarmed"
	},
	breed_anim_state_machine_1p = {
		human = "content/characters/player/human/first_person/animations/scanner",
		ogryn = "content/characters/player/ogryn/first_person/animations/scanner"
	},
	ammo_template = "no_ammo",
	fx_sources = {
		_speaker = "fx_speaker"
	},
	dodge_template = "default",
	sprint_template = "default",
	stamina_template = "default",
	toughness_template = "auspex",
	look_delta_template = "auspex_scanner",
	hud_icon = "content/ui/materials/icons/pickups/default",
	require_minigame = true,
	not_player_wieldable = true,
	action_move_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
		local player_unit = player.player_unit

		if not player_unit then
			return false
		end

		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
		local minigame_character_state_component = unit_data_extension:read_component("minigame_character_state")
		local is_level_unit = true
		local level_unit_id = minigame_character_state_component.interface_unit_id
		local interface_unit = Managers.state.unit_spawner:unit(level_unit_id, is_level_unit)

		if not interface_unit then
			return false
		end

		local minigame_extension = interface_unit and ScriptUnit.has_extension(interface_unit, "minigame_system")
		local minigame = minigame_extension:minigame()

		return minigame and minigame:uses_joystick()
	end
}

return weapon_template
