func _on_turn_left_button_pressed():
	if is_transitioning:
		return
	if grid_pos == Vector2(0, 0) and player_dir == "north":
		start_transition() 
		complete_turn_left()
		update_background()
		$UI.show()
		is_transitioning = false

func complete_turn_left():
	var i = directions.find(player_dir)
	player_dir = directions[(i - 1) % 4]
	update_background()

func _on_turn_right_button_pressed():
	if is_transitioning:
		return
	var i = directions.find(player_dir)
	player_dir = directions[(i + 1) % 4]
	update_background()

func start_transition():
	is_transitioning = true
	move_buttons.visible = false
	transition.stream = load("res://Assets/aiturnleft.ogv")
	transition.visible = true
	transition.play()

func _on_transition_finished():
	emit_signal("transition_completed")
	transition.visible = false
	is_transitioning = false
	move_buttons.visible = true
	complete_turn_left()
	$UI.show()  # Show movement UI again
