local mod = get_mod("warpcharges")
local UIHudSettings = mod:original_require("scripts/settings/ui/ui_hud_settings")

mod.text_options = table.enum(
	"none",
	"text_option_charges",
	"text_option_souls",
	"text_option_warp",
	"text_option_warpcharges",
	"text_option_grenades",
	"text_option_blitz"
)
mod.value_options = table.enum(
	"none",
	"value_option_damage",
	"value_option_stacks",
	"value_option_time_percent",
	"value_option_time_seconds"
)
mod.orientation_options = table.enum(
	"orientation_option_horizontal",
	"orientation_option_vertical"
)

local function list_options(enum)
	local options = {}
	for k, v in pairs(enum) do
		table.insert(options, { text = k, value = v })
	end
	return options
end

local colors = {}

for _, color_name in ipairs(Color.list) do
	table.insert(colors, { text = color_name, value = color_name })
end

table.sort(colors, function(a, b)
	return a.text < b.text
end)

local function get_colors()
	return table.clone(colors)
end

local function color_archetype(archetype)
	return {
		setting_id = "color_" .. archetype,
		type = "checkbox",
		default_value = true,
		sub_widgets = {
			{
				setting_id = "color_" .. archetype .. "_full",
				type = "dropdown",
				default_value = "ui_" .. archetype,
				options = get_colors()
			},
			{
				setting_id = "color_" .. archetype .. "_empty",
				type = "dropdown",
				default_value = "ui_" .. archetype .. "_text",
				options = get_colors()
			}
		}
	}
end

local function color_options()
	local archetypes = { "psyker", "veteran", "zealot", "ogryn" } --"default", 
	local sub_widgets = {}
	for _, archetype in pairs(archetypes) do
		table.insert(sub_widgets, color_archetype(archetype))
	end
	return sub_widgets
end

local function archetype_options()
	local archetypes = { "psyker", "veteran", "zealot", "ogryn" }
	local archetype_widgets = {}
	for _, archetype in pairs(archetypes) do
		local widget = {
			setting_id = archetype,
			type = "group",
			sub_widgets = {
				{
					setting_id = archetype .. "_show_gauge",
					type = "checkbox",
					default_value = true
				},
				{
					setting_id = archetype .. "_gauge_text",
					type = "dropdown",
					default_value = mod.text_options["text_option_warpcharges"],
					options = list_options(mod.text_options)
				},
				{
					setting_id = archetype .. "_gauge_value",
					type = "dropdown",
					default_value = mod.value_options["value_option_stacks"],
					options = list_options(mod.value_options)
				},
				{
					setting_id = archetype .. "_gauge_value_text",
					type = "checkbox",
					default_value = true
				},
				{
					setting_id = "color_" .. archetype .. "_full",
					type = "dropdown",
					default_value = "ui_" .. archetype,
					options = get_colors()
				},
				{
					setting_id = "color_" .. archetype .. "_empty",
					type = "dropdown",
					default_value = "ui_" .. archetype .. "_text",
					options = get_colors()
				}
			}
		}
		table.insert(archetype_widgets, widget)
	end
	return archetype_widgets
end

return {
	name = mod:localize("mod_name"),
	description = mod:localize("mod_description"),
	is_togglable = true,
	options = {
		widgets = {
			{
				setting_id = "miscellaneous",
				type = "group",
				sub_widgets = {
					{
						setting_id = "gauge_orientation",
						type = "dropdown",
						default_value = mod.orientation_options["orientation_option_horizontal"],
						options = list_options(mod.orientation_options)
					},
					{
						setting_id = "gauge_color_1",
						type = "dropdown",
						default_value = "ui_hud_yellow_super_light",
						options = get_colors()
					},
					{
						setting_id = "gauge_color_2",
						type = "dropdown",
						default_value = "ui_hud_yellow_medium",
						options = get_colors()
					},
					{
						setting_id = "show_gauge",
						type = "checkbox",
						default_value = true
					},
					{
						setting_id = "martyrdom",
						type = "checkbox",
						default_value = false
					},
					{
						setting_id = "psyker_only",
						type = "checkbox",
						default_value = false
					}
				}
			},
			{
				setting_id = "archetype_options",
				type = "group",
				sub_widgets = archetype_options()
			}
		}
	}
}