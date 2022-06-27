extends ColorRect

var commands = ["mac_copy", "mac_paste", "mac_cut", "mac_select_all"]
var commands_keys = [KEY_C, KEY_V, KEY_X, KEY_A]


func _ready():
	add_mac_actions()


func add_mac_actions():
	for i in commands.size():
		var new_event = InputEventKey.new()
		new_event.scancode = commands_keys[i]
		new_event.meta = true
		new_event.pressed = true
		InputMap.action_add_event(commands[i], new_event)
	for i in commands.size():
		var new_event = InputEventKey.new()
		new_event.scancode = commands_keys[i]
		new_event.command = true
		new_event.pressed = true
		InputMap.action_add_event(commands[i], new_event)



func _input(event):
	if event is InputEventKey and event.pressed:
		if event.is_action_pressed("mac_copy"):
			show_debug("simulate: mac copy")
			simulate_input(KEY_C)
		if event.is_action_pressed("mac_paste"):
			show_debug("simulate: mac paste")
			simulate_input(KEY_V)
		if event.is_action_pressed("mac_cut"):
			show_debug("simulate: mac cut")
			simulate_input(KEY_X)
		if event.is_action_pressed("mac_select_all"):
			show_debug("simulate: mac select all")
			simulate_input(KEY_A)


func simulate_input(new_scancode):
	var input_event = InputEventKey.new()
	input_event.scancode = new_scancode
	input_event.control = true
	input_event.pressed = true
	Input.parse_input_event(input_event)
	
	input_event.pressed = false
	Input.parse_input_event(input_event)


func show_debug(text):
	$DebugLabel.text = text
