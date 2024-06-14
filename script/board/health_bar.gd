class_name HealthBar
extends Control

@export var max_hp: int = 5
@export var hp: int = 5
@onready var hp_value_100_scale: float

func _ready():
	hp_value_100_scale = $HealthBarHPValue.scale.x
	Signals.finished.connect(_on_finish)

func update_hp(new_hp: int) -> void:
	hp = new_hp
	get_tree().create_tween().tween_property(
		$HealthBarHPValue, "scale", Vector2(hp_value_100_scale * (float(hp)/float(max_hp)), 1), 0.6
	).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	
func _on_finish() -> void:
	get_tree().create_tween().tween_property(self, "modulate", Color("ffffff6b"), 0.6) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
