extends ColorRect

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.is_action_pressed("mac_copy"):
			simulate_input(KEY_C)
		if event.is_action_pressed("mac_paste"):
			simulate_input(KEY_V)
		if event.is_action_pressed("mac_cut"):
			simulate_input(KEY_X)
		if event.is_action_pressed("mac_select_all"):
			simulate_input(KEY_A)

func simulate_input(new_scancode):
	var input_event = InputEventKey.new()
	input_event.scancode = new_scancode
	input_event.control = true
	input_event.pressed = true
	Input.parse_input_event(input_event)
	
	input_event.pressed = false
	Input.parse_input_event(input_event)
