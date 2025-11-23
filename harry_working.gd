extends Node2D

# === IMAGES FOR EACH GRID POSITION + DIRECTION ===
var images = {
	Vector2(0,0): {
		"north": preload("res://Assets/img_1.jpg"),
		"east":  preload("res://Assets/img_2.jpg"),
		"south": preload("res://Assets/img_3.jpg"),
		"west":  preload("res://Assets/img_4.jpg"),
	},
	Vector2(0,1): {
		"north": preload("res://Assets/img_5.jpg"),
		"east":  preload("res://Assets/img_6.jpg"),
		"south": preload("res://Assets/img_7.jpg"),
		"west":  preload("res://Assets/img_8.jpg"),
	},
	Vector2(1,0): {
		"north": preload("res://Assets/img_13.jpg"),
		"east":  preload("res://Assets/img_14.jpg"),
		"south": preload("res://Assets/img_15.jpg"),
		"west":  preload("res://Assets/img_16.jpg"),
	},
	Vector2(1,1): {
		"north": preload("res://Assets/img_9.jpg"),
		"east":  preload("res://Assets/img_10.jpg"),
		"south": preload("res://Assets/img_11.jpg"),
		"west":  preload("res://Assets/img_12.jpg"),
	},
}

# === HARRY IMAGES ===
var harry_images = {
	Vector2(0,0): {
		"north": preload("res://Assets/img_17.jpg"),
		"east":  preload("res://Assets/img_18.jpg"),
		"south": preload("res://Assets/img_19.jpg"),
		"west":  preload("res://Assets/img_20.jpg"),
	},
	Vector2(0,1): {
		"north": preload("res://Assets/img_21.jpg"),
		"east":  preload("res://Assets/img_22.jpg"),
		"south": preload("res://Assets/img_23.jpg"),
		"west":  preload("res://Assets/img_24.jpg"),
	},
	Vector2(1,0): {
		"north": preload("res://Assets/img_29.jpg"),
		"east":  preload("res://Assets/img_30.jpg"),
		"south": preload("res://Assets/img_31.jpg"),
		"west":  preload("res://Assets/img_32.jpg"),
	},
	Vector2(1,1): {
		"north": preload("res://Assets/img_25.jpg"),
		"east":  preload("res://Assets/img_26.jpg"),
		"south": preload("res://Assets/img_27.jpg"),
		"west":  preload("res://Assets/img_28.jpg"),
	},
}

@onready var bg = $UI/Background   # TextureRect
@onready var harry_timer = $"UI/Harry Timer"   # Timer node in scene

var grid_pos = Vector2(0, 0)       # Starting position
var player_dir = "north"           # Starting facing direction
var directions = ["north", "east", "south", "west"]
var harry_active = false           # flag for Harry's appearance

func _ready():
	bg.stretch_mode = TextureRect.STRETCH_SCALE
	bg.expand = true

	randomize()
	harry_timer.wait_time = randf_range(5.0, 15.0)
	harry_timer.start()

	# Connect Harry's timer timeout signal
	harry_timer.timeout.connect(_on_HarryTimer_timeout)

	print("Harry timer Start")
	update_background()

# === UPDATE BACKGROUND BASED ON POSITION + DIRECTION ===
func update_background():
	if harry_active and harry_images.has(grid_pos) and harry_images[grid_pos].has(player_dir):
		bg.texture = harry_images[grid_pos][player_dir]
		print("👀 Showing HARRY at", grid_pos, player_dir)
	elif images.has(grid_pos) and images[grid_pos].has(player_dir):
		bg.texture = images[grid_pos][player_dir]
		print("Showing normal", grid_pos, player_dir)
	else:
		bg.texture = null
		print("No image for", grid_pos, player_dir)

# === TIMER CALLBACK ===
func _on_HarryTimer_timeout():
	harry_active = true
	print("⚠️ Harry has appeared!")
	update_background()

# === MOVEMENT ===
func _on_forward_button_pressed() -> void:
	print("Forward pressed! Current:", grid_pos, player_dir)
	match player_dir:
		"north": if grid_pos.x > 0: grid_pos.x -= 1
		"east":  if grid_pos.y < 1: grid_pos.y += 1
		"south": if grid_pos.x < 1: grid_pos.x += 1
		"west":  if grid_pos.y > 0: grid_pos.y -= 1
	print("After move:", grid_pos, player_dir)
	update_background()

func _on_backward_button_pressed() -> void:
	print("Backward pressed! Current:", grid_pos, player_dir)
	match player_dir:
		"north": if grid_pos.x < 1: grid_pos.x += 1
		"east":  if grid_pos.y > 0: grid_pos.y -= 1
		"south": if grid_pos.x > 0: grid_pos.x -= 1
		"west":  if grid_pos.y < 1: grid_pos.y += 1
	print("After move:", grid_pos, player_dir)
	update_background()

# === TURNING ===
func _on_turn_left_button_pressed() -> void:
	var i = directions.find(player_dir)
	player_dir = directions[(i - 1) % 4]   # Rotate left
	update_background()

func _on_turn_right_button_pressed() -> void:
	var i = directions.find(player_dir)
	player_dir = directions[(i + 1) % 4]   # Rotate right
	update_background()
