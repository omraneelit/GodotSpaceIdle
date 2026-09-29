extends SceneTree

func _init():
    print("\n=============================================")
    print("🚀 STARTING GODOT HEADLESS UNIT TESTS 🚀")
    print("=============================================\n")
    
    var tests_passed = 0
    var tests_failed = 0
    
    # ---------------------------------------------------------
    # TEST 1: GameManager Economy Math
    # ---------------------------------------------------------
    var gm = load("res://game_manager.gd").new()
    gm.money = 100
    var spend_success = gm.spend_money(50)
    var spend_fail = gm.spend_money(100) # Only 50 left
    
    if spend_success and not spend_fail and gm.money == 50:
        print("[PASS] GameManager economy logic")
        tests_passed += 1
    else:
        print("[FAIL] GameManager economy logic")
        tests_failed += 1
        
    # ---------------------------------------------------------
    # TEST 2: Rebirth System Multipliers
    # ---------------------------------------------------------
    var rm = load("res://rebirth_manager.gd").new()
    rm.rebirth_count = 2
    rm.update_multiplier()
    
    if rm.money_multiplier == 2.0: # Base 1.0 + (2 * 0.5)
        print("[PASS] RebirthManager calculates multiplier correctly")
        tests_passed += 1
    else:
        print("[FAIL] RebirthManager multiplier scaling")
        tests_failed += 1
        
    # ---------------------------------------------------------
    # TEST 3: Phase Manager Boundaries
    # ---------------------------------------------------------
    var pm = load("res://phase_manager.gd").new()
    pm.current_phase = 3 # The max phase (Phase 4)
    
    # We mock SaveManager so it doesn't crash trying to save to disk in a raw test
    var dummy_save = Node.new()
    dummy_save.name = "SaveManager"
    dummy_save.set_script(load("res://save_manager.gd"))
    root.add_child(dummy_save)
    
    pm.unlock_next_phase()
    
    if pm.current_phase == 3: # Should not go to 4
        print("[PASS] PhaseManager respects max phase limit")
        tests_passed += 1
    else:
        print("[FAIL] PhaseManager respects max phase limit (Went to " + str(pm.current_phase) + ")")
        tests_failed += 1

    print("\n=============================================")
    print("RESULTS: ", tests_passed, " PASSED | ", tests_failed, " FAILED")
    print("=============================================\n")
    
    if tests_failed > 0:
        quit(1)
    else:
        quit(0)
