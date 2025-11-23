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

@onready var bg = $UI/Background   # Reference to the TextureRect in the UI

var grid_pos = Vector2(0, 0)       # Starting position
var player_dir = "north"           # Starting facing direction
var directions = ["north", "east", "south", "west"]   # Order of directions

func _ready():
	bg.stretch_mode = TextureRect.STRETCH_SCALE
	bg.expand = true
	update_background()

# === UPDATE BACKGROUND BASED ON POSITION + DIRECTION ===
func update_background():
	if images.has(grid_pos) and images[grid_pos].has(player_dir):
		bg.texture = images[grid_pos][player_dir]
		print("Showing", grid_pos, player_dir)
	else:
		bg.texture = null
		print("No image for", grid_pos, player_dir)

# === MOVEMENT (Option A fix) ===
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
