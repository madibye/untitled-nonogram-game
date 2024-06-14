class_name Board
extends Control

var prev_size: Vector2
@export var rows: int
@export var columns: int
@onready var grid: Grid

func _ready():
	grid = Grid.new_grid(rows, columns)
	add_child(grid)
	Signals.size_changed.connect(_on_size_changed)
	
func _process(_delta):
	var new_size = get_viewport_rect().size
	if prev_size != new_size:
		prev_size = new_size
		Signals.size_changed.emit(new_size)
	
func _on_size_changed(new_size: Vector2):
	var ratio = new_size / grid.get_rect().size
	grid.scale = grid.scale * Vector2([ratio.x, ratio.y].min(), [ratio.x, ratio.y].min())

static func new_board(rows: int, columns: int) -> Board:
	var board: Board = Resources.board_scene.instantiate()
	board.rows = rows
	board.columns = columns
	return board
