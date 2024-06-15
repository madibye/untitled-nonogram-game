class_name HealthBar
extends Control

@export var max_hp: int = 5
@export var hp: int = 5
@onready var hpvfs: float
@onready var hp_value: Sprite2D = $HealthBarHPValue

static func new_health_bar(board: Board, max_hp: int):
	var health_bar: HealthBar = Resources.health_bar_scene.instantiate() as HealthBar
	health_bar.max_hp = max_hp
	health_bar.hp = max_hp
	board.add_child(health_bar)
	return health_bar

func _ready():
	hpvfs = hp_value.scale.x
	Signals.finished.connect(_on_finish)
	
func get_hp_ratio() -> float:
	return float(hp)/float(max_hp)

func update_hp(new_hp: int) -> void:
	hp = new_hp
	get_tree().create_tween().tween_property(
		hp_value, "scale:x", hpvfs * get_hp_ratio(), 0.6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	
func _on_finish() -> void:
	get_tree().create_tween().tween_property(self, "modulate", Color("ffffff6b"), 0.6) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
