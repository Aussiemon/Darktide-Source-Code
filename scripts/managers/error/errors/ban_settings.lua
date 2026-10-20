-- chunkname: @scripts/managers/error/errors/ban_settings.lua

local BanSettings = {
	appeal_url = "https://www.fatshark.se/community-safety#appeals",
	fallback_description = "loc_error_banned_gen",
	frozen_description = "loc_error_banned_frozen",
}

BanSettings.categories = {
	{
		category = "loc_error_banned_bhv",
		reasons = {
			"BHV",
			"Behavior",
		},
	},
	{
		category = "loc_error_banned_crg",
		reasons = {
			"CRG",
			"Chargeback",
		},
	},
	{
		category = "loc_error_banned_harassment_abuse",
		description = "loc_error_banned_harassment_abuse_desc",
		violation = "loc_error_banned_eula_breach_section_7",
		reasons = {
			"CYB",
			"CYBER_BULLYING_INTIMIDATION",
			"CYH",
			"CYBER_HARASSMENT",
			"CYI",
			"CYBER_INCITEMENT",
			"CYS",
			"CYBER_STALKING",
			"DEF",
			"DEFAMATION",
		},
	},
	{
		category = "loc_error_banned_hate_speech_discrimination",
		description = "loc_error_banned_hate_speech_discrimination_desc",
		violation = "loc_error_banned_eula_breach_section_7",
		reasons = {
			"DIS",
			"DISCRIMINATION",
			"HSP",
			"HATE_SPEECH",
			"BAG",
			"BULLYING_AGAINST_GIRLS",
			"CHW",
			"CYBER_HARASSMENT_AGAINST_WOMEN",
			"CSW",
			"CYBER_STALKING_AGAINST_WOMEN",
			"FGD",
			"FEMALE_GENDERED_DISINFORMATION",
			"IAW",
			"INCITEMENT_AGAINST_WOMEN",
		},
	},
	{
		category = "loc_error_banned_threats_incitement_violence",
		description = "loc_error_banned_threats_incitement_violence_desc",
		violation = "loc_error_banned_eula_breach_section_7",
		reasons = {
			"CHA",
			"COORDINATED_HARM",
			"IVH",
			"INCITEMENT_VIOLENCE_HATRED",
		},
	},
	{
		category = "loc_error_banned_fraud_scams_impersonation",
		description = "loc_error_banned_fraud_scams_impersonation_desc",
		violation = "loc_error_banned_eula_breach_section_7",
		reasons = {
			"PHI",
			"PHISHING",
			"IAH",
			"IMPERSONATION_ACCOUNT_HIJACKING",
			"PSC",
			"PYRAMID_SCHEMES",
			"IAC",
			"INAUTHENTIC_ACCOUNTS",
			"ILI",
			"INAUTHENTIC_LISTINGS",
			"IUR",
			"INAUTHENTIC_USER_REVIEWS",
		},
	},
	{
		category = "loc_error_banned_cheating_unfair_play",
		description = "loc_error_banned_cheating_unfair_play_desc",
		violation = "loc_error_banned_eula_breach_section_7",
		reasons = {
			"CUS",
			"CHEATING_OR_UNAUTHORISED_SOFTWARE",
			"EGL",
			"EXPLOITING_GLITCHES",
		},
	},
	{
		category = "loc_error_banned_adult_sexual_explicit_content",
		description = "loc_error_banned_adult_sexual_explicit_content_desc",
		violation = "loc_error_banned_eula_breach_section_7",
		reasons = {
			"ASM",
			"ADULT_SEXUAL_MATERIAL",
			"NUD",
			"NUDITY",
		},
	},
	{
		category = "loc_error_banned_non_consensual_intimate_content",
		description = "loc_error_banned_non_consensual_intimate_content_desc",
		violation = "loc_error_banned_eula_breach_section_7",
		reasons = {
			"NCI",
			"NON_CONSENSUAL_IMAGE_SHARING",
			"NCM",
			"NON_CONSENSUAL_MATERIAL_DEEPFAKE",
			"NIW",
			"NON_CONSENSUAL_IMAGE_SHARING_AGAINST_WOMEN",
			"NMW",
			"NON_CONSENSUAL_MATERIAL_DEEPFAKE_AGAINST_WOMEN",
		},
	},
	{
		category = "loc_error_banned_child_sexual_exploitation_grooming",
		description = "loc_error_banned_child_sexual_exploitation_grooming_desc",
		violation = "loc_error_banned_eula_breach_section_7",
		reasons = {
			"CAM",
			"CHILD_SEXUAL_ABUSE_MATERIAL",
			"CAD",
			"CHILD_SEXUAL_ABUSE_MATERIAL_DEEPFAKE",
			"GEM",
			"GROOMING_SEXUAL_ENTICEMENT_MINORS",
		},
	},
	{
		category = "loc_error_banned_unsafe_content_involving_minors",
		description = "loc_error_banned_unsafe_content_involving_minors_desc",
		violation = "loc_error_banned_eula_breach_section_7",
		reasons = {
			"ARM",
			"AGE_SPECIFIC_RESTRICTIONS_MINORS",
			"UCH",
			"UNSAFE_CHALLENGES",
		},
	},
	{
		category = "loc_error_banned_promotion_self_harm_eating_disorders",
		description = "loc_error_banned_promotion_self_harm_eating_disorders_desc",
		violation = "loc_error_banned_eula_breach_section_7",
		reasons = {
			"SMU",
			"SELF_MUTILATION",
			"SUI",
			"SUICIDE",
			"CED",
			"CONTENT_PROMOTING_EATING_DISORDERS",
		},
	},
	{
		category = "loc_error_banned_terrorist_extremist_content",
		description = "loc_error_banned_terrorist_extremist_content_desc",
		violation = "loc_error_banned_eula_breach_section_7",
		reasons = {
			"TCO",
			"TERRORIST_CONTENT",
			"IOR",
			"ILLEGAL_ORGANIZATIONS",
		},
	},
	{
		category = "loc_error_banned_human_exploitation_trafficking",
		description = "loc_error_banned_human_exploitation_trafficking_desc",
		violation = "loc_error_banned_eula_breach_section_7",
		reasons = {
			"HEX",
			"HUMAN_EXPLOITATION",
			"HTR",
			"HUMAN_TRAFFICKING",
			"TWG",
			"TRAFFICKING_WOMEN_GIRLS",
		},
	},
	{
		category = "loc_error_banned_illegal_unsafe_goods_services",
		description = "loc_error_banned_illegal_unsafe_goods_services_desc",
		violation = "loc_error_banned_eula_breach_section_7",
		reasons = {
			"PPR",
			"PROHIBITED_PRODUCTS",
			"UPR",
			"UNSAFE_PRODUCTS",
			"GNP",
			"GOODS_SERVICES_NOT_PERMITTED",
		},
	},
	{
		category = "loc_error_banned_health_environmental_animal_harm",
		description = "loc_error_banned_health_environmental_animal_harm_desc",
		violation = "loc_error_banned_eula_breach_section_7",
		reasons = {
			"RPH",
			"RISK_PUBLIC_HEALTH",
			"RED",
			"RISK_ENVIRONMENTAL_DAMAGE",
			"AHA",
			"ANIMAL_HARM",
			"USA",
			"UNLAWFUL_SALE_ANIMALS",
		},
	},
	{
		category = "loc_error_banned_privacy_personal_data_violations",
		description = "loc_error_banned_privacy_personal_data_violations_desc",
		violation = "loc_error_banned_eula_breach_section_7",
		reasons = {
			"BDB",
			"BIOMETRIC_DATA_BREACH",
			"MPG",
			"MISSING_PROCESSING_GROUND",
			"RBF",
			"RIGHT_TO_BE_FORGOTTEN",
		},
	},
	{
		category = "loc_error_banned_false_misleading_information",
		description = "loc_error_banned_false_misleading_information_desc",
		violation = "loc_error_banned_eula_breach_section_7",
		reasons = {
			"MDI",
			"MISINFORMATION_DISINFORMATION",
			"DFA",
			"DATA_FALSIFICATION",
		},
	},
	{
		category = "loc_error_banned_intellectual_property_infringement",
		description = "loc_error_banned_intellectual_property_infringement_desc",
		violation = "loc_error_banned_eula_breach_section_7_17",
		reasons = {
			"CIN",
			"COPYRIGHT_INFRINGEMENT",
			"TIN",
			"TRADEMARK_INFRINGEMENT",
			"PIN",
			"PATENT_INFRINGEMENT",
			"DIN",
			"DESIGN_INFRINGEMENT",
			"TSI",
			"TRADE_SECRET_INFRINGEMENT",
			"GII",
			"GEOGRAPHIC_INDICATIONS_INFRINGEMENT",
		},
	},
	{
		category = "loc_error_banned_marketplace_consumer_law_violation",
		description = "loc_error_banned_marketplace_consumer_law_violation_desc",
		violation = "loc_error_banned_eula_breach_section_7",
		reasons = {
			"HAD",
			"HIDDEN_ADVERTISEMENT",
			"MIG",
			"MISLEADING_INFO_GOODS_SERVICES",
			"MIC",
			"MISLEADING_INFO_CONSUMER_RIGHTS",
			"IIT",
			"INSUFFICIENT_INFORMATION_ON_TRADERS",
			"NPR",
			"NONCOMPLIANCE_PRICING",
		},
	},
	{
		category = "loc_error_banned_violation_applicable_law",
		description = "loc_error_banned_violation_applicable_law_desc",
		violation = "loc_error_banned_eula_breach_section_7",
		reasons = {
			"VEL",
			"VIOLATION_EU_LAW",
			"VIL",
			"VIOLATION_NATIONAL_LAW",
		},
	},
	{
		category = "loc_error_banned_regional_age_restrictions",
		description = "loc_error_banned_regional_age_restrictions_desc",
		violation = "loc_error_banned_eula_breach_section_5_6",
		reasons = {
			"ASR",
			"AGE_SPECIFIC_RESTRICTIONS",
			"GRE",
			"GEOGRAPHICAL_REQUIREMENTS",
			"LRE",
			"LANGUAGE_REQUIREMENTS",
		},
	},
	{
		category = "loc_error_banned_inappropriate_username",
		description = "loc_error_banned_inappropriate_username_desc",
		violation = "loc_error_banned_eula_breach_section_7",
		reasons = {
			"IUS",
			"INAPPROPRIATE_USERNAME",
		},
	},
	{
		category = "loc_error_banned_ban_evasion",
		description = "loc_error_banned_ban_evasion_desc",
		violation = "loc_error_banned_eula_breach_section_5_21",
		reasons = {
			"BEV",
			"BAN_EVASION",
		},
	},
	{
		category = "loc_error_banned_gen",
		reasons = {
			"GEN",
			"GENERIC",
		},
	},
}

local category_by_reason = {}
local categories = BanSettings.categories

for i = 1, #categories do
	local category = categories[i]
	local reasons = category.reasons

	for j = 1, #reasons do
		local reason = reasons[j]

		category_by_reason[reason] = category
	end
end

BanSettings.category_by_reason = category_by_reason

return settings("BanSettings", BanSettings)
