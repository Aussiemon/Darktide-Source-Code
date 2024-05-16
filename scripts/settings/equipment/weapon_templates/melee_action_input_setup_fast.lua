-- chunkname: @scripts/settings/equipment/weapon_templates/melee_action_input_setup_fast.lua

local DefaultMeleeActionInputSetup = require("scripts/settings/equipment/weapon_templates/default_melee_action_input_setup")
local melee_action_input_setup_fast = table.clone(DefaultMeleeActionInputSetup)
local light_attack = melee_action_input_setup_fast.action_inputs.light_attack
local heavy_attack = melee_action_input_setup_fast.action_inputs.heavy_attack
local push_follow_up = melee_action_input_setup_fast.action_inputs.push_follow_up
local light_to_heavy_timing = 0.3
local heavy_auto_complete_timing = 1
local push_follow_up_timing = 0.25

light_attack.input_sequence[1].time_window = light_to_heavy_timing
heavy_attack.input_sequence[1].duration = light_to_heavy_timing
heavy_attack.input_sequence[2].time_window = heavy_auto_complete_timing
push_follow_up.input_sequence[1].duration = push_follow_up_timing

return melee_action_input_setup_fast
