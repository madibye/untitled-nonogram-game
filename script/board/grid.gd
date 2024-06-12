class_name Grid
extends GridContainer

const SquareState = Square.SquareState

@onready var squares: Array[Square] = []
@export var rows: int
@export var cols: int
@onready var row_numbers = []
@onready var col_numbers = []

func _ready():
	populate_squares()

func populate_squares(r = rows, c = cols):
	set_grid_size(r, c)
	while squares.size() < (rows*cols):
		squares.append(make_square())
	
	row_numbers = range(rows).map(generate_row_numbers.bind('y'))
	col_numbers = range(cols).map(generate_row_numbers)
	var max_rn = row_numbers.map(func(rn): return rn.size()).max()
	var max_cn = col_numbers.map(func(rn): return rn.size()).max()
	var adjusted_rows = rows + max_cn
	set_columns(columns + max_rn)
	print(max_rn)
	print(max_cn)
	print(adjusted_rows)
	print(columns)
	
	for i in range(adjusted_rows * columns):
		var pos = Vector2((i % columns) - max_rn, floor(i / (columns)) - max_cn)
		var sq = preload("res://scene/square.tscn").instantiate() as Square
		sq.set_sq_state(SquareState.BLANK)
		sq.set_pos(pos.x, pos.y)
		var filtered = flatten_array([squares, row_numbers, col_numbers]).filter(func(s): return Vector2(s.x_pos, s.y_pos) == pos)
		if filtered:
			sq = filtered[0]
		if sq.get_parent():
			sq.get_parent().remove_child(sq)
		add_child(sq)
	return
	
func make_square() -> Square:
	var sq = preload("res://scene/square.tscn").instantiate() as Square
	sq.set_pos(squares.size() % cols, floor(squares.size() / cols))
	print(squares.size() % cols, floor(squares.size() / cols))
	return sq

func set_grid_size(r, c) -> void:
	rows = r
	cols = c
	set_columns(c)
	
func generate_row_numbers(row, pos_identifier: String = 'x') -> Array:
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
	var side_facing = pos_identifier.contains('y')
	var enum_offset = 4 if side_facing else 0
	var opposite_letter = 'x' if side_facing else 'y'
	var rn_squares = rn.map(func(r): 
		var sq: Square = preload("res://scene/square.tscn").instantiate() as Square
		sq.set_sq_state(SquareState.BLUE_LINES + enum_offset)
		sq.set_label_text("[center][color=#000000]%s[/color][/center]" % r)
		sq.set('%s_pos' % pos_identifier, row)
		return sq
	)
	rn_squares[0].set_sq_state(SquareState.FADING_BLUE_LINES + enum_offset)
	rn_squares[-1].set_sq_state((SquareState.BOTTOM_FADING_BLUE_LINES if rn_squares.size() == 1 else \
								 SquareState.BOTTOM_BLUE_LINES) + enum_offset)
	for i in range(rn_squares.size()):
		rn_squares[i].set('%s_pos' % opposite_letter, i - rn_squares.size())
	return rn_squares
	
func find_square_from_pos(list, pos):
	return list.filter(func(i): return Vector2(i.x_pos, i.y_pos) == pos)

func flatten_array(list) -> Array:
	var ret_list = []
	for i in list:
		if i is Array:
			ret_list.append_array(flatten_array(i))
		else:
			ret_list.append(i)
	return ret_list
