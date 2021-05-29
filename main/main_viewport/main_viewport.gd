extends Viewport
# Functions as final controller for what is displayed on the screen
# Controller of all main UI controllers - connector of all

export (NodePath) var transition

var last_menu: String
var current_menu

func _ready() -> void:
	transition = get_node(transition)

func get_menu(menu_name) -> Node:
	match menu_name:
		"SaveFile":
			return $SaveFileMenu
		"Game":
			return $GameMenu
		"Main":
			return $MainMenu
	return null

func hide_menu(menu_name: String) -> void:
	match menu_name:
		"SaveFile":
			$SaveFileMenu.visible = false
		"Game":
			$GameMenu.visible = false
			$GameMenu.can_open = false
		"Main":
			$MainMenu.visible = false

func show_menu(menu_name: String) -> void:
	match menu_name:
		"SaveFile":
			$SaveFileMenu.visible = true
		"Game":
			$GameMenu.visible = true
			$GameMenu.can_open = true
		"Main":
			$MainMenu.visible = true
