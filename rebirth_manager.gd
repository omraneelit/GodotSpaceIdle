extends Node

var rebirth_count: int = 0
var money_multiplier: float = 1.0

func _ready():
    call_deferred("load_rebirth_data")

func load_rebirth_data():
    var config = ConfigFile.new()
    var err = config.load(SaveManager.save_path)
    if err == OK:
        rebirth_count = config.get_value("Progression", "rebirths", 0)
        
    update_multiplier()

func update_multiplier():
    # Every rebirth adds +50% value to all items!
    money_multiplier = 1.0 + (rebirth_count * 0.5)

func do_rebirth():
    rebirth_count += 1
    update_multiplier()
    
    # Wipe the world data but keep the rebirth count
    GameManager.money = 0
    PhaseManager.current_phase = 0
    
    var config = ConfigFile.new()
    config.set_value("Player", "money", 0)
    config.set_value("Progression", "phase", 0)
    config.set_value("Progression", "rebirths", rebirth_count)
    config.set_value("World", "bots", [])
    config.set_value("World", "turrets", [])
    config.save(SaveManager.save_path)
    
    print("REBIRTH ACHIEVED! New Multiplier: ", money_multiplier, "x")
    
    # Reload the entire game scene
    get_tree().reload_current_scene()
