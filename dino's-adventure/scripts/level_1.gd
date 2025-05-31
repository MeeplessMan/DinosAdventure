extends Node2D

@export var killzone: Area2D = null
@export var player: CharacterBody2D = null
@export var hud: CanvasLayer = null
var save_path = "res://lvl/lvl1.cfg"
var config =ConfigFile.new()
var err = config.load(save_path)
var time = float(config.get_value("level1","temptime"))

func _ready():
	time = float(config.get_value("level1","temptime"))
	
func time_to_string(time:float)->String:
	var msec=fmod(time,1)*1000
	var sec = fmod(time,60)
	var min = time/60
	var format_string="%02d : %02d : %02d"
	var actual_string = format_string % [min,sec,msec]
	return actual_string
	
func _process(delta: float) -> void:
	time+=delta
	hud.set_time.emit(time_to_string(time))
	player.set_time.emit(time)
	killzone.set_time.emit(time)
