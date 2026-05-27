extends Control

@export var levels: Array[String] = [
	"level 1",
	"level 2",
	"level 3",
	"level 4",
	"level 5",
	"level 6",
	"level 7",
	"level 8",
	"level 9",
	"level ?",
	"level ??",
	"level ???",
]

func _ready() -> void:
	
	var idx: int = 0
	for i in get_children():
		if !i.has_connections("button_down"):
			i.connect("button_down", Select.open_level)
		i.gui_input.connect(Select.get_level_info.bind(idx))
		i.visible = levels[idx][0] != "l"
		idx += 1
	
