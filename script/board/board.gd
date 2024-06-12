class_name Board
extends Control

signal size_changed

var prev_size: Vector2
@onready var grid: Grid = $GridMargin/Grid

func _ready():
	size_changed.connect(_on_size_changed)
	
func _process(delta):
	if prev_size != get_viewport_rect().size:
		size_changed.emit(get_viewport_rect().size)
		prev_size = get_viewport_rect().size
	
func _on_size_changed(size: Vector2):
	var ratio = size / grid.get_rect().size
	grid.scale = grid.scale * Vector2([ratio.x, ratio.y].min(), [ratio.x, ratio.y].min())
