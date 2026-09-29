extends Node

var save_path = "user://space_idle_save.cfg"

func save_game(money: int, phase: int):
    var config = ConfigFile.new()
    config.set_value("Player", "money", money)
    config.set_value("Progression", "phase", phase)
    
    # Save Bots
    var bots = get_tree().get_nodes_in_group("bots")
    var bot_positions = []
    for b in bots:
        bot_positions.append(b.global_position)
    config.set_value("World", "bots", bot_positions)
    
    # Save Turrets
    var turrets = get_tree().get_nodes_in_group("turrets")
    var turret_positions = []
    for t in turrets:
        turret_positions.append(t.global_position)
    config.set_value("World", "turrets", turret_positions)
    
    config.save(save_path)
    print("Game Saved! Phase: ", phase, " Money: $", money, " Bots: ", bots.size(), " Turrets: ", turrets.size())

func load_game() -> Dictionary:
    var config = ConfigFile.new()
    var err = config.load(save_path)
    if err != OK:
        return {"money": 0, "phase": 0, "bots": [], "turrets": []}
    
    var m = config.get_value("Player", "money", 0)
    var p = config.get_value("Progression", "phase", 0)
    var b = config.get_value("World", "bots", [])
    var t = config.get_value("World", "turrets", [])
    
    return {"money": m, "phase": p, "bots": b, "turrets": t}

func restore_base():
    var data = load_game()
    var root = get_tree().get_root()
    
    # Restore Bots
    for pos in data["bots"]:
        var bot = CharacterBody3D.new()
        bot.add_to_group("bots")
        bot.position = pos
        # (Simplified bot setup for loading)
        var mesh = CSGBox3D.new()
        mesh.size = Vector3(0.6, 1.0, 0.6)
        var mat = StandardMaterial3D.new()
        mat.albedo_color = Color.CYAN
        mesh.material = mat
        bot.add_child(mesh)
        var ai = Node3D.new()
        ai.set_script(load("res://bot_ai.gd"))
        bot.add_child(ai)
        root.add_child(bot)
        
    # Restore Turrets
    for pos in data["turrets"]:
        var turret = load("res://turret.gd").new()
        turret.add_to_group("turrets")
        turret.position = pos
        root.add_child(turret)
