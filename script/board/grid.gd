class_name Grid
extends GridContainer

@onready var squares: Array[Square] = []
@export var rows: int
@export var cols: int
@onready var row_numbers = []
@onready var col_numbers = []

func _ready():
	populate_squares()

func populate_squares(r = rows, c = cols):
	while squares.size() < (rows*cols):
		squares.append(make_square())
	for s in squares:
		add_child(s)
	set_grid_size(r, c)
	
	row_numbers = range(rows).map(generate_row_numbers.bind('y'))
	col_numbers = range(cols).map(generate_row_numbers)
	
	print(row_numbers)
	print(col_numbers)
		
func make_square() -> Square:
	var sq = preload("res://scene/square.tscn").instantiate() as Square
	sq.set_pos(squares.size() % 10, floor(squares.size() / 10))
	return sq

func set_grid_size(r, c) -> void:
	rows = r
	cols = c
	set_columns(cols)
	
func generate_row_numbers(row, pos_identifier: String = 'x'):
	var relevant_squares = squares.filter(
		func(sq: Square): return sq.get('%s_pos' % pos_identifier) == row)
	var rn = []
	var last_was_filled = false
	for sq in relevant_squares:
		if not sq.is_filled:
			last_was_filled = false
			continue
		if last_was_filled: rn[-1] += 1
		else: rn.push_back(1)
		last_was_filled = true
	if not rn:
		rn.push_back(0)
	return rn
