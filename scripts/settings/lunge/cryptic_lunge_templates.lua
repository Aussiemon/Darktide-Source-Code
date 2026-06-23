-- chunkname: @scripts/settings/lunge/cryptic_lunge_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local MoodSettings = require("scripts/settings/camera/mood/mood_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local armor_types = ArmorSettings.types
local damage_types = DamageSettings.damage_types
local talent_settings = TalentSettings.cryptic
local ability_dash_talent_settings = talent_settings.chordclaw_ability.dash
local cryptic_lunge_templates = {}

return cryptic_lunge_templates
