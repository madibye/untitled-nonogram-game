class_name Board
extends Control

var prev_size: Vector2
@export var rows: int
@export var columns: int
@onready var game: Game
@onready var grid: Grid
@onready var health_bar: HealthBar

static func new_board(g: Game, r: int, c: int, hp: int) -> Board:
	var board: Board = Resources.board_scene.instantiate()
	board.game = g
	board.rows = r
	board.columns = c
	board.grid = Grid.new_grid(board, r, c)
	board.health_bar = HealthBar.new_health_bar(board, hp)
	return board

func _ready():
	Signals.size_changed.connect(_on_size_changed)
	Signals.damage_taken.connect(_on_damage_taken)
	
func _process(_delta):
	var new_size = get_viewport_rect().size
	if prev_size != new_size:
		prev_size = new_size
		Signals.size_changed.emit(new_size)
	
func _on_size_changed(new_size: Vector2):
	var ratio = new_size / grid.get_rect().size
	grid.scale = grid.scale * Vector2([ratio.x, ratio.y].min(), [ratio.x, ratio.y].min())
	var pos_sq: VOSquare = grid.get_child(grid.columns * (grid.max_cn - 1) + (grid.max_rn - 2))
	health_bar.set_global_position(grid.get_child(grid.columns * (grid.max_cn - 1) + (grid.max_rn - 2)).global_position)
	health_bar.scale = health_bar.def_scale * (Vector2(pos_sq.get_global_transform().x.x, pos_sq.get_global_transform().y.y) / 3)
	
func _on_damage_taken(amt: int):
	health_bar.update_hp(health_bar.hp - amt)
	if health_bar.hp == 0: finish("you died lmao")

func finish(text):
	Signals.finished.emit()
	FinishScreen.new_finish_screen(self, text)
