extends Node2D

# === IMAGES FOR EACH GRID POSITION + DIRECTION ===
var images = {
	Vector2(0,0): {"north": preload("res://Assets/img_1.jpg"), "east": preload("res://Assets/img_2.jpg"), "south": preload("res://Assets/img_3.jpg"), "west": preload("res://Assets/img_4.jpg")},
	Vector2(0,1): {"north": preload("res://Assets/img_5.jpg"), "east": preload("res://Assets/img_6.jpg"), "south": preload("res://Assets/img_7.jpg"), "west": preload("res://Assets/img_8.jpg")},
	Vector2(1,0): {"north": preload("res://Assets/img_13.jpg"), "east": preload("res://Assets/img_14.jpg"), "south": preload("res://Assets/img_15.jpg"), "west": preload("res://Assets/img_16.jpg")},
	Vector2(1,1): {"north": preload("res://Assets/img_9.jpg"), "east": preload("res://Assets/img_10.jpg"), "south": preload("res://Assets/img_11.jpg"), "west": preload("res://Assets/img_12.jpg")},
}

# === HARRY IMAGES ===
var harry_images = {
	Vector2(0,0): {"north": preload("res://Assets/img_17.jpg"), "east": preload("res://Assets/img_18.jpg"), "south": preload("res://Assets/img_19.jpg"), "west": preload("res://Assets/img_20.jpg")},
	Vector2(0,1): {"north": preload("res://Assets/img_21.jpg"), "east": preload("res://Assets/img_22.jpg"), "south": preload("res://Assets/img_23.jpg"), "west": preload("res://Assets/img_24.jpg")},
	Vector2(1,0): {"north": preload("res://Assets/img_29.jpg"), "east": preload("res://Assets/img_30.jpg"), "south": preload("res://Assets/img_31.jpg"), "west": preload("res://Assets/img_32.jpg")},
	Vector2(1,1): {"north": preload("res://Assets/img_25.jpg"), "east": preload("res://Assets/img_26.jpg"), "south": preload("res://Assets/img_27.jpg"), "west": preload("res://Assets/img_28.jpg")},
}

# === UI NODES ===
@onready var bg = $UI/Background
@onready var harry_timer = $"UI/Harry Timer"
@onready var move_buttons = $UI/Control
@onready var play_button = $UI/Playbutton
@onready var rps_container = $UI/RPScontainer
@onready var countdown_label = $UI/Countdownlabel
@onready var countdown_timer = $UI/Countdowntimer
@onready var result_sprite = $UI/ResultSprite
@onready var play_again_button = $"UI/play again"

# === GAME STATE ===
var grid_pos = Vector2(0, 0)
var player_dir = "north"
var directions = ["north", "east", "south", "west"]
var harry_active = false
var countdown_time = 4
var player_choice = ""
var harry_choice = ""

func _ready():
	bg.stretch_mode = TextureRect.STRETCH_SCALE
	bg.expand = true

	randomize()
	harry_timer.wait_time = randf_range(5.0, 15.0)
	harry_timer.start()
	harry_timer.timeout.connect(_on_HarryTimer_timeout)
	countdown_timer.timeout.connect(_on_CountdownTimer_timeout)
	
	# Configure result sprite to be full screen
	result_sprite.expand = true
	result_sprite.stretch_mode = TextureRect.STRETCH_SCALE
	result_sprite.size = get_viewport_rect().size
	
	# Configure play again button
	play_again_button.pressed.connect(_on_play_again_pressed)
	play_again_button.visible = false
	
	# Hide UI elements initially
	play_button.visible = false
	rps_container.visible = false
	countdown_label.visible = false
	result_sprite.visible = false

	update_background()

func update_background():
	if harry_active and harry_images.has(grid_pos) and harry_images[grid_pos].has(player_dir):
		bg.texture = harry_images[grid_pos][player_dir]
		print("👀 Showing HARRY at", grid_pos, player_dir)
	elif images.has(grid_pos) and images[grid_pos].has(player_dir):
		bg.texture = images[grid_pos][player_dir]
	else:
		bg.texture = null

func _on_HarryTimer_timeout():
	harry_active = true
	print("⚠️ Harry has appeared!")
	update_background()
	play_button.visible = true

func _on_rock_pressed():
	player_choice = "rock"
	start_rps_countdown()

func _on_paper_pressed():
	player_choice = "paper"
	start_rps_countdown()

func _on_scissors_pressed():
	player_choice = "scissors"
	start_rps_countdown()

func start_rps_countdown():
	rps_container.visible = false
	countdown_time = 3
	countdown_label.text = str(countdown_time)
	countdown_label.visible = true
	countdown_timer.start()

func _on_playbutton_pressed():
	play_button.visible = false
	move_buttons.visible = false
	rps_container.visible = true
	
	countdown_time = 4
	countdown_label.text = str(countdown_time)
	countdown_label.visible = true
	countdown_label.modulate = Color(1, 1, 1, 1)
	
	countdown_timer.start()

func _on_CountdownTimer_timeout():
	countdown_time -= 1
	countdown_label.text = str(countdown_time)
	
	if countdown_time <= 1:
		countdown_label.modulate = Color(1, 0, 0)
	
	var tween = create_tween()
	tween.tween_property(countdown_label, "scale", Vector2(1.3, 1.3), 0.1)
	tween.tween_property(countdown_label, "scale", Vector2(1, 1), 0.1)
	
	if countdown_time <= 0:
		countdown_timer.stop()
		countdown_label.visible = false
		if player_choice == "":
			player_choice = ["rock", "paper", "scissors"].pick_random()
		harry_choice = ["rock", "paper", "scissors"].pick_random()
		process_rps_result()

func process_rps_result():
	var win_map = {"rock": "scissors", "scissors": "paper", "paper": "rock"}
	var player_wins = win_map[player_choice] == harry_choice

	print("Player chose:", player_choice, "Harry chose:", harry_choice)

	if player_wins:
		result_sprite.texture = preload("res://Assets/Harri lose.jpg")
		$UI/Result.text = "You Beat Harry!"
	else:
		result_sprite.texture = preload("res://Assets/Harri win.jpg")
		$UI/Result.text = "Harry Beat You!"
	result_sprite.visible = true
	
	# Show the Play Again button after a short delay
	await get_tree().create_timer(1.0).timeout
	if play_again_button:
		play_again_button.visible = true

func _on_play_again_pressed():
	if play_again_button:
		play_again_button.visible = false
	reset_to_movement_ui()

func reset_to_movement_ui():
	# Reset UI elements
	result_sprite.visible = false
	rps_container.visible = false
	move_buttons.visible = true
	countdown_label.visible = false
	
	# Reset game state
	harry_active = false
	player_choice = ""
	harry_choice = ""
	update_background()

	# Restart Harry timer
	harry_timer.wait_time = randf_range(5.0, 15.0)
	harry_timer.start()

# === MOVEMENT FUNCTIONS ===
func _on_forward_button_pressed():
	match player_dir:
		"north": if grid_pos.x > 0: grid_pos.x -= 1
		"east":  if grid_pos.y < 1: grid_pos.y += 1
		"south": if grid_pos.x < 1: grid_pos.x += 1
		"west":  if grid_pos.y > 0: grid_pos.y -= 1
	update_background()

func _on_backward_button_pressed():
	match player_dir:
		"north": if grid_pos.x < 1: grid_pos.x += 1
		"east":  if grid_pos.y > 0: grid_pos.y -= 1
		"south": if grid_pos.x > 0: grid_pos.x -= 1
		"west":  if grid_pos.y < 1: grid_pos.y += 1
	update_background()

func _on_turn_left_button_pressed():
	var i = directions.find(player_dir)
	player_dir = directions[(i - 1) % 4]
	update_background()

func _on_turn_right_button_pressed():
	var i = directions.find(player_dir)
	player_dir = directions[(i + 1) % 4]
	update_background()
