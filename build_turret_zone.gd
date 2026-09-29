extends Area3D

@export var cost: int = 300
var timer = 0.0

func _process(delta):
    var bodies = get_overlapping_bodies()
    for body in bodies:
        if body.name == "Player":
            if cost > 0:
                timer += delta
                if timer > 0.05:
                    if GameManager.spend_money(10):
                        cost -= 10
                        timer = 0.0
                        GameManager.spawn_floating_text(global_position + Vector3(randomf_range(-1,1), 2, randomf_range(-1,1)), "-$10", Color.RED)
                        
                        if cost <= 0:
                            build_turret()

func build_turret():
    GameManager.spawn_floating_text(global_position + Vector3(0, 3, 0), "TURRET ONLINE!", Color.CYAN)
    ParticleManager.spawn_poof(global_position, Color.CYAN)
    
    var turret = load("res://turret.gd").new()
    turret.add_to_group("turrets")
    turret.position = global_position
    get_parent().add_child(turret)
    
    queue_free()
