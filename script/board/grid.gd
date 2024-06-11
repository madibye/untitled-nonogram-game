class_name Grid
extends GridContainer

@onready var squares: Array[Square] = []
@export var rows: int
@export var cols: int

func _ready():
	populate_squares()

func populate_squares(r = rows, c = cols):
	set_grid_size(r, c)
	while squares.size() < (rows*cols):
		squares.append(make_square())
		
func make_square() -> Square:
	var sq = preload("res://scene/square.tscn").instantiate() as Square
	sq.set_pos(squares.size() % 10, floor(squares.size() / 10))
	add_child(sq)
	return sq

func set_grid_size(r, c) -> void:
	rows = r
	cols = c
	set_columns(cols)
