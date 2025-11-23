extends Node2D

# Preload your background textures for 2x2 grid cells
var backgrounds = {
	Vector2(0,0): preload("res://Assets/Dungeon1.png"),
	Vector2(0,1): preload("res://Assets/dungeon2.jpg"),
	Vector2(1,0): preload("res://Assets/dungeon3.jpg"),
	Vector2(1,1): preload("res://Assets/dungeon9.jpg"),
}

@onready var bg = $UI/Background

var grid_pos = Vector2(0, 0)

func _ready():
	# Setup the background TextureRect correctly once
	bg.stretch_mode = TextureRect.STRETCH_SCALE
	bg.expand = true

	update_background()

func update_background():
	if backgrounds.has(grid_pos):
		bg.texture = backgrounds[grid_pos]
		print("Showing background at ", grid_pos)
	else:
		bg.texture = null
		print("No background for ", grid_pos)

func _on_forward_button_pressed() -> void:
	if grid_pos.y > 0:
		grid_pos.y -= 1
		update_background()

func _on_backward_button_pressed() -> void:
	if grid_pos.y < 1:
		grid_pos.y += 1
		update_background()

func _on_turn_left_button_pressed() -> void:
	if grid_pos.x > 0:
		grid_pos.x -= 1
		update_background()

func _on_turn_right_button_pressed() -> void:
	if grid_pos.x < 1:
		grid_pos.x += 1
		update_background()
