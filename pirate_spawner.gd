extends Node

var timer = 0.0
var spawn_interval = 25.0 # Spawns every 25 seconds
var spawn_count = 0

func _process(delta):
    timer += delta
    if timer > spawn_interval:
        spawn_count += 1
        if spawn_count % 3 == 0:
            spawn_boss()
        else:
            spawn_pirate()
        timer = 0.0
        
func spawn_boss():
    var boss = load("res://boss_pirate.gd").new()
    boss.position = Vector3(randf_range(-20, 20), 2.0, randf_range(30, 40))
    get_tree().get_root().add_child(boss)
    GameManager.spawn_floating_text(boss.position + Vector3(0, 5, 0), "WARNING: BOSS INCOMING!", Color.DARK_RED)
    
func spawn_pirate():
    var pirate = load("res://pirate.gd").new()
    pirate.position = Vector3(randf_range(-20, 20), 1.5, randf_range(20, 30))
    get_tree().get_root().add_child(pirate)
    GameManager.spawn_floating_text(pirate.position + Vector3(0, 4, 0), "PIRATE ATTACK!", Color.RED)
