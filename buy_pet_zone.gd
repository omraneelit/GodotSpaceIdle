extends Area3D

@export var cost: int = 1500
var timer = 0.0

func _process(delta):
    var bodies = get_overlapping_bodies()
    for body in bodies:
        if body.name == "Player":
            if cost > 0:
                timer += delta
                if timer > 0.05:
                    if GameManager.spend_money(25):
                        cost -= 25
                        timer = 0.0
                        GameManager.spawn_floating_text(global_position + Vector3(randomf_range(-1,1), 2, randomf_range(-1,1)), "-$25", Color.RED)
                        
                        if cost <= 0:
                            buy_pet()

func buy_pet():
    GameManager.spawn_floating_text(global_position + Vector3(0, 3, 0), "PET ADOPTED!", Color.HOT_PINK)
    ParticleManager.spawn_poof(global_position, Color.HOT_PINK)
    
    var pet = load("res://pet.gd").new()
    pet.position = global_position
    get_parent().add_child(pet)
    
    queue_free()
