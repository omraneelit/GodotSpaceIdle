extends Area3D

@export var cost: int = 200
@export var source_zone_path: NodePath
@export var dest_zone_path: NodePath

var timer: float = 0.0

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
                            hire_bot()

func hire_bot():
    GameManager.spawn_floating_text(global_position + Vector3(0, 3, 0), "BOT HIRED!", Color.CYAN)
    
    # Generate the Bot procedurally!
    var bot = CharacterBody3D.new()
    bot.name = "WorkerBot"
    bot.add_to_group("bots")
    bot.position = global_position
    
    # Mesh
    var mesh = CSGBox3D.new()
    mesh.size = Vector3(0.6, 1.0, 0.6)
    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color.CYAN
    mesh.material = mat
    bot.add_child(mesh)
    
    # Squash & Stretch Animation
    var anim = Node3D.new()
    anim.set_script(load("res://squash_stretch.gd"))
    bot.add_child(anim)
    mesh.owner = bot # for squash stretch targets
    
    # Stacker
    var stacker = Node3D.new()
    stacker.name = "ItemStacker"
    stacker.position = Vector3(0, 0.5, -0.4)
    stacker.set_script(load("res://item_stacker.gd"))
    bot.add_child(stacker)
    
    # Bot AI
    var ai = Node3D.new()
    ai.set_script(load("res://bot_ai.gd"))
    if has_node(source_zone_path):
        ai.set("source_zone", get_node(source_zone_path))
    if has_node(dest_zone_path):
        ai.set("dest_zone", get_node(dest_zone_path))
    bot.add_child(ai)
    
    # Add to the world
    get_parent().add_child(bot)
    
    # Destroy the hire zone
    queue_free()
