extends Panel

var leaf_count = 0

func _ready():
	set_process(true)

func _process(delta):
	leaf_count = get_tree().get_nodes_in_group("leaf").size()
	var text = "Leaf Count: " + str(leaf_count)
	get_node("CenterContainer/Label").set_text(text)

