extends Node

var left
var right
var up
var down

var movement_intentions = Vector2()

func _ready():
	set_process_unhandled_input(true)

func _unhandled_input(event):
	var interesting = false
	
	if event.is_action_pressed("ui_left"):
		get_tree().set_input_as_handled()
		left = true
		interesting = true
	
	if event.is_action_pressed("ui_right"):
		get_tree().set_input_as_handled()
		right = true
		interesting = true
	
	if event.is_action_released("ui_left"):
		get_tree().set_input_as_handled()
		left = false
		interesting = true
	
	if event.is_action_released("ui_right"):
		get_tree().set_input_as_handled()
		right = false
		interesting = true
	
	if event.is_action_pressed("ui_up"):
		get_tree().set_input_as_handled()
		up = true
		interesting = true
	
	if event.is_action_pressed("ui_down"):
		get_tree().set_input_as_handled()
		down = true
		interesting = true
	
	if event.is_action_released("ui_up"):
		get_tree().set_input_as_handled()
		up = false
		interesting = true
	
	if event.is_action_released("ui_down"):
		get_tree().set_input_as_handled()
		down = false
		interesting = true
	
	if interesting:
		movement_intentions = Vector2()
		if left:
			movement_intentions.x -= 1
		if right:
			movement_intentions.x += 1
		if up:
			movement_intentions.y -= 1
		if down:
			movement_intentions.y += 1


func get_movement_intentions():
	return movement_intentions
