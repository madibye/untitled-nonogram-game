class_name Board
extends Control

var prev_size: Vector2
@export var rows: int
@export var columns: int
@onready var grid: Grid
@onready var health_bar: HealthBar = $HealthBar

func _ready():
	grid = Grid.new_grid(rows, columns)
	add_child(grid)
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
	
func _on_damage_taken(amt: int):
	health_bar.update_hp(health_bar.hp - amt)
	if health_bar.hp == 0:
		Signals.finished.emit()
		var finish = Resources.finish_scene.instantiate() as FinishScreen
		finish.set_label_text("[center]you died lmao[/center]")
		add_child(finish)
		await get_tree().process_frame
		get_tree().create_tween().tween_property(finish, "modulate", Color("ffffffff"), 0.6)

static func new_board(rows: int, columns: int) -> Board:
	var board: Board = Resources.board_scene.instantiate()
	board.rows = rows
	board.columns = columns
	return board
