extends Panel

signal lose_game

var leaf_count = 0
var lose_count = 40
var lost = false
var quit_count = 250

func _ready():
	set_process(true)

func _process(delta):
	leaf_count = get_tree().get_nodes_in_group("leaf").size()
	var text = "Leaf Count: %s / %s" % [str(leaf_count), str(lose_count)]
	get_node("CenterContainer/Label").set_text(text)
	
	if leaf_count > lose_count and not lost:
		emit_signal("lose_game")
		lost = true
	
	if leaf_count > quit_count:
		get_tree().change_scene("res://game.tscn")

func get_leaf_count():
	return leaf_count
