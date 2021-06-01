extends UIController
class_name GameMenu
# Main controller for combat/game UI 

export(NodePath) var pop_out_party
export(NodePath) var party
export(NodePath) var active_party
export(NodePath) var inactive_party
export(NodePath) var effect_handler
export(NodePath) var action_selection
export(NodePath) var party_skill_container

var open := false
var can_open := false

func _ready():
	party = get_node(party)
	active_party = get_node(active_party)
	inactive_party = get_node(inactive_party)
	pop_out_party = get_node(pop_out_party)
	effect_handler = get_node(effect_handler)
	action_selection = get_node(action_selection)
	yield(get_tree().root, "ready")
	close_menu()

func _input(event: InputEvent) -> void:
	if disabled: return
	if event.is_action_pressed("open_menu", false) and can_open:
		if open:
			close_menu()
			main_viewport.world_node.player.can_move = true
		else:
			open_menu()
			main_viewport.interact.disable(false)
			main_viewport.world_node.player.can_move = false
	if event.is_action_pressed("ui_cancel", false) and open: 
		input_pressed("Back")

func input_pressed(key_name: String) -> void:
	if disabled or not open: return
	match(key_name):
		"Party":
			match state:
				"default": show_party(true)
		"Back":
			match state:
				"party":
					hide_party()
					input["MainButtonContainer"].enable_input()
					input["MainButtonContainer"].grab_focus_at(0)
				"skills":
					hide_skills()
					input["MainButtonContainer"].enable_input()
					input["MainButtonContainer"].grab_focus_at(0)
				"return_member":
					show_party(false)
				"default":
					close_menu()
					main_viewport.world_node.player.can_move = true
		"Skills":
			match state:
				"default": show_skills()
		"Summon":
			match state:
				"party":
					summon_member()
					
		"Confirm":
			pass

func open_menu() -> void:
	effect_handler.fade(self, "visible", effect_handler.default_fade_time)
	input["MainButtonContainer"].enable_input()
	input["MainButtonContainer"].grab_focus_at(0)
	open = true

func close_menu() -> void:
	hide_party()
	hide_skills()
	effect_handler.fade(self, "hide", effect_handler.default_fade_time)
	input["MainButtonContainer"].disable_input()
	open = false

func show_skills() -> void:
	input["MainButtonContainer"].disable_input()
	input["ActionHotkeyContainer"].enable_input()
	input["CreatureA"].enable_input()
	input["CreatureA"].grab_focus_at(0)
	effect_handler.fade(action_selection, "visible", effect_handler.default_fade_time)
	state = "skills"
	
func hide_skills() -> void:
	input["ActionHotkeyContainer"].disable_input()
	input["CreatureA"].disable_input()
	effect_handler.fade(action_selection, "hide", effect_handler.default_fade_time)
	state = "default"

func summon_member() -> void:
	var creature_button := get_focus_owner()
	if party.in_active_party(creature_button.creature):
		return_member()
		return
	var scroll = input["FullPartyContainer"].get_parent().get_h_scroll()
	var index := creature_button.get_index()
	var success: bool = party.summon_member(creature_button.creature)
	if success:
		update_party()
		input["FullPartyContainer"].grab_focus_at(index)
		input["FullPartyContainer"].get_parent().set_h_scroll(scroll)

func return_member():
	var creature_button := get_focus_owner()
	var scroll = input["FullPartyContainer"].get_parent().get_h_scroll()
	var index := creature_button.get_index()
	var success: bool = party.return_member(creature_button.creature)
	if success:
		update_party()
		input["FullPartyContainer"].grab_focus_at(index)
		input["FullPartyContainer"].get_parent().set_h_scroll(scroll)

func select_active_member() -> void:
	input["PartyHotKeyContainer"].disable_input()
	input["PartyHotKeyContainer"].visible = false
	input["ActivePartyContainer"].grab_focus_at(0)
	input["PartySelectHotKeyContainer"].enable_input()
	input["PartySelectHotKeyContainer"].visible = true
	state = "select_active_member"

func show_party(anim: bool) -> void:
	if anim:
		effect_handler.slide(self, "y", 0, effect_handler.default_slide_time)
	input["MainButtonContainer"].disable_input()
	input["PartyHotKeyContainer"].enable_input()
	input["PartyHotKeyContainer"].visible = true
	input["PartySelectHotKeyContainer"].disable_input()
	input["PartySelectHotKeyContainer"].visible = false
	input["FullPartyContainer"].grab_focus_at(0)
	state = "party"
	
func hide_party() -> void:
	effect_handler.slide(self, "y", pop_out_party.rect_size.y, effect_handler.default_slide_time)
	input["PartyHotKeyContainer"].disable_input()
	state = "default"

func update_party() -> void:
	input["FullPartyContainer"].add_items()
	input["ActivePartyContainer"].add_items()

func enable(show: bool) -> void:
	.enable(show)
	can_open = true

func disable(show: bool) -> void:
	.disable(show)
	can_open = false
