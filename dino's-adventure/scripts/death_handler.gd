class_name DeathHandler
extends Node2D

@export var parent:Node2D = null

signal handle_death

func _ready():
	handle_death.connect(on_handle_death)

func on_handle_death() -> void:
	if parent.name=="Player":
		Engine.time_scale = 0.5
		parent.get_node("CollisionShape2D").queue_free()
		parent.get_node("HitBox").queue_free()
		var timer:Timer = Timer.new()
		add_child(timer)
		timer.one_shot = true
		timer.autostart = false
		timer.wait_time = 0.6
		timer.timeout.connect(_timer_Timeout)
		timer.start()
	else:
		return

func _timer_Timeout():
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
