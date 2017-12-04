extends Panel

func _ready():
	get_node("Button").connect("pressed", self, "start")


func start():
	get_tree().change_scene("res://game.tscn")


