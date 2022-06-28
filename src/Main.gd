extends ColorRect

var commands:PoolStringArray				= ["mac_copy", "mac_paste", "mac_cut", "mac_select_all"]
var commands_keys:Array						= [KEY_C, KEY_V, KEY_X, KEY_A]
var _clipboard_callback:JavaScriptObject	= JavaScript.create_callback(self, "_on_clipboard")
var copied:bool								= false
var os										= "Windows"

onready var navigator:JavaScriptObject		= JavaScript.get_interface("navigator")


func _ready():
	if not OS.has_feature("HTML5"):
		return
	os = JavaScript.eval("getOS()")
	if os == "MacOS":
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
	if not OS.has_feature("HTML5"):
		print("input function cancelled: HTML5 feature not found.")
		return
	if event is InputEventKey and event.pressed:
		if os != "MacOS":
			# Handling default Inputs (Windows)
			if event.scancode == KEY_C:
				show_debug("Default: copy")
			if event.scancode == KEY_V and not copied:
				copied = true
				var obj = navigator.clipboard.readText().then(_clipboard_callback)
				show_debug("Default: paste")
				get_tree().set_input_as_handled()
			if event.scancode == KEY_X:
				show_debug("Default: cut")
			if event.scancode == KEY_A:
				show_debug("Default: select all")
		
		else:
			# Handling Mac Input
			if event.is_action_pressed("mac_copy"):
				show_debug("MacOS: copy")
				simulate_input(KEY_C)
			if event.is_action_pressed("mac_paste") and not copied:
				copied = true
				var obj = navigator.clipboard.readText().then(_clipboard_callback)
				show_debug("MacOS: paste")
				#simulate_input(KEY_V)
			if event.is_action_pressed("mac_cut"):
				show_debug("MacOS: cut")
				simulate_input(KEY_X)
			if event.is_action_pressed("mac_select_all"):
				show_debug("MacOS: select all")
				simulate_input(KEY_A)


func _on_clipboard(args):
	OS.clipboard = args[0]
	simulate_input(KEY_V)
	copied = false


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
