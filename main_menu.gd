extends Panel

func _ready():
	get_node("Button").connect("pressed", self, "start")
	set_process_unhandled_input(true)


func start():
	get_tree().change_scene("res://game.tscn")

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		get_tree().quit()

