class_name Grid
extends GridContainer

const SquareState = Square.SquareState

@onready var squares: Array[Square] = []
@export var sq_rows: int
@export var sq_cols: int
@onready var row_numbers = []
@onready var col_numbers = []
@onready var rows: int

func _ready():
	populate_squares()
	await get_tree().process_frame
	pivot_offset = get_rect().size / 2

func populate_squares(r = sq_rows, c = sq_cols):
	set_grid_size(r, c)
	while squares.size() < (sq_rows*sq_cols):
		squares.append(make_square())
	
	row_numbers = range(sq_rows).map(generate_row_numbers.bind('y'))
	col_numbers = range(sq_cols).map(generate_row_numbers)
	var max_rn = row_numbers.map(func(rn): return rn.size()).max()
	var max_cn = col_numbers.map(func(rn): return rn.size()).max()
	rows = sq_rows + max_cn
	set_columns(columns + max_rn)
	
	for i in range(rows * columns):
		var pos = Vector2((i % columns) - max_rn, floor(float(i) / float(columns)) - max_cn)
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
	sq.set_pos(squares.size() % sq_cols, floor(float(squares.size()) / float(sq_cols)))
	return sq

func set_grid_size(r, c) -> void:
	sq_rows = r
	sq_cols = c
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

