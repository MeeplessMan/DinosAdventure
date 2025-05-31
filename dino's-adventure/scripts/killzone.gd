extends Area2D

var time_path
@onready var timer: Timer = $Timer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var time
signal set_time(value:float)

func _ready():
	set_time_path()
	set_time.connect(change_time)

func set_time_path()->void:
	var parent = get_parent().name
	if parent == "Level1":
		time_path = "res://lvl/lvl1.cfg"
	elif parent == "Level2":
		time_path = "res://lvl/lvl2.cfg"

func save_temp_time()->void:
	var parent = get_parent().name
	if parent != "Game":
		var time_config = ConfigFile.new()
		var err = await time_config.load(time_path)
		if parent == "Level1":
			time_config.set_value("level1","temptime",time)
		elif parent == "Level2":
			time_config.set_value("level2","temptime",time)
		time_config.save(time_path)
func change_time(value:float)->void:
	time = value
func _on_body_entered(body: Node2D) -> void:
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	save_temp_time()
	collision_shape_2d.queue_free()
	timer.start()

func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
