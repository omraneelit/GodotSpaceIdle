extends Node

func _ready():
    print("\n=============================================")
    print("🚀 RUNNING GODOT INTEGRATION TESTS 🚀")
    print("=============================================\n")
    
    var passed = 0
    var failed = 0
    
    # ---------------------------------------------------------
    # TEST 1: GameManager Economy Math
    # ---------------------------------------------------------
    GameManager.money = 100
    var spend_success = GameManager.spend_money(50)
    var spend_fail = GameManager.spend_money(100)
    
    if spend_success and not spend_fail and GameManager.money == 50:
        print("[PASS] GameManager economy logic")
        passed += 1
    else:
        print("[FAIL] GameManager economy logic")
        failed += 1
        
    # ---------------------------------------------------------
    # TEST 2: Rebirth System Multipliers
    # ---------------------------------------------------------
    RebirthManager.rebirth_count = 2
    RebirthManager.update_multiplier()
    
    if RebirthManager.money_multiplier == 2.0: # Base 1.0 + (2 * 0.5)
        print("[PASS] RebirthManager calculates multiplier correctly")
        passed += 1
    else:
        print("[FAIL] RebirthManager multiplier scaling")
        failed += 1
        
    # ---------------------------------------------------------
    # TEST 3: Phase Manager Boundaries
    # ---------------------------------------------------------
    PhaseManager.current_phase = 3 # The max phase
    PhaseManager.unlock_next_phase()
    
    if PhaseManager.current_phase == 3: # Should not go to 4
        print("[PASS] PhaseManager respects max phase limit")
        passed += 1
    else:
        print("[FAIL] PhaseManager respects max phase limit")
        failed += 1

    print("\n=============================================")
    print("RESULTS: ", passed, " PASSED | ", failed, " FAILED")
    print("=============================================\n")
    
    if failed > 0:
        get_tree().quit(1)
    else:
        get_tree().quit(0)
