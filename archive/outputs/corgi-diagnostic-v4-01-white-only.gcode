; HEADER_BLOCK_START
; BambuStudio 02.08.02.61
; model printing time: 9m 54s; total estimated time: 16m 51s
; total layer number: 7
; total filament length [mm] : 326.91
; total filament volume [cm^3] : 786.30
; total filament weight [g] : 0.99
; model label id: 5887,5909
; object max height: 0.70,0.70
; filament_density: 1.26,1.26,1.27,1.27,1.26,1.26,1.26,1.25
; filament_diameter: 1.75,1.75,1.75,1.75,1.75,1.75,1.75,1.75
; max_z_height: 0.70
; filament: 1
; support_material_on_wipe_tower: 0
; HEADER_BLOCK_END

; CONFIG_BLOCK_START
; accel_to_decel_enable = 0
; accel_to_decel_factor = 50%
; activate_air_filtration = 0,0,0,0,0,0,0,0
; additional_cooling_fan_speed = 75,75,75,75,75,75,75,70
; additional_fan_full_speed_layer = 0,0,0,0,0,0,0,0
; alternate_extra_wall = 0
; ams_filament_load_time_ams = 0
; ams_filament_load_time_ams_lite = 0
; ams_filament_load_time_n3f_s = 0
; ams_filament_unload_time_ams = 0
; ams_filament_unload_time_ams_lite = 0
; ams_filament_unload_time_n3f_s = 0
; apply_scarf_seam_on_circles = 1
; auxiliary_fan = 1
; avoid_crossing_wall_includes_support = 0
; bed_custom_model = 
; bed_custom_texture = 
; bed_exclude_area = 
; bed_heat_soak_area = 
; bed_temperature_formula = by_highest_temp
; before_layer_change_gcode = 
; best_object_pos = 0.3,0.5
; bottom_color_penetration_layers = 5
; bottom_shell_layers = 5
; bottom_shell_thickness = 0
; bottom_surface_density = 100%
; bottom_surface_pattern = monotonic
; bridge_angle = 0
; bridge_flow = 1
; bridge_no_support = 0
; bridge_speed = 50,50
; brim_object_gap = 0.1
; brim_type = auto_brim
; brim_width = 5
; chamber_temperatures = 0,0,0,0,0,0,0,0
; change_filament_gcode = ;======== H2D ========\n;===== 20260528 =====\nM993 A2 B2 C2 ; nozzle cam detection allow status save.\nM993 A0 B0 C0 ; nozzle cam detection not allowed.\n\n{if (filament_type[next_filament_id] == \"PLA\") ||  (filament_type[next_filament_id] == \"PETG\")\n ||  (filament_type[next_filament_id] == \"PLA-CF\")  ||  (filament_type[next_filament_id] == \"PETG-CF\")}\nM1015.4 S1 K0 ;disable E air printing detect\n{else}\nM1015.4 S0 ; disable E air printing detect\n{endif}\n\nM620 S[next_filament_id]A H[next_hotend]\nM1002 gcode_claim_action : 4\nM204 S9000\n\nG1 Z{max_layer_z + 3.0} F1200\n\nM400\nM106 P1 S0\nM106 P2 S0\n\n{if toolchange_count == 2}\n; get travel path for change filament\n;M620.1 X[travel_point_1_x] Y[travel_point_1_y] F21000 P0\n;M620.1 X[travel_point_2_x] Y[travel_point_2_y] F21000 P1\n;M620.1 X[travel_point_3_x] Y[travel_point_3_y] F21000 P2\n{endif}\n\n{if ((filament_type[current_filament_id] == \"PLA\") || (filament_type[current_filament_id] == \"PLA-CF\") || (filament_type[current_filament_id] == \"PETG\")) && (nozzle_diameter_at_nozzle_id[current_nozzle_id] == 0.2)}\nM620.10 A0 F74.8347 L[flush_length] H{nozzle_diameter_at_nozzle_id[current_nozzle_id]} T{flush_temperatures[current_filament_id]} P[old_filament_temp] S1\n{else}\nM620.10 A0 F{flush_volumetric_speeds[current_filament_id]/2.4053*60*0.8} L[flush_length] H{nozzle_diameter_at_nozzle_id[current_nozzle_id]} T{flush_temperatures[current_filament_id]} P[old_filament_temp] S1\n{endif}\n\n{if ((filament_type[next_filament_id] == \"PLA\") || (filament_type[next_filament_id] == \"PLA-CF\") || (filament_type[next_filament_id] == \"PETG\")) && (nozzle_diameter_at_nozzle_id[next_nozzle_id] == 0.2)}\nM620.10 A1 F74.8347 L[flush_length] H{nozzle_diameter_at_nozzle_id[next_nozzle_id]} T{flush_temperatures[next_filament_id]} P[new_filament_temp] S1\n{else}\nM620.10 A1 F{flush_volumetric_speeds[next_filament_id]/2.4053*60*0.8} L[flush_length] H{nozzle_diameter_at_nozzle_id[next_nozzle_id]} T{flush_temperatures[next_filament_id]} P[new_filament_temp] S1\n{endif}\n\n{if long_retraction_when_cut}\nM620.11 P1 I[current_filament_id] B[current_hotend] E-{retraction_distance_when_cut} F{max((flush_volumetric_speeds[current_filament_id]/2.4053*60), 200)}\n{else}\nM620.11 P0 I[current_filament_id] B[current_hotend] E0\n{endif}\n\n{if long_retraction_when_ec}\nM620.11 K1 I[current_filament_id] B[current_hotend] R{retraction_distance_when_ec} F{max((flush_volumetric_speeds[current_filament_id]/2.4053*60), 200)}\n{else}\nM620.11 K0 I[current_filament_id] B[current_hotend] R0\n{endif}\n\nM620.15 C{new_filament_temp - filament_cooling_before_tower[next_filament_id]}\n\nM628 S1\n{if filament_type[current_filament_id] == \"TPU\"}\nM620.11 S0 L0 I[current_filament_id] B[current_hotend] E-{retraction_distances_when_cut[current_filament_id]} F{max((flush_volumetric_speeds[current_filament_id]/2.4053*60), 200)}\n{else}\n{if (filament_type[current_filament_id] == \"PA\") || (filament_type[current_filament_id] == \"PA-GF\")}\nM620.11 S1 L0 I[current_filament_id] B[current_hotend] R4 D2 E-{retraction_distances_when_cut[current_filament_id]} F{max((flush_volumetric_speeds[current_filament_id]/2.4053*60), 200)}\n{else}\nM620.11 S1 L0 I[current_filament_id] B[current_hotend] R10 D8 E-{retraction_distances_when_cut[current_filament_id]} F{max((flush_volumetric_speeds[current_filament_id]/2.4053*60), 200)}\n{endif}\n{endif}\nM629\n\n{if (filament_type[current_filament_id] == \"TPU\") && (filament_map[current_filament_id] == 2) && (nozzle_volume_types[current_nozzle_id] != \"TPU High Flow\")}\nM620.11 H2 C331\n{else}\nM620.11 H0\n{endif}\n\n{if  (nozzle_volume_types[current_nozzle_id] == \"TPU High Flow\") && (filament_map[current_filament_id] == 2) && (filament_map[next_filament_id] == 1)}\n;sw from R2L&TPU kit, travel run a distance for sketch TPU\nG1 X30 Y30 F5000\nM400\nG1 X300 Y30 F5000\nM400\n{endif}\n\nT[next_filament_id] H[next_hotend]\n\n;deretract\n{if filament_type[next_filament_id] == \"TPU\"}\n{else}\n{if (filament_type[next_filament_id] == \"PA\") || (filament_type[next_filament_id] == \"PA-GF\")}\n;VG1 E1 F{max(new_filament_e_feedrate, 200)}\n;VG1 E1 F{max(new_filament_e_feedrate/2, 100)}\n{else}\n;VG1 E4 F{max(new_filament_e_feedrate, 200)}\n;VG1 E4 F{max(new_filament_e_feedrate/2, 100)}\n{endif}\n{endif}\n\n; VFLUSH_START\n\n{if flush_length>41.5}\n;VG1 E41.5 F{min(old_filament_e_feedrate,new_filament_e_feedrate)}\n;VG1 E{flush_length-41.5} F{new_filament_e_feedrate}\n{else}\n;VG1 E{flush_length} F{min(old_filament_e_feedrate,new_filament_e_feedrate)}\n{endif}\n\nSYNC T{ceil(flush_length / 125) * 5}\n\n; compensate for heating and cooling\n{if flush_length > 0}\n{if flush_temperatures[next_filament_id] > new_filament_temp}\nSYNC T{(flush_temperatures[next_filament_id]-(new_filament_temp - filament_cooling_before_tower[next_filament_id]))/hotend_cooling_rate[filament_map[next_filament_id]-1]}\nSYNC T{(flush_temperatures[next_filament_id]-(new_filament_temp - filament_cooling_before_tower[next_filament_id]))/hotend_heating_rate[filament_map[next_filament_id]-1]}\n{else}\nSYNC T{(new_filament_temp - filament_cooling_before_tower[next_filament_id] -flush_temperatures[next_filament_id])/hotend_cooling_rate[filament_map[next_filament_id]-1]}\nSYNC T{(new_filament_temp - filament_cooling_before_tower[next_filament_id] -flush_temperatures[next_filament_id])/hotend_heating_rate[filament_map[next_filament_id]-1]}\n{endif}\n{endif}\n\n\n; VFLUSH_END\n\nM1002 set_filament_type:{filament_type[next_filament_id]}\n\nM400\nM83\n{if next_filament_id < 255}\n\nM620.10 R{new_extruder_retracted_length}\nM628 S0\n;VM109 S[new_filament_temp]\nM629\nM400\n\n;prime_tower_interface\n{if is_prime_tower_interface && filament_tower_interface_purge_volume !=0}\nG150.1\nM620.13 W0 L{filament_tower_interface_purge_volume} T{filament_tower_interface_print_temp} R0.0\n{endif}\n;prime_tower_interface\n\nM983.3 F{filament_max_volumetric_speed[next_filament_id]/2.4} A0.4 R{new_extruder_retracted_length}\n\nM400\n{if wipe_avoid_perimeter}\nG1 Y320 F30000\nG1 X{wipe_avoid_pos_x} F30000\n{endif}\nG1 Y295 F30000\nG1 Y265 F18000\nG1 Z{max_layer_z + 3.0} F3000\n{if layer_z <= (initial_layer_print_height + 0.001)}\nM204 S[initial_layer_acceleration]\n{else}\nM204 S[default_acceleration]\n{endif}\n{else}\nG1 X[x_after_toolchange] Y[y_after_toolchange] Z[z_after_toolchange] F12000\n{endif}\nM621 S[next_filament_id]A\n\nM622.1 S0 ;for prev version, default skip\nM1002 judge_flag powerloss_resume_flag\nM622 J1\nM983.3 F{filament_max_volumetric_speed[next_filament_id]/2.4} A0.4 R{new_extruder_retracted_length}\nM400\n{if wipe_avoid_perimeter}\nG1 Y320 F30000\nG1 X{wipe_avoid_pos_x} F30000\n{endif}\nG1 Y295 F30000\nG1 Y265 F18000\nG1 Z{max_layer_z + 3.0} F3000\n{if layer_z <= (initial_layer_print_height + 0.001)}\nM204 S[initial_layer_acceleration]\n{else}\nM204 S[default_acceleration]\n{endif}\nM1002 set_flag powerloss_resume_flag=0\nM623\n\nM993 A3 B3 C3 ; nozzle cam detection allow status restore.\n\n{if (filament_type[next_filament_id]  == \"TPU\")}\nM1015.3 S1;enable tpu clog detect\n{else}\nM1015.3 S0;disable tpu clog detect\n{endif}\n\n{if (filament_type[next_filament_id] == \"PLA\") ||  (filament_type[next_filament_id] == \"PETG\")\n ||  (filament_type[next_filament_id] == \"PLA-CF\")  ||  (filament_type[next_filament_id] == \"PETG-CF\")}\nM1015.4 S1 K1 H{nozzle_diameter_at_nozzle_id[next_nozzle_id]} ;enable E air printing detect\n{else}\nM1015.4 S0 ; disable E air printing detect\n{endif}\n\nM620.6 I[next_filament_id] H[next_hotend] W1 ;enable ams air printing detect\nM620 Q{toolchange_count + 1}\nM1002 gcode_claim_action : 0\n
; circle_compensation_manual_offset = 0
; circle_compensation_speed = 200,200,200,200,200,200,200,200
; close_additional_fan_first_x_layers = 1,1,1,1,1,1,1,1
; close_fan_the_first_x_layers = 1,1,1,1,1,1,1,1
; complete_print_exhaust_fan_speed = 70,70,70,70,70,70,70,70
; cool_plate_temp = 35,35,35,35,35,35,35,35
; cool_plate_temp_initial_layer = 35,35,35,35,35,35,35,35
; cooling_filter_enabled = 0
; cooling_perimeter_transition_distance = 10,10,10,10,10,10,10,10
; cooling_slowdown_logic = uniform_cooling,uniform_cooling,uniform_cooling,uniform_cooling,uniform_cooling,uniform_cooling,uniform_cooling,uniform_cooling
; counter_coef_1 = 0,0,0,0,0,0,0,0
; counter_coef_2 = 0.0025,0.0025,0.008,0.008,0.0025,0.0025,0.0025,0.008
; counter_coef_3 = 0.014,0.014,-0.041,-0.041,0.014,0.014,0.014,-0.041
; counter_limit_max = 0.076,0.076,0.033,0.033,0.076,0.076,0.076,0.033
; counter_limit_min = 0.014,0.014,-0.035,-0.035,0.014,0.014,0.014,-0.035
; counterbore_hole_bridging = none
; curr_bed_type = Textured PEI Plate
; default_acceleration = 8000,8000
; default_ams_type = -1
; default_filament_colour = ;;;;;;;
; default_filament_profile = "Bambu PLA Basic @BBL H2D 0.2 nozzle"
; default_jerk = 0
; default_nozzle_volume_type = Standard,Standard
; default_print_profile = 0.10mm Standard @BBL H2D 0.2 nozzle
; deretraction_speed = 30,30
; detect_floating_vertical_shell = 1
; detect_narrow_internal_solid_infill = 1
; detect_overhang_wall = 1
; detect_thin_wall = 0
; diameter_limit = 50,50,50,50,50,50,50,50
; different_settings_to_system = enable_arc_fitting;infill_wall_overlap;prime_tower_infill_gap;prime_tower_rib_wall;prime_tower_width;seam_gap;skeleton_infill_density;skin_infill_density;sparse_infill_density;sparse_infill_pattern;wall_generator;filament_prime_volume;filament_prime_volume_nc;filament_prime_volume;filament_prime_volume_nc;filament_prime_volume_nc;filament_prime_volume_nc;filament_prime_volume;filament_prime_volume_nc;filament_prime_volume;filament_prime_volume_nc;filament_prime_volume;filament_prime_volume_nc;nozzle_temperature;filament_prime_volume;filament_prime_volume_nc;
; draft_shield = disabled
; during_print_exhaust_fan_speed = 70,70,70,70,70,70,70,70
; elefant_foot_compensation = 0.15
; embedding_wall_into_infill = 0
; enable_arc_fitting = 0
; enable_circle_compensation = 0
; enable_filament_dynamic_map = 0
; enable_height_slowdown = 0,0
; enable_long_retraction_when_cut = 2
; enable_mixed_color_sublayer = 0
; enable_order_independent_overlap_carving = 0
; enable_overhang_bridge_fan = 1,1,1,1,1,1,1,1
; enable_overhang_speed = 1,1
; enable_pre_heating = 1
; enable_pressure_advance = 0,0,0,0,0,0,0,0
; enable_prime_tower = 0
; enable_support = 0
; enable_support_ironing = 0
; enable_tower_interface_features = 1
; enable_wrapping_detection = 0
; enforce_support_layers = 0
; eng_plate_temp = 55,55,55,55,55,55,55,55
; eng_plate_temp_initial_layer = 55,55,55,55,55,55,55,55
; ensure_vertical_shell_thickness = enabled
; exclude_object = 1
; extruder_ams_count = 1#0|4#1;1#0|4#1
; extruder_clearance_dist_to_rod = 50
; extruder_clearance_height_to_lid = 201
; extruder_clearance_height_to_rod = 47.4
; extruder_clearance_max_radius = 96
; extruder_colour = #018001;#018001
; extruder_max_nozzle_count = 1,1
; extruder_nozzle_stats = Standard#1;Standard#1
; extruder_nozzle_stats_new = Standard#1;Standard#1
; extruder_offset = 0x0,0x0
; extruder_printable_area = 0x0,325x0,325x320,0x320#25x0,350x0,350x320,25x320
; extruder_printable_height = 320,325
; extruder_type = Direct Drive,Direct Drive
; extruder_variant_list = "Direct Drive Standard,Direct Drive High Flow";"Direct Drive Standard,Direct Drive High Flow"
; fan_cooling_layer_time = 100,100,100,100,100,100,100,100
; fan_direction = left
; fan_max_speed = 80,80,100,100,80,80,80,100
; fan_min_speed = 60,60,100,100,60,60,60,100
; farthest_point_timelapse = 1
; filament_adaptive_volumetric_speed = 0,0,0,0,0,0,0,0
; filament_adhesiveness_category = 100,100,100,100,100,100,100,100
; filament_bridge_speed = 25,25,25,25,25,25,25,25
; filament_change_length = 4,4,10,10,4,4,4,4
; filament_change_length_nc = 10,10,10,10,10,10,10,10
; filament_colour = #FFFFFF;#0086D6;#F4A925;#F3CFB2;#222222;#6F5034;#000000;#AA6443
; filament_colour_type = 0;0;0;0;0;0;0;0
; filament_cooling_before_tower = 10,10,10,10,10,10,10,10
; filament_cost = 19.99,19.99,19.99,19.99,19.99,19.99,19.99,21.99
; filament_density = 1.26,1.26,1.27,1.27,1.26,1.26,1.26,1.25
; filament_dev_ams_drying_ams_limitations = 1;0;1;0;1;0;1;0;1;0;1;0;1;0;1;0
; filament_dev_ams_drying_heat_distortion_temperature = 45,45,45,45,45,45,45,45
; filament_dev_ams_drying_temperature = 45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45
; filament_dev_ams_drying_time = 12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12
; filament_dev_chamber_drying_bed_temperature = 70,70,70,70,70,70,70,70
; filament_dev_chamber_drying_time = 12,12,12,12,12,12,12,12
; filament_dev_drying_cooling_temperature = 45,45,45,45,45,45,45,45
; filament_dev_drying_softening_temperature = 50,50,50,50,50,50,50,50
; filament_diameter = 1.75,1.75,1.75,1.75,1.75,1.75,1.75,1.75
; filament_enable_overhang_speed = 1,1,1,1,1,1,1,1
; filament_end_gcode = "; filament end gcode \n";"; filament end gcode \n";"; filament end gcode \n";"; filament end gcode \n";"; filament end gcode \n";"; filament end gcode \n";"; filament end gcode \n";"; filament end gcode \n"
; filament_extruder_compatibility = 0,0,0,0,0,0,0,0
; filament_extruder_variant = "Direct Drive Standard";"Direct Drive Standard";"Direct Drive Standard";"Direct Drive Standard";"Direct Drive Standard";"Direct Drive Standard";"Direct Drive Standard";"Direct Drive Standard"
; filament_flow_ratio = 0.98,0.98,0.98,0.98,0.98,0.98,0.98,0.98
; filament_flush_temp = 0,0,0,0,0,0,0,0
; filament_flush_temp_fast = 0,0,0,0,0,0,0,0
; filament_flush_volumetric_speed = 0,0,0,0,0,0,0,0
; filament_ids = GFA00;GFA00;GFA00;GFA00;GFA00;GFA00;GFA00;GFA00
; filament_is_mixed = 0
; filament_is_support = 0,0,0,0,0,0,0,0
; filament_map = 2,2,2,2,1,1,1,1
; filament_map_2 = 1,1,1,1,0,0,0,0
; filament_map_mode = Manual
; filament_max_volumetric_speed = 2,2,2,2,2,2,2,2
; filament_metal_stickiness = None,None,None,None,None,None,None,None
; filament_minimal_purge_on_wipe_tower = 15,15,15,15,15,15,15,15
; filament_mixed_components = ""
; filament_mixed_gradient = 0
; filament_mixed_gradient_curve = ""
; filament_mixed_gradient_per_part = 0
; filament_mixed_gradient_range = ""
; filament_mixed_sublayer_ratios = ""
; filament_multi_colour = #FFFFFF;#0086D6;#F4A925;#F3CFB2;#222222;#6F5034;#000000;#AA6443
; filament_notes = 
; filament_nozzle_map = 1,1,1,1,0,0,0,0
; filament_overhang_1_4_speed = 0,0,0,0,0,0,0,0
; filament_overhang_2_4_speed = 50,50,50,50,50,50,50,50
; filament_overhang_3_4_speed = 30,30,30,30,30,30,30,30
; filament_overhang_4_4_speed = 10,10,10,10,10,10,10,10
; filament_overhang_totally_speed = 10,10,10,10,10,10,10,10
; filament_pre_cooling_temperature = 0,0,0,0,0,0,0,0
; filament_pre_cooling_temperature_nc = 0,0,0,0,0,0,0,0
; filament_preheat_temperature_delta = 10,10,10,10,10,10,10,10
; filament_prime_volume = 45,45,45,45,45,45,45,45
; filament_prime_volume_nc = 90,90,90,90,90,90,90,90
; filament_printable = 3,3,3,3,3,3,3,3
; filament_ramming_travel_time = 0,0,0,0,0,0,0,0
; filament_ramming_travel_time_nc = 0,0,0,0,0,0,0,0
; filament_ramming_volumetric_speed = -1,-1,-1,-1,-1,-1,-1,-1
; filament_ramming_volumetric_speed_nc = -1,-1,-1,-1,-1,-1,-1,-1
; filament_retract_length_nc = 14,14,14,14,14,14,14,14
; filament_scarf_gap = 0%,0%,15%,15%,0%,0%,0%,15%
; filament_scarf_height = 10%,10%,5%,5%,10%,10%,10%,10%
; filament_scarf_length = 10,10,10,10,10,10,10,10
; filament_scarf_seam_type = none,none,none,none,none,none,none,none
; filament_self_index = 1,2,3,4,5,6,7,8
; filament_settings_id = "Bambu PLA Basic @BBL H2D 0.2 nozzle";"Bambu PLA Basic @BBL H2D 0.2 nozzle-1(corgi-diagnostic-v4-01-white-only-H2D.3mf)";"Bambu PLA Silk+ @BBL H2D 0.2 nozzle(corgi-diagnostic-v4-01-white-only-H2D.3mf)";"Bambu PLA Silk+ @BBL H2D 0.2 nozzle(corgi-diagnostic-v4-01-white-only-H2D.3mf)";"Bambu PLA Basic @BBL H2D 0.2 nozzle-1(corgi-diagnostic-v4-01-white-only-H2D.3mf)";"Bambu PLA Basic @BBL H2D 0.2 nozzle-1(corgi-diagnostic-v4-01-white-only-H2D.3mf)";"Bambu PLA Basic @BBL H2D 0.2 nozzle(corgi-diagnostic-v4-01-white-only-H2D.3mf)";"Bambu PLA Metal @BBL H2D 0.2 nozzle(corgi-diagnostic-v4-01-white-only-H2D.3mf)"
; filament_shrink = 100%,100%,100%,100%,100%,100%,100%,100%
; filament_soluble = 0,0,0,0,0,0,0,0
; filament_start_gcode = "; filament start gcode\n";"; filament start gcode\n";"; filament start gcode\n";"; filament start gcode\n";"; filament start gcode\n";"; filament start gcode\n";"; filament start gcode\n";"; filament start gcode\n"
; filament_tower_interface_pre_extrusion_dist = 10,10,10,10,10,10,10,10
; filament_tower_interface_pre_extrusion_length = 0,0,0,0,0,0,0,0
; filament_tower_interface_print_temp = -1,-1,-1,-1,-1,-1,-1,-1
; filament_tower_interface_purge_volume = 20,20,20,20,20,20,20,20
; filament_tower_ironing_area = 4,4,4,4,4,4,4,4
; filament_type = PLA;PLA;PLA;PLA;PLA;PLA;PLA;PLA
; filament_velocity_adaptation_factor = 1,1,1,1,1,1,1,1
; filament_vendor = "Bambu Lab";"Bambu Lab";"Bambu Lab";"Bambu Lab";"Bambu Lab";"Bambu Lab";"Bambu Lab";"Bambu Lab"
; filament_volume_map = 0,0,0,0,0,0,0,0
; filename_format = {input_filename_base}_{filament_type[0]}_{print_time}.gcode
; fill_multiline = 1
; filter_out_gap_fill = 0
; first_layer_print_sequence = 0
; first_x_layer_fan_speed = 0,0,0,0,0,0,0,0
; first_x_layer_part_fan_speed = 0,0,0,0,0,0,0,0
; flush_into_infill = 0
; flush_into_objects = 0
; flush_into_support = 1
; flush_multiplier = 1,1
; flush_multiplier_fast = 1.2,1.2
; flush_volumes_matrix = 0,90,330,195,199,120,90,250,420,0,574,621,226,150,150,450,504,344,0,369,251,280,274,243,320,351,266,0,229,190,271,190,636,490,624,601,0,346,208,443,660,330,488,479,193,0,180,283,900,570,681,658,266,422,0,510,547,312,399,434,217,190,228,0,0,90,345,210,214,120,90,265,420,0,589,636,241,150,150,465,519,359,0,384,266,295,289,258,335,366,281,0,244,205,286,205,651,505,639,616,0,361,223,458,660,330,503,494,208,0,180,298,900,570,696,673,281,437,0,525,562,327,414,449,232,205,243,0
; flush_volumes_vector = 140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140
; full_fan_speed_layer = 0,0,0,0,0,0,0,0
; fuzzy_skin = none
; fuzzy_skin_first_layer = 0
; fuzzy_skin_mode = displacement
; fuzzy_skin_noise_type = classic
; fuzzy_skin_octaves = 4
; fuzzy_skin_persistence = 0.5
; fuzzy_skin_point_distance = 0.8
; fuzzy_skin_scale = 1
; fuzzy_skin_thickness = 0.3
; gap_infill_speed = 50,50
; gcode_add_line_number = 0
; gcode_flavor = marlin
; grab_length = 0,0
; group_algo_with_time = 0
; has_filament_switcher = 0
; has_scarf_joint_seam = 0
; head_wrap_detect_zone = 
; hole_coef_1 = 0,0,0,0,0,0,0,0
; hole_coef_2 = -0.0028,-0.0028,-0.008,-0.008,-0.0028,-0.0028,-0.0028,-0.008
; hole_coef_3 = 0.12,0.12,0.23415,0.23415,0.12,0.12,0.12,0.23415
; hole_limit_max = 0.12,0.12,0.22,0.22,0.12,0.12,0.12,0.22
; hole_limit_min = 0.05,0.05,0.088,0.088,0.05,0.05,0.05,0.088
; host_type = octoprint
; hot_plate_temp = 55,55,55,55,55,55,55,55
; hot_plate_temp_initial_layer = 55,55,55,55,55,55,55,55
; hotend_cooling_rate = 2,2
; hotend_heating_rate = 3.6,3.6
; impact_strength_z = 13.8,13.8,8.5,8.5,13.8,13.8,13.8,16.8
; independent_support_layer_height = 1
; infill_combination = 0
; infill_direction = 45
; infill_instead_top_bottom_surfaces = 0
; infill_jerk = 9
; infill_lock_depth = 1
; infill_rotate_step = 0
; infill_shift_step = 0.4
; infill_wall_overlap = 20%
; inherits_group = ;;"Bambu PLA Basic @BBL H2D 0.2 nozzle";"Bambu PLA Silk+ @BBL H2D 0.2 nozzle";"Bambu PLA Silk+ @BBL H2D 0.2 nozzle";"Bambu PLA Basic @BBL H2D 0.2 nozzle";"Bambu PLA Basic @BBL H2D 0.2 nozzle";"Bambu PLA Basic @BBL H2D 0.2 nozzle";"Bambu PLA Metal @BBL H2D 0.2 nozzle";
; initial_layer_acceleration = 500,500
; initial_layer_flow_ratio = 1
; initial_layer_infill_speed = 70,70
; initial_layer_jerk = 9
; initial_layer_line_width = 0.25
; initial_layer_print_height = 0.1
; initial_layer_speed = 40,40
; initial_layer_travel_acceleration = 6000,6000
; inner_wall_acceleration = 0,0
; inner_wall_jerk = 9
; inner_wall_line_width = 0.22
; inner_wall_speed = 150,150
; interface_shells = 0
; interlocking_beam = 0
; interlocking_beam_layer_count = 2
; interlocking_beam_width = 0.8
; interlocking_boundary_avoidance = 2
; interlocking_depth = 2
; interlocking_orientation = 22.5
; internal_bridge_support_thickness = 0.8
; internal_solid_infill_line_width = 0.22
; internal_solid_infill_pattern = zig-zag
; internal_solid_infill_speed = 150,150
; ironing_direction = 45
; ironing_fan_speed = -1,-1,-1,-1,-1,-1,-1,-1
; ironing_flow = 10%
; ironing_inset = 0.11
; ironing_pattern = zig-zag
; ironing_spacing = 0.15
; ironing_speed = 30
; ironing_type = no ironing
; is_infill_first = 0
; layer_change_gcode = ;======== H2D 20250710 layer_change ========\n; layer num/total_layer_count: {layer_num+1}/[total_layer_count]\n; update layer progress\nM73 L{layer_num+1}\nM991 S0 P{layer_num} ;notify layer change\n
; layer_height = 0.1
; line_width = 0.22
; locked_skeleton_infill_pattern = zigzag
; locked_skin_infill_pattern = crosszag
; long_retractions_when_cut = 0,0
; long_retractions_when_ec = 1,1,1,1,1,1,1,1
; machine_bed_mass_Y = 0
; machine_end_gcode = ;========== H2D end ==========\n;===== date: 2026/07/29 =====\n\nM1003 S0\nM73 P100 R0\n\nG392 S0 ;turn off nozzle clog detect\nM993 A0 B0 C0 ; nozzle cam detection not allowed.\n\nM400 ; wait for buffer to clear\nG92 E0 ; zero the extruder\nM211 Z1\n\nG90\nG1 Z{max_layer_z + 0.4} F900 ; lower z a little\nM1002 judge_flag timelapse_record_flag\nM622 J1\n    G150.3\n    M400 ; wait all motion done\n    M991 S0 P-1 ;end smooth timelapse at safe pos\n    M400 S5 ;wait for last picture to be taken\nM623  ;end of \"timelapse_record_flag\"\n\nG90\nG1 Z{max_layer_z + 10} F900 ; lower z a little\n\nG90\nM141 S0 ; turn off chamber heating\nM140 S0 ; turn off bed\nM106 S0 ; turn off fan\nM106 P2 S0 ; turn off remote part cooling fan\nM106 P3 S0 ; turn off chamber cooling fan\nM106 P9 S0 ; turn off ext toodhead cooling fan\n; pull back filament to AMS\nM620 S65535\nT65535\nG150.2\nM621 S65535\n\nM620 S65279\nT65279\nG150.2\nM621 S65279\n\nG150.3\n\nM104 S0 T0; turn off hotend\nM104 S0 T1; turn off hotend\n\nM400 ; wait all motion done\nM17 S\nM17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom\n{if (100.0 - max_layer_z/2) > 0}\n    {if (max_layer_z + 100.0 - max_layer_z/2) < 320}\n        G1 Z{max_layer_z + 100.0 - max_layer_z/2} F600\n        G1 Z{max_layer_z + 98.0 - max_layer_z/2}\n    {else}\n        G1 Z320 F600\n        G1 Z320\n    {endif}\n{else}\n    {if (max_layer_z + 4.0) < 320}\n        G1 Z{max_layer_z + 4.0} F600\n        G1 Z{max_layer_z + 2.0}\n    {else}\n        G1 Z320 F600\n        G1 Z320\n    {endif}\n{endif}\nM400 P100\nM17 R ; restore z current\n\nM220 S100  ; Reset feedrate magnitude\nM201.2 K1.0 ; Reset acc magnitude\nM73.2   R1.0 ;Reset left time magnitude\nM1002 set_gcode_claim_speed_level : 0\n\nM1015.4 S0 K0 ;disable air printing detect\n\n;=====printer finish air purification=========\nM622.1 S0\nM1002 judge_flag print_finish_air_filt_flag\n\nM622 J1\nM1002 gcode_claim_action : 66\nM145 P1\nM106 P6 S255\nM400 S180\nM106 P6 S0\nM623\n\nM622 J2\nM1002 gcode_claim_action : 66\nM145 P0\nM106 P3 S127\nM400 S180\nM106 P3 S0\nM623\n;=====printer finish air purification=========\n\n\n;=====printer finish  sound=========\nM17\nM400 S1\nM1006 S1\nM1006 A53 B10 L99 C53 D10 M99 E53 F10 N99 \nM1006 A57 B10 L99 C57 D10 M99 E57 F10 N99 \nM1006 A0 B15 L0 C0 D15 M0 E0 F15 N0 \nM1006 A53 B10 L99 C53 D10 M99 E53 F10 N99 \nM1006 A57 B10 L99 C57 D10 M99 E57 F10 N99 \nM1006 A0 B15 L0 C0 D15 M0 E0 F15 N0 \nM1006 A48 B10 L99 C48 D10 M99 E48 F10 N99 \nM1006 A0 B15 L0 C0 D15 M0 E0 F15 N0 \nM1006 A60 B10 L99 C60 D10 M99 E60 F10 N99 \nM1006 W\n;=====printer finish  sound=========\nM400\nM18\n\n
; machine_hotend_change_time = 0
; machine_load_filament_time = 26
; machine_max_acceleration_e = 5000,5000,5000,5000
; machine_max_acceleration_extruding = 20000,20000,20000,20000
; machine_max_acceleration_retracting = 5000,5000,5000,5000
; machine_max_acceleration_travel = 9000,9000,9000,9000
; machine_max_acceleration_x = 20000,20000,20000,20000
; machine_max_acceleration_y = 20000,20000,20000,20000
; machine_max_acceleration_z = 500,500,500,500
; machine_max_force_Y = 0
; machine_max_jerk_e = 2.5,2.5,2.5,2.5
; machine_max_jerk_x = 9,9,9,9
; machine_max_jerk_y = 9,9,9,9
; machine_max_jerk_z = 3,3,3,3
; machine_max_printed_mass = 0
; machine_max_speed_e = 50,50,50,50
; machine_max_speed_x = 1000,1000,1000,1000
; machine_max_speed_y = 1000,1000,1000,1000
; machine_max_speed_z = 30,30,30,30
; machine_min_extruding_rate = 0,0
; machine_min_travel_rate = 0,0
; machine_pause_gcode = M400 U1
; machine_prepare_compensation_time = 260
; machine_start_gcode = ;===== machine: H2D =========================\n;===== date: 20260605 =====================\n\n;M1002 set_flag extrude_cali_flag=1\n;M1002 set_flag g29_before_print_flag=1\n;M1002 set_flag auto_cali_toolhead_offset_flag=1\n;M1002 set_flag build_plate_detect_flag=1\n\nM993 A0 B0 C0 ; nozzle cam detection not allowed.\n\nM400\n;M73 P99\n\nM960 S10 P1 ; ext fan led\n\n;=====printer start sound ===================\nM17\nM400 S1\nM1006 S1\nM1006 A53 B9 L99 C53 D9 M99 E53 F9 N99\nM1006 A56 B9 L99 C56 D9 M99 E56 F9 N99\nM1006 A61 B9 L99 C61 D9 M99 E61 F9 N99\nM1006 A53 B9 L99 C53 D9 M99 E53 F9 N99\nM1006 A56 B9 L99 C56 D9 M99 E56 F9 N99\nM1006 A61 B18 L99 C61 D18 M99 E61 F18 N99\nM1006 W\n;=====printer start sound ===================\n\n;===== reset machine status =================\nM204 S10000\nM630 S0 P0\n\nG90\nM17 D ; reset motor current to default\nM960 S5 P1 ; turn on logo lamp\nG90\nM1002 set_gcode_claim_speed_level 5 ;Reset speed level\nM220 S100 ;Reset Feedrate\nM221 S100 ;Reset Flowrate\nM73.2   R1.0 ;Reset left time magnitude\nG29.1 Z{+0.0} ; clear z-trim value first\nM983.1 M1\nM901 D4\nM481 S0 ; turn off cutter pos comp\nG28.140 D0; reset pre-extrude z pos\n;===== reset machine status =================\n\nM620 M ;enable remap\n\n;===== avoid end stop =================\nG91\nG380 S2 Z42 F1200\nG380 S2 Z-12 F1200\nG90\n;===== avoid end stop =================\n\n;==== set airduct mode ====\n\n{if (overall_chamber_temperature >= 40)}\n\n    M145 P1 ; set airduct mode to heating mode for heating\n    M106 P2 S0 ; turn off auxiliary fan\n    M106 P3 S0 ; turn off chamber fan\n\n{else}\n    M145 P0 ; set airduct mode to cooling mode for cooling\n    M106 P2 S178 ; turn on auxiliary fan for cooling\n    M106 P3 S127 ; turn on chamber fan for cooling\n    M140 S0 ; stop heatbed from heating\n\n    M1002 gcode_claim_action : 29\n    M191 S0 ; wait for chamber temp\n    M106 P2 S0 ; turn off auxiliary fan\n    {if (min_vitrification_temperature <= 50)}\n        {if (nozzle_diameter_at_nozzle_id[initial_nozzle_id] == 0.2)}\n            M142 P1 R30 S35 T40 U0.3 V0.5 W0.8 O40 ; set PLA/TPU ND0.2 chamber autocooling\n        {else}\n            M142 P1 R30 S40 T45 U0.3 V0.5 W0.8 O45; set PLA/TPU ND0.4 chamber autocooling\n        {endif}\n    {else}\n        {if (!is_all_bbl_filament)}\n            M142 P1 R35 S40 T45 U0.3 V0.5 W0.8 O45 L1 ; set third-party PETG chamber autocooling\n        {else}\n            {if (nozzle_diameter_at_nozzle_id[initial_nozzle_id] == 0.2)}\n                M142 P1 R35 S45 T50 U0.3 V0.5 W0.8 O50 L1 ; set PETG ND0.2 chamber autocooling\n            {else}\n                M142 P1 R35 S50 T55 U0.3 V0.5 W0.8 O55 L1 ; set PETG ND0.4 chamber autocooling\n            {endif}\n        {endif}\n    {endif}\n    {if(cooling_filter_enabled)}\n        M145.2 P0 F0\n    {else}\n        M145.2 P0 F1\n    {endif}\n{endif}\n\n;==== set airduct mode ====\n\n;===== start to heat heatbed & hotend==========\n\n    M1002 set_filament_type:{filament_type[initial_no_support_filament_id]}\n\n    M104 S140 A\n    M140 S[bed_temperature_initial_layer_single]\n\n    ;===== set chamber temperature ==========\n    {if (overall_chamber_temperature >= 40)}\n        M145 P1 ; set airduct mode to heating mode\n        M141 S[overall_chamber_temperature] ; Let Chamber begin to heat\n    {endif}\n    ;===== set chamber temperature ==========\n\n;===== start to heat heatbead & hotend==========\n\n;====== cog noise reduction=================\nM982.2 S1 ; turn on cog noise reduction\n\n;===== first homing start =====\nM1002 gcode_claim_action : 13\n\nG28 X T300\n\nG150.1 F18000 ; wipe mouth to avoid filament stick to heatbed\nG150.3 F18000\nM400 P200\nM972 S24 P0 T2000\n\nM1002 gcode_claim_action : 74 ; Heatbed surface foreign object detection\n{if curr_bed_type==\"Textured PEI Plate\"}\nM972 S26 P0 C0\n{else}\nM972 S36 P0 C0 X1\n{endif}\nM972 S35 P0 C0\n\nM972 S41 P0 T5000 ; trash can anti-collision\n\nM1009 Q1 L1\nG91\nG380 S2 Z30 F1200 ; lower heatbed to move toolhead\nG90\nG1 X175 Y160 F30000\nG28 Z P0 T250\nM1009 Q1 L0\n\n;===== first homing end =====\n\nM400\n;M73 P99\n\n;===== detection start =====\n\nM1002 judge_flag build_plate_detect_flag\nM622 S1\n    ;M1002 gcode_claim_action : 11 ; Indentifying build plate type\n    M972 S19 P0 C0    ; heatbed presence detection\n    M972 S31 P0 T5000 ; toolhead camera dirty detection\n    ;M1002 gcode_claim_action : 73 ; Build plate alignment detection\n    M972 S34 P0 T5000 ; heatbed plate offset detection\nM623\n\nM1002 gcode_claim_action : 72 ; Hotend Type Detection\nT1001\nM972 S14 P0 T5000 ; nozzle type detection\n\nM104 S{nozzle_temperature_initial_layer[initial_no_support_filament_id]} T{filament_map[initial_no_support_filament_id] % 2} ; rise temp in advance\n\nG151 P{filament_map[initial_no_support_filament_id] % 2} M ; plug the heat nozzle\n\n{if max_print_z >= 145}\nM1002 gcode_claim_action : 75 ; Heatbed underside foreign object detection\nG3811 Z{max_print_z}  ; Detect obstacles at the bottom of the heated bed\n{endif}\n\n;===== detection end =====\n\nM400\n;M73 P99\n\n;===== prepare print temperature and material ==========\nM400\nM211 X0 Y0 Z0 ;turn off soft endstop\nM975 S1 ; turn on input shaping\n\nG29.2 S0 ; avoid invalid abl data\n\n{if ((filament_type[initial_no_support_filament_id] == \"PLA\") || (filament_type[initial_no_support_filament_id] == \"PLA-CF\") || (filament_type[initial_no_support_filament_id] == \"PETG\")) && (nozzle_diameter_at_nozzle_id[initial_nozzle_id] == 0.2)}\nM620.10 A0 F74.8347 H{nozzle_diameter_at_nozzle_id[initial_nozzle_id]} T{flush_temperatures[initial_no_support_filament_id]} P{nozzle_temperature_initial_layer[initial_no_support_filament_id]} S1\nM620.10 A1 F74.8347 H{nozzle_diameter_at_nozzle_id[initial_nozzle_id]} T{flush_temperatures[initial_no_support_filament_id]} P{nozzle_temperature_initial_layer[initial_no_support_filament_id]} S1\n{else}\nM620.10 A0 F{flush_volumetric_speeds[initial_no_support_filament_id]/2.4053*60*0.8} H{nozzle_diameter_at_nozzle_id[initial_nozzle_id]} T{flush_temperatures[initial_no_support_filament_id]} P{nozzle_temperature_initial_layer[initial_no_support_filament_id]} S1\nM620.10 A1 F{flush_volumetric_speeds[initial_no_support_filament_id]/2.4053*60*0.8} H{nozzle_diameter_at_nozzle_id[initial_nozzle_id]} T{flush_temperatures[initial_no_support_filament_id]} P{nozzle_temperature_initial_layer[initial_no_support_filament_id]} S1\n{endif}\n\nM620.11 P0 I[initial_no_support_filament_id] B[initial_no_support_hotend] E0\n\n{if long_retraction_when_ec }\nM620.11 K1 I[initial_no_support_filament_id] B[initial_no_support_hotend] R{retraction_distance_when_ec} F{max((flush_volumetric_speeds[initial_no_support_filament_id]/2.4053*60), 200)}\n{else}\nM620.11 K0 I[initial_no_support_filament_id] B[initial_no_support_hotend] R0\n{endif}\n\nM628 S1\n{if filament_type[initial_no_support_filament_id] == \"TPU\"}\n    M620.11 S0 L0 I[initial_no_support_filament_id] B[initial_no_support_hotend] E-{retraction_distances_when_cut[initial_no_support_filament_id]} F{flush_volumetric_speeds[initial_no_support_filament_id]/2.4053*60}\n{else}\n{if (filament_type[initial_no_support_filament_id] == \"PA\") ||  (filament_type[initial_no_support_filament_id] == \"PA-GF\")}\n    M620.11 S1 L0 I[initial_no_support_filament_id] B[initial_no_support_hotend] R4 D2 E-{retraction_distances_when_cut[initial_no_support_filament_id]} F{flush_volumetric_speeds[initial_no_support_filament_id]/2.4053*60}\n{else}\n    M620.11 S1 L0 I[initial_no_support_filament_id] B[initial_no_support_hotend] R10 D8 E-{retraction_distances_when_cut[initial_no_support_filament_id]} F{flush_volumetric_speeds[initial_no_support_filament_id]/2.4053*60}\n{endif}\n{endif}\nM629\n\nM620 S[initial_no_support_filament_id]A H[initial_no_support_hotend] ; switch material if AMS exist\nM1002 gcode_claim_action : 4\nM1002 set_filament_type:UNKNOWN\nM400\nT[initial_no_support_filament_id] H[initial_no_support_hotend]\nM400\nM628 S0\nM629\nM400\nM1002 set_filament_type:{filament_type[initial_no_support_filament_id]}\nM621 S[initial_no_support_filament_id]A\n\nM104 S{nozzle_temperature_initial_layer[initial_no_support_filament_id]}\nM400\nM106 P1 S0\n\nG29.2 S1\n;===== prepare print temperature and material ==========\n\nM400\n;M73 P99\n\n;===== auto extrude cali start =========================\nM975 S1\nM1002 judge_flag extrude_cali_flag\n\nM622 J0\n    M983.3 F{filament_max_volumetric_speed[initial_no_support_filament_id]/2.4} A0.4 ; cali dynamic extrusion compensation\nM623\n\nM622 J1\n    M1002 set_filament_type:{filament_type[initial_no_support_filament_id]}\n    M1002 gcode_claim_action : 8\n\n    M109 S{nozzle_temperature[initial_no_support_filament_id]}\n\n    G90\n    M83\n    M983.3 F{filament_max_volumetric_speed[initial_no_support_filament_id]/2.4} A0.4 ; cali dynamic extrusion compensation\n\n    M400\n    M106 P1 S255\n    M400 S5\n    M106 P1 S0\n    G150.3\nM623\n\nM622 J2\n    M1002 set_filament_type:{filament_type[initial_no_support_filament_id]}\n    M1002 gcode_claim_action : 8\n\n    M109 S{nozzle_temperature[initial_no_support_filament_id]}\n\n    G90\n    M83\n    M983.3 F{filament_max_volumetric_speed[initial_no_support_filament_id]/2.4} A0.4 ; cali dynamic extrusion compensation\n\n    M400\n    M106 P1 S255\n    M400 S5\n    M106 P1 S0\n    G150.3\nM623\n\n;===== auto extrude cali end =========================\n\n{if filament_type[initial_no_support_filament_id] == \"TPU\"}\n    G150.2\n    G150.1\n    G150.2\n    G150.1\n    G150.2\n    G150.1\n{else}\n    M106 P1 S0\n    M400 S2\n    M109 S{nozzle_temperature[initial_no_support_filament_id]} ; wait tmpr to extrude\n    M83\n    {if(nozzle_diameter_at_nozzle_id[initial_nozzle_id] == 0.8)}\n        G1 E60 F{filament_max_volumetric_speed[initial_no_support_filament_id]/2.4053*60}\n    {else}\n        G1 E45 F{filament_max_volumetric_speed[initial_no_support_filament_id]/2.4053*60}\n    {endif}\n    G1 E-3 F1800\n    M400 P500\n    G150.2\n    G150.1\n{endif}\n\nG91\nG1 Y-16 F12000 ; move away from the trash bin\nG90\n\nM400\n;M73 P99\n\n;===== wipe right nozzle start =====\n\nM1002 gcode_claim_action : 14\n    G150 T{nozzle_temperature_initial_layer[initial_no_support_filament_id]}\n    {if (overall_chamber_temperature >= 40)}\n        G150 T{nozzle_temperature_initial_layer[initial_no_support_filament_id] - 80}\n    {endif}\nM106 S255 ; turn on fan to cool the nozzle\n\n;===== wipe left nozzle end =====\n\nM400\n;M73 P99\n\n{if (overall_chamber_temperature >= 40)}\n    M1002 gcode_claim_action : 49\n    M191 S[overall_chamber_temperature] ; wait for chamber temp\n{endif}\n\nM400\n;M73 P99\n\n;===== bed leveling ==================================\n\nM1002 judge_flag g29_before_print_flag\n\nM190 S[bed_temperature_initial_layer_single]; ensure bed temp\nM109 S140 A\nM106 S0 ; turn off fan , too noisy\n\nG91\nG1 Z5 F1200\nG90\nG1 X175 Y160 F30000\n\nM622 J1\n    M1002 gcode_claim_action : 1\n    G29.20 A3\n    G29 A1 O X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]} R\n    M400\nM623\n\nM622 J2\n    M1002 gcode_claim_action : 1\n    {if has_tpu_in_first_layer}\n        G29.20 A3\n        G29 A1 O X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]} R\n    {else}\n        G29.20 A4\n        G29 A2 O X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]} R\n    {endif}\n    M400\nM623\n\nM622 J0\n    G28 R\nM623\n\n;===== bed leveling end ================================\n\n;===== z ofst cali start =====\n\n    M190 S[bed_temperature_initial_layer_single]; ensure bed temp\n\n    G383 O0 M2 T140\n\n;===== z ofst cali end =====\n\nG39.1 ; cali nozzle wrapped detection pos\n\nG90\nG1 Z5 F1200\nG1 X270 Y-0.5 F60000\nG28.140 S0 ; cali pre-extrude z pos\n\nM141 S[overall_chamber_temperature]\nM104 S{nozzle_temperature_initial_layer[initial_no_support_filament_id]} A\n\n;===== mech mode sweep start =====\n    M1002 gcode_claim_action : 3\n\n    G90\n    G1 Z5 F1200\n    G1 X187 Y160 F20000\n    T1000\n    M400 P200\n\n    M970.3 Q1 A5 K0 O1\n    M974 Q1 S2 P0\n\n    M970.3 Q0 A5 K0 O1\n    M974 Q0 S2 P0\n\n    M970.2 Q2 K0 W38 Z0.01\n    M974 Q2 S2 P0\n\n    M975 S1\n;===== mech mode sweep end =====\n\nM400\n;M73 P99\n\nG150.3 ; move to garbage can to wait for temp\nM1026\nG29.9\n\n;===== xy ofst cali start =====\n\nM1002 judge_flag auto_cali_toolhead_offset_flag\n\nM622 J0\n    M1012.5 N1 R1\nM623\n\nM622 J1\n    M1002 gcode_claim_action : 39\n    M141 S0\n    M620.17 T0 S{nozzle_temperature_initial_layer[(first_non_support_filaments[0] != -1 ? first_non_support_filaments[0] : (first_filaments[0] != -1 ? first_filaments[0] : 0))]} L{(first_non_support_filaments[0] != -1 ? first_non_support_filaments[0] : (first_filaments[0] != -1 ? first_filaments[0] : 0))}\n    M620.17 T1 S{nozzle_temperature_initial_layer[(first_non_support_filaments[1] != -1 ? first_non_support_filaments[1] : (first_filaments[1] != -1 ? first_filaments[1] : 0))]} L{(first_non_support_filaments[1] != -1 ? first_non_support_filaments[1] : (first_filaments[1] != -1 ? first_filaments[1] : 0))}\n    M620 D[initial_no_support_hotend]\n    G383 O1 T{nozzle_temperature_initial_layer[initial_no_support_filament_id]} L{initial_no_support_filament_id}\n    M141 S[overall_chamber_temperature]\nM623\n\nM622 J2\n    M1002 gcode_claim_action : 39\n    M141 S0\n    M620.17 T0 S{nozzle_temperature_initial_layer[(first_non_support_filaments[0] != -1 ? first_non_support_filaments[0] : (first_filaments[0] != -1 ? first_filaments[0] : 0))]} L{(first_non_support_filaments[0] != -1 ? first_non_support_filaments[0] : (first_filaments[0] != -1 ? first_filaments[0] : 0))}\n    M620.17 T1 S{nozzle_temperature_initial_layer[(first_non_support_filaments[1] != -1 ? first_non_support_filaments[1] : (first_filaments[1] != -1 ? first_filaments[1] : 0))]} L{(first_non_support_filaments[1] != -1 ? first_non_support_filaments[1] : (first_filaments[1] != -1 ? first_filaments[1] : 0))}\n    M620 D[initial_no_support_hotend]\n    G383.3 T{nozzle_temperature_initial_layer[initial_no_support_filament_id]} L{initial_no_support_filament_id}\n    M141 S[overall_chamber_temperature]\nM623\n;===== xy ofst cali end =====\n\nM400\n;M73 P99\n\nM1002 gcode_claim_action : 0\nM400\n\n;============switch again==================\nM211 X0 Y0 Z0 ;turn off soft endstop\nG91\nG1 Z6 F1200\nG90\nM1002 set_filament_type:{filament_type[initial_no_support_filament_id]}\nM620 S[initial_no_support_filament_id]A H[initial_no_support_hotend]\nM400\nT[initial_no_support_filament_id] H[initial_no_support_hotend]\nM400\nM628 S0\nM629\nM400\nM621 S[initial_no_support_filament_id]A\n\n;============switch again==================\n\nM400\n;M73 P99\n\n;===== wait temperature reaching the reference value =======\n\nM104 S{nozzle_temperature_initial_layer[initial_no_support_filament_id]} ; rise to print tmpr\n\nM140 S[bed_temperature_initial_layer_single]\nM190 S[bed_temperature_initial_layer_single]\n\n    ;========turn off light and fans =============\n    M960 S1 P0 ; turn off laser\n    M960 S2 P0 ; turn off laser\n    M106 S0 ; turn off fan\n    M106 P2 S0 ; turn off big fan\n    ;==== set ext toodhead cooling fan ====\n    {if (min_vitrification_temperature <= 50)}\n    M106 P9 S255\n    {endif}\n    ;============set motor current==================\n    M400 S1\n\n;===== wait temperature reaching the reference value =======\n\nM400\n;M73 P99\n\n;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==\n    {if curr_bed_type==\"Textured PEI Plate\"}\n        {if nozzle_diameter_at_nozzle_id[initial_nozzle_id] == 0.2}\n            G29.1 Z{-0.01} ; for Textured PEI Plate\n        {else}\n            G29.1 Z{-0.02} ; for Textured PEI Plate\n        {endif}\n    {else}\n        {if nozzle_diameter_at_nozzle_id[initial_nozzle_id] == 0.2}\n            G29.1 Z{0.01}\n        {endif}\n    {endif}\n\nG150.1\n\nM975 S1 ; turn on mech mode supression\nM983.4 S1 ; turn on deformation compensation\nG29.2 S1 ; turn on pos comp\nG29.7 S1\n\nG90\nG1 Z5 F1200\nG1 Y295 F30000\nG1 Y265 F18000\n\n;===== nozzle load line ===============================\n    G29.2 S1 ; ensure z comp turn on\n    G90\n    M83\n    G1 Z5 F1200\n    G1 X270 Y-0.5 F60000\n    G28.14 R0\n    G29.2 S0\n    G91\n    G1 Z0.8 F1200\n    G90\n    G1 X250 F60000\n    M400 P50\n    M500 D1\n    M400 S3\n    M109 S{nozzle_temperature_initial_layer[initial_no_support_filament_id]}\n    M83\n{if nozzle_diameter_at_nozzle_id[initial_nozzle_id] == 0.8}\n    G1 E5 F{filament_max_volumetric_speed[initial_no_support_filament_id]/2.4053*60}\n{endif}\n{if (filament_type[initial_no_support_filament_id] == \"TPU\")}\n    G1 E5 F{filament_max_volumetric_speed[initial_no_support_filament_id]/2.4053*60}\n{endif}\n    G1 E5 F{filament_max_volumetric_speed[initial_no_support_filament_id]/2.4053*60}\n    G1 X290 E10 F{filament_max_volumetric_speed[initial_no_support_filament_id]/2.4053*60}\n    G91\n    G3 Z0.4 I1.217 J0 P1 F60000\n    G90\n    M83\n    G29.2 S1 ; ensure z comp turn on\n;===== noozle load line end ===========================\n\nM400\n;M73 P99\n\nM993 A1 B1 C1 ; nozzle cam detection allowed.\n\n{if (filament_type[initial_no_support_filament_id] == \"TPU\")}\nM1015.3 S1;enable tpu clog detect\n{else}\nM1015.3 S0;disable tpu clog detect\n{endif}\n\n{if (filament_type[initial_no_support_filament_id] == \"PLA\") ||  (filament_type[initial_no_support_filament_id] == \"PETG\")\n ||  (filament_type[initial_no_support_filament_id] == \"PLA-CF\")  ||  (filament_type[initial_no_support_filament_id] == \"PETG-CF\")}\nM1015.4 S1 K1 H{nozzle_diameter_at_nozzle_id[initial_nozzle_id]} ;enable E air printing detect\n{else}\nM1015.4 S0 K0 H{nozzle_diameter_at_nozzle_id[initial_nozzle_id]} ;disable E air printing detect\n{endif}\n\nM620.6 I[initial_no_support_filament_id] H[initial_no_support_hotend] W1 ;enable ams air printing detect\nM620 Q1\n\nM211 Z1\nG29.99\n
; machine_switch_extruder_time = 5.6
; machine_unload_filament_time = 26
; master_extruder_id = 2
; max_bridge_length = 0
; max_layer_height = 0.14,0.14
; max_travel_detour_distance = 0
; min_bead_width = 85%
; min_feature_size = 25%
; min_layer_height = 0.04,0.04
; minimum_sparse_infill_area = 15
; mmu_segmented_region_interlocking_depth = 0
; mmu_segmented_region_max_width = 0
; monotonic_travel_into_wall = 45%
; no_slow_down_for_cooling_on_outwalls = 0,0,0,0,0,0,0,0
; nozzle_diameter = 0.2,0.2
; nozzle_flush_dataset = 1,1
; nozzle_height = 4
; nozzle_temperature = 220,220,230,230,220,220,215,220
; nozzle_temperature_initial_layer = 220,220,230,230,220,220,220,220
; nozzle_temperature_range_high = 240,240,240,240,240,240,240,240
; nozzle_temperature_range_low = 190,190,190,190,190,190,190,190
; nozzle_type = hardened_steel,hardened_steel
; nozzle_volume = 130,145
; nozzle_volume_type = Standard,Standard
; only_one_wall_first_layer = 0
; ooze_prevention = 0
; other_layers_print_sequence = 0
; other_layers_print_sequence_nums = 0
; outer_wall_acceleration = 5000,5000
; outer_wall_jerk = 9
; outer_wall_line_width = 0.22
; outer_wall_speed = 120,120
; overhang_1_4_speed = 0,0
; overhang_2_4_speed = 50,50
; overhang_3_4_speed = 30,30
; overhang_4_4_speed = 10,10
; overhang_fan_speed = 100,100,100,100,100,100,100,100
; overhang_fan_threshold = 50%,50%,50%,50%,50%,50%,50%,50%
; overhang_threshold_participating_cooling = 95%,95%,95%,95%,95%,95%,95%,95%
; overhang_totally_speed = 10,10
; override_filament_scarf_seam_setting = 0
; override_process_overhang_speed = 0,0,0,0,0,0,0,0
; physical_extruder_map = 1,0
; post_process = 
; pre_start_fan_time = 2,2,2,2,2,2,2,2
; precise_outer_wall = 0
; precise_z_height = 0
; pressure_advance = 0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02
; prime_tower_brim_width = -1
; prime_tower_enable_framework = 0
; prime_tower_extra_rib_length = 0
; prime_tower_fillet_wall = 1
; prime_tower_flat_ironing = 1
; prime_tower_infill_gap = 100%
; prime_tower_lift_height = -1
; prime_tower_lift_speed = 90
; prime_tower_max_speed = 90
; prime_tower_rib_wall = 0
; prime_tower_rib_width = 8
; prime_tower_skip_points = 1
; prime_tower_width = 45
; prime_volume_mode = Default
; print_compatible_printers = "Bambu Lab H2D 0.2 nozzle"
; print_extruder_id = 1,2
; print_extruder_variant = "Direct Drive Standard";"Direct Drive Standard"
; print_flow_ratio = 1
; print_in_clockwise = 0
; print_sequence = by layer
; print_settings_id = 0.10mm Standard @BBL H2D 0.2 nozzle
; printable_area = 0x0,350x0,350x320,0x320
; printable_height = 325
; printer_extruder_id = 1,2
; printer_extruder_variant = "Direct Drive Standard";"Direct Drive Standard"
; printer_model = Bambu Lab H2D
; printer_notes = 
; printer_settings_id = Bambu Lab H2D 0.2 nozzle
; printer_structure = corexy
; printer_technology = FFF
; printer_variant = 0.2
; printhost_authorization_type = key
; printhost_ssl_ignore_revoke = 0
; printing_by_object_gcode = 
; process_notes = 
; raft_contact_distance = 0.1
; raft_expansion = 1.5
; raft_first_layer_density = 90%
; raft_first_layer_expansion = -1
; raft_layers = 0
; reduce_crossing_wall = 0
; reduce_fan_stop_start_freq = 1,1,1,1,1,1,1,1
; reduce_infill_retraction_mode = Auto
; required_nozzle_HRC = 3,3,3,3,3,3,3,3
; resolution = 0.012
; retract_before_wipe = 0%,0%
; retract_length_toolchange = 2,2
; retract_lift_above = 0,0
; retract_lift_below = 319,319
; retract_restart_extra = 0,0
; retract_restart_extra_toolchange = 0,0
; retract_when_changing_layer = 1,1
; retraction_distances_when_cut = 10,10
; retraction_distances_when_ec = 10,10,10,10,10,10,10,10
; retraction_length = 0.4,0.4
; retraction_minimum_travel = 1,1
; retraction_speed = 30,30
; role_base_wipe_speed = 1
; scan_first_layer = 0
; scarf_angle_threshold = 155
; seam_gap = 0%
; seam_placement_away_from_overhangs = 0
; seam_position = aligned
; seam_slope_conditional = 1
; seam_slope_entire_loop = 0
; seam_slope_gap = 0
; seam_slope_inner_walls = 1
; seam_slope_min_length = 10
; seam_slope_start_height = 10%
; seam_slope_steps = 10
; seam_slope_type = none
; silent_mode = 0
; single_extruder_multi_material = 1
; skeleton_infill_density = 100%
; skeleton_infill_line_width = 0.22
; skin_infill_density = 100%
; skin_infill_depth = 2
; skin_infill_line_width = 0.22
; skirt_distance = 2
; skirt_height = 1
; skirt_loops = 0
; skirt_per_object = 1
; slice_closing_radius = 0.049
; slicing_mode = regular
; slow_down_for_layer_cooling = 1,1,1,1,1,1,1,1
; slow_down_layer_time = 4,4,6,6,4,4,4,4
; slow_down_min_speed = 20,20,20,20,20,20,20,20
; slowdown_end_acc = 100000,100000
; slowdown_end_height = 400,400
; slowdown_end_speed = 1000,1000
; slowdown_start_acc = 100000,100000
; slowdown_start_height = 0,0
; slowdown_start_speed = 1000,1000
; small_perimeter_speed = 50%,50%
; small_perimeter_threshold = 0,0
; smooth_coefficient = 4
; smooth_speed_discontinuity_area = 1
; solid_infill_filament = 0
; sparse_infill_acceleration = 100%,100%
; sparse_infill_anchor = 400%
; sparse_infill_anchor_max = 20
; sparse_infill_density = 100%
; sparse_infill_filament = 0
; sparse_infill_lattice_angle_1 = -45
; sparse_infill_lattice_angle_2 = 45
; sparse_infill_line_width = 0.22
; sparse_infill_pattern = zig-zag
; sparse_infill_speed = 100,100
; spiral_mode = 0
; spiral_mode_max_xy_smoothing = 200%
; spiral_mode_smooth = 0
; standby_temperature_delta = -5
; start_end_points = 30x-3,54x245
; supertack_plate_temp = 40,40,35,35,40,40,40,40
; supertack_plate_temp_initial_layer = 40,40,35,35,40,40,40,40
; support_air_filtration = 0
; support_angle = 0
; support_base_pattern = default
; support_base_pattern_spacing = 2.5
; support_bottom_interface_spacing = 0.5
; support_bottom_z_distance = 0.1
; support_chamber_temp_control = 1
; support_cooling_filter = 1
; support_critical_regions_only = 0
; support_expansion = 0
; support_fast_purge_mode = 0
; support_filament = 0
; support_interface_bottom_layers = 2
; support_interface_filament = 0
; support_interface_loop_pattern = 0
; support_interface_not_for_body = 1
; support_interface_pattern = auto
; support_interface_spacing = 0.5
; support_interface_speed = 80,80
; support_interface_top_layers = 2
; support_ironing_direction = 0
; support_ironing_flow = 10%
; support_ironing_inset = 0
; support_ironing_pattern = zig-zag
; support_ironing_spacing = 0.15
; support_ironing_speed = 30
; support_line_width = 0.22
; support_object_first_layer_gap = 0.2
; support_object_skip_flush = 0
; support_object_xy_distance = 0.35
; support_on_build_plate_only = 0
; support_remove_small_overhang = 1
; support_speed = 150,150
; support_style = default
; support_threshold_angle = 30
; support_top_z_distance = 0.1
; support_type = tree(auto)
; symmetric_infill_y_axis = 0
; temperature_vitrification = 45,45,45,45,45,45,45,45
; template_custom_gcode = 
; textured_plate_temp = 55,55,55,55,55,55,55,55
; textured_plate_temp_initial_layer = 55,55,55,55,55,55,55,55
; thick_bridges = 0
; thumbnail_size = 50x50
; time_lapse_gcode = ;======== H2D 20260731========\n; SKIPPABLE_START\n; SKIPTYPE: timelapse\nM622.1 S1 ; for prev firmware, default turned on\n\nM1002 judge_flag timelapse_record_flag\nM622 J1\n    {if !spiral_mode && !timelapse_inline_photo}\n        M993 A2 B2 C2\n        M993 A0 B0 C0\n    {endif}\n\n    {if timelapse_inline_photo}\n        M971 S11 C10 O0\n        M1004 S5 P1  ; external shutter\n    {else}\n        M622.1 S0 ; for prev firmware, default turn off\n        M1002 set_flag smooth_safe_pos_suppoprt_flag=1\n        M1002 judge_flag smooth_safe_pos_suppoprt_flag\n        \n        M622 J0\n            {if !spiral_mode && !(has_timelapse_safe_pos && timelapse_type == 0) }\n                {if most_used_physical_extruder_id!= curr_physical_extruder_id || timelapse_type == 1}\n                    M83\n                    G1 Z{max_layer_z + 0.4} F1200\n                    M400\n                {endif}\n            {endif}\n\n            {if has_timelapse_safe_pos && timelapse_type == 0 && !spiral_mode}\n                M9711 M{timelapse_type} E{most_used_physical_extruder_id} X{timelapse_pos_x} Y{timelapse_pos_y} Z{layer_z + (farthest_point_timelapse_enabled ? 0.0 : 0.4)} S11 C10 O0 T3000\n            {else}\n                {if spiral_mode}\n                    M971 S11 C10 O0\n                    M1004 S5 P1  ; external shutter\n                {else}\n                    M9711 M{timelapse_type} E{most_used_physical_extruder_id} Z{layer_z + (farthest_point_timelapse_enabled ? 0.0 : 0.4)} S11 C10 O0 T3000\n                {endif}\n            {endif}\n\n            {if !spiral_mode && !(has_timelapse_safe_pos && timelapse_type == 0) }\n                {if most_used_physical_extruder_id!= curr_physical_extruder_id || timelapse_type == 1}\n                    G90\n                    G1 Z{max_layer_z + 3.0} F1200\n                    G1 Y295 F30000\n                    G1 Y265 F18000\n                    M83\n                {endif}\n            {endif}\n        M623\n\n        M622 J1\n            {if !spiral_mode && !(has_timelapse_safe_pos) }\n                {if most_used_physical_extruder_id!= curr_physical_extruder_id || timelapse_type == 1}\n                    M83\n                    G1 Z{max_layer_z + 0.4} F1200\n                    M400\n                {endif}\n            {endif}\n\n            {if has_timelapse_safe_pos && !spiral_mode}\n                M9711 M{timelapse_type} E{most_used_physical_extruder_id} U{timelapse_pos_x} V{timelapse_pos_y} Z{layer_z + (farthest_point_timelapse_enabled ? 0.0 : 0.4)} S11 C10 O0 T3000\n            {else}\n                {if spiral_mode}\n                    M971 S11 C10 O0\n                    M1004 S5 P1  ; external shutter\n                {else}\n                    M9711 M{timelapse_type} E{most_used_physical_extruder_id} Z{layer_z + (farthest_point_timelapse_enabled ? 0.0 : 0.4)} S11 C10 O0 T3000\n                {endif}\n            {endif}\n\n            {if !spiral_mode && !(has_timelapse_safe_pos) }\n                {if most_used_physical_extruder_id!= curr_physical_extruder_id || timelapse_type == 1}\n                    G90\n                    G1 Z{max_layer_z + 3.0} F1200\n                    G1 Y295 F30000\n                    G1 Y265 F18000\n                    M83\n                {endif}\n            {endif}\n        M623\n    {endif}\n    \n    {if !spiral_mode && !timelapse_inline_photo}\n        M993 A3 B3 C3\n    {endif}\nM623\n; SKIPPABLE_END\n
; timelapse_type = 0
; top_area_threshold = 200%
; top_color_penetration_layers = 7
; top_one_wall_type = all top
; top_shell_layers = 7
; top_shell_thickness = 0.8
; top_solid_infill_flow_ratio = 1,1
; top_surface_acceleration = 2000,2000
; top_surface_density = 100%
; top_surface_jerk = 9
; top_surface_line_width = 0.22
; top_surface_pattern = monotonicline
; top_surface_speed = 150,150
; top_z_overrides_xy_distance = 0
; travel_acceleration = 10000,10000
; travel_jerk = 9
; travel_short_distance_acceleration = 250,250
; travel_speed = 1000,1000
; travel_speed_z = 0,0
; tree_support_branch_angle = 45
; tree_support_branch_diameter = 2
; tree_support_branch_diameter_angle = 5
; tree_support_branch_distance = 5
; tree_support_wall_count = -1
; upward_compatible_machine = "Bambu Lab H2D Pro 0.2 nozzle"
; use_firmware_retraction = 0
; use_relative_e_distances = 1
; vertical_shell_speed = 80%,80%
; volumetric_speed_coefficients = "0 0 0 0 0 0";"0 0 0 0 0 0";"0 0 0 0 0 0";"0 0 0 0 0 0";"0 0 0 0 0 0";"0 0 0 0 0 0";"0 0 0 0 0 0";"0 0 0 0 0 0"
; wall_distribution_count = 1
; wall_filament = 0
; wall_generator = arachne
; wall_loops = 4
; wall_sequence = inner wall/outer wall
; wall_transition_angle = 10
; wall_transition_filter_deviation = 25%
; wall_transition_length = 100%
; wipe = 1,1
; wipe_distance = 2,2
; wipe_speed = 80%
; wipe_tower_no_sparse_layers = 0
; wipe_tower_rotation_angle = 0
; wipe_tower_x = 40
; wipe_tower_y = 210
; wrapping_detection_gcode = ;======== H2D 20250729 clumping ========\n{if !spiral_mode}\n    M622.1 S0 ; for previous firmware, default turn off\n    M1002 set_flag g39_forced_detection_flag=1\n    M1002 judge_flag g39_forced_detection_flag\n    M622 J1\n        {if layer_num == 3 || layer_num == 10 || layer_num == 19}\n            M993 A2 B2 C2 ; nozzle cam detection allow status save.\n            M993 A0 B0 C0 ; nozzle cam detection not allowed.\n\n            M400 P100\n\n            G39\n\n            G90\n            G1 Y295 F30000\n            G1 Y265 F18000\n            \n            M993 A3 B3 C3 ; nozzle cam detection allow status restore.\n        {endif}\n    M623\n{endif}\n
; wrapping_detection_layers = 20
; wrapping_exclude_area = 145x310,256x310,256x326,145x326
; xy_contour_compensation = 0
; xy_hole_compensation = 0
; z_direction_outwall_speed_continuous = 1
; z_hop = 0.4,0.4
; z_hop_types = Auto Lift,Auto Lift
; CONFIG_BLOCK_END

; EXECUTABLE_BLOCK_START
M73 P0 R16
M201 X20000 Y20000 Z500 E5000
M203 X1000 Y1000 Z30 E50
M204 P20000 R5000 T20000
M205 X9.00 Y9.00 Z3.00 E2.50
M106 S0
M106 P2 S0
; FEATURE: Custom
;===== machine: H2D =========================
;===== date: 20260605 =====================

;M1002 set_flag extrude_cali_flag=1
;M1002 set_flag g29_before_print_flag=1
;M1002 set_flag auto_cali_toolhead_offset_flag=1
;M1002 set_flag build_plate_detect_flag=1

M993 A0 B0 C0 ; nozzle cam detection not allowed.

M400
;M73 P99

M960 S10 P1 ; ext fan led

;=====printer start sound ===================
M17
M400 S1
M1006 S1
M1006 A53 B9 L99 C53 D9 M99 E53 F9 N99
M1006 A56 B9 L99 C56 D9 M99 E56 F9 N99
M1006 A61 B9 L99 C61 D9 M99 E61 F9 N99
M1006 A53 B9 L99 C53 D9 M99 E53 F9 N99
M1006 A56 B9 L99 C56 D9 M99 E56 F9 N99
M1006 A61 B18 L99 C61 D18 M99 E61 F18 N99
M1006 W
;=====printer start sound ===================

;===== reset machine status =================
M204 S10000
M630 S0 P0

G90
M17 D ; reset motor current to default
M960 S5 P1 ; turn on logo lamp
G90
M1002 set_gcode_claim_speed_level 5 ;Reset speed level
M220 S100 ;Reset Feedrate
M221 S100 ;Reset Flowrate
M73.2   R1.0 ;Reset left time magnitude
G29.1 Z0 ; clear z-trim value first
M983.1 M1
M901 D4
M481 S0 ; turn off cutter pos comp
G28.140 D0; reset pre-extrude z pos
;===== reset machine status =================

M620 M ;enable remap

;===== avoid end stop =================
G91
G380 S2 Z42 F1200
G380 S2 Z-12 F1200
G90
;===== avoid end stop =================

;==== set airduct mode ====


    M145 P0 ; set airduct mode to cooling mode for cooling
    M106 P2 S178 ; turn on auxiliary fan for cooling
    M106 P3 S127 ; turn on chamber fan for cooling
    M140 S0 ; stop heatbed from heating

    M1002 gcode_claim_action : 29
    M191 S0 ; wait for chamber temp
    M106 P2 S0 ; turn off auxiliary fan
    
        
            M142 P1 R30 S35 T40 U0.3 V0.5 W0.8 O40 ; set PLA/TPU ND0.2 chamber autocooling
        
    
    
        M145.2 P0 F1
    


;==== set airduct mode ====

;===== start to heat heatbed & hotend==========

    M1002 set_filament_type:PLA

    M104 S140 A
    M140 S55

    ;===== set chamber temperature ==========
    
    ;===== set chamber temperature ==========

;===== start to heat heatbead & hotend==========

;====== cog noise reduction=================
M982.2 S1 ; turn on cog noise reduction

;===== first homing start =====
M1002 gcode_claim_action : 13

G28 X T300

G150.1 F18000 ; wipe mouth to avoid filament stick to heatbed
G150.3 F18000
M400 P200
M972 S24 P0 T2000

M1002 gcode_claim_action : 74 ; Heatbed surface foreign object detection

M972 S26 P0 C0

M972 S35 P0 C0

M972 S41 P0 T5000 ; trash can anti-collision

M1009 Q1 L1
G91
G380 S2 Z30 F1200 ; lower heatbed to move toolhead
G90
G1 X175 Y160 F30000
G28 Z P0 T250
M1009 Q1 L0

;===== first homing end =====

M400
;M73 P99

;===== detection start =====

M1002 judge_flag build_plate_detect_flag
M622 S1
    ;M1002 gcode_claim_action : 11 ; Indentifying build plate type
    M972 S19 P0 C0    ; heatbed presence detection
    M972 S31 P0 T5000 ; toolhead camera dirty detection
    ;M1002 gcode_claim_action : 73 ; Build plate alignment detection
    M972 S34 P0 T5000 ; heatbed plate offset detection
M623

M1002 gcode_claim_action : 72 ; Hotend Type Detection
T1001
M972 S14 P0 T5000 ; nozzle type detection

M104 S220 T0 ; rise temp in advance

G151 P0 M ; plug the heat nozzle



;===== detection end =====

M400
;M73 P99

;===== prepare print temperature and material ==========
M400
M211 X0 Y0 Z0 ;turn off soft endstop
M975 S1 ; turn on input shaping

G29.2 S0 ; avoid invalid abl data


M620.10 A0 F74.8347 H0.2 T240 P220 S1
M620.10 A1 F74.8347 H0.2 T240 P220 S1


M620.11 P0 I0 B-1 E0


M620.11 K1 I0 B-1 R10 F200


M628 S1


    M620.11 S1 L0 I0 B-1 R10 D8 E-10 F49.8898


M629

M620 S0A H-1 ; switch material if AMS exist
M1002 gcode_claim_action : 4
M1002 set_filament_type:UNKNOWN
M400
T0 H-1
M400
M628 S0
M629
M400
M1002 set_filament_type:PLA
M621 S0A

M104 S220
M400
M106 P1 S0

G29.2 S1
;===== prepare print temperature and material ==========

M400
;M73 P99

;===== auto extrude cali start =========================
M975 S1
M1002 judge_flag extrude_cali_flag

M622 J0
    M983.3 F0.833333 A0.4 ; cali dynamic extrusion compensation
M623

M622 J1
    M1002 set_filament_type:PLA
    M1002 gcode_claim_action : 8

    M109 S220

    G90
    M83
    M983.3 F0.833333 A0.4 ; cali dynamic extrusion compensation

    M400
    M106 P1 S255
    M400 S5
    M106 P1 S0
    G150.3
M623

M622 J2
    M1002 set_filament_type:PLA
    M1002 gcode_claim_action : 8

    M109 S220

    G90
    M83
    M983.3 F0.833333 A0.4 ; cali dynamic extrusion compensation

    M400
    M106 P1 S255
    M400 S5
    M106 P1 S0
    G150.3
M623

;===== auto extrude cali end =========================


    M106 P1 S0
    M400 S2
    M109 S220 ; wait tmpr to extrude
    M83
    
        G1 E45 F49.8898
    
    G1 E-3 F1800
    M400 P500
    G150.2
    G150.1


G91
M73 P2 R16
G1 Y-16 F12000 ; move away from the trash bin
G90

M400
;M73 P99

;===== wipe right nozzle start =====

M1002 gcode_claim_action : 14
    G150 T220
    
M106 S255 ; turn on fan to cool the nozzle

;===== wipe left nozzle end =====

M400
;M73 P99



M400
;M73 P99

;===== bed leveling ==================================

M1002 judge_flag g29_before_print_flag

M190 S55; ensure bed temp
M109 S140 A
M106 S0 ; turn off fan , too noisy

G91
M73 P9 R15
G1 Z5 F1200
G90
G1 X175 Y160 F30000

M622 J1
    M1002 gcode_claim_action : 1
    G29.20 A3
    G29 A1 O X120 Y110 I74 J22 R
    M400
M623

M622 J2
    M1002 gcode_claim_action : 1
    
        G29.20 A4
        G29 A2 O X120 Y110 I74 J22 R
    
    M400
M623

M622 J0
    G28 R
M623

;===== bed leveling end ================================

;===== z ofst cali start =====

    M190 S55; ensure bed temp

    G383 O0 M2 T140

;===== z ofst cali end =====

G39.1 ; cali nozzle wrapped detection pos

G90
M73 P35 R10
G1 Z5 F1200
G1 X270 Y-0.5 F60000
G28.140 S0 ; cali pre-extrude z pos

M141 S0
M104 S220 A

;===== mech mode sweep start =====
    M1002 gcode_claim_action : 3

    G90
    G1 Z5 F1200
    G1 X187 Y160 F20000
    T1000
    M400 P200

    M970.3 Q1 A5 K0 O1
    M974 Q1 S2 P0

    M970.3 Q0 A5 K0 O1
    M974 Q0 S2 P0

    M970.2 Q2 K0 W38 Z0.01
    M974 Q2 S2 P0

    M975 S1
;===== mech mode sweep end =====

M400
;M73 P99

G150.3 ; move to garbage can to wait for temp
M1026
G29.9

;===== xy ofst cali start =====

M1002 judge_flag auto_cali_toolhead_offset_flag

M622 J0
    M1012.5 N1 R1
M623

M622 J1
    M1002 gcode_claim_action : 39
    M141 S0
    M620.17 T0 S220 L0
    M620.17 T1 S220 L0
    M620 D-1
    G383 O1 T220 L0
    M141 S0
M623

M622 J2
    M1002 gcode_claim_action : 39
    M141 S0
    M620.17 T0 S220 L0
    M620.17 T1 S220 L0
    M620 D-1
    G383.3 T220 L0
    M141 S0
M623
;===== xy ofst cali end =====

M400
;M73 P99

M1002 gcode_claim_action : 0
M400

;============switch again==================
M211 X0 Y0 Z0 ;turn off soft endstop
G91
G1 Z6 F1200
G90
M1002 set_filament_type:PLA
M620 S0A H-1
M400
T0 H-1
M400
M628 S0
M629
M400
M621 S0A

;============switch again==================

M400
;M73 P99

;===== wait temperature reaching the reference value =======

M104 S220 ; rise to print tmpr

M140 S55
M190 S55

    ;========turn off light and fans =============
    M960 S1 P0 ; turn off laser
    M960 S2 P0 ; turn off laser
    M106 S0 ; turn off fan
    M106 P2 S0 ; turn off big fan
    ;==== set ext toodhead cooling fan ====
    
    M106 P9 S255
    
    ;============set motor current==================
    M400 S1

;===== wait temperature reaching the reference value =======

M400
;M73 P99

;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==
    
        
            G29.1 Z-0.01 ; for Textured PEI Plate
        
    

G150.1

M975 S1 ; turn on mech mode supression
M983.4 S1 ; turn on deformation compensation
G29.2 S1 ; turn on pos comp
G29.7 S1

G90
G1 Z5 F1200
G1 Y295 F30000
G1 Y265 F18000

;===== nozzle load line ===============================
    G29.2 S1 ; ensure z comp turn on
    G90
    M83
    G1 Z5 F1200
    G1 X270 Y-0.5 F60000
    G28.14 R0
    G29.2 S0
    G91
    G1 Z0.8 F1200
    G90
    G1 X250 F60000
    M400 P50
    M500 D1
    M400 S3
    M109 S220
    M83


    G1 E5 F49.8898
    G1 X290 E10 F49.8898
    G91
    G3 Z0.4 I1.217 J0 P1 F60000
    G90
    M83
    G29.2 S1 ; ensure z comp turn on
;===== noozle load line end ===========================

M400
;M73 P99

M993 A1 B1 C1 ; nozzle cam detection allowed.


M1015.3 S0;disable tpu clog detect



M1015.4 S1 K1 H0.2 ;enable E air printing detect


M620.6 I0 H-1 W1 ;enable ams air printing detect
M620 Q1

M211 Z1
G29.99
; MACHINE_START_GCODE_END
; filament start gcode
;VT0 H-1
G90
G21
M83 ; use relative distances for extrusion
M981 S1 P20000 ;open spaghetti detector
; CHANGE_LAYER
; Z_HEIGHT: 0.1
; LAYER_HEIGHT: 0.1
G1 E-.4 F1800
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 1/7
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change

M106 S0
M106 P2 S0
; OBJECT_ID: 5909
; start printing object, unique label id: 5909
M624 AgAAAAAAAAA=
M73 P36 R10
G1 X166.052 Y130.252 F60000
M204 S6000
M73 P41 R9
G1 Z.4
G1 Z.1
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.24999
G1 F2400
M204 S500
G1 X165.961 Y130.239 E.00086
G1 X164.839 Y130.239 E.01044
G1 X164.528 Y130.303 E.00296
G1 X164.242 Y130.507 E.00327
G1 X164.039 Y131.039 E.0053
G1 X162.398 Y131.039 E.01528
G1 X160.961 Y129.602 E.01893
G1 X160.961 Y110.961 E.17357
G1 X193.039 Y110.961 E.29869
G1 X193.039 Y121 E.09348
G1 X193.039 Y131.039 E.09348
G1 X168.761 Y131.039 E.22606
G1 X168.595 Y130.553 E.00479
G1 X168.434 Y130.394 E.00211
G1 X168.262 Y130.298 E.00183
G1 X167.961 Y130.239 E.00286
G1 X166.783 Y130.241 E.01097
G1 X166.446 Y130.343 E.00328
G1 X166.4 Y130.422 E.00085
G1 X166.354 Y130.343 E.00085
G1 X166.178 Y130.269 E.00177
G1 X166.052 Y130.252 E.00119
M204 S6000
G1 X166.059 Y130.494 F60000
G1 F2400
M204 S500
G1 X165.961 Y130.468 E.00095
G1 X164.839 Y130.468 E.01044
G1 X164.617 Y130.513 E.00212
G1 X164.413 Y130.659 E.00234
G1 X164.268 Y131.039 E.00379
G1 X164.268 Y131.268 E.00213
G1 X162.303 Y131.268 E.01829
G1 X160.732 Y129.697 E.02069
G1 X160.732 Y110.732 E.17658
G1 X193.268 Y110.732 E.30295
G1 X193.268 Y121 E.09561
G1 X193.268 Y131.268 E.09561
G1 X168.532 Y131.268 E.23032
G1 X168.532 Y131.039 E.00213
G1 X168.414 Y130.692 E.00342
G1 X168.225 Y130.533 E.0023
G1 X167.961 Y130.468 E.00253
G1 X166.839 Y130.468 E.01044
G1 X166.558 Y130.542 E.0027
G1 X166.4 Y130.813 E.00292
G1 X166.242 Y130.542 E.00292
G1 X166.059 Y130.494 E.00176
M204 S6000
G1 X166.01 Y130.709 F60000
G1 F2400
M204 S500
G1 X165.961 Y130.696 E.00047
G1 X164.839 Y130.696 E.01044
G1 X164.631 Y130.767 E.00205
G1 X164.496 Y131.039 E.00283
G1 X164.496 Y131.496 E.00426
G1 X162.209 Y131.496 E.0213
G1 X160.504 Y129.791 E.02245
G1 X160.504 Y110.504 E.17959
G1 X193.496 Y110.504 E.3072
G1 X193.496 Y121 E.09773
G1 X193.496 Y131.496 E.09773
; object ids of layer 1 start: 5887,5909
M624 AwAAAAAAAAA=
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

; object ids of this layer1 end: 5887,5909
M625
G1 X168.304 Y131.496 E.23458
M73 P42 R9
G1 X168.304 Y131.039 E.00426
G1 X168.233 Y130.831 E.00205
G1 X168.163 Y130.763 E.0009
G1 X167.961 Y130.696 E.00199
G1 X166.839 Y130.696 E.01044
G1 X166.671 Y130.741 E.00162
G1 X166.505 Y131.039 E.00318
; LINE_WIDTH: 0.2322
G1 X166.505 Y131.505 E.004
G1 X166.295 Y131.505 E.00181
G1 X166.295 Y131.039 E.004
; LINE_WIDTH: 0.24999
G1 X166.129 Y130.741 E.00318
G1 X166.01 Y130.709 E.00115
M204 S6000
G1 X165.961 Y130.925 F60000
; FEATURE: Outer wall
G1 F2400
M204 S500
G1 X164.795 Y130.934 E.01086
G1 X164.725 Y131.039 E.00118
G1 X164.725 Y131.725 E.00639
G1 X162.114 Y131.725 E.02431
G1 X160.275 Y129.886 E.02421
G1 X160.275 Y110.275 E.1826
G1 X193.725 Y110.275 E.31146
G1 X193.725 Y121 E.09986
G1 X193.725 Y131.725 E.09986
G1 X168.075 Y131.725 E.23883
G1 X168.051 Y130.97 E.00704
G1 X167.961 Y130.925 E.00094
G1 X166.829 Y130.926 E.01054
G1 X166.725 Y131.039 E.00143
G1 X166.725 Y131.725 E.00639
G1 X166.075 Y131.725 E.00605
G1 X166.075 Y131.039 E.00639
G1 X166.017 Y130.94 E.00107
G1 X165.961 Y130.925 E.00054
; WIPE_START
G1 X164.795 Y130.934 E-.22155
G1 X164.725 Y131.039 E-.02399
G1 X164.725 Y131.725 E-.13029
G1 X164.703 Y131.725 E-.00418
; WIPE_END
G1 E-.02 F1800
M204 S6000
G1 X170.91 Y127.283 Z.5 F60000
G1 X192.959 Y111.503 Z.5
G1 Z.1
G1 E.4 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.2503
G1 F4200
M204 S500
G1 X192.6 Y111.143 E.00474
G1 X192.276 Y111.143 E.00302
G1 X192.857 Y111.724 E.00766
G1 X192.857 Y112.048 E.00302
G1 X191.952 Y111.143 E.01192
G1 X191.629 Y111.143 E.00302
G1 X192.857 Y112.371 E.01619
G1 X192.857 Y112.695 E.00302
G1 X191.305 Y111.143 E.02046
G1 X190.981 Y111.143 E.00302
G1 X192.857 Y113.019 E.02472
G1 X192.857 Y113.342 E.00302
G1 X190.658 Y111.143 E.02899
G1 X190.334 Y111.143 E.00302
G1 X192.857 Y113.666 E.03326
G1 X192.857 Y113.989 E.00302
G1 X190.011 Y111.143 E.03753
G1 X189.687 Y111.143 E.00302
G1 X192.857 Y114.313 E.04179
G1 X192.857 Y114.637 E.00302
G1 X189.363 Y111.143 E.04606
G1 X189.04 Y111.143 E.00302
G1 X192.857 Y114.96 E.05033
G1 X192.857 Y115.284 E.00302
G1 X188.716 Y111.143 E.0546
G1 X188.392 Y111.143 E.00302
G1 X192.857 Y115.608 E.05886
G1 X192.857 Y115.931 E.00302
G1 X188.069 Y111.143 E.06313
G1 X187.745 Y111.143 E.00302
G1 X192.857 Y116.255 E.0674
G1 X192.857 Y116.578 E.00302
G1 X187.422 Y111.143 E.07167
G1 X187.098 Y111.143 E.00302
G1 X192.857 Y116.902 E.07593
G1 X192.857 Y117.226 E.00302
G1 X186.774 Y111.143 E.0802
G1 X186.451 Y111.143 E.00302
G1 X192.857 Y117.549 E.08447
G1 X192.857 Y117.873 E.00302
G1 X186.127 Y111.143 E.08873
G1 X185.803 Y111.143 E.00302
G1 X192.857 Y118.197 E.093
G1 X192.857 Y118.52 E.00302
G1 X185.48 Y111.143 E.09727
G1 X185.156 Y111.143 E.00302
G1 X192.857 Y118.844 E.10154
G1 X192.857 Y119.167 E.00302
G1 X184.833 Y111.143 E.1058
G1 X184.509 Y111.143 E.00302
G1 X192.857 Y119.491 E.11007
G1 X192.857 Y119.815 E.00302
G1 X184.185 Y111.143 E.11434
G1 X183.862 Y111.143 E.00302
M73 P43 R9
G1 X192.857 Y120.138 E.11861
G1 X192.857 Y120.462 E.00302
G1 X183.538 Y111.143 E.12287
G1 X183.214 Y111.143 E.00302
G1 X192.857 Y120.786 E.12714
G1 X192.857 Y121.109 E.00302
G1 X182.891 Y111.143 E.13141
G1 X182.567 Y111.143 E.00302
G1 X192.857 Y121.433 E.13567
G1 X192.857 Y121.756 E.00302
G1 X182.244 Y111.143 E.13994
G1 X181.92 Y111.143 E.00302
G1 X192.857 Y122.08 E.14421
G1 X192.857 Y122.404 E.00302
G1 X181.596 Y111.143 E.14848
G1 X181.273 Y111.143 E.00302
G1 X192.857 Y122.727 E.15274
G1 X192.857 Y123.051 E.00302
G1 X180.949 Y111.143 E.15701
G1 X180.625 Y111.143 E.00302
G1 X192.857 Y123.375 E.16128
G1 X192.857 Y123.698 E.00302
G1 X180.302 Y111.143 E.16555
G1 X179.978 Y111.143 E.00302
G1 X192.857 Y124.022 E.16981
G1 X192.857 Y124.346 E.00302
G1 X179.654 Y111.143 E.17408
G1 X179.331 Y111.143 E.00302
G1 X192.857 Y124.669 E.17835
G1 X192.857 Y124.993 E.00302
G1 X179.007 Y111.143 E.18262
G1 X178.684 Y111.143 E.00302
G1 X192.857 Y125.316 E.18688
G1 X192.857 Y125.64 E.00302
G1 X178.36 Y111.143 E.19115
G1 X178.036 Y111.143 E.00302
G1 X192.857 Y125.964 E.19542
G1 X192.857 Y126.287 E.00302
G1 X177.713 Y111.143 E.19968
G1 X177.389 Y111.143 E.00302
G1 X192.857 Y126.611 E.20395
G1 X192.857 Y126.935 E.00302
G1 X177.065 Y111.143 E.20822
G1 X176.742 Y111.143 E.00302
G1 X192.857 Y127.258 E.21249
G1 X192.857 Y127.582 E.00302
G1 X176.418 Y111.143 E.21675
G1 X176.095 Y111.143 E.00302
G1 X192.857 Y127.905 E.22102
G1 X192.857 Y128.229 E.00302
G1 X175.771 Y111.143 E.22529
G1 X175.447 Y111.143 E.00302
M73 P44 R9
G1 X192.857 Y128.553 E.22956
G1 X192.857 Y128.876 E.00302
G1 X175.124 Y111.143 E.23382
G1 X174.8 Y111.143 E.00302
G1 X192.857 Y129.2 E.23809
G1 X192.857 Y129.524 E.00302
G1 X174.476 Y111.143 E.24236
G1 X174.153 Y111.143 E.00302
G1 X192.857 Y129.847 E.24662
G1 X192.857 Y130.171 E.00302
G1 X173.829 Y111.143 E.25089
G1 X173.506 Y111.143 E.00302
G1 X192.857 Y130.494 E.25516
G1 X192.857 Y130.818 E.00302
G1 X173.182 Y111.143 E.25943
G1 X172.858 Y111.143 E.00302
G1 X192.571 Y130.857 E.25993
G1 X192.248 Y130.857 E.00302
G1 X172.535 Y111.143 E.25993
G1 X172.211 Y111.143 E.00302
G1 X191.924 Y130.857 E.25993
G1 X191.601 Y130.857 E.00302
G1 X171.887 Y111.143 E.25993
G1 X171.564 Y111.143 E.00302
G1 X191.277 Y130.857 E.25993
G1 X190.953 Y130.857 E.00302
G1 X171.24 Y111.143 E.25993
G1 X170.917 Y111.143 E.00302
G1 X190.63 Y130.857 E.25993
G1 X190.306 Y130.857 E.00302
G1 X170.593 Y111.143 E.25993
G1 X170.269 Y111.143 E.00302
G1 X189.982 Y130.857 E.25993
G1 X189.659 Y130.857 E.00302
G1 X169.946 Y111.143 E.25993
G1 X169.622 Y111.143 E.00302
G1 X189.335 Y130.857 E.25993
G1 X189.012 Y130.857 E.00302
G1 X169.298 Y111.143 E.25993
G1 X168.975 Y111.143 E.00302
M73 P45 R9
G1 X188.688 Y130.857 E.25993
G1 X188.364 Y130.857 E.00302
G1 X168.651 Y111.143 E.25993
G1 X168.327 Y111.143 E.00302
G1 X188.041 Y130.857 E.25993
G1 X187.717 Y130.857 E.00302
G1 X168.004 Y111.143 E.25993
G1 X167.68 Y111.143 E.00302
G1 X187.393 Y130.857 E.25993
G1 X187.07 Y130.857 E.00302
G1 X167.357 Y111.143 E.25993
G1 X167.033 Y111.143 E.00302
G1 X186.746 Y130.857 E.25993
G1 X186.423 Y130.857 E.00302
G1 X166.709 Y111.143 E.25993
G1 X166.386 Y111.143 E.00302
G1 X186.099 Y130.857 E.25993
G1 X185.775 Y130.857 E.00302
G1 X166.062 Y111.143 E.25993
G1 X165.738 Y111.143 E.00302
G1 X185.452 Y130.857 E.25993
G1 X185.128 Y130.857 E.00302
G1 X165.415 Y111.143 E.25993
G1 X165.091 Y111.143 E.00302
G1 X184.804 Y130.857 E.25993
G1 X184.481 Y130.857 E.00302
G1 X164.768 Y111.143 E.25993
G1 X164.444 Y111.143 E.00302
G1 X184.157 Y130.857 E.25993
G1 X183.834 Y130.857 E.00302
G1 X164.12 Y111.143 E.25993
G1 X163.797 Y111.143 E.00302
G1 X183.51 Y130.857 E.25993
G1 X183.186 Y130.857 E.00302
G1 X163.473 Y111.143 E.25993
G1 X163.149 Y111.143 E.00302
G1 X182.863 Y130.857 E.25993
G1 X182.539 Y130.857 E.00302
G1 X162.826 Y111.143 E.25993
G1 X162.502 Y111.143 E.00302
M73 P46 R9
G1 X182.215 Y130.857 E.25993
G1 X181.892 Y130.857 E.00302
G1 X162.179 Y111.143 E.25993
G1 X161.855 Y111.143 E.00302
G1 X181.568 Y130.857 E.25993
G1 X181.244 Y130.857 E.00302
G1 X161.531 Y111.143 E.25993
G1 X161.208 Y111.143 E.00302
G1 X180.921 Y130.857 E.25993
G1 X180.597 Y130.857 E.00302
G1 X161.143 Y111.403 E.25651
G1 X161.143 Y111.726 E.00302
G1 X180.274 Y130.857 E.25225
G1 X179.95 Y130.857 E.00302
G1 X161.143 Y112.05 E.24798
G1 X161.143 Y112.374 E.00302
G1 X179.626 Y130.857 E.24371
G1 X179.303 Y130.857 E.00302
G1 X161.143 Y112.697 E.23945
G1 X161.143 Y113.021 E.00302
G1 X178.979 Y130.857 E.23518
G1 X178.655 Y130.857 E.00302
G1 X161.143 Y113.345 E.23091
G1 X161.143 Y113.668 E.00302
G1 X178.332 Y130.857 E.22664
G1 X178.008 Y130.857 E.00302
M73 P46 R8
G1 X161.143 Y113.992 E.22238
G1 X161.143 Y114.315 E.00302
G1 X177.685 Y130.857 E.21811
G1 X177.361 Y130.857 E.00302
G1 X161.143 Y114.639 E.21384
G1 X161.143 Y114.963 E.00302
G1 X177.037 Y130.857 E.20957
G1 X176.714 Y130.857 E.00302
G1 X161.143 Y115.286 E.20531
G1 X161.143 Y115.61 E.00302
G1 X176.39 Y130.857 E.20104
G1 X176.066 Y130.857 E.00302
G1 X161.143 Y115.934 E.19677
G1 X161.143 Y116.257 E.00302
M73 P47 R8
G1 X175.743 Y130.857 E.1925
G1 X175.419 Y130.857 E.00302
G1 X161.143 Y116.581 E.18824
G1 X161.143 Y116.904 E.00302
G1 X175.096 Y130.857 E.18397
G1 X174.772 Y130.857 E.00302
G1 X161.143 Y117.228 E.1797
G1 X161.143 Y117.552 E.00302
G1 X174.448 Y130.857 E.17544
G1 X174.125 Y130.857 E.00302
G1 X161.143 Y117.875 E.17117
G1 X161.143 Y118.199 E.00302
G1 X173.801 Y130.857 E.1669
G1 X173.477 Y130.857 E.00302
G1 X161.143 Y118.523 E.16263
G1 X161.143 Y118.846 E.00302
G1 X173.154 Y130.857 E.15837
G1 X172.83 Y130.857 E.00302
G1 X161.143 Y119.17 E.1541
G1 X161.143 Y119.493 E.00302
G1 X172.507 Y130.857 E.14983
G1 X172.183 Y130.857 E.00302
G1 X161.143 Y119.817 E.14556
G1 X161.143 Y120.141 E.00302
G1 X171.859 Y130.857 E.1413
G1 X171.536 Y130.857 E.00302
G1 X161.143 Y120.464 E.13703
G1 X161.143 Y120.788 E.00302
G1 X171.212 Y130.857 E.13276
G1 X170.888 Y130.857 E.00302
G1 X161.143 Y121.112 E.1285
G1 X161.143 Y121.435 E.00302
G1 X170.565 Y130.857 E.12423
G1 X170.241 Y130.857 E.00302
G1 X161.143 Y121.759 E.11996
G1 X161.143 Y122.083 E.00302
G1 X169.917 Y130.857 E.11569
G1 X169.594 Y130.857 E.00302
G1 X161.143 Y122.406 E.11143
G1 X161.143 Y122.73 E.00302
G1 X169.27 Y130.857 E.10716
G1 X168.947 Y130.857 E.00302
G1 X168.854 Y130.764 E.00122
G1 X168.746 Y130.445 E.00313
G1 X168.542 Y130.246 E.00266
G1 X168.28 Y130.11 E.00275
G1 X168.171 Y130.081 E.00106
G1 X161.143 Y123.053 E.09266
G1 X161.143 Y123.377 E.00302
G1 X167.823 Y130.057 E.08808
G1 X167.5 Y130.057 E.00301
G1 X161.143 Y123.701 E.08382
G1 X161.143 Y124.024 E.00302
G1 X167.177 Y130.058 E.07956
G1 X166.854 Y130.059 E.00301
G1 X161.143 Y124.348 E.0753
G1 X161.143 Y124.672 E.00302
G1 X166.567 Y130.095 E.07152
G1 X166.4 Y130.165 E.00169
G1 X166.251 Y130.103 E.00151
G1 X161.143 Y124.995 E.06735
G1 X161.143 Y125.319 E.00302
G1 X165.883 Y130.059 E.0625
G1 X165.559 Y130.058 E.00302
G1 X161.143 Y125.642 E.05822
G1 X161.143 Y125.966 E.00302
G1 X165.235 Y130.057 E.05395
G1 X164.91 Y130.057 E.00302
G1 X161.143 Y126.29 E.04967
M73 P48 R8
G1 X161.143 Y126.613 E.00302
G1 X164.616 Y130.086 E.04579
G1 X164.456 Y130.134 E.00156
G1 X164.383 Y130.176 E.00078
G1 X161.143 Y126.937 E.04271
G1 X161.143 Y127.261 E.00302
G1 X164.19 Y130.307 E.04017
G1 X164.098 Y130.392 E.00117
G1 X164.058 Y130.498 E.00106
G1 X161.143 Y127.584 E.03843
G1 X161.143 Y127.908 E.00302
G1 X163.968 Y130.733 E.03725
G1 X163.921 Y130.857 E.00123
G1 X163.769 Y130.857 E.00142
G1 X161.143 Y128.231 E.03461
G1 X161.143 Y128.555 E.00302
G1 X163.445 Y130.857 E.03035
G1 X163.121 Y130.857 E.00302
G1 X161.143 Y128.879 E.02608
G1 X161.143 Y129.202 E.00302
G1 X162.798 Y130.857 E.02181
G1 X162.474 Y130.857 E.00302
G1 X161.041 Y129.423 E.0189
; OBJECT_ID: 5887
; WIPE_START
G1 X162.455 Y130.837 E-.38
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 5909
M625
; start printing object, unique label id: 5887
M624 AQAAAAAAAAA=
M204 S6000
G1 X154.823 Y130.718 Z.5 F60000
G1 X126.106 Y130.27 Z.5
G1 Z.1
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.24999
G1 F2400
M204 S500
G1 X125.961 Y130.239 E.00138
G1 X124.839 Y130.239 E.01044
G1 X124.528 Y130.303 E.00296
G1 X124.242 Y130.507 E.00327
G1 X124.039 Y131.039 E.0053
G1 X122.398 Y131.039 E.01528
G1 X120.961 Y129.602 E.01893
G1 X120.961 Y110.961 E.17357
G1 X153.039 Y110.961 E.29869
G1 X153.039 Y121 E.09348
G1 X153.039 Y131.039 E.09348
G1 X126.761 Y131.039 E.24468
G1 X126.61 Y130.572 E.00457
G1 X126.453 Y130.409 E.00211
G1 X126.28 Y130.306 E.00188
G1 X126.106 Y130.27 E.00166
M204 S6000
G1 X126.068 Y130.496 F60000
G1 F2400
M204 S500
G1 X125.961 Y130.468 E.00103
G1 X124.839 Y130.468 E.01044
G1 X124.617 Y130.513 E.00212
G1 X124.413 Y130.659 E.00234
G1 X124.268 Y131.039 E.00379
G1 X124.268 Y131.268 E.00213
G1 X122.303 Y131.268 E.01829
G1 X120.732 Y129.697 E.02069
G1 X120.732 Y110.732 E.17658
G1 X153.268 Y110.732 E.30295
G1 X153.268 Y121 E.09561
G1 X153.268 Y131.268 E.09561
G1 X126.532 Y131.268 E.24894
G1 X126.532 Y131.039 E.00213
G1 X126.424 Y130.705 E.00327
G1 X126.238 Y130.54 E.00232
G1 X126.068 Y130.496 E.00164
M204 S6000
G1 X126.022 Y130.718 F60000
G1 F2400
M204 S500
G1 X125.961 Y130.696 E.0006
G1 X124.839 Y130.696 E.01044
G1 X124.631 Y130.767 E.00205
G1 X124.496 Y131.039 E.00283
G1 X124.496 Y131.496 E.00426
G1 X122.209 Y131.496 E.0213
G1 X120.504 Y129.791 E.02245
G1 X120.504 Y110.504 E.17959
G1 X153.496 Y110.504 E.3072
G1 X153.496 Y121 E.09773
G1 X153.496 Y131.496 E.09773
G1 X126.304 Y131.496 E.2532
G1 X126.304 Y131.039 E.00426
M73 P49 R8
G1 X126.239 Y130.839 E.00196
G1 X126.172 Y130.769 E.0009
G1 X126.022 Y130.718 E.00147
M204 S6000
G1 X125.961 Y130.925 F60000
; FEATURE: Outer wall
G1 F2400
M204 S500
G1 X124.795 Y130.934 E.01086
G1 X124.725 Y131.039 E.00118
G1 X124.725 Y131.725 E.00639
G1 X122.114 Y131.725 E.02431
G1 X120.275 Y129.886 E.02421
G1 X120.275 Y110.275 E.1826
G1 X153.725 Y110.275 E.31146
G1 X153.725 Y121 E.09986
G1 X153.725 Y131.725 E.09986
G1 X126.075 Y131.725 E.25745
G1 X126.053 Y130.973 E.00701
G1 X125.961 Y130.925 E.00097
; WIPE_START
G1 X124.795 Y130.934 E-.22155
G1 X124.725 Y131.039 E-.02399
G1 X124.725 Y131.725 E-.13029
G1 X124.703 Y131.725 E-.00418
; WIPE_END
G1 E-.02 F1800
M204 S6000
G1 X130.91 Y127.283 Z.5 F60000
G1 X152.959 Y111.503 Z.5
G1 Z.1
G1 E.4 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.2503
G1 F4200
M204 S500
G1 X152.6 Y111.143 E.00474
G1 X152.276 Y111.143 E.00302
G1 X152.857 Y111.724 E.00766
G1 X152.857 Y112.048 E.00302
G1 X151.952 Y111.143 E.01192
G1 X151.629 Y111.143 E.00302
G1 X152.857 Y112.371 E.01619
G1 X152.857 Y112.695 E.00302
G1 X151.305 Y111.143 E.02046
G1 X150.981 Y111.143 E.00302
G1 X152.857 Y113.019 E.02472
G1 X152.857 Y113.342 E.00302
G1 X150.658 Y111.143 E.02899
G1 X150.334 Y111.143 E.00302
G1 X152.857 Y113.666 E.03326
G1 X152.857 Y113.989 E.00302
G1 X150.011 Y111.143 E.03753
G1 X149.687 Y111.143 E.00302
G1 X152.857 Y114.313 E.04179
G1 X152.857 Y114.637 E.00302
G1 X149.363 Y111.143 E.04606
G1 X149.04 Y111.143 E.00302
G1 X152.857 Y114.96 E.05033
G1 X152.857 Y115.284 E.00302
G1 X148.716 Y111.143 E.0546
G1 X148.392 Y111.143 E.00302
G1 X152.857 Y115.608 E.05886
G1 X152.857 Y115.931 E.00302
G1 X148.069 Y111.143 E.06313
G1 X147.745 Y111.143 E.00302
G1 X152.857 Y116.255 E.0674
G1 X152.857 Y116.578 E.00302
G1 X147.422 Y111.143 E.07167
G1 X147.098 Y111.143 E.00302
G1 X152.857 Y116.902 E.07593
G1 X152.857 Y117.226 E.00302
G1 X146.774 Y111.143 E.0802
G1 X146.451 Y111.143 E.00302
G1 X152.857 Y117.549 E.08447
G1 X152.857 Y117.873 E.00302
G1 X146.127 Y111.143 E.08873
G1 X145.803 Y111.143 E.00302
G1 X152.857 Y118.197 E.093
G1 X152.857 Y118.52 E.00302
G1 X145.48 Y111.143 E.09727
G1 X145.156 Y111.143 E.00302
G1 X152.857 Y118.844 E.10154
G1 X152.857 Y119.167 E.00302
G1 X144.833 Y111.143 E.1058
G1 X144.509 Y111.143 E.00302
G1 X152.857 Y119.491 E.11007
G1 X152.857 Y119.815 E.00302
G1 X144.185 Y111.143 E.11434
G1 X143.862 Y111.143 E.00302
G1 X152.857 Y120.138 E.11861
G1 X152.857 Y120.462 E.00302
G1 X143.538 Y111.143 E.12287
G1 X143.214 Y111.143 E.00302
M73 P50 R8
G1 X152.857 Y120.786 E.12714
G1 X152.857 Y121.109 E.00302
G1 X142.891 Y111.143 E.13141
G1 X142.567 Y111.143 E.00302
G1 X152.857 Y121.433 E.13567
G1 X152.857 Y121.756 E.00302
G1 X142.244 Y111.143 E.13994
G1 X141.92 Y111.143 E.00302
G1 X152.857 Y122.08 E.14421
G1 X152.857 Y122.404 E.00302
G1 X141.596 Y111.143 E.14848
G1 X141.273 Y111.143 E.00302
G1 X152.857 Y122.727 E.15274
G1 X152.857 Y123.051 E.00302
G1 X140.949 Y111.143 E.15701
G1 X140.625 Y111.143 E.00302
G1 X152.857 Y123.375 E.16128
G1 X152.857 Y123.698 E.00302
G1 X140.302 Y111.143 E.16555
G1 X139.978 Y111.143 E.00302
G1 X152.857 Y124.022 E.16981
G1 X152.857 Y124.346 E.00302
G1 X139.654 Y111.143 E.17408
G1 X139.331 Y111.143 E.00302
G1 X152.857 Y124.669 E.17835
G1 X152.857 Y124.993 E.00302
G1 X139.007 Y111.143 E.18262
G1 X138.684 Y111.143 E.00302
G1 X152.857 Y125.316 E.18688
G1 X152.857 Y125.64 E.00302
G1 X138.36 Y111.143 E.19115
G1 X138.036 Y111.143 E.00302
G1 X152.857 Y125.964 E.19542
G1 X152.857 Y126.287 E.00302
G1 X137.713 Y111.143 E.19968
G1 X137.389 Y111.143 E.00302
G1 X152.857 Y126.611 E.20395
G1 X152.857 Y126.935 E.00302
G1 X137.065 Y111.143 E.20822
G1 X136.742 Y111.143 E.00302
G1 X152.857 Y127.258 E.21249
G1 X152.857 Y127.582 E.00302
G1 X136.418 Y111.143 E.21675
G1 X136.095 Y111.143 E.00302
G1 X152.857 Y127.905 E.22102
G1 X152.857 Y128.229 E.00302
G1 X135.771 Y111.143 E.22529
G1 X135.447 Y111.143 E.00302
G1 X152.857 Y128.553 E.22956
G1 X152.857 Y128.876 E.00302
G1 X135.124 Y111.143 E.23382
G1 X134.8 Y111.143 E.00302
M73 P51 R8
G1 X152.857 Y129.2 E.23809
G1 X152.857 Y129.524 E.00302
G1 X134.476 Y111.143 E.24236
G1 X134.153 Y111.143 E.00302
G1 X152.857 Y129.847 E.24662
G1 X152.857 Y130.171 E.00302
G1 X133.829 Y111.143 E.25089
G1 X133.506 Y111.143 E.00302
G1 X152.857 Y130.494 E.25516
G1 X152.857 Y130.818 E.00302
G1 X133.182 Y111.143 E.25943
G1 X132.858 Y111.143 E.00302
G1 X152.571 Y130.857 E.25993
G1 X152.248 Y130.857 E.00302
G1 X132.535 Y111.143 E.25993
G1 X132.211 Y111.143 E.00302
G1 X151.924 Y130.857 E.25993
G1 X151.601 Y130.857 E.00302
G1 X131.887 Y111.143 E.25993
G1 X131.564 Y111.143 E.00302
G1 X151.277 Y130.857 E.25993
G1 X150.953 Y130.857 E.00302
G1 X131.24 Y111.143 E.25993
G1 X130.917 Y111.143 E.00302
G1 X150.63 Y130.857 E.25993
G1 X150.306 Y130.857 E.00302
G1 X130.593 Y111.143 E.25993
G1 X130.269 Y111.143 E.00302
G1 X149.982 Y130.857 E.25993
G1 X149.659 Y130.857 E.00302
G1 X129.946 Y111.143 E.25993
G1 X129.622 Y111.143 E.00302
G1 X149.335 Y130.857 E.25993
G1 X149.012 Y130.857 E.00302
G1 X129.298 Y111.143 E.25993
G1 X128.975 Y111.143 E.00302
G1 X148.688 Y130.857 E.25993
G1 X148.364 Y130.857 E.00302
M73 P52 R8
G1 X128.651 Y111.143 E.25993
G1 X128.327 Y111.143 E.00302
G1 X148.041 Y130.857 E.25993
G1 X147.717 Y130.857 E.00302
G1 X128.004 Y111.143 E.25993
G1 X127.68 Y111.143 E.00302
G1 X147.393 Y130.857 E.25993
G1 X147.07 Y130.857 E.00302
G1 X127.357 Y111.143 E.25993
G1 X127.033 Y111.143 E.00302
G1 X146.746 Y130.857 E.25993
G1 X146.423 Y130.857 E.00302
G1 X126.709 Y111.143 E.25993
G1 X126.386 Y111.143 E.00302
G1 X146.099 Y130.857 E.25993
G1 X145.775 Y130.857 E.00302
G1 X126.062 Y111.143 E.25993
G1 X125.738 Y111.143 E.00302
G1 X145.452 Y130.857 E.25993
G1 X145.128 Y130.857 E.00302
G1 X125.415 Y111.143 E.25993
G1 X125.091 Y111.143 E.00302
G1 X144.804 Y130.857 E.25993
G1 X144.481 Y130.857 E.00302
M73 P52 R7
G1 X124.768 Y111.143 E.25993
G1 X124.444 Y111.143 E.00302
G1 X144.157 Y130.857 E.25993
G1 X143.834 Y130.857 E.00302
G1 X124.12 Y111.143 E.25993
G1 X123.797 Y111.143 E.00302
G1 X143.51 Y130.857 E.25993
G1 X143.186 Y130.857 E.00302
G1 X123.473 Y111.143 E.25993
G1 X123.149 Y111.143 E.00302
G1 X142.863 Y130.857 E.25993
G1 X142.539 Y130.857 E.00302
G1 X122.826 Y111.143 E.25993
G1 X122.502 Y111.143 E.00302
G1 X142.215 Y130.857 E.25993
G1 X141.892 Y130.857 E.00302
M73 P53 R7
G1 X122.179 Y111.143 E.25993
G1 X121.855 Y111.143 E.00302
G1 X141.568 Y130.857 E.25993
G1 X141.244 Y130.857 E.00302
G1 X121.531 Y111.143 E.25993
G1 X121.208 Y111.143 E.00302
G1 X140.921 Y130.857 E.25993
G1 X140.597 Y130.857 E.00302
G1 X121.143 Y111.403 E.25651
G1 X121.143 Y111.726 E.00302
G1 X140.274 Y130.857 E.25225
G1 X139.95 Y130.857 E.00302
G1 X121.143 Y112.05 E.24798
G1 X121.143 Y112.374 E.00302
G1 X139.626 Y130.857 E.24371
G1 X139.303 Y130.857 E.00302
G1 X121.143 Y112.697 E.23945
G1 X121.143 Y113.021 E.00302
G1 X138.979 Y130.857 E.23518
G1 X138.655 Y130.857 E.00302
G1 X121.143 Y113.345 E.23091
G1 X121.143 Y113.668 E.00302
G1 X138.332 Y130.857 E.22664
G1 X138.008 Y130.857 E.00302
G1 X121.143 Y113.992 E.22238
G1 X121.143 Y114.315 E.00302
G1 X137.685 Y130.857 E.21811
G1 X137.361 Y130.857 E.00302
G1 X121.143 Y114.639 E.21384
G1 X121.143 Y114.963 E.00302
G1 X137.037 Y130.857 E.20957
G1 X136.714 Y130.857 E.00302
G1 X121.143 Y115.286 E.20531
G1 X121.143 Y115.61 E.00302
G1 X136.39 Y130.857 E.20104
G1 X136.066 Y130.857 E.00302
G1 X121.143 Y115.934 E.19677
G1 X121.143 Y116.257 E.00302
G1 X135.743 Y130.857 E.1925
G1 X135.419 Y130.857 E.00302
G1 X121.143 Y116.581 E.18824
G1 X121.143 Y116.904 E.00302
M73 P54 R7
G1 X135.096 Y130.857 E.18397
G1 X134.772 Y130.857 E.00302
G1 X121.143 Y117.228 E.1797
G1 X121.143 Y117.552 E.00302
G1 X134.448 Y130.857 E.17544
G1 X134.125 Y130.857 E.00302
G1 X121.143 Y117.875 E.17117
G1 X121.143 Y118.199 E.00302
G1 X133.801 Y130.857 E.1669
G1 X133.477 Y130.857 E.00302
G1 X121.143 Y118.523 E.16263
G1 X121.143 Y118.846 E.00302
G1 X133.154 Y130.857 E.15837
G1 X132.83 Y130.857 E.00302
G1 X121.143 Y119.17 E.1541
G1 X121.143 Y119.493 E.00302
G1 X132.507 Y130.857 E.14983
G1 X132.183 Y130.857 E.00302
G1 X121.143 Y119.817 E.14556
G1 X121.143 Y120.141 E.00302
G1 X131.859 Y130.857 E.1413
G1 X131.536 Y130.857 E.00302
G1 X121.143 Y120.464 E.13703
G1 X121.143 Y120.788 E.00302
G1 X131.212 Y130.857 E.13276
G1 X130.888 Y130.857 E.00302
G1 X121.143 Y121.112 E.1285
G1 X121.143 Y121.435 E.00302
G1 X130.565 Y130.857 E.12423
G1 X130.241 Y130.857 E.00302
G1 X121.143 Y121.759 E.11996
G1 X121.143 Y122.083 E.00302
G1 X129.917 Y130.857 E.11569
G1 X129.594 Y130.857 E.00302
G1 X121.143 Y122.406 E.11143
G1 X121.143 Y122.73 E.00302
G1 X129.27 Y130.857 E.10716
G1 X128.947 Y130.857 E.00302
G1 X121.143 Y123.053 E.10289
G1 X121.143 Y123.377 E.00302
G1 X128.623 Y130.857 E.09862
G1 X128.299 Y130.857 E.00302
G1 X121.143 Y123.701 E.09436
G1 X121.143 Y124.024 E.00302
G1 X127.976 Y130.857 E.09009
G1 X127.652 Y130.857 E.00302
G1 X121.143 Y124.348 E.08582
G1 X121.143 Y124.672 E.00302
G1 X127.328 Y130.857 E.08155
G1 X127.005 Y130.857 E.00302
G1 X126.832 Y130.684 E.00227
G1 X126.763 Y130.469 E.00211
G1 X126.568 Y130.266 E.00263
G1 X126.438 Y130.18 E.00145
G1 X126.252 Y130.104 E.00188
G1 X121.143 Y124.995 E.06736
G1 X121.143 Y125.319 E.00302
G1 X125.881 Y130.057 E.06247
G1 X125.558 Y130.057 E.00302
G1 X121.143 Y125.642 E.0582
G1 X121.143 Y125.966 E.00302
G1 X125.234 Y130.057 E.05394
G1 X124.91 Y130.057 E.00302
G1 X121.143 Y126.29 E.04967
G1 X121.143 Y126.613 E.00302
G1 X124.616 Y130.086 E.04579
G1 X124.456 Y130.134 E.00156
G1 X124.383 Y130.176 E.00078
G1 X121.143 Y126.937 E.04271
M73 P55 R7
G1 X121.143 Y127.261 E.00302
G1 X124.19 Y130.307 E.04017
G1 X124.098 Y130.392 E.00117
G1 X124.058 Y130.498 E.00106
G1 X121.143 Y127.584 E.03843
G1 X121.143 Y127.908 E.00302
G1 X123.968 Y130.733 E.03725
G1 X123.921 Y130.857 E.00123
G1 X123.769 Y130.857 E.00142
G1 X121.143 Y128.231 E.03461
G1 X121.143 Y128.555 E.00302
G1 X123.445 Y130.857 E.03035
G1 X123.121 Y130.857 E.00302
G1 X121.143 Y128.879 E.02608
G1 X121.143 Y129.202 E.00302
G1 X122.798 Y130.857 E.02181
G1 X122.474 Y130.857 E.00302
G1 X121.041 Y129.423 E.0189
; CHANGE_LAYER
; Z_HEIGHT: 0.2
; LAYER_HEIGHT: 0.1
; WIPE_START
G1 F4200
G1 X122.455 Y130.837 E-.38
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 5887
M625
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 2/7
; update layer progress
M73 L2
M991 S0 P1 ;notify layer change

M106 S165.75
M106 P2 S191
; open powerlost recovery
M1003 S1
; OBJECT_ID: 5909
; start printing object, unique label id: 5909
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z.5 I.009 J1.217 P1  F60000
G1 X165.91 Y130.512 Z.5
G1 Z.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.21999
G1 F6044.427
M204 S8000
G1 X165.811 Y130.494 E.00082
G1 X164.989 Y130.494 E.00664
G1 X164.721 Y130.548 E.00221
G1 X164.491 Y130.705 E.00225
G1 X164.294 Y131.189 E.00423
G1 X164.294 Y131.294 E.00085
G1 X162.292 Y131.294 E.0162
G1 X160.706 Y129.708 E.01815
G1 X160.706 Y110.706 E.15371
G1 X193.294 Y110.706 E.26361
G1 X193.294 Y121 E.08327
G1 X193.294 Y131.294 E.08327
G1 X168.506 Y131.294 E.20051
G1 X168.506 Y131.189 E.00085
G1 X168.361 Y130.764 E.00363
G1 X168.22 Y130.628 E.00159
G1 X168.071 Y130.545 E.00138
G1 X167.811 Y130.494 E.00214
G1 X166.887 Y130.502 E.00747
G1 X166.576 Y130.631 E.00273
G1 X166.4 Y130.98 E.00316
G1 X166.224 Y130.631 E.00316
G1 X166.052 Y130.538 E.00158
G1 X165.91 Y130.512 E.00117
M204 S10000
G1 X165.877 Y130.705 F60000
G1 F6044.427
M204 S8000
G1 X165.811 Y130.693 E.00054
G1 X164.989 Y130.693 E.00664
G1 X164.798 Y130.731 E.00158
G1 X164.633 Y130.843 E.00161
G1 X164.493 Y131.189 E.00302
G1 X164.493 Y131.493 E.00246
G1 X162.21 Y131.493 E.01847
G1 X160.507 Y129.79 E.01948
G1 X160.507 Y110.507 E.15598
G1 X193.493 Y110.507 E.26682
G1 X193.493 Y121 E.08488
G1 X193.493 Y131.493 E.08488
G1 X168.307 Y131.493 E.20372
G1 X168.307 Y131.189 E.00246
G1 X168.203 Y130.886 E.00259
G1 X168.039 Y130.748 E.00173
G1 X167.811 Y130.693 E.0019
G1 X166.943 Y130.695 E.00701
G1 X166.694 Y130.79 E.00216
G1 X166.496 Y131.189 E.0036
; LINE_WIDTH: 0.21367
G1 F6243.172
G1 X166.496 Y131.496 E.0024
G1 X166.304 Y131.496 E.00151
G1 X166.304 Y131.189 E.0024
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X166.106 Y130.79 E.0036
G1 X165.983 Y130.724 E.00113
G1 X165.877 Y130.705 E.00087
M204 S10000
G1 X165.861 Y130.908 F60000
G1 F6044.427
M204 S8000
G1 X165.811 Y130.891 E.00043
G1 X164.989 Y130.891 E.00664
G1 X164.81 Y130.952 E.00153
G1 X164.691 Y131.189 E.00215
G1 X164.691 Y131.691 E.00406
G1 X162.128 Y131.691 E.02074
G1 X160.309 Y129.872 E.02081
G1 X160.309 Y110.309 E.15825
G1 X193.691 Y110.309 E.27003
G1 X193.691 Y121 E.08648
G1 X193.691 Y131.691 E.08648
; object ids of layer 2 start: 5887,5909
M624 AwAAAAAAAAA=
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

; object ids of this layer2 end: 5887,5909
M625
G1 X168.109 Y131.691 E.20694
G1 X168.109 Y131.189 E.00406
G1 X168.046 Y131.007 E.00156
G1 X167.986 Y130.949 E.00068
G1 X167.811 Y130.891 E.00149
G1 X166.989 Y130.891 E.00664
G1 X166.812 Y130.95 E.00151
G1 X166.691 Y131.189 E.00217
G1 X166.691 Y131.691 E.00406
G1 X166.109 Y131.691 E.00472
G1 X166.109 Y131.189 E.00406
G1 X165.988 Y130.95 E.00217
G1 X165.861 Y130.908 E.00108
M204 S250
G1 X165.811 Y131.09 F60000
; FEATURE: Outer wall
G1 F6044.427
M204 S5000
G1 X164.951 Y131.098 E.00695
G1 X164.89 Y131.189 E.00089
G1 X164.89 Y131.89 E.00567
G1 X162.046 Y131.89 E.02301
G1 X160.11 Y129.954 E.02214
G1 X160.11 Y110.11 E.16052
G1 X193.89 Y110.11 E.27324
G1 X193.89 Y121 E.08809
G1 X193.89 Y131.89 E.08809
G1 X167.91 Y131.89 E.21015
G1 X167.889 Y131.129 E.00616
G1 X167.811 Y131.09 E.00071
G1 X166.977 Y131.091 E.00674
G1 X166.89 Y131.189 E.00106
G1 X166.89 Y131.89 E.00567
G1 X165.91 Y131.89 E.00793
G1 X165.91 Y131.189 E.00567
G1 X165.87 Y131.11 E.00072
G1 X165.811 Y131.09 E.0005
M204 S10000
G1 X166.322 Y130.693 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.22057
G1 F6026.819
M204 S8000
G1 X186.151 Y110.864 E.22749
G1 X185.869 Y110.864 E.00228
G1 X166.262 Y130.472 E.22495
G1 X166.074 Y130.378 E.0017
G1 X185.588 Y110.864 E.22388
G1 X185.306 Y110.864 E.00228
G1 X165.833 Y130.338 E.22341
G1 X165.55 Y130.339 E.0023
G1 X185.025 Y110.864 E.22343
G1 X184.743 Y110.864 E.00228
G1 X165.264 Y130.343 E.22347
G1 X164.979 Y130.347 E.00232
G1 X184.461 Y110.864 E.22352
G1 X184.18 Y110.864 E.00228
G1 X163.909 Y131.136 E.23257
G1 X163.627 Y131.136 E.00228
G1 X183.898 Y110.864 E.23257
G1 X183.617 Y110.864 E.00228
G1 X163.345 Y131.136 E.23257
G1 X163.064 Y131.136 E.00228
G1 X183.335 Y110.864 E.23257
G1 X183.053 Y110.864 E.00228
G1 X162.782 Y131.136 E.23257
G1 X162.501 Y131.136 E.00228
G1 X182.772 Y110.864 E.23257
G1 X182.49 Y110.864 E.00228
M73 P56 R7
G1 X162.289 Y131.066 E.23177
G1 X162.148 Y130.925 E.00162
G1 X182.209 Y110.864 E.23015
G1 X181.927 Y110.864 E.00228
G1 X162.007 Y130.785 E.22854
G1 X161.866 Y130.644 E.00162
G1 X181.646 Y110.864 E.22692
G1 X181.364 Y110.864 E.00228
G1 X161.725 Y130.503 E.22531
G1 X161.585 Y130.362 E.00162
G1 X181.082 Y110.864 E.22369
G1 X180.801 Y110.864 E.00228
G1 X161.444 Y130.221 E.22208
G1 X161.303 Y130.081 E.00162
G1 X180.519 Y110.864 E.22046
G1 X180.238 Y110.864 E.00228
G1 X161.162 Y129.94 E.21885
G1 X161.021 Y129.799 E.00162
G1 X179.956 Y110.864 E.21723
G1 X179.674 Y110.864 E.00228
G1 X160.881 Y129.658 E.21562
G1 X160.864 Y129.642 E.00019
G1 X160.864 Y129.393 E.00202
G1 X179.393 Y110.864 E.21257
G1 X179.111 Y110.864 E.00228
G1 X160.864 Y129.111 E.20934
G1 X160.864 Y128.83 E.00228
G1 X178.83 Y110.864 E.20611
G1 X178.548 Y110.864 E.00228
G1 X160.864 Y128.548 E.20288
G1 X160.864 Y128.266 E.00228
G1 X178.266 Y110.864 E.19965
G1 X177.985 Y110.864 E.00228
G1 X160.864 Y127.985 E.19642
G1 X160.864 Y127.703 E.00228
G1 X177.703 Y110.864 E.19319
G1 X177.422 Y110.864 E.00228
G1 X160.864 Y127.422 E.18996
G1 X160.864 Y127.14 E.00228
G1 X177.14 Y110.864 E.18673
G1 X176.859 Y110.864 E.00228
G1 X160.864 Y126.859 E.1835
G1 X160.864 Y126.577 E.00228
G1 X176.577 Y110.864 E.18027
G1 X176.295 Y110.864 E.00228
G1 X160.864 Y126.295 E.17704
G1 X160.864 Y126.014 E.00228
G1 X176.014 Y110.864 E.17381
G1 X175.732 Y110.864 E.00228
G1 X160.864 Y125.732 E.17058
G1 X160.864 Y125.451 E.00228
G1 X175.451 Y110.864 E.16734
G1 X175.169 Y110.864 E.00228
G1 X160.864 Y125.169 E.16411
G1 X160.864 Y124.887 E.00228
G1 X174.887 Y110.864 E.16088
G1 X174.606 Y110.864 E.00228
G1 X160.864 Y124.606 E.15765
G1 X160.864 Y124.324 E.00228
G1 X174.324 Y110.864 E.15442
G1 X174.043 Y110.864 E.00228
G1 X160.864 Y124.043 E.15119
G1 X160.864 Y123.761 E.00228
G1 X173.761 Y110.864 E.14796
G1 X173.48 Y110.864 E.00228
G1 X160.864 Y123.48 E.14473
G1 X160.864 Y123.198 E.00228
G1 X173.198 Y110.864 E.1415
G1 X172.916 Y110.864 E.00228
G1 X160.864 Y122.916 E.13827
G1 X160.864 Y122.635 E.00228
G1 X172.635 Y110.864 E.13504
G1 X172.353 Y110.864 E.00228
G1 X160.864 Y122.353 E.13181
G1 X160.864 Y122.072 E.00228
G1 X172.072 Y110.864 E.12858
G1 X171.79 Y110.864 E.00228
G1 X160.864 Y121.79 E.12535
G1 X160.864 Y121.508 E.00228
G1 X171.508 Y110.864 E.12212
G1 X171.227 Y110.864 E.00228
M73 P57 R7
G1 X160.864 Y121.227 E.11889
G1 X160.864 Y120.945 E.00228
G1 X170.945 Y110.864 E.11566
G1 X170.664 Y110.864 E.00228
G1 X160.864 Y120.664 E.11243
G1 X160.864 Y120.382 E.00228
G1 X170.382 Y110.864 E.10919
G1 X170.101 Y110.864 E.00228
G1 X160.864 Y120.101 E.10596
G1 X160.864 Y119.819 E.00228
G1 X169.819 Y110.864 E.10273
G1 X169.537 Y110.864 E.00228
G1 X160.864 Y119.537 E.0995
G1 X160.864 Y119.256 E.00228
G1 X169.256 Y110.864 E.09627
G1 X168.974 Y110.864 E.00228
G1 X160.864 Y118.974 E.09304
G1 X160.864 Y118.693 E.00228
G1 X168.693 Y110.864 E.08981
G1 X168.411 Y110.864 E.00228
G1 X160.864 Y118.411 E.08658
G1 X160.864 Y118.129 E.00228
G1 X168.129 Y110.864 E.08335
G1 X167.848 Y110.864 E.00228
G1 X160.864 Y117.848 E.08012
G1 X160.864 Y117.566 E.00228
G1 X167.566 Y110.864 E.07689
G1 X167.285 Y110.864 E.00228
G1 X160.864 Y117.285 E.07366
G1 X160.864 Y117.003 E.00228
G1 X167.003 Y110.864 E.07043
G1 X166.722 Y110.864 E.00228
G1 X160.864 Y116.722 E.0672
G1 X160.864 Y116.44 E.00228
G1 X166.44 Y110.864 E.06397
G1 X166.158 Y110.864 E.00228
G1 X160.864 Y116.158 E.06074
G1 X160.864 Y115.877 E.00228
G1 X165.877 Y110.864 E.05751
G1 X165.595 Y110.864 E.00228
G1 X160.864 Y115.595 E.05428
G1 X160.864 Y115.314 E.00228
G1 X165.314 Y110.864 E.05104
G1 X165.032 Y110.864 E.00228
G1 X160.864 Y115.032 E.04781
G1 X160.864 Y114.75 E.00228
G1 X164.75 Y110.864 E.04458
G1 X164.469 Y110.864 E.00228
G1 X160.864 Y114.469 E.04135
G1 X160.864 Y114.187 E.00228
G1 X164.187 Y110.864 E.03812
G1 X163.906 Y110.864 E.00228
G1 X160.864 Y113.906 E.03489
G1 X160.864 Y113.624 E.00228
G1 X163.624 Y110.864 E.03166
G1 X163.343 Y110.864 E.00228
G1 X160.864 Y113.343 E.02843
G1 X160.864 Y113.061 E.00228
G1 X163.061 Y110.864 E.0252
G1 X162.779 Y110.864 E.00228
G1 X160.864 Y112.779 E.02197
G1 X160.864 Y112.498 E.00228
G1 X162.498 Y110.864 E.01874
G1 X162.216 Y110.864 E.00228
G1 X160.864 Y112.216 E.01551
G1 X160.864 Y111.935 E.00228
G1 X161.935 Y110.864 E.01228
G1 X161.653 Y110.864 E.00228
G1 X160.864 Y111.653 E.00905
G1 X160.864 Y111.371 E.00228
G1 X161.371 Y110.864 E.00582
G1 X161.09 Y110.864 E.00228
G1 X160.775 Y111.179 E.00361
M204 S10000
G1 X166.855 Y130.441 F60000
G1 F6026.819
M204 S8000
G1 X186.432 Y110.864 E.2246
G1 X186.714 Y110.864 E.00228
G1 X167.243 Y130.336 E.22339
G1 X167.524 Y130.336 E.00228
G1 X186.996 Y110.864 E.22339
G1 X187.277 Y110.864 E.00228
G1 X167.806 Y130.336 E.22339
G1 X167.98 Y130.352 E.00142
G1 X168.047 Y130.376 E.00058
G1 X187.559 Y110.864 E.22385
G1 X187.84 Y110.864 E.00228
G1 X168.247 Y130.458 E.22479
G1 X168.402 Y130.584 E.00162
G1 X188.122 Y110.864 E.22624
G1 X188.404 Y110.864 E.00228
G1 X168.518 Y130.75 E.22815
G1 X168.589 Y130.961 E.0018
G1 X188.685 Y110.864 E.23056
G1 X188.967 Y110.864 E.00228
G1 X168.695 Y131.136 E.23257
G1 X168.977 Y131.136 E.00228
G1 X189.248 Y110.864 E.23257
G1 X189.53 Y110.864 E.00228
G1 X169.259 Y131.136 E.23257
G1 X169.54 Y131.136 E.00228
G1 X189.811 Y110.864 E.23257
G1 X190.093 Y110.864 E.00228
G1 X169.822 Y131.136 E.23257
G1 X170.103 Y131.136 E.00228
G1 X190.375 Y110.864 E.23257
G1 X190.656 Y110.864 E.00228
G1 X170.385 Y131.136 E.23257
G1 X170.667 Y131.136 E.00228
G1 X190.938 Y110.864 E.23257
G1 X191.219 Y110.864 E.00228
G1 X170.948 Y131.136 E.23257
G1 X171.23 Y131.136 E.00228
G1 X191.501 Y110.864 E.23257
G1 X191.783 Y110.864 E.00228
G1 X171.511 Y131.136 E.23257
G1 X171.793 Y131.136 E.00228
G1 X192.064 Y110.864 E.23257
G1 X192.346 Y110.864 E.00228
G1 X172.074 Y131.136 E.23257
G1 X172.356 Y131.136 E.00228
G1 X192.627 Y110.864 E.23257
G1 X192.909 Y110.864 E.00228
M73 P58 R7
G1 X172.638 Y131.136 E.23257
G1 X172.919 Y131.136 E.00228
G1 X193.136 Y110.919 E.23194
G1 X193.136 Y111.201 E.00228
G1 X173.201 Y131.136 E.22871
G1 X173.482 Y131.136 E.00228
G1 X193.136 Y111.482 E.22548
G1 X193.136 Y111.764 E.00228
G1 X173.764 Y131.136 E.22225
G1 X174.046 Y131.136 E.00228
G1 X193.136 Y112.046 E.21902
G1 X193.136 Y112.327 E.00228
G1 X174.327 Y131.136 E.21579
G1 X174.609 Y131.136 E.00228
G1 X193.136 Y112.609 E.21255
G1 X193.136 Y112.89 E.00228
G1 X174.89 Y131.136 E.20932
G1 X175.172 Y131.136 E.00228
G1 X193.136 Y113.172 E.20609
G1 X193.136 Y113.453 E.00228
G1 X175.453 Y131.136 E.20286
G1 X175.735 Y131.136 E.00228
G1 X193.136 Y113.735 E.19963
G1 X193.136 Y114.017 E.00228
G1 X176.017 Y131.136 E.1964
G1 X176.298 Y131.136 E.00228
G1 X193.136 Y114.298 E.19317
G1 X193.136 Y114.58 E.00228
G1 X176.58 Y131.136 E.18994
G1 X176.861 Y131.136 E.00228
G1 X193.136 Y114.861 E.18671
G1 X193.136 Y115.143 E.00228
G1 X177.143 Y131.136 E.18348
G1 X177.425 Y131.136 E.00228
G1 X193.136 Y115.425 E.18025
G1 X193.136 Y115.706 E.00228
G1 X177.706 Y131.136 E.17702
G1 X177.988 Y131.136 E.00228
M73 P58 R6
G1 X193.136 Y115.988 E.17379
G1 X193.136 Y116.269 E.00228
G1 X178.269 Y131.136 E.17056
G1 X178.551 Y131.136 E.00228
G1 X193.136 Y116.551 E.16733
G1 X193.136 Y116.832 E.00228
G1 X178.832 Y131.136 E.1641
G1 X179.114 Y131.136 E.00228
G1 X193.136 Y117.114 E.16087
G1 X193.136 Y117.396 E.00228
G1 X179.396 Y131.136 E.15764
G1 X179.677 Y131.136 E.00228
G1 X193.136 Y117.677 E.15441
G1 X193.136 Y117.959 E.00228
G1 X179.959 Y131.136 E.15117
G1 X180.24 Y131.136 E.00228
G1 X193.136 Y118.24 E.14794
G1 X193.136 Y118.522 E.00228
G1 X180.522 Y131.136 E.14471
G1 X180.804 Y131.136 E.00228
G1 X193.136 Y118.804 E.14148
G1 X193.136 Y119.085 E.00228
G1 X181.085 Y131.136 E.13825
G1 X181.367 Y131.136 E.00228
G1 X193.136 Y119.367 E.13502
G1 X193.136 Y119.648 E.00228
G1 X181.648 Y131.136 E.13179
G1 X181.93 Y131.136 E.00228
G1 X193.136 Y119.93 E.12856
G1 X193.136 Y120.211 E.00228
G1 X182.211 Y131.136 E.12533
G1 X182.493 Y131.136 E.00228
G1 X193.136 Y120.493 E.1221
G1 X193.136 Y120.775 E.00228
G1 X182.775 Y131.136 E.11887
G1 X183.056 Y131.136 E.00228
G1 X193.136 Y121.056 E.11564
G1 X193.136 Y121.338 E.00228
G1 X183.338 Y131.136 E.11241
G1 X183.619 Y131.136 E.00228
G1 X193.136 Y121.619 E.10918
G1 X193.136 Y121.901 E.00228
G1 X183.901 Y131.136 E.10595
G1 X184.183 Y131.136 E.00228
G1 X193.136 Y122.183 E.10272
G1 X193.136 Y122.464 E.00228
G1 X184.464 Y131.136 E.09949
G1 X184.746 Y131.136 E.00228
G1 X193.136 Y122.746 E.09626
M73 P59 R6
G1 X193.136 Y123.027 E.00228
G1 X185.027 Y131.136 E.09302
G1 X185.309 Y131.136 E.00228
G1 X193.136 Y123.309 E.08979
G1 X193.136 Y123.59 E.00228
G1 X185.59 Y131.136 E.08656
G1 X185.872 Y131.136 E.00228
G1 X193.136 Y123.872 E.08333
G1 X193.136 Y124.154 E.00228
G1 X186.154 Y131.136 E.0801
G1 X186.435 Y131.136 E.00228
G1 X193.136 Y124.435 E.07687
G1 X193.136 Y124.717 E.00228
G1 X186.717 Y131.136 E.07364
G1 X186.998 Y131.136 E.00228
G1 X193.136 Y124.998 E.07041
G1 X193.136 Y125.28 E.00228
G1 X187.28 Y131.136 E.06718
G1 X187.562 Y131.136 E.00228
G1 X193.136 Y125.562 E.06395
G1 X193.136 Y125.843 E.00228
G1 X187.843 Y131.136 E.06072
G1 X188.125 Y131.136 E.00228
G1 X193.136 Y126.125 E.05749
G1 X193.136 Y126.406 E.00228
G1 X188.406 Y131.136 E.05426
G1 X188.688 Y131.136 E.00228
G1 X193.136 Y126.688 E.05103
G1 X193.136 Y126.969 E.00228
G1 X188.97 Y131.136 E.0478
G1 X189.251 Y131.136 E.00228
G1 X193.136 Y127.251 E.04457
G1 X193.136 Y127.533 E.00228
G1 X189.533 Y131.136 E.04134
G1 X189.814 Y131.136 E.00228
G1 X193.136 Y127.814 E.03811
G1 X193.136 Y128.096 E.00228
G1 X190.096 Y131.136 E.03487
G1 X190.377 Y131.136 E.00228
G1 X193.136 Y128.377 E.03164
G1 X193.136 Y128.659 E.00228
G1 X190.659 Y131.136 E.02841
G1 X190.941 Y131.136 E.00228
G1 X193.136 Y128.941 E.02518
G1 X193.136 Y129.222 E.00228
G1 X191.222 Y131.136 E.02195
G1 X191.504 Y131.136 E.00228
G1 X193.136 Y129.504 E.01872
G1 X193.136 Y129.785 E.00228
G1 X191.785 Y131.136 E.01549
G1 X192.067 Y131.136 E.00228
G1 X193.136 Y130.067 E.01226
G1 X193.136 Y130.349 E.00228
G1 X192.349 Y131.136 E.00903
G1 X192.63 Y131.136 E.00228
G1 X193.136 Y130.63 E.0058
G1 X193.136 Y130.912 E.00228
G1 X192.822 Y131.225 E.00359
; OBJECT_ID: 5887
; WIPE_START
G1 X193.136 Y130.912 E-.08418
G1 X193.136 Y130.63 E-.0535
G1 X192.63 Y131.136 E-.13583
G1 X192.349 Y131.136 E-.0535
G1 X192.546 Y130.938 E-.05299
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 5909
M625
; start printing object, unique label id: 5887
M624 AQAAAAAAAAA=
M204 S10000
G1 X184.913 Y130.925 Z.6 F60000
G1 X126.388 Y130.825 Z.6
G1 Z.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.21999
G1 F6044.427
M204 S8000
G1 X126.375 Y130.783 E.00036
G1 X126.239 Y130.642 E.00159
G1 X126.088 Y130.552 E.00142
G1 X125.811 Y130.494 E.00229
G1 X124.989 Y130.494 E.00664
G1 X124.721 Y130.548 E.00221
G1 X124.491 Y130.705 E.00225
G1 X124.294 Y131.189 E.00423
G1 X124.294 Y131.294 E.00085
G1 X122.292 Y131.294 E.0162
G1 X120.706 Y129.708 E.01815
G1 X120.706 Y110.706 E.15371
G1 X153.294 Y110.706 E.26361
G1 X153.294 Y121 E.08327
G1 X153.294 Y131.294 E.08327
G1 X126.506 Y131.294 E.21669
G1 X126.506 Y131.189 E.00085
G1 X126.388 Y130.825 E.00309
M204 S10000
G1 X126.223 Y130.927 F60000
G1 F6044.427
M204 S8000
G1 X126.214 Y130.899 E.00024
G1 X126.052 Y130.755 E.00175
G1 X125.811 Y130.693 E.00202
G1 X124.989 Y130.693 E.00664
G1 X124.798 Y130.731 E.00158
G1 X124.633 Y130.843 E.00161
G1 X124.493 Y131.189 E.00302
G1 X124.493 Y131.493 E.00246
G1 X122.21 Y131.493 E.01847
G1 X120.507 Y129.79 E.01948
G1 X120.507 Y110.507 E.15598
G1 X153.493 Y110.507 E.26682
G1 X153.493 Y121 E.08488
G1 X153.493 Y131.493 E.08488
G1 X126.307 Y131.493 E.2199
G1 X126.307 Y131.189 E.00246
G1 X126.223 Y130.927 E.00223
M204 S10000
G1 X126.057 Y131.029 F60000
G1 F6044.427
M204 S8000
G1 X126.052 Y131.015 E.00012
G1 X125.994 Y130.955 E.00068
G1 X125.811 Y130.891 E.00157
G1 X124.989 Y130.891 E.00664
G1 X124.81 Y130.952 E.00153
G1 X124.691 Y131.189 E.00215
G1 X124.691 Y131.691 E.00406
G1 X122.128 Y131.691 E.02074
G1 X120.309 Y129.872 E.02081
G1 X120.309 Y110.309 E.15825
G1 X153.691 Y110.309 E.27003
G1 X153.691 Y121 E.08648
G1 X153.691 Y131.691 E.08648
G1 X126.109 Y131.691 E.22311
G1 X126.109 Y131.189 E.00406
G1 X126.057 Y131.029 E.00136
M204 S250
G1 X125.891 Y131.131 F60000
; FEATURE: Outer wall
G1 F6044.427
M204 S5000
G1 X125.811 Y131.09 E.00073
G1 X124.951 Y131.098 E.00695
G1 X124.89 Y131.189 E.00089
G1 X124.89 Y131.89 E.00567
G1 X122.046 Y131.89 E.02301
G1 X120.11 Y129.954 E.02214
G1 X120.11 Y110.11 E.16052
G1 X153.89 Y110.11 E.27324
G1 X153.89 Y121 E.08809
G1 X153.89 Y131.89 E.08809
G1 X125.91 Y131.89 E.22633
G1 X125.891 Y131.131 E.00614
; WIPE_START
M204 S8000
G1 X125.811 Y131.09 E-.0172
G1 X124.951 Y131.098 E-.16337
G1 X124.89 Y131.189 E-.0209
G1 X124.89 Y131.89 E-.13314
G1 X124.651 Y131.89 E-.0454
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X123.247 Y124.388 Z.6 F60000
G1 X120.775 Y111.179 Z.6
G1 Z.2
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.22057
G1 F6026.819
M204 S8000
G1 X121.09 Y110.864 E.00361
G1 X121.371 Y110.864 E.00228
G1 X120.864 Y111.371 E.00582
G1 X120.864 Y111.653 E.00228
G1 X121.653 Y110.864 E.00905
G1 X121.935 Y110.864 E.00228
G1 X120.864 Y111.935 E.01228
G1 X120.864 Y112.216 E.00228
G1 X122.216 Y110.864 E.01551
G1 X122.498 Y110.864 E.00228
G1 X120.864 Y112.498 E.01874
G1 X120.864 Y112.779 E.00228
G1 X122.779 Y110.864 E.02197
G1 X123.061 Y110.864 E.00228
G1 X120.864 Y113.061 E.0252
G1 X120.864 Y113.343 E.00228
G1 X123.343 Y110.864 E.02843
G1 X123.624 Y110.864 E.00228
G1 X120.864 Y113.624 E.03166
G1 X120.864 Y113.906 E.00228
G1 X123.906 Y110.864 E.03489
G1 X124.187 Y110.864 E.00228
G1 X120.864 Y114.187 E.03812
G1 X120.864 Y114.469 E.00228
G1 X124.469 Y110.864 E.04135
G1 X124.75 Y110.864 E.00228
G1 X120.864 Y114.75 E.04458
G1 X120.864 Y115.032 E.00228
G1 X125.032 Y110.864 E.04781
G1 X125.314 Y110.864 E.00228
G1 X120.864 Y115.314 E.05105
G1 X120.864 Y115.595 E.00228
G1 X125.595 Y110.864 E.05428
G1 X125.877 Y110.864 E.00228
G1 X120.864 Y115.877 E.05751
G1 X120.864 Y116.158 E.00228
G1 X126.158 Y110.864 E.06074
G1 X126.44 Y110.864 E.00228
G1 X120.864 Y116.44 E.06397
G1 X120.864 Y116.722 E.00228
G1 X126.722 Y110.864 E.0672
G1 X127.003 Y110.864 E.00228
G1 X120.864 Y117.003 E.07043
G1 X120.864 Y117.285 E.00228
G1 X127.285 Y110.864 E.07366
G1 X127.566 Y110.864 E.00228
G1 X120.864 Y117.566 E.07689
G1 X120.864 Y117.848 E.00228
G1 X127.848 Y110.864 E.08012
G1 X128.129 Y110.864 E.00228
G1 X120.864 Y118.129 E.08335
G1 X120.864 Y118.411 E.00228
G1 X128.411 Y110.864 E.08658
G1 X128.693 Y110.864 E.00228
G1 X120.864 Y118.693 E.08981
G1 X120.864 Y118.974 E.00228
G1 X128.974 Y110.864 E.09304
G1 X129.256 Y110.864 E.00228
G1 X120.864 Y119.256 E.09627
G1 X120.864 Y119.537 E.00228
M73 P60 R6
G1 X129.537 Y110.864 E.0995
G1 X129.819 Y110.864 E.00228
G1 X120.864 Y119.819 E.10273
G1 X120.864 Y120.101 E.00228
G1 X130.101 Y110.864 E.10596
G1 X130.382 Y110.864 E.00228
G1 X120.864 Y120.382 E.10919
G1 X120.864 Y120.664 E.00228
G1 X130.664 Y110.864 E.11243
G1 X130.945 Y110.864 E.00228
G1 X120.864 Y120.945 E.11566
G1 X120.864 Y121.227 E.00228
G1 X131.227 Y110.864 E.11889
G1 X131.508 Y110.864 E.00228
G1 X120.864 Y121.508 E.12212
G1 X120.864 Y121.79 E.00228
G1 X131.79 Y110.864 E.12535
G1 X132.072 Y110.864 E.00228
G1 X120.864 Y122.072 E.12858
G1 X120.864 Y122.353 E.00228
G1 X132.353 Y110.864 E.13181
G1 X132.635 Y110.864 E.00228
G1 X120.864 Y122.635 E.13504
G1 X120.864 Y122.916 E.00228
G1 X132.916 Y110.864 E.13827
G1 X133.198 Y110.864 E.00228
G1 X120.864 Y123.198 E.1415
G1 X120.864 Y123.48 E.00228
G1 X133.48 Y110.864 E.14473
G1 X133.761 Y110.864 E.00228
G1 X120.864 Y123.761 E.14796
G1 X120.864 Y124.043 E.00228
G1 X134.043 Y110.864 E.15119
G1 X134.324 Y110.864 E.00228
G1 X120.864 Y124.324 E.15442
G1 X120.864 Y124.606 E.00228
G1 X134.606 Y110.864 E.15765
G1 X134.887 Y110.864 E.00228
G1 X120.864 Y124.887 E.16088
G1 X120.864 Y125.169 E.00228
G1 X135.169 Y110.864 E.16411
G1 X135.451 Y110.864 E.00228
G1 X120.864 Y125.451 E.16734
G1 X120.864 Y125.732 E.00228
G1 X135.732 Y110.864 E.17058
G1 X136.014 Y110.864 E.00228
G1 X120.864 Y126.014 E.17381
G1 X120.864 Y126.295 E.00228
G1 X136.295 Y110.864 E.17704
G1 X136.577 Y110.864 E.00228
G1 X120.864 Y126.577 E.18027
G1 X120.864 Y126.859 E.00228
G1 X136.859 Y110.864 E.1835
G1 X137.14 Y110.864 E.00228
G1 X120.864 Y127.14 E.18673
G1 X120.864 Y127.422 E.00228
G1 X137.422 Y110.864 E.18996
G1 X137.703 Y110.864 E.00228
G1 X120.864 Y127.703 E.19319
G1 X120.864 Y127.985 E.00228
G1 X137.985 Y110.864 E.19642
G1 X138.266 Y110.864 E.00228
G1 X120.864 Y128.266 E.19965
G1 X120.864 Y128.548 E.00228
G1 X138.548 Y110.864 E.20288
G1 X138.83 Y110.864 E.00228
G1 X120.864 Y128.83 E.20611
G1 X120.864 Y129.111 E.00228
G1 X139.111 Y110.864 E.20934
G1 X139.393 Y110.864 E.00228
G1 X120.864 Y129.393 E.21257
G1 X120.864 Y129.642 E.00202
G1 X120.881 Y129.658 E.00019
G1 X139.674 Y110.864 E.21562
G1 X139.956 Y110.864 E.00228
G1 X121.021 Y129.799 E.21723
G1 X121.162 Y129.94 E.00162
G1 X140.238 Y110.864 E.21885
G1 X140.519 Y110.864 E.00228
G1 X121.303 Y130.081 E.22046
G1 X121.444 Y130.221 E.00162
G1 X140.801 Y110.864 E.22208
G1 X141.082 Y110.864 E.00228
G1 X121.585 Y130.362 E.22369
G1 X121.725 Y130.503 E.00162
G1 X141.364 Y110.864 E.22531
G1 X141.645 Y110.864 E.00228
G1 X121.866 Y130.644 E.22692
G1 X122.007 Y130.785 E.00162
G1 X141.927 Y110.864 E.22854
G1 X142.209 Y110.864 E.00228
G1 X122.148 Y130.925 E.23015
G1 X122.289 Y131.066 E.00162
M73 P61 R6
G1 X142.49 Y110.864 E.23177
G1 X142.772 Y110.864 E.00228
G1 X122.501 Y131.136 E.23257
G1 X122.782 Y131.136 E.00228
G1 X143.053 Y110.864 E.23257
G1 X143.335 Y110.864 E.00228
G1 X123.064 Y131.136 E.23257
G1 X123.345 Y131.136 E.00228
G1 X143.617 Y110.864 E.23257
G1 X143.898 Y110.864 E.00228
G1 X123.627 Y131.136 E.23257
G1 X123.909 Y131.136 E.00228
G1 X144.18 Y110.864 E.23257
G1 X144.461 Y110.864 E.00228
G1 X124.99 Y130.336 E.22339
G1 X125.272 Y130.336 E.00228
G1 X144.743 Y110.864 E.22339
G1 X145.025 Y110.864 E.00228
G1 X125.553 Y130.336 E.22339
G1 X125.832 Y130.338 E.00226
G1 X145.306 Y110.864 E.22342
G1 X145.588 Y110.864 E.00228
G1 X126.074 Y130.378 E.22388
G1 X126.259 Y130.474 E.00169
G1 X145.869 Y110.864 E.22498
G1 X146.151 Y110.864 E.00228
G1 X126.416 Y130.599 E.22641
G1 X126.508 Y130.694 E.00107
G1 X126.531 Y130.766 E.00061
G1 X146.432 Y110.864 E.22833
G1 X146.714 Y110.864 E.00228
G1 X126.599 Y130.98 E.23078
G1 X126.648 Y131.136 E.00133
G1 X126.724 Y131.136 E.00062
G1 X146.996 Y110.864 E.23257
G1 X147.277 Y110.864 E.00228
G1 X127.006 Y131.136 E.23257
G1 X127.288 Y131.136 E.00228
G1 X147.559 Y110.864 E.23257
G1 X147.84 Y110.864 E.00228
G1 X127.569 Y131.136 E.23257
G1 X127.851 Y131.136 E.00228
G1 X148.122 Y110.864 E.23257
G1 X148.404 Y110.864 E.00228
G1 X128.132 Y131.136 E.23257
G1 X128.414 Y131.136 E.00228
G1 X148.685 Y110.864 E.23257
G1 X148.967 Y110.864 E.00228
G1 X128.695 Y131.136 E.23257
G1 X128.977 Y131.136 E.00228
G1 X149.248 Y110.864 E.23257
G1 X149.53 Y110.864 E.00228
G1 X129.259 Y131.136 E.23257
G1 X129.54 Y131.136 E.00228
G1 X149.811 Y110.864 E.23257
G1 X150.093 Y110.864 E.00228
G1 X129.822 Y131.136 E.23257
G1 X130.103 Y131.136 E.00228
G1 X150.375 Y110.864 E.23257
G1 X150.656 Y110.864 E.00228
G1 X130.385 Y131.136 E.23257
G1 X130.667 Y131.136 E.00228
G1 X150.938 Y110.864 E.23257
G1 X151.219 Y110.864 E.00228
G1 X130.948 Y131.136 E.23257
G1 X131.23 Y131.136 E.00228
G1 X151.501 Y110.864 E.23257
G1 X151.783 Y110.864 E.00228
M73 P62 R6
G1 X131.511 Y131.136 E.23257
G1 X131.793 Y131.136 E.00228
G1 X152.064 Y110.864 E.23257
G1 X152.346 Y110.864 E.00228
G1 X132.074 Y131.136 E.23257
G1 X132.356 Y131.136 E.00228
G1 X152.627 Y110.864 E.23257
G1 X152.909 Y110.864 E.00228
G1 X132.638 Y131.136 E.23257
G1 X132.919 Y131.136 E.00228
G1 X153.136 Y110.919 E.23194
G1 X153.136 Y111.201 E.00228
G1 X133.201 Y131.136 E.22871
G1 X133.482 Y131.136 E.00228
G1 X153.136 Y111.482 E.22548
G1 X153.136 Y111.764 E.00228
G1 X133.764 Y131.136 E.22225
G1 X134.046 Y131.136 E.00228
G1 X153.136 Y112.046 E.21902
G1 X153.136 Y112.327 E.00228
G1 X134.327 Y131.136 E.21579
G1 X134.609 Y131.136 E.00228
G1 X153.136 Y112.609 E.21255
G1 X153.136 Y112.89 E.00228
G1 X134.89 Y131.136 E.20932
G1 X135.172 Y131.136 E.00228
G1 X153.136 Y113.172 E.20609
G1 X153.136 Y113.453 E.00228
G1 X135.453 Y131.136 E.20286
G1 X135.735 Y131.136 E.00228
G1 X153.136 Y113.735 E.19963
G1 X153.136 Y114.017 E.00228
G1 X136.017 Y131.136 E.1964
G1 X136.298 Y131.136 E.00228
G1 X153.136 Y114.298 E.19317
G1 X153.136 Y114.58 E.00228
G1 X136.58 Y131.136 E.18994
G1 X136.861 Y131.136 E.00228
G1 X153.136 Y114.861 E.18671
G1 X153.136 Y115.143 E.00228
G1 X137.143 Y131.136 E.18348
G1 X137.425 Y131.136 E.00228
G1 X153.136 Y115.425 E.18025
G1 X153.136 Y115.706 E.00228
G1 X137.706 Y131.136 E.17702
G1 X137.988 Y131.136 E.00228
G1 X153.136 Y115.988 E.17379
G1 X153.136 Y116.269 E.00228
G1 X138.269 Y131.136 E.17056
G1 X138.551 Y131.136 E.00228
G1 X153.136 Y116.551 E.16733
G1 X153.136 Y116.832 E.00228
G1 X138.832 Y131.136 E.1641
G1 X139.114 Y131.136 E.00228
G1 X153.136 Y117.114 E.16087
G1 X153.136 Y117.396 E.00228
G1 X139.396 Y131.136 E.15764
G1 X139.677 Y131.136 E.00228
G1 X153.136 Y117.677 E.15441
G1 X153.136 Y117.959 E.00228
G1 X139.959 Y131.136 E.15117
G1 X140.24 Y131.136 E.00228
G1 X153.136 Y118.24 E.14794
G1 X153.136 Y118.522 E.00228
G1 X140.522 Y131.136 E.14471
G1 X140.804 Y131.136 E.00228
G1 X153.136 Y118.804 E.14148
G1 X153.136 Y119.085 E.00228
G1 X141.085 Y131.136 E.13825
G1 X141.367 Y131.136 E.00228
G1 X153.136 Y119.367 E.13502
G1 X153.136 Y119.648 E.00228
G1 X141.648 Y131.136 E.13179
G1 X141.93 Y131.136 E.00228
G1 X153.136 Y119.93 E.12856
G1 X153.136 Y120.211 E.00228
G1 X142.211 Y131.136 E.12533
G1 X142.493 Y131.136 E.00228
G1 X153.136 Y120.493 E.1221
G1 X153.136 Y120.775 E.00228
G1 X142.775 Y131.136 E.11887
G1 X143.056 Y131.136 E.00228
M73 P63 R6
G1 X153.136 Y121.056 E.11564
G1 X153.136 Y121.338 E.00228
G1 X143.338 Y131.136 E.11241
G1 X143.619 Y131.136 E.00228
G1 X153.136 Y121.619 E.10918
G1 X153.136 Y121.901 E.00228
G1 X143.901 Y131.136 E.10595
G1 X144.183 Y131.136 E.00228
G1 X153.136 Y122.183 E.10272
G1 X153.136 Y122.464 E.00228
G1 X144.464 Y131.136 E.09949
G1 X144.746 Y131.136 E.00228
G1 X153.136 Y122.746 E.09626
G1 X153.136 Y123.027 E.00228
G1 X145.027 Y131.136 E.09302
G1 X145.309 Y131.136 E.00228
G1 X153.136 Y123.309 E.08979
G1 X153.136 Y123.59 E.00228
G1 X145.59 Y131.136 E.08656
G1 X145.872 Y131.136 E.00228
G1 X153.136 Y123.872 E.08333
G1 X153.136 Y124.154 E.00228
G1 X146.154 Y131.136 E.0801
G1 X146.435 Y131.136 E.00228
G1 X153.136 Y124.435 E.07687
G1 X153.136 Y124.717 E.00228
G1 X146.717 Y131.136 E.07364
G1 X146.998 Y131.136 E.00228
G1 X153.136 Y124.998 E.07041
G1 X153.136 Y125.28 E.00228
G1 X147.28 Y131.136 E.06718
G1 X147.562 Y131.136 E.00228
G1 X153.136 Y125.562 E.06395
G1 X153.136 Y125.843 E.00228
G1 X147.843 Y131.136 E.06072
G1 X148.125 Y131.136 E.00228
G1 X153.136 Y126.125 E.05749
G1 X153.136 Y126.406 E.00228
G1 X148.406 Y131.136 E.05426
G1 X148.688 Y131.136 E.00228
G1 X153.136 Y126.688 E.05103
G1 X153.136 Y126.969 E.00228
G1 X148.969 Y131.136 E.0478
G1 X149.251 Y131.136 E.00228
G1 X153.136 Y127.251 E.04457
G1 X153.136 Y127.533 E.00228
G1 X149.533 Y131.136 E.04134
G1 X149.814 Y131.136 E.00228
G1 X153.136 Y127.814 E.03811
G1 X153.136 Y128.096 E.00228
G1 X150.096 Y131.136 E.03487
G1 X150.377 Y131.136 E.00228
G1 X153.136 Y128.377 E.03164
G1 X153.136 Y128.659 E.00228
G1 X150.659 Y131.136 E.02841
G1 X150.941 Y131.136 E.00228
G1 X153.136 Y128.941 E.02518
G1 X153.136 Y129.222 E.00228
G1 X151.222 Y131.136 E.02195
G1 X151.504 Y131.136 E.00228
G1 X153.136 Y129.504 E.01872
G1 X153.136 Y129.785 E.00228
G1 X151.785 Y131.136 E.01549
G1 X152.067 Y131.136 E.00228
G1 X153.136 Y130.067 E.01226
G1 X153.136 Y130.349 E.00228
G1 X152.349 Y131.136 E.00903
G1 X152.63 Y131.136 E.00228
G1 X153.136 Y130.63 E.0058
G1 X153.136 Y130.912 E.00228
G1 X152.822 Y131.225 E.00359
; CHANGE_LAYER
; Z_HEIGHT: 0.3
; LAYER_HEIGHT: 0.1
; WIPE_START
G1 F6026.819
G1 X153.136 Y130.912 E-.08418
G1 X153.136 Y130.63 E-.0535
G1 X152.63 Y131.136 E-.13583
G1 X152.349 Y131.136 E-.0535
G1 X152.546 Y130.938 E-.05299
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 5887
M625
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 3/7
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change

; OBJECT_ID: 5909
; COOLING_NODE: 0
; start printing object, unique label id: 5909
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z.6 I.039 J1.216 P1  F60000
G1 X165.91 Y130.512 Z.6
G1 Z.3
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.21999
G1 F6044.427
M204 S8000
G1 X165.811 Y130.494 E.00082
G1 X164.989 Y130.494 E.00664
G1 X164.721 Y130.548 E.00221
G1 X164.491 Y130.705 E.00225
G1 X164.294 Y131.189 E.00423
G1 X164.294 Y131.294 E.00085
G1 X162.292 Y131.294 E.0162
G1 X160.706 Y129.708 E.01815
G1 X160.706 Y110.706 E.15371
G1 X193.294 Y110.706 E.26361
G1 X193.294 Y121 E.08327
G1 X193.294 Y131.294 E.08327
G1 X168.506 Y131.294 E.20051
G1 X168.506 Y131.189 E.00085
G1 X168.361 Y130.764 E.00363
G1 X168.22 Y130.628 E.00159
G1 X168.071 Y130.545 E.00138
G1 X167.811 Y130.494 E.00214
G1 X166.887 Y130.502 E.00747
G1 X166.576 Y130.631 E.00273
G1 X166.4 Y130.98 E.00316
G1 X166.224 Y130.631 E.00316
G1 X166.052 Y130.538 E.00158
G1 X165.91 Y130.512 E.00117
; COOLING_NODE: 0
M204 S10000
G1 X165.877 Y130.705 F60000
G1 F6044.427
M204 S8000
G1 X165.811 Y130.693 E.00054
G1 X164.989 Y130.693 E.00664
G1 X164.798 Y130.731 E.00158
G1 X164.633 Y130.843 E.00161
G1 X164.493 Y131.189 E.00302
G1 X164.493 Y131.493 E.00246
G1 X162.21 Y131.493 E.01847
G1 X160.507 Y129.79 E.01948
G1 X160.507 Y110.507 E.15598
G1 X193.493 Y110.507 E.26682
G1 X193.493 Y121 E.08488
G1 X193.493 Y131.493 E.08488
G1 X168.307 Y131.493 E.20372
G1 X168.307 Y131.189 E.00246
G1 X168.203 Y130.886 E.00259
G1 X168.039 Y130.748 E.00173
G1 X167.811 Y130.693 E.0019
G1 X166.943 Y130.695 E.00701
G1 X166.694 Y130.79 E.00216
G1 X166.496 Y131.189 E.0036
; LINE_WIDTH: 0.21367
G1 F6243.172
G1 X166.496 Y131.496 E.0024
G1 X166.304 Y131.496 E.00151
G1 X166.304 Y131.189 E.0024
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X166.106 Y130.79 E.0036
G1 X165.983 Y130.724 E.00113
G1 X165.877 Y130.705 E.00087
; COOLING_NODE: 0
M204 S10000
G1 X165.861 Y130.908 F60000
G1 F6044.427
M204 S8000
G1 X165.811 Y130.891 E.00043
G1 X164.989 Y130.891 E.00664
G1 X164.81 Y130.952 E.00153
G1 X164.691 Y131.189 E.00215
G1 X164.691 Y131.691 E.00406
G1 X162.128 Y131.691 E.02074
G1 X160.309 Y129.872 E.02081
G1 X160.309 Y110.309 E.15825
G1 X193.691 Y110.309 E.27003
G1 X193.691 Y121 E.08648
G1 X193.691 Y131.691 E.08648
; object ids of layer 3 start: 5887,5909
M624 AwAAAAAAAAA=
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

; object ids of this layer3 end: 5887,5909
M625
G1 X168.109 Y131.691 E.20694
G1 X168.109 Y131.189 E.00406
G1 X168.046 Y131.007 E.00156
G1 X167.986 Y130.949 E.00068
G1 X167.811 Y130.891 E.00149
G1 X166.989 Y130.891 E.00664
G1 X166.812 Y130.95 E.00151
G1 X166.691 Y131.189 E.00217
G1 X166.691 Y131.691 E.00406
G1 X166.109 Y131.691 E.00472
G1 X166.109 Y131.189 E.00406
G1 X165.988 Y130.95 E.00217
G1 X165.861 Y130.908 E.00108
; COOLING_NODE: 0
M204 S250
G1 X165.811 Y131.09 F60000
; FEATURE: Outer wall
G1 F6044.427
M204 S5000
G1 X164.951 Y131.098 E.00695
G1 X164.89 Y131.189 E.00089
G1 X164.89 Y131.89 E.00567
G1 X162.046 Y131.89 E.02301
G1 X160.11 Y129.954 E.02214
G1 X160.11 Y110.11 E.16052
G1 X193.89 Y110.11 E.27324
G1 X193.89 Y121 E.08809
G1 X193.89 Y131.89 E.08809
G1 X167.91 Y131.89 E.21015
G1 X167.889 Y131.129 E.00616
G1 X167.811 Y131.09 E.00071
G1 X166.977 Y131.091 E.00674
G1 X166.89 Y131.189 E.00106
G1 X166.89 Y131.89 E.00567
G1 X165.91 Y131.89 E.00793
G1 X165.91 Y131.189 E.00567
G1 X165.87 Y131.11 E.00072
G1 X165.811 Y131.09 E.0005
; WIPE_START
M204 S8000
G1 X164.951 Y131.098 E-.16337
G1 X164.89 Y131.189 E-.0209
G1 X164.89 Y131.89 E-.13314
G1 X164.561 Y131.89 E-.06259
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X162.447 Y131.225 Z.7 F60000
G1 Z.3
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.22002
G1 F6043.513
M204 S8000
G1 X160.864 Y129.642 E.01811
G1 X160.864 Y129.361 E.00227
G1 X162.639 Y131.136 E.0203
G1 X162.92 Y131.136 E.00227
G1 X160.864 Y129.08 E.02352
G1 X160.864 Y128.799 E.00227
G1 X163.201 Y131.136 E.02673
G1 X163.481 Y131.136 E.00227
G1 X160.864 Y128.519 E.02994
G1 X160.864 Y128.238 E.00227
G1 X163.762 Y131.136 E.03315
G1 X164.043 Y131.136 E.00227
G1 X160.864 Y127.957 E.03637
G1 X160.864 Y127.676 E.00227
G1 X164.203 Y131.015 E.0382
G1 X164.284 Y130.815 E.00175
G1 X160.864 Y127.395 E.03912
G1 X160.864 Y127.115 E.00227
G1 X164.364 Y130.614 E.04004
G1 X164.515 Y130.484 E.00161
G1 X160.864 Y126.834 E.04177
G1 X160.864 Y126.553 E.00227
G1 X164.701 Y130.389 E.04389
G1 X164.836 Y130.349 E.00115
G1 X164.94 Y130.347 E.00083
G1 X160.864 Y126.272 E.04663
G1 X160.864 Y125.991 E.00227
G1 X165.217 Y130.344 E.04979
G1 X165.494 Y130.34 E.00224
G1 X160.864 Y125.711 E.05296
G1 X160.864 Y125.43 E.00227
G1 X165.771 Y130.336 E.05613
G1 X166.014 Y130.36 E.00197
G1 X166.103 Y130.387 E.00075
G1 X160.864 Y125.149 E.05993
G1 X160.864 Y124.868 E.00227
G1 X166.493 Y130.496 E.06439
G1 X166.675 Y130.398 E.00168
M73 P64 R6
G1 X160.864 Y124.587 E.06648
G1 X160.864 Y124.307 E.00227
G1 X166.903 Y130.346 E.06909
G1 X167.174 Y130.336 E.00219
G1 X160.864 Y124.026 E.07219
G1 X160.864 Y123.745 E.00227
G1 X167.455 Y130.336 E.0754
G1 X167.736 Y130.336 E.00227
G1 X160.864 Y123.464 E.07862
G1 X160.864 Y123.183 E.00227
G1 X168.062 Y130.381 E.08235
G1 X168.201 Y130.43 E.0012
G1 X168.315 Y130.5 E.00108
G1 X168.491 Y130.671 E.00199
G1 X168.562 Y130.881 E.00179
G1 X168.817 Y131.136 E.00292
G1 X169.097 Y131.136 E.00227
G1 X160.864 Y122.903 E.0942
G1 X160.864 Y122.622 E.00227
G1 X169.378 Y131.136 E.09741
G1 X169.659 Y131.136 E.00227
G1 X160.864 Y122.341 E.10062
G1 X160.864 Y122.06 E.00227
G1 X169.94 Y131.136 E.10383
G1 X170.221 Y131.136 E.00227
G1 X160.864 Y121.779 E.10705
G1 X160.864 Y121.498 E.00227
G1 X170.502 Y131.136 E.11026
G1 X170.782 Y131.136 E.00227
G1 X160.864 Y121.218 E.11347
G1 X160.864 Y120.937 E.00227
G1 X171.063 Y131.136 E.11668
G1 X171.344 Y131.136 E.00227
G1 X160.864 Y120.656 E.1199
G1 X160.864 Y120.375 E.00227
G1 X171.625 Y131.136 E.12311
G1 X171.906 Y131.136 E.00227
G1 X160.864 Y120.094 E.12632
G1 X160.864 Y119.814 E.00227
G1 X172.186 Y131.136 E.12954
G1 X172.467 Y131.136 E.00227
G1 X160.864 Y119.533 E.13275
G1 X160.864 Y119.252 E.00227
G1 X172.748 Y131.136 E.13596
G1 X173.029 Y131.136 E.00227
G1 X160.864 Y118.971 E.13917
G1 X160.864 Y118.69 E.00227
G1 X173.31 Y131.136 E.14239
G1 X173.59 Y131.136 E.00227
G1 X160.864 Y118.41 E.1456
G1 X160.864 Y118.129 E.00227
G1 X173.871 Y131.136 E.14881
G1 X174.152 Y131.136 E.00227
G1 X160.864 Y117.848 E.15202
G1 X160.864 Y117.567 E.00227
G1 X174.433 Y131.136 E.15524
G1 X174.714 Y131.136 E.00227
G1 X160.864 Y117.286 E.15845
G1 X160.864 Y117.006 E.00227
G1 X174.994 Y131.136 E.16166
G1 X175.275 Y131.136 E.00227
G1 X160.864 Y116.725 E.16488
G1 X160.864 Y116.444 E.00227
M73 P64 R5
G1 X175.556 Y131.136 E.16809
G1 X175.837 Y131.136 E.00227
G1 X160.864 Y116.163 E.1713
G1 X160.864 Y115.882 E.00227
G1 X176.118 Y131.136 E.17451
G1 X176.398 Y131.136 E.00227
G1 X160.864 Y115.602 E.17773
G1 X160.864 Y115.321 E.00227
G1 X176.679 Y131.136 E.18094
G1 X176.96 Y131.136 E.00227
G1 X160.864 Y115.04 E.18415
G1 X160.864 Y114.759 E.00227
G1 X177.241 Y131.136 E.18736
G1 X177.522 Y131.136 E.00227
G1 X160.864 Y114.478 E.19058
G1 X160.864 Y114.198 E.00227
G1 X177.802 Y131.136 E.19379
G1 X178.083 Y131.136 E.00227
G1 X160.864 Y113.917 E.197
G1 X160.864 Y113.636 E.00227
G1 X178.364 Y131.136 E.20022
G1 X178.645 Y131.136 E.00227
G1 X160.864 Y113.355 E.20343
G1 X160.864 Y113.074 E.00227
G1 X178.926 Y131.136 E.20664
G1 X179.207 Y131.136 E.00227
G1 X160.864 Y112.793 E.20985
G1 X160.864 Y112.513 E.00227
G1 X179.487 Y131.136 E.21307
G1 X179.768 Y131.136 E.00227
G1 X160.864 Y112.232 E.21628
G1 X160.864 Y111.951 E.00227
G1 X180.049 Y131.136 E.21949
G1 X180.33 Y131.136 E.00227
G1 X160.864 Y111.67 E.2227
G1 X160.864 Y111.389 E.00227
G1 X180.611 Y131.136 E.22592
G1 X180.891 Y131.136 E.00227
G1 X160.864 Y111.109 E.22913
G1 X160.864 Y110.864 E.00198
G1 X160.901 Y110.864 E.0003
G1 X181.172 Y131.136 E.23192
M73 P65 R5
G1 X181.453 Y131.136 E.00227
G1 X161.182 Y110.864 E.23192
G1 X161.463 Y110.864 E.00227
G1 X181.734 Y131.136 E.23192
G1 X182.015 Y131.136 E.00227
G1 X161.743 Y110.864 E.23192
G1 X162.024 Y110.864 E.00227
G1 X182.295 Y131.136 E.23192
G1 X182.576 Y131.136 E.00227
G1 X162.305 Y110.864 E.23192
G1 X162.586 Y110.864 E.00227
G1 X182.857 Y131.136 E.23192
G1 X183.138 Y131.136 E.00227
G1 X162.867 Y110.864 E.23192
G1 X163.147 Y110.864 E.00227
G1 X183.419 Y131.136 E.23192
G1 X183.699 Y131.136 E.00227
G1 X163.428 Y110.864 E.23192
G1 X163.709 Y110.864 E.00227
G1 X183.98 Y131.136 E.23192
G1 X184.261 Y131.136 E.00227
G1 X163.99 Y110.864 E.23192
G1 X164.271 Y110.864 E.00227
G1 X184.542 Y131.136 E.23192
G1 X184.823 Y131.136 E.00227
G1 X164.551 Y110.864 E.23192
G1 X164.832 Y110.864 E.00227
G1 X185.103 Y131.136 E.23192
G1 X185.384 Y131.136 E.00227
G1 X165.113 Y110.864 E.23192
G1 X165.394 Y110.864 E.00227
G1 X185.665 Y131.136 E.23192
G1 X185.946 Y131.136 E.00227
G1 X165.675 Y110.864 E.23192
G1 X165.955 Y110.864 E.00227
G1 X186.227 Y131.136 E.23192
G1 X186.507 Y131.136 E.00227
G1 X166.236 Y110.864 E.23192
G1 X166.517 Y110.864 E.00227
G1 X186.788 Y131.136 E.23192
G1 X187.069 Y131.136 E.00227
G1 X166.798 Y110.864 E.23192
G1 X167.079 Y110.864 E.00227
G1 X187.35 Y131.136 E.23192
G1 X187.631 Y131.136 E.00227
G1 X167.359 Y110.864 E.23192
G1 X167.64 Y110.864 E.00227
G1 X187.912 Y131.136 E.23192
G1 X188.192 Y131.136 E.00227
G1 X167.921 Y110.864 E.23192
G1 X168.202 Y110.864 E.00227
G1 X188.473 Y131.136 E.23192
G1 X188.754 Y131.136 E.00227
G1 X168.483 Y110.864 E.23192
G1 X168.764 Y110.864 E.00227
G1 X189.035 Y131.136 E.23192
G1 X189.316 Y131.136 E.00227
G1 X169.044 Y110.864 E.23192
G1 X169.325 Y110.864 E.00227
G1 X189.596 Y131.136 E.23192
G1 X189.877 Y131.136 E.00227
G1 X169.606 Y110.864 E.23192
G1 X169.887 Y110.864 E.00227
G1 X190.158 Y131.136 E.23192
G1 X190.439 Y131.136 E.00227
G1 X170.168 Y110.864 E.23192
G1 X170.448 Y110.864 E.00227
M73 P66 R5
G1 X190.72 Y131.136 E.23192
G1 X191 Y131.136 E.00227
G1 X170.729 Y110.864 E.23192
G1 X171.01 Y110.864 E.00227
G1 X191.281 Y131.136 E.23192
G1 X191.562 Y131.136 E.00227
G1 X171.291 Y110.864 E.23192
G1 X171.572 Y110.864 E.00227
G1 X191.843 Y131.136 E.23192
G1 X192.124 Y131.136 E.00227
G1 X171.852 Y110.864 E.23192
G1 X172.133 Y110.864 E.00227
G1 X192.404 Y131.136 E.23192
G1 X192.685 Y131.136 E.00227
G1 X172.414 Y110.864 E.23192
G1 X172.695 Y110.864 E.00227
G1 X192.966 Y131.136 E.23192
G1 X193.136 Y131.136 E.00137
G1 X193.136 Y131.024 E.0009
G1 X172.976 Y110.864 E.23065
G1 X173.256 Y110.864 E.00227
G1 X193.136 Y130.744 E.22744
G1 X193.136 Y130.463 E.00227
G1 X173.537 Y110.864 E.22423
G1 X173.818 Y110.864 E.00227
G1 X193.136 Y130.182 E.22101
G1 X193.136 Y129.901 E.00227
G1 X174.099 Y110.864 E.2178
G1 X174.38 Y110.864 E.00227
G1 X193.136 Y129.62 E.21459
G1 X193.136 Y129.34 E.00227
G1 X174.66 Y110.864 E.21138
G1 X174.941 Y110.864 E.00227
G1 X193.136 Y129.059 E.20816
G1 X193.136 Y128.778 E.00227
G1 X175.222 Y110.864 E.20495
G1 X175.503 Y110.864 E.00227
G1 X193.136 Y128.497 E.20174
G1 X193.136 Y128.216 E.00227
G1 X175.784 Y110.864 E.19852
G1 X176.064 Y110.864 E.00227
G1 X193.136 Y127.936 E.19531
G1 X193.136 Y127.655 E.00227
G1 X176.345 Y110.864 E.1921
G1 X176.626 Y110.864 E.00227
G1 X193.136 Y127.374 E.18889
G1 X193.136 Y127.093 E.00227
G1 X176.907 Y110.864 E.18567
G1 X177.188 Y110.864 E.00227
G1 X193.136 Y126.812 E.18246
G1 X193.136 Y126.532 E.00227
G1 X177.469 Y110.864 E.17925
G1 X177.749 Y110.864 E.00227
G1 X193.136 Y126.251 E.17604
G1 X193.136 Y125.97 E.00227
G1 X178.03 Y110.864 E.17282
G1 X178.311 Y110.864 E.00227
G1 X193.136 Y125.689 E.16961
G1 X193.136 Y125.408 E.00227
G1 X178.592 Y110.864 E.1664
G1 X178.873 Y110.864 E.00227
G1 X193.136 Y125.127 E.16319
G1 X193.136 Y124.847 E.00227
G1 X179.153 Y110.864 E.15997
G1 X179.434 Y110.864 E.00227
G1 X193.136 Y124.566 E.15676
G1 X193.136 Y124.285 E.00227
G1 X179.715 Y110.864 E.15355
G1 X179.996 Y110.864 E.00227
G1 X193.136 Y124.004 E.15033
G1 X193.136 Y123.723 E.00227
G1 X180.277 Y110.864 E.14712
G1 X180.557 Y110.864 E.00227
G1 X193.136 Y123.443 E.14391
G1 X193.136 Y123.162 E.00227
G1 X180.838 Y110.864 E.1407
G1 X181.119 Y110.864 E.00227
G1 X193.136 Y122.881 E.13748
G1 X193.136 Y122.6 E.00227
M73 P67 R5
G1 X181.4 Y110.864 E.13427
G1 X181.681 Y110.864 E.00227
G1 X193.136 Y122.319 E.13106
G1 X193.136 Y122.039 E.00227
G1 X181.961 Y110.864 E.12785
G1 X182.242 Y110.864 E.00227
G1 X193.136 Y121.758 E.12463
G1 X193.136 Y121.477 E.00227
G1 X182.523 Y110.864 E.12142
G1 X182.804 Y110.864 E.00227
G1 X193.136 Y121.196 E.11821
G1 X193.136 Y120.915 E.00227
G1 X183.085 Y110.864 E.11499
G1 X183.365 Y110.864 E.00227
G1 X193.136 Y120.635 E.11178
G1 X193.136 Y120.354 E.00227
G1 X183.646 Y110.864 E.10857
G1 X183.927 Y110.864 E.00227
G1 X193.136 Y120.073 E.10536
G1 X193.136 Y119.792 E.00227
G1 X184.208 Y110.864 E.10214
G1 X184.489 Y110.864 E.00227
G1 X193.136 Y119.511 E.09893
G1 X193.136 Y119.231 E.00227
G1 X184.769 Y110.864 E.09572
G1 X185.05 Y110.864 E.00227
G1 X193.136 Y118.95 E.09251
G1 X193.136 Y118.669 E.00227
G1 X185.331 Y110.864 E.08929
G1 X185.612 Y110.864 E.00227
G1 X193.136 Y118.388 E.08608
G1 X193.136 Y118.107 E.00227
G1 X185.893 Y110.864 E.08287
G1 X186.173 Y110.864 E.00227
G1 X193.136 Y117.827 E.07965
G1 X193.136 Y117.546 E.00227
G1 X186.454 Y110.864 E.07644
G1 X186.735 Y110.864 E.00227
G1 X193.136 Y117.265 E.07323
G1 X193.136 Y116.984 E.00227
G1 X187.016 Y110.864 E.07002
G1 X187.297 Y110.864 E.00227
G1 X193.136 Y116.703 E.0668
G1 X193.136 Y116.422 E.00227
G1 X187.578 Y110.864 E.06359
G1 X187.858 Y110.864 E.00227
G1 X193.136 Y116.142 E.06038
G1 X193.136 Y115.861 E.00227
G1 X188.139 Y110.864 E.05717
G1 X188.42 Y110.864 E.00227
G1 X193.136 Y115.58 E.05395
G1 X193.136 Y115.299 E.00227
G1 X188.701 Y110.864 E.05074
G1 X188.982 Y110.864 E.00227
G1 X193.136 Y115.018 E.04753
G1 X193.136 Y114.738 E.00227
G1 X189.262 Y110.864 E.04431
G1 X189.543 Y110.864 E.00227
G1 X193.136 Y114.457 E.0411
G1 X193.136 Y114.176 E.00227
G1 X189.824 Y110.864 E.03789
G1 X190.105 Y110.864 E.00227
G1 X193.136 Y113.895 E.03468
G1 X193.136 Y113.614 E.00227
G1 X190.386 Y110.864 E.03146
G1 X190.666 Y110.864 E.00227
G1 X193.136 Y113.334 E.02825
G1 X193.136 Y113.053 E.00227
G1 X190.947 Y110.864 E.02504
G1 X191.228 Y110.864 E.00227
G1 X193.136 Y112.772 E.02183
G1 X193.136 Y112.491 E.00227
G1 X191.509 Y110.864 E.01861
G1 X191.79 Y110.864 E.00227
G1 X193.136 Y112.21 E.0154
G1 X193.136 Y111.93 E.00227
G1 X192.07 Y110.864 E.01219
G1 X192.351 Y110.864 E.00227
G1 X193.136 Y111.649 E.00897
G1 X193.136 Y111.368 E.00227
G1 X192.632 Y110.864 E.00576
G1 X192.913 Y110.864 E.00227
G1 X193.225 Y111.176 E.00357
; OBJECT_ID: 5887
; COOLING_NODE: 0
; WIPE_START
G1 X192.913 Y110.864 E-.08387
G1 X192.632 Y110.864 E-.05335
G1 X193.136 Y111.368 E-.13531
G1 X193.136 Y111.649 E-.05335
G1 X192.934 Y111.447 E-.05411
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 5909
M625
; start printing object, unique label id: 5887
M624 AQAAAAAAAAA=
M204 S10000
G1 X185.606 Y113.581 Z.7 F60000
G1 X126.388 Y130.825 Z.7
G1 Z.3
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.21999
G1 F6044.427
M204 S8000
G1 X126.375 Y130.783 E.00036
G1 X126.239 Y130.642 E.00159
G1 X126.088 Y130.552 E.00142
G1 X125.811 Y130.494 E.00229
G1 X124.989 Y130.494 E.00664
G1 X124.721 Y130.548 E.00221
G1 X124.491 Y130.705 E.00225
G1 X124.294 Y131.189 E.00423
G1 X124.294 Y131.294 E.00085
G1 X122.292 Y131.294 E.0162
G1 X120.706 Y129.708 E.01815
G1 X120.706 Y110.706 E.15371
G1 X153.294 Y110.706 E.26361
G1 X153.294 Y121 E.08327
G1 X153.294 Y131.294 E.08327
G1 X126.506 Y131.294 E.21669
G1 X126.506 Y131.189 E.00085
G1 X126.388 Y130.825 E.00309
; COOLING_NODE: 0
M204 S10000
G1 X126.223 Y130.927 F60000
G1 F6044.427
M204 S8000
G1 X126.214 Y130.899 E.00024
G1 X126.052 Y130.755 E.00175
G1 X125.811 Y130.693 E.00202
G1 X124.989 Y130.693 E.00664
G1 X124.798 Y130.731 E.00158
G1 X124.633 Y130.843 E.00161
G1 X124.493 Y131.189 E.00302
G1 X124.493 Y131.493 E.00246
G1 X122.21 Y131.493 E.01847
G1 X120.507 Y129.79 E.01948
G1 X120.507 Y110.507 E.15598
G1 X153.493 Y110.507 E.26682
G1 X153.493 Y121 E.08488
G1 X153.493 Y131.493 E.08488
G1 X126.307 Y131.493 E.2199
G1 X126.307 Y131.189 E.00246
G1 X126.223 Y130.927 E.00223
; COOLING_NODE: 0
M204 S10000
G1 X126.057 Y131.029 F60000
G1 F6044.427
M204 S8000
G1 X126.052 Y131.015 E.00012
G1 X125.994 Y130.955 E.00068
G1 X125.811 Y130.891 E.00157
G1 X124.989 Y130.891 E.00664
G1 X124.81 Y130.952 E.00153
G1 X124.691 Y131.189 E.00215
G1 X124.691 Y131.691 E.00406
G1 X122.128 Y131.691 E.02074
G1 X120.309 Y129.872 E.02081
G1 X120.309 Y110.309 E.15825
G1 X153.691 Y110.309 E.27003
G1 X153.691 Y121 E.08648
G1 X153.691 Y131.691 E.08648
G1 X126.109 Y131.691 E.22311
G1 X126.109 Y131.189 E.00406
G1 X126.057 Y131.029 E.00136
; COOLING_NODE: 0
M204 S250
G1 X125.891 Y131.131 F60000
; FEATURE: Outer wall
G1 F6044.427
M204 S5000
G1 X125.811 Y131.09 E.00073
G1 X124.951 Y131.098 E.00695
G1 X124.89 Y131.189 E.00089
G1 X124.89 Y131.89 E.00567
G1 X122.046 Y131.89 E.02301
G1 X120.11 Y129.954 E.02214
G1 X120.11 Y110.11 E.16052
G1 X153.89 Y110.11 E.27324
G1 X153.89 Y121 E.08809
G1 X153.89 Y131.89 E.08809
G1 X125.91 Y131.89 E.22633
G1 X125.891 Y131.131 E.00614
M204 S10000
G1 X125.87 Y130.435 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.22002
G1 F6043.513
M204 S8000
G1 X120.864 Y125.43 E.05727
G1 X120.864 Y125.711 E.00227
G1 X125.489 Y130.336 E.05292
G1 X125.209 Y130.336 E.00227
G1 X120.864 Y125.991 E.0497
G1 X120.864 Y126.272 E.00227
G1 X124.933 Y130.341 E.04655
G1 X124.701 Y130.389 E.00192
G1 X120.864 Y126.553 E.04389
G1 X120.864 Y126.834 E.00227
M73 P68 R5
G1 X124.515 Y130.484 E.04177
G1 X124.364 Y130.614 E.00161
G1 X120.864 Y127.115 E.04004
G1 X120.864 Y127.395 E.00227
G1 X124.284 Y130.815 E.03912
G1 X124.203 Y131.015 E.00175
G1 X120.864 Y127.676 E.0382
G1 X120.864 Y127.957 E.00227
G1 X124.043 Y131.136 E.03637
G1 X123.762 Y131.136 E.00227
G1 X120.864 Y128.238 E.03315
G1 X120.864 Y128.519 E.00227
G1 X123.481 Y131.136 E.02994
G1 X123.201 Y131.136 E.00227
G1 X120.864 Y128.799 E.02673
G1 X120.864 Y129.08 E.00227
G1 X122.92 Y131.136 E.02352
G1 X122.639 Y131.136 E.00227
G1 X120.864 Y129.361 E.0203
G1 X120.864 Y129.642 E.00227
G1 X122.447 Y131.225 E.01811
; WIPE_START
G1 X121.033 Y129.811 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X126.94 Y131.225 Z.7 F60000
G1 Z.3
G1 E.4 F1800
G1 F6043.513
M204 S8000
G1 X120.864 Y125.149 E.06952
G1 X120.864 Y124.868 E.00227
G1 X127.132 Y131.136 E.07171
G1 X127.413 Y131.136 E.00227
G1 X120.864 Y124.587 E.07492
G1 X120.864 Y124.307 E.00227
G1 X127.693 Y131.136 E.07813
G1 X127.974 Y131.136 E.00227
G1 X120.864 Y124.026 E.08134
G1 X120.864 Y123.745 E.00227
G1 X128.255 Y131.136 E.08456
G1 X128.536 Y131.136 E.00227
G1 X120.864 Y123.464 E.08777
G1 X120.864 Y123.183 E.00227
G1 X128.817 Y131.136 E.09098
G1 X129.097 Y131.136 E.00227
G1 X120.864 Y122.902 E.0942
G1 X120.864 Y122.622 E.00227
G1 X129.378 Y131.136 E.09741
G1 X129.659 Y131.136 E.00227
G1 X120.864 Y122.341 E.10062
G1 X120.864 Y122.06 E.00227
G1 X129.94 Y131.136 E.10383
G1 X130.221 Y131.136 E.00227
G1 X120.864 Y121.779 E.10705
G1 X120.864 Y121.498 E.00227
G1 X130.502 Y131.136 E.11026
G1 X130.782 Y131.136 E.00227
G1 X120.864 Y121.218 E.11347
G1 X120.864 Y120.937 E.00227
G1 X131.063 Y131.136 E.11668
G1 X131.344 Y131.136 E.00227
G1 X120.864 Y120.656 E.1199
G1 X120.864 Y120.375 E.00227
G1 X131.625 Y131.136 E.12311
G1 X131.906 Y131.136 E.00227
G1 X120.864 Y120.094 E.12632
G1 X120.864 Y119.814 E.00227
G1 X132.186 Y131.136 E.12954
G1 X132.467 Y131.136 E.00227
G1 X120.864 Y119.533 E.13275
G1 X120.864 Y119.252 E.00227
G1 X132.748 Y131.136 E.13596
G1 X133.029 Y131.136 E.00227
G1 X120.864 Y118.971 E.13917
G1 X120.864 Y118.69 E.00227
G1 X133.31 Y131.136 E.14239
G1 X133.59 Y131.136 E.00227
G1 X120.864 Y118.41 E.1456
G1 X120.864 Y118.129 E.00227
G1 X133.871 Y131.136 E.14881
G1 X134.152 Y131.136 E.00227
G1 X120.864 Y117.848 E.15202
G1 X120.864 Y117.567 E.00227
G1 X134.433 Y131.136 E.15524
G1 X134.714 Y131.136 E.00227
G1 X120.864 Y117.286 E.15845
G1 X120.864 Y117.006 E.00227
G1 X134.994 Y131.136 E.16166
G1 X135.275 Y131.136 E.00227
G1 X120.864 Y116.725 E.16488
G1 X120.864 Y116.444 E.00227
G1 X135.556 Y131.136 E.16809
G1 X135.837 Y131.136 E.00227
G1 X120.864 Y116.163 E.1713
G1 X120.864 Y115.882 E.00227
G1 X136.118 Y131.136 E.17451
G1 X136.398 Y131.136 E.00227
G1 X120.864 Y115.602 E.17773
G1 X120.864 Y115.321 E.00227
G1 X136.679 Y131.136 E.18094
G1 X136.96 Y131.136 E.00227
G1 X120.864 Y115.04 E.18415
G1 X120.864 Y114.759 E.00227
G1 X137.241 Y131.136 E.18736
G1 X137.522 Y131.136 E.00227
G1 X120.864 Y114.478 E.19058
G1 X120.864 Y114.198 E.00227
G1 X137.802 Y131.136 E.19379
G1 X138.083 Y131.136 E.00227
G1 X120.864 Y113.917 E.197
G1 X120.864 Y113.636 E.00227
G1 X138.364 Y131.136 E.20022
G1 X138.645 Y131.136 E.00227
G1 X120.864 Y113.355 E.20343
G1 X120.864 Y113.074 E.00227
G1 X138.926 Y131.136 E.20664
G1 X139.207 Y131.136 E.00227
G1 X120.864 Y112.793 E.20985
G1 X120.864 Y112.513 E.00227
G1 X139.487 Y131.136 E.21307
G1 X139.768 Y131.136 E.00227
G1 X120.864 Y112.232 E.21628
G1 X120.864 Y111.951 E.00227
G1 X140.049 Y131.136 E.21949
G1 X140.33 Y131.136 E.00227
G1 X120.864 Y111.67 E.2227
G1 X120.864 Y111.389 E.00227
M73 P69 R5
G1 X140.611 Y131.136 E.22592
G1 X140.891 Y131.136 E.00227
G1 X120.864 Y111.109 E.22913
G1 X120.864 Y110.864 E.00198
G1 X120.901 Y110.864 E.0003
G1 X141.172 Y131.136 E.23192
G1 X141.453 Y131.136 E.00227
G1 X121.182 Y110.864 E.23192
G1 X121.463 Y110.864 E.00227
G1 X141.734 Y131.136 E.23192
G1 X142.015 Y131.136 E.00227
G1 X121.743 Y110.864 E.23192
G1 X122.024 Y110.864 E.00227
G1 X142.295 Y131.136 E.23192
G1 X142.576 Y131.136 E.00227
G1 X122.305 Y110.864 E.23192
G1 X122.586 Y110.864 E.00227
G1 X142.857 Y131.136 E.23192
G1 X143.138 Y131.136 E.00227
G1 X122.867 Y110.864 E.23192
G1 X123.147 Y110.864 E.00227
G1 X143.419 Y131.136 E.23192
G1 X143.699 Y131.136 E.00227
G1 X123.428 Y110.864 E.23192
G1 X123.709 Y110.864 E.00227
G1 X143.98 Y131.136 E.23192
G1 X144.261 Y131.136 E.00227
G1 X123.99 Y110.864 E.23192
G1 X124.271 Y110.864 E.00227
G1 X144.542 Y131.136 E.23192
G1 X144.823 Y131.136 E.00227
G1 X124.551 Y110.864 E.23192
G1 X124.832 Y110.864 E.00227
G1 X145.103 Y131.136 E.23192
G1 X145.384 Y131.136 E.00227
G1 X125.113 Y110.864 E.23192
G1 X125.394 Y110.864 E.00227
G1 X145.665 Y131.136 E.23192
G1 X145.946 Y131.136 E.00227
G1 X125.675 Y110.864 E.23192
G1 X125.955 Y110.864 E.00227
G1 X146.227 Y131.136 E.23192
G1 X146.507 Y131.136 E.00227
G1 X126.236 Y110.864 E.23192
G1 X126.517 Y110.864 E.00227
G1 X146.788 Y131.136 E.23192
G1 X147.069 Y131.136 E.00227
G1 X126.798 Y110.864 E.23192
G1 X127.079 Y110.864 E.00227
G1 X147.35 Y131.136 E.23192
G1 X147.631 Y131.136 E.00227
G1 X127.359 Y110.864 E.23192
G1 X127.64 Y110.864 E.00227
G1 X147.912 Y131.136 E.23192
G1 X148.192 Y131.136 E.00227
G1 X127.921 Y110.864 E.23192
G1 X128.202 Y110.864 E.00227
G1 X148.473 Y131.136 E.23192
G1 X148.754 Y131.136 E.00227
G1 X128.483 Y110.864 E.23192
G1 X128.763 Y110.864 E.00227
G1 X149.035 Y131.136 E.23192
G1 X149.316 Y131.136 E.00227
G1 X129.044 Y110.864 E.23192
G1 X129.325 Y110.864 E.00227
G1 X149.596 Y131.136 E.23192
G1 X149.877 Y131.136 E.00227
M73 P70 R5
G1 X129.606 Y110.864 E.23192
G1 X129.887 Y110.864 E.00227
G1 X150.158 Y131.136 E.23192
G1 X150.439 Y131.136 E.00227
G1 X130.168 Y110.864 E.23192
G1 X130.448 Y110.864 E.00227
G1 X150.72 Y131.136 E.23192
G1 X151 Y131.136 E.00227
G1 X130.729 Y110.864 E.23192
G1 X131.01 Y110.864 E.00227
G1 X151.281 Y131.136 E.23192
G1 X151.562 Y131.136 E.00227
G1 X131.291 Y110.864 E.23192
G1 X131.572 Y110.864 E.00227
G1 X151.843 Y131.136 E.23192
G1 X152.124 Y131.136 E.00227
G1 X131.852 Y110.864 E.23192
G1 X132.133 Y110.864 E.00227
G1 X152.404 Y131.136 E.23192
G1 X152.685 Y131.136 E.00227
G1 X132.414 Y110.864 E.23192
G1 X132.695 Y110.864 E.00227
G1 X152.966 Y131.136 E.23192
G1 X153.136 Y131.136 E.00137
G1 X153.136 Y131.024 E.0009
G1 X132.976 Y110.864 E.23065
M73 P70 R4
G1 X133.256 Y110.864 E.00227
G1 X153.136 Y130.744 E.22744
G1 X153.136 Y130.463 E.00227
G1 X133.537 Y110.864 E.22423
G1 X133.818 Y110.864 E.00227
G1 X153.136 Y130.182 E.22101
G1 X153.136 Y129.901 E.00227
G1 X134.099 Y110.864 E.2178
G1 X134.38 Y110.864 E.00227
G1 X153.136 Y129.62 E.21459
G1 X153.136 Y129.34 E.00227
G1 X134.66 Y110.864 E.21138
G1 X134.941 Y110.864 E.00227
G1 X153.136 Y129.059 E.20816
G1 X153.136 Y128.778 E.00227
G1 X135.222 Y110.864 E.20495
G1 X135.503 Y110.864 E.00227
G1 X153.136 Y128.497 E.20174
G1 X153.136 Y128.216 E.00227
G1 X135.784 Y110.864 E.19853
G1 X136.064 Y110.864 E.00227
G1 X153.136 Y127.936 E.19531
G1 X153.136 Y127.655 E.00227
G1 X136.345 Y110.864 E.1921
G1 X136.626 Y110.864 E.00227
G1 X153.136 Y127.374 E.18889
G1 X153.136 Y127.093 E.00227
G1 X136.907 Y110.864 E.18567
G1 X137.188 Y110.864 E.00227
G1 X153.136 Y126.812 E.18246
G1 X153.136 Y126.532 E.00227
G1 X137.468 Y110.864 E.17925
G1 X137.749 Y110.864 E.00227
G1 X153.136 Y126.251 E.17604
G1 X153.136 Y125.97 E.00227
G1 X138.03 Y110.864 E.17282
G1 X138.311 Y110.864 E.00227
G1 X153.136 Y125.689 E.16961
G1 X153.136 Y125.408 E.00227
G1 X138.592 Y110.864 E.1664
G1 X138.873 Y110.864 E.00227
G1 X153.136 Y125.127 E.16319
G1 X153.136 Y124.847 E.00227
G1 X139.153 Y110.864 E.15997
G1 X139.434 Y110.864 E.00227
G1 X153.136 Y124.566 E.15676
G1 X153.136 Y124.285 E.00227
G1 X139.715 Y110.864 E.15355
G1 X139.996 Y110.864 E.00227
M73 P71 R4
G1 X153.136 Y124.004 E.15033
G1 X153.136 Y123.723 E.00227
G1 X140.277 Y110.864 E.14712
G1 X140.557 Y110.864 E.00227
G1 X153.136 Y123.443 E.14391
G1 X153.136 Y123.162 E.00227
G1 X140.838 Y110.864 E.1407
G1 X141.119 Y110.864 E.00227
G1 X153.136 Y122.881 E.13748
G1 X153.136 Y122.6 E.00227
G1 X141.4 Y110.864 E.13427
G1 X141.681 Y110.864 E.00227
G1 X153.136 Y122.319 E.13106
G1 X153.136 Y122.039 E.00227
G1 X141.961 Y110.864 E.12785
G1 X142.242 Y110.864 E.00227
G1 X153.136 Y121.758 E.12463
G1 X153.136 Y121.477 E.00227
G1 X142.523 Y110.864 E.12142
G1 X142.804 Y110.864 E.00227
G1 X153.136 Y121.196 E.11821
G1 X153.136 Y120.915 E.00227
G1 X143.085 Y110.864 E.11499
G1 X143.365 Y110.864 E.00227
G1 X153.136 Y120.635 E.11178
G1 X153.136 Y120.354 E.00227
G1 X143.646 Y110.864 E.10857
G1 X143.927 Y110.864 E.00227
G1 X153.136 Y120.073 E.10536
G1 X153.136 Y119.792 E.00227
G1 X144.208 Y110.864 E.10214
G1 X144.489 Y110.864 E.00227
G1 X153.136 Y119.511 E.09893
G1 X153.136 Y119.231 E.00227
G1 X144.769 Y110.864 E.09572
G1 X145.05 Y110.864 E.00227
G1 X153.136 Y118.95 E.09251
G1 X153.136 Y118.669 E.00227
G1 X145.331 Y110.864 E.08929
G1 X145.612 Y110.864 E.00227
G1 X153.136 Y118.388 E.08608
G1 X153.136 Y118.107 E.00227
G1 X145.893 Y110.864 E.08287
G1 X146.173 Y110.864 E.00227
G1 X153.136 Y117.827 E.07965
G1 X153.136 Y117.546 E.00227
G1 X146.454 Y110.864 E.07644
G1 X146.735 Y110.864 E.00227
G1 X153.136 Y117.265 E.07323
G1 X153.136 Y116.984 E.00227
G1 X147.016 Y110.864 E.07002
G1 X147.297 Y110.864 E.00227
G1 X153.136 Y116.703 E.0668
G1 X153.136 Y116.422 E.00227
G1 X147.578 Y110.864 E.06359
G1 X147.858 Y110.864 E.00227
G1 X153.136 Y116.142 E.06038
G1 X153.136 Y115.861 E.00227
G1 X148.139 Y110.864 E.05717
G1 X148.42 Y110.864 E.00227
G1 X153.136 Y115.58 E.05395
G1 X153.136 Y115.299 E.00227
G1 X148.701 Y110.864 E.05074
G1 X148.982 Y110.864 E.00227
G1 X153.136 Y115.018 E.04753
G1 X153.136 Y114.738 E.00227
G1 X149.262 Y110.864 E.04431
G1 X149.543 Y110.864 E.00227
G1 X153.136 Y114.457 E.0411
G1 X153.136 Y114.176 E.00227
G1 X149.824 Y110.864 E.03789
G1 X150.105 Y110.864 E.00227
G1 X153.136 Y113.895 E.03468
G1 X153.136 Y113.614 E.00227
G1 X150.386 Y110.864 E.03146
G1 X150.666 Y110.864 E.00227
G1 X153.136 Y113.334 E.02825
G1 X153.136 Y113.053 E.00227
G1 X150.947 Y110.864 E.02504
G1 X151.228 Y110.864 E.00227
G1 X153.136 Y112.772 E.02183
G1 X153.136 Y112.491 E.00227
G1 X151.509 Y110.864 E.01861
G1 X151.79 Y110.864 E.00227
G1 X153.136 Y112.21 E.0154
G1 X153.136 Y111.93 E.00227
G1 X152.07 Y110.864 E.01219
G1 X152.351 Y110.864 E.00227
G1 X153.136 Y111.649 E.00897
G1 X153.136 Y111.368 E.00227
G1 X152.632 Y110.864 E.00576
G1 X152.913 Y110.864 E.00227
G1 X153.225 Y111.176 E.00357
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.1
; WIPE_START
G1 F6043.513
G1 X152.913 Y110.864 E-.08387
G1 X152.632 Y110.864 E-.05335
G1 X153.136 Y111.368 E-.13531
G1 X153.136 Y111.649 E-.05335
G1 X152.934 Y111.447 E-.05411
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 5887
M625
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 4/7
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change

M106 S163.2
; OBJECT_ID: 5909
; COOLING_NODE: 0
; start printing object, unique label id: 5909
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z.7 I-.952 J.758 P1  F60000
G1 X168.268 Y130.716 Z.7
G1 Z.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.21999
G1 F6044.427
M204 S8000
G1 X179.306 Y130.709 E.08928
G1 X179.602 Y130.537 E.00277
G1 X179.715 Y130.251 E.00249
G1 X179.716 Y129.767 E.00391
G1 X181.191 Y128.84 E.01409
G1 X181.53 Y128.627 E.00324
G1 F5876.836
G1 X181.868 Y128.414 E.00324
; LINE_WIDTH: 0.263145
G1 F4965.14
G1 X182.313 Y128.161 E.00504
; LINE_WIDTH: 0.3063
G1 F4212.892
G1 X182.757 Y127.907 E.00594
G1 X184.443 Y126.831 E.02321
; LINE_WIDTH: 0.27945
G1 F4651.343
G1 X186.129 Y125.756 E.02102
; LINE_WIDTH: 0.25261
G1 F5191.434
G1 X187.815 Y124.68 E.01884
; LINE_WIDTH: 0.22577
G1 F5873.428
G1 X188.152 Y124.465 E.00333
G1 X189.501 Y123.604 E.01332
; LINE_WIDTH: 0.19893
G1 F6761.706
G1 X189.838 Y123.389 E.00289
G1 X190.247 Y123.128 E.00351
G1 F5989.115
G1 X190.585 Y122.913 E.00289
G1 F5068.386
G1 X190.922 Y122.698 E.00289
; LINE_WIDTH: 0.226154
G1 F4224.457
G1 X190.992 Y122.684 E.00059
; LINE_WIDTH: 0.275987
G1 F4082.373
G1 X191.061 Y122.669 E.00074
; LINE_WIDTH: 0.32582
G1 F3942.699
G1 X191.131 Y122.655 E.00088
G1 X191.089 Y122.713 E.00088
; LINE_WIDTH: 0.275987
G1 F4082.365
G1 X191.048 Y122.77 E.00074
; LINE_WIDTH: 0.226154
G1 F4224.462
G1 X191.006 Y122.828 E.00059
; LINE_WIDTH: 0.20316
G1 F5068.391
G1 X190.672 Y123.048 E.00296
G1 F5989.12
G1 X190.337 Y123.267 E.00296
G1 F6478.288
G1 X190.003 Y123.487 E.00296
G1 X189.669 Y123.707 E.00296
G1 X189.335 Y123.926 E.00296
; LINE_WIDTH: 0.23
G1 F5754.292
G1 X187.997 Y124.805 E.01359
G1 X187.663 Y125.024 E.0034
; LINE_WIDTH: 0.25684
G1 F5098.139
G1 X186.326 Y125.903 E.01534
G1 X185.992 Y126.123 E.00384
; LINE_WIDTH: 0.28368
G1 F4576.31
G1 X184.32 Y127.221 E.02137
; LINE_WIDTH: 0.3063
G1 F4212.892
G1 X182.912 Y128.146 E.01956
; LINE_WIDTH: 0.31137
G1 F4139.216
G1 X182.847 Y128.193 E.00094
G1 X182.792 Y128.466 E.00329
; LINE_WIDTH: 0.26568
G1 F4713.308
G1 X182.736 Y128.739 E.00277
; LINE_WIDTH: 0.21999
G1 F5602.569
G1 X182.852 Y129.122 E.00324
G1 F6044.427
G1 X182.925 Y129.364 E.00205
G1 X183.116 Y129.627 E.00263
G1 X183.4 Y129.716 E.00241
G1 X192.22 Y129.716 E.07134
G1 X192.306 Y129.709 E.0007
G1 X192.577 Y129.565 E.00248
G1 X192.709 Y129.306 E.00235
G1 X192.716 Y129.22 E.0007
G1 X192.716 Y122.989 E.0504
G1 X192.716 Y122.589 E.00324
G1 F6002.399
G1 X192.577 Y122.245 E.003
G1 F5144.02
G1 X192.484 Y122.169 E.00097
; LINE_WIDTH: 0.260175
G1 F4880.439
G1 X192.209 Y122.152 E.00268
; LINE_WIDTH: 0.30036
G1 F4302.618
G1 X191.934 Y122.135 E.00313
G1 X192.256 Y121.9 E.00452
; LINE_WIDTH: 0.260175
G1 F5026.915
G1 X192.577 Y121.666 E.00387
; LINE_WIDTH: 0.21999
G1 F5684.504
G1 X192.709 Y121.407 E.00235
G1 F6044.427
G1 X192.713 Y121.007 E.00324
G1 X192.716 Y120.678 E.00266
G1 X192.484 Y120.258 E.00388
G1 X179.716 Y112.233 E.12198
G1 X179.716 Y111.78 E.00366
G1 X179.602 Y111.463 E.00272
G1 X179.22 Y111.284 E.00341
G1 X161.694 Y111.291 E.14176
G1 X161.429 Y111.429 E.00242
G1 X161.284 Y111.78 E.00307
G1 X161.284 Y130.22 E.14916
G1 X161.33 Y130.332 E.00098
G1 X160.706 Y129.708 E.00715
G1 X160.706 Y110.706 E.15371
G1 X193.294 Y110.706 E.26361
G1 X193.294 Y114.287 E.02897
G1 X193.294 Y131.294 E.13757
G1 X168.506 Y131.294 E.20051
G1 X168.492 Y131.073 E.00179
G1 X168.37 Y130.804 E.00239
G1 X168.268 Y130.716 E.00109
; COOLING_NODE: 0
; WIPE_START
G1 X170.268 Y130.715 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X177.804 Y129.504 Z.8 F60000
G1 X182.926 Y128.681 Z.8
G1 Z.4
G1 E.4 F1800
G1 F6044.427
M204 S8000
G1 X183.046 Y128.347 E.00287
G1 X191.104 Y122.975 E.07834
G1 X192.062 Y122.337 E.00931
G1 X192.378 Y122.337 E.00256
G1 X192.434 Y122.382 E.00058
G1 X192.518 Y122.589 E.0018
G1 X192.518 Y129.22 E.05364
G1 X192.434 Y129.427 E.00181
G1 X192.22 Y129.518 E.00188
G1 X183.4 Y129.518 E.07134
G1 X183.23 Y129.464 E.00144
G1 X183.115 Y129.306 E.00158
G1 X182.926 Y128.681 E.00528
; COOLING_NODE: 0
M204 S10000
G1 X183.116 Y128.624 F60000
G1 F6044.427
M204 S8000
G1 X183.156 Y128.512 E.00096
G1 X191.214 Y123.14 E.07834
G1 X192.167 Y122.505 E.00926
G1 X192.291 Y122.52 E.00101
G1 X192.319 Y122.589 E.0006
G1 X192.319 Y129.22 E.05364
G1 X192.241 Y129.317 E.00101
G1 X183.4 Y129.319 E.07151
G1 X183.305 Y129.249 E.00096
G1 X183.116 Y128.624 E.00528
; COOLING_NODE: 0
; WIPE_START
G1 X183.156 Y128.512 E-.02248
G1 X184.721 Y127.469 E-.35752
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X177.186 Y128.68 Z.8 F60000
G1 X164.52 Y130.716 Z.8
G1 Z.4
G1 E.4 F1800
G1 F6044.427
M204 S8000
G1 X164.387 Y130.864 E.00161
G1 X164.331 Y131.003 E.00121
G1 X164.294 Y131.294 E.00238
G1 X162.292 Y131.294 E.0162
G1 X161.684 Y130.686 E.00696
G1 X161.78 Y130.716 E.00082
G1 X164.52 Y130.716 E.02216
; COOLING_NODE: 0
; WIPE_START
G1 X164.387 Y130.864 E-.03784
G1 X164.331 Y131.003 E-.02836
G1 X164.294 Y131.294 E-.05586
G1 X162.937 Y131.294 E-.25794
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X165.839 Y130.512 Z.8 F60000
G1 Z.4
G1 E.4 F1800
G1 F6044.427
M204 S8000
G1 X165.811 Y130.512 E.00022
; LINE_WIDTH: 0.20994
G1 F6366.724
G1 X164.952 Y130.513 E.0066
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X162.58 Y130.517 E.01919
G1 X162.18 Y130.517 E.00324
G1 F5730.729
G1 X161.78 Y130.518 E.00324
; LINE_WIDTH: 0.26986
G1 F4830.918
G1 X161.552 Y130.448 E.00241
G1 X161.482 Y130.22 E.00241
; LINE_WIDTH: 0.21999
G1 F5730.729
G1 X161.482 Y129.82 E.00324
G1 F6044.427
G1 X161.482 Y129.42 E.00324
G1 X161.482 Y111.78 E.14269
G1 X161.569 Y111.569 E.00184
G1 X161.78 Y111.482 E.00184
G1 X179.22 Y111.482 E.14107
G1 X179.449 Y111.59 E.00205
G1 X179.518 Y111.78 E.00163
G1 X179.518 Y112.342 E.00455
G1 X192.378 Y120.426 E.12287
G1 X192.518 Y120.678 E.00233
G1 X192.518 Y121.322 E.0052
G1 X192.434 Y121.528 E.0018
M73 P72 R4
G1 X179.518 Y129.658 E.12345
G1 X179.518 Y130.22 E.00455
G1 X179.449 Y130.41 E.00163
G1 X179.22 Y130.518 E.00205
G1 X167.811 Y130.512 E.09229
; LINE_WIDTH: 0.20996
G1 F6366.048
G1 X166.952 Y130.513 E.0066
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X165.839 Y130.512 E.009
; COOLING_NODE: 0
M204 S10000
G1 X165.847 Y130.319 F60000
G1 F6044.427
M204 S8000
G1 X164.952 Y130.319 E.00724
G1 X161.78 Y130.319 E.02566
G1 X161.71 Y130.29 E.00061
G1 X161.681 Y130.22 E.00061
G1 X161.681 Y111.78 E.14916
G1 X161.763 Y111.682 E.00103
G1 X179.22 Y111.681 E.14121
G1 X179.296 Y111.717 E.00068
G1 X179.319 Y112.452 E.00595
G1 X192.273 Y120.594 E.12376
G1 X192.319 Y120.678 E.00078
G1 X192.319 Y121.322 E.0052
G1 X192.273 Y121.406 E.00078
G1 X179.319 Y129.548 E.12376
G1 X179.319 Y130.22 E.00544
G1 X179.237 Y130.318 E.00103
G1 X165.847 Y130.319 E.10831
; COOLING_NODE: 0
; WIPE_START
G1 X164.952 Y130.319 E-.17016
G1 X163.847 Y130.319 E-.20984
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X171.175 Y128.184 Z.8 F60000
G1 X191.934 Y122.135 Z.8
G1 Z.4
G1 E.4 F1800
; LINE_WIDTH: 0.32582
G1 F3942.699
M204 S8000
G1 X191.131 Y122.655 E.01187
; COOLING_NODE: 0
; WIPE_START
G1 X191.934 Y122.135 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X184.685 Y124.523 Z.8 F60000
G1 X165.888 Y130.716 Z.8
G1 Z.4
G1 E.4 F1800
; LINE_WIDTH: 0.21935
G1 F6063.975
M204 S8000
G1 X165.811 Y130.699 E.00064
; LINE_WIDTH: 0.20994
G1 F6366.724
G1 X164.952 Y130.701 E.00659
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X164.706 Y130.788 E.00211
G1 X164.571 Y130.939 E.00164
G1 X164.515 Y131.077 E.00121
G1 X164.493 Y131.493 E.00337
G1 X162.61 Y131.493 E.01523
G1 X162.21 Y131.493 E.00324
G1 F5796.179
G1 X162.067 Y131.35 E.00163
; LINE_WIDTH: 0.24662
G1 F5329.544
G1 X161.75 Y131.014 E.00424
; LINE_WIDTH: 0.27325
G1 F4765.877
G1 X161.432 Y130.678 E.00474
G1 X161.265 Y130.529 E.0023
; LINE_WIDTH: 0.24662
G1 F5329.544
G1 X161.097 Y130.38 E.00206
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X160.814 Y130.097 E.00324
G1 X160.507 Y129.79 E.00351
G1 X160.507 Y110.507 E.15598
G1 X193.493 Y110.507 E.26682
G1 X193.493 Y114.287 E.03057
G1 X193.493 Y131.493 E.13918
G1 X168.307 Y131.493 E.20372
G1 X168.307 Y131.189 E.00246
G1 X168.193 Y130.894 E.00256
G1 X168.02 Y130.746 E.00184
; LINE_WIDTH: 0.21923
G1 F6067.654
G1 X167.81 Y130.699 E.00173
; LINE_WIDTH: 0.21626
G1 F6160.164
G1 X166.835 Y130.723 E.00774
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X166.612 Y130.883 E.00222
G1 X166.525 Y131.055 E.00157
; LINE_WIDTH: 0.21988
G1 F6047.778
G1 X166.496 Y131.496 E.00357
; LINE_WIDTH: 0.21368
G1 F6242.847
G1 X166.304 Y131.496 E.00151
G1 X166.304 Y131.189 E.0024
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X166.195 Y130.896 E.00253
G1 X166.022 Y130.747 E.00184
; LINE_WIDTH: 0.21935
G1 F6063.975
G1 X165.888 Y130.716 E.00111
; COOLING_NODE: 0
M204 S10000
G1 X165.872 Y130.919 F60000
; LINE_WIDTH: 0.21999
G1 F6044.427
M204 S8000
G1 X165.811 Y130.891 E.00054
G1 X164.953 Y130.895 E.00694
G1 X164.8 Y130.963 E.00136
G1 X164.691 Y131.189 E.00203
G1 X164.691 Y131.691 E.00406
G1 X162.128 Y131.691 E.02074
G1 X160.309 Y129.872 E.02081
G1 X160.309 Y110.309 E.15825
G1 X193.691 Y110.309 E.27003
G1 X193.691 Y114.287 E.03218
G1 X193.691 Y131.691 E.14078
; object ids of layer 4 start: 5887,5909
M624 AwAAAAAAAAA=
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

; object ids of this layer4 end: 5887,5909
M625
G1 X168.109 Y131.691 E.20694
G1 X168.109 Y131.189 E.00406
G1 X168.016 Y130.984 E.00182
G1 X167.811 Y130.891 E.00182
G1 X166.953 Y130.895 E.00694
G1 X166.785 Y130.981 E.00153
G1 X166.691 Y131.189 E.00185
G1 X166.691 Y131.691 E.00406
G1 X166.109 Y131.691 E.00472
G1 X166.109 Y131.189 E.00406
G1 X166.018 Y130.985 E.00181
G1 X165.872 Y130.919 E.00129
; COOLING_NODE: 0
M204 S250
G1 X165.811 Y131.09 F60000
; FEATURE: Outer wall
G1 F6044.427
M204 S5000
G1 X164.951 Y131.098 E.00695
G1 X164.89 Y131.189 E.00089
G1 X164.89 Y131.89 E.00567
G1 X162.046 Y131.89 E.02301
G1 X160.11 Y129.954 E.02214
G1 X160.11 Y110.11 E.16052
G1 X193.89 Y110.11 E.27324
G1 X193.89 Y121 E.08809
G1 X193.89 Y131.89 E.08809
G1 X167.91 Y131.89 E.21015
G1 X167.889 Y131.129 E.00616
G1 X167.811 Y131.09 E.00071
G1 X166.977 Y131.091 E.00674
G1 X166.89 Y131.189 E.00106
G1 X166.89 Y131.89 E.00567
G1 X165.91 Y131.89 E.00793
G1 X165.91 Y131.189 E.00567
G1 X165.87 Y131.11 E.00072
G1 X165.811 Y131.09 E.0005
; COOLING_NODE: 0
M204 S10000
G1 X166.436 Y130.762 F60000
; FEATURE: Inner wall
; LINE_WIDTH: 0.31116
G1 F4142.216
M204 S8000
G1 X166.418 Y130.793 E.00043
G1 X166.364 Y130.762 E.00074
G1 X166.418 Y130.731 E.00074
; WIPE_START
G1 X166.364 Y130.762 E-.14743
G1 X166.418 Y130.793 E-.14743
G1 X166.436 Y130.762 E-.08513
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X168.539 Y131.011 Z.8 F60000
G1 Z.4
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.22057
G1 F6026.819
M204 S8000
G1 X168.675 Y130.875 E.00156
G1 X168.957 Y130.875 E.00229
G1 X168.696 Y131.136 E.003
G1 X168.977 Y131.136 E.00228
G1 X169.238 Y130.874 E.003
G1 X169.52 Y130.874 E.00229
G1 X169.259 Y131.136 E.003
G1 X169.54 Y131.136 E.00228
G1 X169.802 Y130.874 E.003
G1 X170.084 Y130.874 E.00229
G1 X169.822 Y131.136 E.00301
G1 X170.103 Y131.136 E.00228
G1 X170.366 Y130.873 E.00301
G1 X170.648 Y130.873 E.00229
G1 X170.385 Y131.136 E.00301
G1 X170.667 Y131.136 E.00228
G1 X170.929 Y130.873 E.00301
G1 X171.211 Y130.873 E.00229
G1 X170.948 Y131.136 E.00302
G1 X171.23 Y131.136 E.00228
G1 X171.493 Y130.873 E.00302
G1 X171.775 Y130.872 E.00229
G1 X171.511 Y131.136 E.00302
G1 X171.793 Y131.136 E.00228
G1 X172.057 Y130.872 E.00302
G1 X172.338 Y130.872 E.00229
G1 X172.075 Y131.136 E.00303
G1 X172.356 Y131.136 E.00228
G1 X172.62 Y130.872 E.00303
G1 X172.902 Y130.871 E.00229
G1 X172.638 Y131.136 E.00303
G1 X172.919 Y131.136 E.00228
G1 X173.184 Y130.871 E.00304
G1 X173.466 Y130.871 E.00229
G1 X173.201 Y131.136 E.00304
G1 X173.482 Y131.136 E.00228
G1 X173.748 Y130.871 E.00304
G1 X174.029 Y130.87 E.00229
G1 X173.764 Y131.136 E.00304
G1 X174.046 Y131.136 E.00228
G1 X174.311 Y130.87 E.00305
G1 X174.593 Y130.87 E.00229
G1 X174.327 Y131.136 E.00305
G1 X174.609 Y131.136 E.00228
G1 X174.875 Y130.87 E.00305
G1 X175.157 Y130.87 E.00229
G1 X174.89 Y131.136 E.00305
G1 X175.172 Y131.136 E.00228
G1 X175.438 Y130.869 E.00306
G1 X175.72 Y130.869 E.00229
G1 X175.454 Y131.136 E.00306
G1 X175.735 Y131.136 E.00228
G1 X176.002 Y130.869 E.00306
G1 X176.284 Y130.869 E.00229
G1 X176.017 Y131.136 E.00306
G1 X176.298 Y131.136 E.00228
G1 X176.566 Y130.868 E.00307
G1 X176.848 Y130.868 E.00229
G1 X176.58 Y131.136 E.00307
G1 X176.862 Y131.136 E.00228
G1 X177.129 Y130.868 E.00307
G1 X177.411 Y130.868 E.00229
G1 X177.143 Y131.136 E.00308
G1 X177.425 Y131.136 E.00228
G1 X177.693 Y130.867 E.00308
G1 X177.975 Y130.867 E.00229
G1 X177.706 Y131.136 E.00308
G1 X177.988 Y131.136 E.00228
G1 X178.257 Y130.867 E.00308
G1 X178.538 Y130.867 E.00229
G1 X178.269 Y131.136 E.00309
G1 X178.551 Y131.136 E.00228
G1 X178.82 Y130.866 E.00309
G1 X179.102 Y130.866 E.00229
G1 X178.743 Y131.225 E.00412
; WIPE_START
G1 X179.102 Y130.866 E-.09641
G1 X178.82 Y130.866 E-.05355
G1 X178.551 Y131.136 E-.07234
G1 X178.269 Y131.136 E-.0535
G1 X178.538 Y130.867 E-.07228
G1 X178.37 Y130.867 E-.03192
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X179.785 Y130.184 Z.8 F60000
G1 Z.4
G1 E.4 F1800
G1 F6026.819
M204 S8000
G1 X180.517 Y129.452 E.0084
G1 X181.275 Y128.975 E.00726
G1 X179.114 Y131.136 E.02479
G1 X179.396 Y131.136 E.00228
G1 X182.012 Y128.52 E.03001
G1 X182.573 Y128.24 E.00509
G1 X179.677 Y131.136 E.03322
G1 X179.959 Y131.136 E.00228
G1 X182.629 Y128.466 E.03063
G1 X182.586 Y128.791 E.00266
G1 X180.241 Y131.136 E.02691
G1 X180.522 Y131.136 E.00228
G1 X182.651 Y129.007 E.02443
G1 X182.717 Y129.223 E.00183
G1 X180.804 Y131.136 E.02195
G1 X181.085 Y131.136 E.00228
G1 X182.784 Y129.437 E.01949
G1 X182.812 Y129.509 E.00063
G1 X182.895 Y129.607 E.00104
G1 X181.367 Y131.136 E.01753
G1 X181.648 Y131.136 E.00228
G1 X183.025 Y129.759 E.01579
G1 X183.239 Y129.827 E.00182
G1 X181.93 Y131.136 E.01501
G1 X182.212 Y131.136 E.00228
G1 X183.472 Y129.875 E.01446
G1 X183.754 Y129.875 E.00228
G1 X182.493 Y131.136 E.01446
G1 X182.775 Y131.136 E.00228
G1 X184.035 Y129.875 E.01446
G1 X184.317 Y129.875 E.00228
G1 X183.056 Y131.136 E.01446
G1 X183.338 Y131.136 E.00228
G1 X184.599 Y129.875 E.01446
G1 X184.88 Y129.875 E.00228
G1 X183.62 Y131.136 E.01446
G1 X183.901 Y131.136 E.00228
G1 X185.162 Y129.875 E.01446
G1 X185.443 Y129.875 E.00228
G1 X184.183 Y131.136 E.01446
G1 X184.464 Y131.136 E.00228
G1 X185.725 Y129.875 E.01446
G1 X186.007 Y129.875 E.00228
G1 X184.746 Y131.136 E.01446
G1 X185.027 Y131.136 E.00228
G1 X186.288 Y129.875 E.01446
G1 X186.57 Y129.875 E.00228
G1 X185.309 Y131.136 E.01446
G1 X185.591 Y131.136 E.00228
G1 X186.851 Y129.875 E.01446
G1 X187.133 Y129.875 E.00228
G1 X185.872 Y131.136 E.01446
G1 X186.154 Y131.136 E.00228
G1 X187.414 Y129.875 E.01446
G1 X187.696 Y129.875 E.00228
G1 X186.435 Y131.136 E.01446
G1 X186.717 Y131.136 E.00228
G1 X187.978 Y129.875 E.01446
G1 X188.259 Y129.875 E.00228
G1 X186.999 Y131.136 E.01446
G1 X187.28 Y131.136 E.00228
G1 X188.541 Y129.875 E.01446
G1 X188.822 Y129.875 E.00228
G1 X187.562 Y131.136 E.01446
G1 X187.843 Y131.136 E.00228
G1 X189.104 Y129.875 E.01446
G1 X189.386 Y129.875 E.00228
G1 X188.125 Y131.136 E.01446
G1 X188.406 Y131.136 E.00228
G1 X189.667 Y129.875 E.01446
G1 X189.949 Y129.875 E.00228
G1 X188.688 Y131.136 E.01446
G1 X188.97 Y131.136 E.00228
G1 X190.23 Y129.875 E.01446
G1 X190.512 Y129.875 E.00228
G1 X189.251 Y131.136 E.01446
G1 X189.533 Y131.136 E.00228
G1 X190.793 Y129.875 E.01446
G1 X191.075 Y129.875 E.00228
G1 X189.814 Y131.136 E.01446
G1 X190.096 Y131.136 E.00228
G1 X191.357 Y129.875 E.01446
G1 X191.638 Y129.875 E.00228
G1 X190.378 Y131.136 E.01446
G1 X190.659 Y131.136 E.00228
G1 X191.92 Y129.875 E.01446
G1 X192.201 Y129.875 E.00228
G1 X190.851 Y131.225 E.01549
M204 S10000
G1 X192.822 Y131.225 F60000
G1 F6026.819
M204 S8000
G1 X193.136 Y130.912 E.00359
G1 X193.136 Y130.63 E.00228
G1 X192.63 Y131.136 E.0058
G1 X192.349 Y131.136 E.00228
G1 X193.136 Y130.349 E.00903
G1 X193.136 Y130.067 E.00228
G1 X192.067 Y131.136 E.01226
G1 X191.785 Y131.136 E.00228
G1 X193.136 Y129.785 E.01549
G1 X193.136 Y129.504 E.00228
G1 X191.504 Y131.136 E.01872
G1 X191.222 Y131.136 E.00228
G1 X193.136 Y129.222 E.02195
G1 X193.136 Y128.941 E.00228
G1 X192.875 Y129.201 E.00299
G1 X192.875 Y128.92 E.00228
G1 X193.136 Y128.659 E.00299
G1 X193.136 Y128.378 E.00228
G1 X192.875 Y128.638 E.00299
G1 X192.875 Y128.357 E.00228
G1 X193.136 Y128.096 E.00299
G1 X193.136 Y127.814 E.00228
G1 X192.875 Y128.075 E.00299
G1 X192.875 Y127.793 E.00228
G1 X193.136 Y127.533 E.00299
G1 X193.136 Y127.251 E.00228
G1 X192.875 Y127.512 E.00299
G1 X192.875 Y127.23 E.00228
G1 X193.136 Y126.97 E.00299
G1 X193.136 Y126.688 E.00228
G1 X192.875 Y126.949 E.00299
G1 X192.875 Y126.667 E.00228
G1 X193.136 Y126.406 E.00299
G1 X193.136 Y126.125 E.00228
G1 X192.875 Y126.386 E.00299
G1 X192.875 Y126.104 E.00228
G1 X193.136 Y125.843 E.00299
G1 X193.136 Y125.562 E.00228
G1 X192.875 Y125.822 E.00299
G1 X192.875 Y125.541 E.00228
G1 X193.136 Y125.28 E.00299
G1 X193.136 Y124.999 E.00228
G1 X192.875 Y125.259 E.00299
G1 X192.875 Y124.978 E.00228
G1 X193.136 Y124.717 E.00299
G1 X193.136 Y124.435 E.00228
G1 X192.875 Y124.696 E.00299
G1 X192.875 Y124.414 E.00228
G1 X193.136 Y124.154 E.00299
G1 X193.136 Y123.872 E.00228
G1 X192.875 Y124.133 E.00299
G1 X192.875 Y123.851 E.00228
G1 X193.136 Y123.591 E.00299
G1 X193.136 Y123.309 E.00228
G1 X192.875 Y123.57 E.00299
G1 X192.875 Y123.288 E.00228
G1 X193.136 Y123.027 E.00299
G1 X193.136 Y122.746 E.00228
G1 X192.875 Y123.007 E.00299
G1 X192.875 Y122.725 E.00228
G1 X193.136 Y122.464 E.00299
G1 X193.136 Y122.183 E.00228
G1 X192.837 Y122.482 E.00343
G1 X192.756 Y122.281 E.00176
G1 X193.136 Y121.901 E.00436
G1 X193.136 Y121.62 E.00228
G1 X192.653 Y122.102 E.00554
G1 X192.558 Y122.025 E.00099
G1 X192.448 Y122.025 E.00089
G1 X193.136 Y121.338 E.00789
G1 X193.136 Y121.056 E.00228
G1 X192.867 Y121.325 E.00308
G1 X192.871 Y121.04 E.00231
G1 X193.136 Y120.775 E.00304
G1 X193.136 Y120.493 E.00228
G1 X192.874 Y120.755 E.003
G1 X192.875 Y120.663 E.00074
G1 X192.807 Y120.54 E.00114
G1 X193.136 Y120.212 E.00377
G1 X193.136 Y119.93 E.00228
G1 X192.707 Y120.359 E.00492
G1 X192.607 Y120.177 E.00168
G1 X193.136 Y119.648 E.00607
G1 X193.136 Y119.367 E.00228
G1 X192.452 Y120.051 E.00784
G1 X192.279 Y119.942 E.00166
G1 X193.136 Y119.085 E.00983
G1 X193.136 Y118.804 E.00228
G1 X192.106 Y119.833 E.01181
G1 X191.933 Y119.725 E.00166
G1 X193.136 Y118.522 E.0138
G1 X193.136 Y118.241 E.00228
G1 X191.76 Y119.616 E.01578
G1 X191.587 Y119.507 E.00166
G1 X193.136 Y117.959 E.01776
G1 X193.136 Y117.677 E.00228
G1 X191.415 Y119.398 E.01975
G1 X191.242 Y119.29 E.00166
G1 X193.136 Y117.396 E.02173
G1 X193.136 Y117.114 E.00228
G1 X191.069 Y119.181 E.02371
G1 X190.896 Y119.072 E.00166
G1 X193.136 Y116.833 E.0257
G1 X193.136 Y116.551 E.00228
G1 X190.723 Y118.964 E.02768
G1 X190.55 Y118.855 E.00166
G1 X193.136 Y116.269 E.02966
G1 X193.136 Y115.988 E.00228
G1 X190.377 Y118.746 E.03165
G1 X190.204 Y118.638 E.00166
G1 X193.136 Y115.706 E.03363
G1 X193.136 Y115.425 E.00228
M73 P73 R4
G1 X190.031 Y118.529 E.03562
G1 X189.858 Y118.42 E.00166
G1 X193.136 Y115.143 E.0376
G1 X193.136 Y114.861 E.00228
G1 X189.686 Y118.312 E.03958
G1 X189.513 Y118.203 E.00166
G1 X193.136 Y114.58 E.04157
G1 X193.136 Y114.298 E.00228
G1 X189.34 Y118.094 E.04355
G1 X189.167 Y117.986 E.00166
G1 X193.136 Y114.017 E.04553
G1 X193.136 Y113.735 E.00228
G1 X188.994 Y117.877 E.04752
G1 X188.821 Y117.768 E.00166
G1 X193.136 Y113.454 E.0495
G1 X193.136 Y113.172 E.00228
G1 X188.648 Y117.66 E.05148
G1 X188.475 Y117.551 E.00166
G1 X193.136 Y112.89 E.05347
G1 X193.136 Y112.609 E.00228
G1 X188.302 Y117.442 E.05545
G1 X188.129 Y117.334 E.00166
G1 X193.136 Y112.327 E.05744
G1 X193.136 Y112.046 E.00228
G1 X187.957 Y117.225 E.05942
G1 X187.784 Y117.116 E.00166
G1 X193.136 Y111.764 E.0614
G1 X193.136 Y111.482 E.00228
G1 X187.611 Y117.007 E.06339
G1 X187.438 Y116.899 E.00166
G1 X193.136 Y111.201 E.06537
G1 X193.136 Y110.919 E.00228
G1 X187.265 Y116.79 E.06735
G1 X187.092 Y116.681 E.00166
G1 X192.909 Y110.864 E.06674
G1 X192.628 Y110.864 E.00228
G1 X186.919 Y116.573 E.06549
G1 X186.746 Y116.464 E.00166
G1 X192.346 Y110.864 E.06425
G1 X192.064 Y110.864 E.00228
G1 X186.573 Y116.355 E.063
G1 X186.4 Y116.247 E.00166
G1 X191.783 Y110.864 E.06175
G1 X191.501 Y110.864 E.00228
G1 X186.228 Y116.138 E.0605
G1 X186.055 Y116.029 E.00166
G1 X191.22 Y110.864 E.05926
G1 X190.938 Y110.864 E.00228
G1 X185.882 Y115.921 E.05801
G1 X185.709 Y115.812 E.00166
G1 X190.657 Y110.864 E.05676
G1 X190.375 Y110.864 E.00228
G1 X185.536 Y115.703 E.05552
G1 X185.363 Y115.595 E.00166
G1 X190.093 Y110.864 E.05427
G1 X189.812 Y110.864 E.00228
G1 X185.19 Y115.486 E.05302
G1 X185.017 Y115.377 E.00166
G1 X189.53 Y110.864 E.05178
G1 X189.249 Y110.864 E.00228
G1 X184.844 Y115.269 E.05053
G1 X184.671 Y115.16 E.00166
G1 X188.967 Y110.864 E.04928
G1 X188.685 Y110.864 E.00228
G1 X184.498 Y115.051 E.04804
G1 X184.326 Y114.943 E.00166
G1 X188.404 Y110.864 E.04679
G1 X188.122 Y110.864 E.00228
G1 X184.153 Y114.834 E.04554
G1 X183.98 Y114.725 E.00166
G1 X187.841 Y110.864 E.0443
G1 X187.559 Y110.864 E.00228
G1 X183.807 Y114.616 E.04305
G1 X183.634 Y114.508 E.00166
G1 X187.278 Y110.864 E.0418
G1 X186.996 Y110.864 E.00228
G1 X183.461 Y114.399 E.04055
G1 X183.288 Y114.29 E.00166
G1 X186.714 Y110.864 E.03931
G1 X186.433 Y110.864 E.00228
G1 X183.115 Y114.182 E.03806
G1 X182.942 Y114.073 E.00166
G1 X186.151 Y110.864 E.03681
G1 X185.87 Y110.864 E.00228
G1 X182.769 Y113.964 E.03557
G1 X182.597 Y113.856 E.00166
G1 X185.588 Y110.864 E.03432
G1 X185.306 Y110.864 E.00228
G1 X182.424 Y113.747 E.03307
G1 X182.251 Y113.638 E.00166
G1 X185.025 Y110.864 E.03183
G1 X184.743 Y110.864 E.00228
G1 X182.078 Y113.53 E.03058
G1 X181.905 Y113.421 E.00166
G1 X184.462 Y110.864 E.02933
G1 X184.18 Y110.864 E.00228
G1 X181.732 Y113.312 E.02809
G1 X181.559 Y113.204 E.00166
G1 X183.899 Y110.864 E.02684
G1 X183.617 Y110.864 E.00228
G1 X181.386 Y113.095 E.02559
G1 X181.213 Y112.986 E.00166
G1 X183.335 Y110.864 E.02435
G1 X183.054 Y110.864 E.00228
G1 X181.04 Y112.878 E.0231
G1 X180.868 Y112.769 E.00166
G1 X182.772 Y110.864 E.02185
G1 X182.491 Y110.864 E.00228
G1 X180.695 Y112.66 E.0206
G1 X180.522 Y112.552 E.00166
G1 X182.209 Y110.864 E.01936
G1 X181.927 Y110.864 E.00228
G1 X180.349 Y112.443 E.01811
G1 X180.176 Y112.334 E.00166
G1 X181.646 Y110.864 E.01686
G1 X181.364 Y110.864 E.00228
G1 X180.003 Y112.226 E.01562
G1 X179.875 Y112.145 E.00123
G1 X179.875 Y112.072 E.00059
G1 X181.083 Y110.864 E.01386
G1 X180.801 Y110.864 E.00228
G1 X179.874 Y111.791 E.01064
G1 X179.874 Y111.732 E.00049
G1 X179.811 Y111.573 E.00139
G1 X180.52 Y110.864 E.00813
G1 X180.238 Y110.864 E.00228
G1 X179.731 Y111.371 E.00582
G1 X179.548 Y111.273 E.00169
G1 X179.956 Y110.864 E.00469
G1 X179.675 Y110.864 E.00228
G1 X179.356 Y111.183 E.00365
G1 X179.233 Y111.125 E.0011
G1 X179.132 Y111.125 E.00082
G1 X179.393 Y110.864 E.00299
G1 X179.112 Y110.864 E.00228
G1 X178.851 Y111.125 E.00299
G1 X178.569 Y111.125 E.00228
G1 X178.83 Y110.864 E.00299
G1 X178.548 Y110.864 E.00228
G1 X178.288 Y111.125 E.00299
G1 X178.006 Y111.125 E.00228
G1 X178.267 Y110.864 E.00299
G1 X177.985 Y110.864 E.00228
G1 X177.725 Y111.125 E.00299
G1 X177.443 Y111.125 E.00228
G1 X177.704 Y110.864 E.00299
G1 X177.422 Y110.864 E.00228
G1 X177.161 Y111.125 E.00299
G1 X176.88 Y111.125 E.00228
G1 X177.14 Y110.864 E.00299
G1 X176.859 Y110.864 E.00228
G1 X176.598 Y111.125 E.00299
G1 X176.317 Y111.125 E.00228
G1 X176.577 Y110.864 E.00299
G1 X176.296 Y110.864 E.00228
G1 X176.035 Y111.125 E.00299
G1 X175.753 Y111.125 E.00228
G1 X176.014 Y110.864 E.00299
G1 X175.733 Y110.864 E.00228
G1 X175.472 Y111.125 E.00299
G1 X175.19 Y111.125 E.00228
G1 X175.451 Y110.864 E.00299
G1 X175.169 Y110.864 E.00228
G1 X174.909 Y111.125 E.00299
G1 X174.627 Y111.125 E.00228
G1 X174.888 Y110.864 E.00299
G1 X174.606 Y110.864 E.00228
G1 X174.346 Y111.125 E.00299
G1 X174.064 Y111.125 E.00228
G1 X174.325 Y110.864 E.00299
G1 X174.043 Y110.864 E.00228
G1 X173.782 Y111.125 E.00299
G1 X173.501 Y111.125 E.00228
G1 X173.761 Y110.864 E.00299
G1 X173.48 Y110.864 E.00228
G1 X173.219 Y111.125 E.00299
G1 X172.938 Y111.125 E.00228
G1 X173.198 Y110.864 E.00299
G1 X172.917 Y110.864 E.00228
G1 X172.656 Y111.125 E.00299
G1 X172.374 Y111.125 E.00228
G1 X172.635 Y110.864 E.00299
G1 X172.354 Y110.864 E.00228
G1 X172.093 Y111.125 E.00299
G1 X171.811 Y111.125 E.00228
G1 X172.072 Y110.864 E.00299
G1 X171.79 Y110.864 E.00228
G1 X171.53 Y111.125 E.00299
G1 X171.248 Y111.125 E.00228
G1 X171.509 Y110.864 E.00299
G1 X171.227 Y110.864 E.00228
G1 X170.967 Y111.125 E.00299
G1 X170.685 Y111.125 E.00228
G1 X170.946 Y110.864 E.00299
G1 X170.664 Y110.864 E.00228
G1 X170.403 Y111.125 E.00299
G1 X170.122 Y111.125 E.00228
G1 X170.382 Y110.864 E.00299
G1 X170.101 Y110.864 E.00228
G1 X169.84 Y111.125 E.00299
G1 X169.559 Y111.125 E.00228
G1 X169.819 Y110.864 E.00299
G1 X169.538 Y110.864 E.00228
G1 X169.277 Y111.125 E.00299
G1 X168.995 Y111.125 E.00228
G1 X169.256 Y110.864 E.00299
G1 X168.975 Y110.864 E.00228
G1 X168.714 Y111.125 E.00299
G1 X168.432 Y111.125 E.00228
G1 X168.693 Y110.864 E.00299
G1 X168.411 Y110.864 E.00228
G1 X168.151 Y111.125 E.00299
G1 X167.869 Y111.125 E.00228
G1 X168.13 Y110.864 E.00299
G1 X167.848 Y110.864 E.00228
G1 X167.588 Y111.125 E.00299
G1 X167.306 Y111.125 E.00228
G1 X167.567 Y110.864 E.00299
G1 X167.285 Y110.864 E.00228
G1 X167.024 Y111.125 E.00299
G1 X166.743 Y111.125 E.00228
G1 X167.003 Y110.864 E.00299
G1 X166.722 Y110.864 E.00228
G1 X166.461 Y111.125 E.00299
G1 X166.18 Y111.125 E.00228
G1 X166.44 Y110.864 E.00299
G1 X166.159 Y110.864 E.00228
G1 X165.898 Y111.125 E.00299
G1 X165.616 Y111.125 E.00228
G1 X165.877 Y110.864 E.00299
G1 X165.596 Y110.864 E.00228
G1 X165.335 Y111.125 E.00299
G1 X165.053 Y111.125 E.00228
G1 X165.314 Y110.864 E.00299
G1 X165.032 Y110.864 E.00228
G1 X164.772 Y111.125 E.00299
G1 X164.49 Y111.125 E.00228
G1 X164.751 Y110.864 E.00299
G1 X164.469 Y110.864 E.00228
G1 X164.209 Y111.125 E.00299
G1 X163.927 Y111.125 E.00228
G1 X164.188 Y110.864 E.00299
G1 X163.906 Y110.864 E.00228
G1 X163.645 Y111.125 E.00299
G1 X163.364 Y111.125 E.00228
G1 X163.624 Y110.864 E.00299
G1 X163.343 Y110.864 E.00228
G1 X163.082 Y111.125 E.00299
G1 X162.801 Y111.125 E.00228
G1 X163.061 Y110.864 E.00299
G1 X162.78 Y110.864 E.00228
G1 X162.519 Y111.125 E.00299
G1 X162.237 Y111.125 E.00228
G1 X162.498 Y110.864 E.00299
G1 X162.217 Y110.864 E.00228
G1 X161.956 Y111.125 E.00299
G1 X161.664 Y111.135 E.00237
G1 X161.935 Y110.864 E.0031
G1 X161.653 Y110.864 E.00228
G1 X160.864 Y111.653 E.00905
G1 X160.864 Y111.935 E.00228
G1 X161.191 Y111.608 E.00375
G1 X161.125 Y111.768 E.00141
G1 X161.125 Y111.956 E.00152
G1 X160.864 Y112.217 E.00299
G1 X160.864 Y112.498 E.00228
G1 X161.125 Y112.237 E.00299
G1 X161.125 Y112.519 E.00228
G1 X160.864 Y112.78 E.00299
G1 X160.864 Y113.061 E.00228
G1 X161.125 Y112.801 E.00299
G1 X161.125 Y113.082 E.00228
G1 X160.864 Y113.343 E.00299
G1 X160.864 Y113.624 E.00228
G1 X161.125 Y113.364 E.00299
G1 X161.125 Y113.645 E.00228
G1 X160.864 Y113.906 E.00299
G1 X160.864 Y114.188 E.00228
G1 X161.125 Y113.927 E.00299
G1 X161.125 Y114.209 E.00228
G1 X160.864 Y114.469 E.00299
G1 X160.864 Y114.751 E.00228
G1 X161.125 Y114.49 E.00299
G1 X161.125 Y114.772 E.00228
G1 X160.864 Y115.032 E.00299
G1 X160.864 Y115.314 E.00228
G1 X161.125 Y115.053 E.00299
G1 X161.125 Y115.335 E.00228
G1 X160.864 Y115.596 E.00299
G1 X160.864 Y115.877 E.00228
G1 X161.125 Y115.616 E.00299
G1 X161.125 Y115.898 E.00228
G1 X160.864 Y116.159 E.00299
G1 X160.864 Y116.44 E.00228
G1 X161.125 Y116.18 E.00299
G1 X161.125 Y116.461 E.00228
G1 X160.864 Y116.722 E.00299
G1 X160.864 Y117.003 E.00228
G1 X161.125 Y116.743 E.00299
G1 X161.125 Y117.024 E.00228
G1 X160.864 Y117.285 E.00299
G1 X160.864 Y117.567 E.00228
G1 X161.125 Y117.306 E.00299
G1 X161.125 Y117.588 E.00228
G1 X160.864 Y117.848 E.00299
G1 X160.864 Y118.13 E.00228
G1 X161.125 Y117.869 E.00299
G1 X161.125 Y118.151 E.00228
G1 X160.864 Y118.411 E.00299
G1 X160.864 Y118.693 E.00228
G1 X161.125 Y118.432 E.00299
G1 X161.125 Y118.714 E.00228
G1 X160.864 Y118.975 E.00299
G1 X160.864 Y119.256 E.00228
G1 X161.125 Y118.995 E.00299
G1 X161.125 Y119.277 E.00228
G1 X160.864 Y119.538 E.00299
G1 X160.864 Y119.819 E.00228
G1 X161.125 Y119.559 E.00299
G1 X161.125 Y119.84 E.00228
G1 X160.864 Y120.101 E.00299
G1 X160.864 Y120.382 E.00228
G1 X161.125 Y120.122 E.00299
G1 X161.125 Y120.403 E.00228
G1 X160.864 Y120.664 E.00299
G1 X160.864 Y120.946 E.00228
G1 X161.125 Y120.685 E.00299
G1 X161.125 Y120.967 E.00228
G1 X160.864 Y121.227 E.00299
G1 X160.864 Y121.509 E.00228
G1 X161.125 Y121.248 E.00299
G1 X161.125 Y121.53 E.00228
G1 X160.864 Y121.79 E.00299
G1 X160.864 Y122.072 E.00228
G1 X161.125 Y121.811 E.00299
G1 X161.125 Y122.093 E.00228
G1 X160.864 Y122.354 E.00299
G1 X160.864 Y122.635 E.00228
G1 X161.125 Y122.374 E.00299
G1 X161.125 Y122.656 E.00228
G1 X160.864 Y122.917 E.00299
G1 X160.864 Y123.198 E.00228
G1 X161.125 Y122.938 E.00299
G1 X161.125 Y123.219 E.00228
G1 X160.864 Y123.48 E.00299
G1 X160.864 Y123.761 E.00228
G1 X161.125 Y123.501 E.00299
G1 X161.125 Y123.782 E.00228
G1 X160.864 Y124.043 E.00299
G1 X160.864 Y124.325 E.00228
G1 X161.125 Y124.064 E.00299
G1 X161.125 Y124.346 E.00228
G1 X160.864 Y124.606 E.00299
G1 X160.864 Y124.888 E.00228
G1 X161.125 Y124.627 E.00299
G1 X161.125 Y124.909 E.00228
G1 X160.864 Y125.169 E.00299
G1 X160.864 Y125.451 E.00228
G1 X161.125 Y125.19 E.00299
G1 X161.125 Y125.472 E.00228
G1 X160.864 Y125.733 E.00299
G1 X160.864 Y126.014 E.00228
G1 X161.125 Y125.753 E.00299
G1 X161.125 Y126.035 E.00228
G1 X160.864 Y126.296 E.00299
G1 X160.864 Y126.577 E.00228
G1 X161.125 Y126.317 E.00299
G1 X161.125 Y126.598 E.00228
G1 X160.864 Y126.859 E.00299
G1 X160.864 Y127.14 E.00228
G1 X161.125 Y126.88 E.00299
G1 X161.125 Y127.161 E.00228
G1 X160.864 Y127.422 E.00299
G1 X160.864 Y127.704 E.00228
G1 X161.125 Y127.443 E.00299
G1 X161.125 Y127.725 E.00228
G1 X160.864 Y127.985 E.00299
G1 X160.864 Y128.267 E.00228
G1 X161.125 Y128.006 E.00299
G1 X161.125 Y128.288 E.00228
G1 X160.864 Y128.548 E.00299
G1 X160.864 Y128.83 E.00228
G1 X161.125 Y128.569 E.00299
G1 X161.125 Y128.851 E.00228
G1 X160.864 Y129.112 E.00299
G1 X160.864 Y129.393 E.00228
G1 X161.125 Y129.132 E.00299
G1 X161.125 Y129.414 E.00228
G1 X160.881 Y129.658 E.0028
G1 X161.021 Y129.799 E.00162
G1 X161.214 Y129.606 E.00221
; WIPE_START
G1 X161.021 Y129.799 E-.05182
G1 X160.881 Y129.658 E-.03783
G1 X161.125 Y129.414 E-.06565
G1 X161.125 Y129.132 E-.0535
G1 X160.864 Y129.393 E-.07005
G1 X160.864 Y129.112 E-.0535
G1 X161.042 Y128.934 E-.04765
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X164.179 Y130.91 Z.8 F60000
G1 Z.4
G1 E.4 F1800
; LINE_WIDTH: 0.211265
G1 F6322.275
M204 S8000
G1 X162.183 Y130.91 E.01544
G1 X162.373 Y131.1 E.00208
G1 X164.124 Y131.1 E.01354
G1 X164.171 Y130.939 E.0013
; WIPE_START
G1 X164.124 Y131.1 E-.03185
G1 X162.373 Y131.1 E-.33273
G1 X162.315 Y131.043 E-.01542
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X161.717 Y123.434 Z.8 F60000
G1 X160.775 Y111.461 Z.8
G1 Z.4
G1 E.4 F1800
; LINE_WIDTH: 0.22057
G1 F6026.819
M204 S8000
G1 X161.372 Y110.864 E.00685
G1 X161.09 Y110.864 E.00228
G1 X160.775 Y111.18 E.00362
; WIPE_START
G1 X161.09 Y110.864 E-.1078
G1 X161.372 Y110.864 E-.0681
G1 X160.775 Y111.461 E-.2041
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X168.073 Y113.697 Z.8 F60000
G1 X192.21 Y121.091 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.22
G1 F6044.128
M204 S2000
G1 X191.605 Y121.696 E.00692
M204 S10000
G1 X190.85 Y122.171 F60000
G1 F6044.128
M204 S2000
G1 X192.21 Y120.811 E.01556
G1 X192.28 Y120.741
G1 X192.186 Y120.554
G1 X192.116 Y120.624
G1 X190.094 Y122.646 E.02313
M204 S10000
G1 X189.338 Y123.122 F60000
G1 F6044.128
M204 S2000
G1 X191.943 Y120.516 E.02981
G1 X192.013 Y120.446
G1 X191.841 Y120.338
G1 X191.771 Y120.408
G1 X188.582 Y123.597 E.03648
M204 S10000
G1 X187.826 Y124.072 F60000
G1 F6044.128
M204 S2000
G1 X191.598 Y120.299 E.04316
G1 X191.668 Y120.229
G1 X191.496 Y120.121
G1 X191.426 Y120.191
G1 X187.07 Y124.547 E.04983
M204 S10000
G1 X186.314 Y125.022 F60000
G1 F6044.128
M204 S2000
G1 X191.254 Y120.083 E.05651
G1 X191.324 Y120.013
G1 X191.151 Y119.904
G1 X191.081 Y119.974
G1 X185.558 Y125.497 E.06318
M204 S10000
G1 X184.802 Y125.972 F60000
G1 F6044.128
M204 S2000
G1 X190.909 Y119.866 E.06986
G1 X190.979 Y119.796
G1 X190.806 Y119.688
G1 X190.736 Y119.758
G1 X184.046 Y126.448 E.07653
M204 S10000
G1 X183.291 Y126.923 F60000
G1 F6044.128
M204 S2000
G1 X190.564 Y119.649 E.08321
G1 X190.634 Y119.579
G1 X190.462 Y119.471
G1 X190.392 Y119.541
G1 X182.535 Y127.398 E.08988
M204 S10000
G1 X181.779 Y127.873 F60000
G1 F6044.128
M204 S2000
G1 X190.219 Y119.432 E.09656
G1 X190.289 Y119.362
G1 X190.117 Y119.254
G1 X190.047 Y119.324
G1 X181.023 Y128.348 E.10323
M204 S10000
G1 X180.267 Y128.823 F60000
G1 F6044.128
M204 S2000
G1 X189.874 Y119.216 E.10991
G1 X189.944 Y119.146
G1 X189.772 Y119.037
G1 X189.702 Y119.107
G1 X179.511 Y129.298 E.11658
G1 X179.441 Y129.368
G1 X179.28 Y129.81
G1 X179.21 Y129.88
G1 X178.88 Y130.21 E.00378
G1 X178.81 Y130.28
G1 X178.529 Y130.28
G1 X178.599 Y130.21
G1 X179.21 Y129.599 E.00699
; WIPE_START
M204 S8000
G1 X178.599 Y130.21 E-.16413
G1 X178.529 Y130.28 E-.01881
G1 X178.81 Y130.28 E-.05335
G1 X178.88 Y130.21 E-.01881
M73 P74 R4
G1 X179.21 Y129.88 E-.08869
G1 X179.28 Y129.81 E-.01881
G1 X179.311 Y129.724 E-.01741
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X178.318 Y130.21 Z.8 F60000
G1 Z.4
G1 E.4 F1800
G1 F6044.128
M204 S2000
G1 X189.53 Y118.999 E.12825
G1 X189.6 Y118.929
G1 X189.427 Y118.821
G1 X189.357 Y118.891
G1 X178.038 Y130.21 E.12949
G1 X177.968 Y130.28
G1 X177.687 Y130.28
G1 X177.757 Y130.21
G1 X189.185 Y118.782 E.13073
G1 X189.255 Y118.712
G1 X189.082 Y118.604
G1 X189.012 Y118.674
G1 X177.476 Y130.21 E.13197
G1 X177.406 Y130.28
G1 X177.125 Y130.28
G1 X177.195 Y130.21
G1 X188.84 Y118.566 E.13321
G1 X188.91 Y118.496
G1 X188.738 Y118.387
G1 X188.668 Y118.457
G1 X176.915 Y130.21 E.13445
G1 X176.845 Y130.28
G1 X176.564 Y130.28
G1 X176.634 Y130.21
G1 X188.495 Y118.349 E.13569
G1 X188.565 Y118.279
G1 X188.393 Y118.17
G1 X188.323 Y118.24
G1 X176.353 Y130.21 E.13693
G1 X176.283 Y130.28
G1 X176.002 Y130.28
G1 X176.072 Y130.21
G1 X188.15 Y118.132 E.13817
G1 X188.22 Y118.062
G1 X188.048 Y117.954
G1 X187.978 Y118.024
G1 X175.792 Y130.21 E.13941
G1 X175.722 Y130.28
G1 X175.441 Y130.28
G1 X175.511 Y130.21
G1 X187.806 Y117.915 E.14065
G1 X187.876 Y117.845
G1 X187.703 Y117.737
G1 X187.633 Y117.807
G1 X175.23 Y130.21 E.14189
G1 X175.16 Y130.28
G1 X174.879 Y130.28
G1 X174.949 Y130.21
G1 X187.461 Y117.699 E.14313
G1 X187.531 Y117.629
G1 X187.358 Y117.52
G1 X187.288 Y117.59
G1 X174.669 Y130.21 E.14437
G1 X174.599 Y130.28
G1 X174.318 Y130.28
G1 X174.388 Y130.21
G1 X187.116 Y117.482 E.14561
G1 X187.186 Y117.412
G1 X187.014 Y117.304
G1 X186.944 Y117.374
G1 X174.107 Y130.21 E.14685
G1 X174.037 Y130.28
G1 X173.756 Y130.28
G1 X173.826 Y130.21
G1 X186.771 Y117.265 E.14809
G1 X186.841 Y117.195
G1 X186.669 Y117.087
G1 X186.599 Y117.157
G1 X173.546 Y130.21 E.14933
G1 X173.476 Y130.28
G1 X173.195 Y130.28
G1 X173.265 Y130.21
G1 X186.426 Y117.048 E.15057
G1 X186.496 Y116.978
G1 X186.324 Y116.87
G1 X186.254 Y116.94
G1 X172.984 Y130.21 E.15181
G1 X172.914 Y130.28
G1 X172.633 Y130.28
G1 X172.703 Y130.21
G1 X186.082 Y116.832 E.15305
G1 X186.152 Y116.762
G1 X185.979 Y116.653
G1 X185.909 Y116.723
G1 X172.422 Y130.21 E.15429
G1 X172.352 Y130.28
G1 X172.072 Y130.28
G1 X172.142 Y130.21
G1 X185.737 Y116.615 E.15553
G1 X185.807 Y116.545
G1 X185.634 Y116.437
G1 X185.564 Y116.507
G1 X171.861 Y130.21 E.15677
G1 X171.791 Y130.28
G1 X171.51 Y130.28
G1 X171.58 Y130.21
G1 X185.392 Y116.398 E.15801
G1 X185.462 Y116.328
G1 X185.29 Y116.22
G1 X185.22 Y116.29
G1 X171.299 Y130.21 E.15925
G1 X171.229 Y130.28
G1 X170.949 Y130.28
G1 X171.019 Y130.21
G1 X185.047 Y116.182 E.16049
G1 X185.117 Y116.112
G1 X184.945 Y116.003
G1 X184.875 Y116.073
G1 X170.738 Y130.21 E.16173
G1 X170.668 Y130.28
G1 X170.387 Y130.28
G1 X170.457 Y130.21
G1 X184.702 Y115.965 E.16296
G1 X184.772 Y115.895
G1 X184.6 Y115.786
G1 X184.53 Y115.856
G1 X170.176 Y130.21 E.1642
G1 X170.106 Y130.28
G1 X169.826 Y130.28
G1 X169.896 Y130.21
G1 X184.358 Y115.748 E.16544
G1 X184.428 Y115.678
G1 X184.255 Y115.57
G1 X184.185 Y115.64
G1 X169.615 Y130.21 E.16668
G1 X169.545 Y130.28
G1 X169.264 Y130.28
G1 X169.334 Y130.21
G1 X184.013 Y115.531 E.16792
G1 X184.083 Y115.461
G1 X183.91 Y115.353
G1 X183.84 Y115.423
G1 X169.053 Y130.21 E.16916
G1 X168.983 Y130.28
G1 X168.703 Y130.28
G1 X168.773 Y130.21
G1 X183.668 Y115.315 E.1704
G1 X183.738 Y115.245
G1 X183.566 Y115.136
G1 X183.496 Y115.206
G1 X168.492 Y130.21 E.17164
G1 X168.422 Y130.28
G1 X168.141 Y130.28
G1 X168.211 Y130.21
G1 X183.323 Y115.098 E.17288
G1 X183.393 Y115.028
G1 X183.221 Y114.92
G1 X183.151 Y114.99
G1 X167.93 Y130.21 E.17412
G1 X167.86 Y130.28
G1 X167.579 Y130.28
G1 X167.649 Y130.21
G1 X182.978 Y114.881 E.17536
G1 X183.048 Y114.811
G1 X182.876 Y114.703
G1 X182.806 Y114.773
G1 X167.369 Y130.21 E.1766
G1 X167.299 Y130.28
G1 X167.018 Y130.28
G1 X167.088 Y130.21
G1 X182.634 Y114.664 E.17784
G1 X182.704 Y114.594
G1 X182.531 Y114.486
G1 X182.461 Y114.556
G1 X166.807 Y130.21 E.17908
G1 X166.737 Y130.28
G1 X166.456 Y130.28
G1 X166.526 Y130.21
G1 X182.289 Y114.448 E.18032
G1 X182.359 Y114.378
G1 X182.186 Y114.269
G1 X182.116 Y114.339
G1 X166.246 Y130.21 E.18156
G1 X166.176 Y130.28
G1 X165.895 Y130.28
G1 X165.965 Y130.21
M73 P75 R4
G1 X181.944 Y114.231 E.1828
G1 X182.014 Y114.161
G1 X181.842 Y114.053
G1 X181.772 Y114.123
G1 X165.684 Y130.21 E.18404
G1 X165.614 Y130.28
G1 X165.333 Y130.28
G1 X165.403 Y130.21
G1 X181.599 Y114.014 E.18528
G1 X181.669 Y113.944
G1 X181.497 Y113.836
G1 X181.427 Y113.906
G1 X165.123 Y130.21 E.18652
G1 X165.053 Y130.28
G1 X164.772 Y130.28
G1 X164.842 Y130.21
G1 X181.254 Y113.798 E.18776
G1 X181.324 Y113.728
G1 X181.152 Y113.619
G1 X181.082 Y113.689
G1 X164.561 Y130.21 E.189
G1 X164.491 Y130.28
G1 X164.21 Y130.28
G1 X164.28 Y130.21
G1 X180.91 Y113.581 E.19024
G1 X180.98 Y113.511
G1 X180.807 Y113.402
G1 X180.737 Y113.472
G1 X164 Y130.21 E.19148
G1 X163.93 Y130.28
G1 X163.649 Y130.28
G1 X163.719 Y130.21
G1 X180.565 Y113.364 E.19272
G1 X180.635 Y113.294
G1 X180.462 Y113.186
G1 X180.392 Y113.256
G1 X163.438 Y130.21 E.19396
G1 X163.368 Y130.28
G1 X163.087 Y130.28
G1 X163.157 Y130.21
G1 X180.22 Y113.147 E.1952
G1 X180.29 Y113.077
G1 X180.118 Y112.969
G1 X180.048 Y113.039
G1 X162.876 Y130.21 E.19644
G1 X162.806 Y130.28
G1 X162.526 Y130.28
G1 X162.596 Y130.21
G1 X179.875 Y112.931 E.19768
G1 X179.945 Y112.861
G1 X179.773 Y112.752
G1 X179.703 Y112.822
G1 X162.315 Y130.21 E.19892
G1 X162.245 Y130.28
G1 X161.964 Y130.28
G1 X162.034 Y130.21
G1 X179.53 Y112.714 E.20016
G1 X179.6 Y112.644
G1 X179.428 Y112.535
G1 X179.358 Y112.605
G1 X161.79 Y130.174 E.20098
G1 X161.72 Y130.244
G1 X161.72 Y129.963
G1 X161.79 Y129.893
G1 X179.21 Y112.473 E.19929
G1 X179.28 Y112.403
G1 X179.28 Y112.122
G1 X179.21 Y112.192
G1 X161.79 Y129.612 E.19929
G1 X161.72 Y129.682
G1 X161.72 Y129.401
G1 X161.79 Y129.331
G1 X179.21 Y111.911 E.19929
G1 X179.28 Y111.841
G1 X179.121 Y111.72
G1 X179.051 Y111.79
G1 X161.79 Y129.051 E.19746
G1 X161.72 Y129.121
G1 X161.72 Y128.84
G1 X161.79 Y128.77
G1 X178.77 Y111.79 E.19425
G1 X178.84 Y111.72
G1 X178.559 Y111.72
G1 X178.489 Y111.79
G1 X161.79 Y128.489 E.19104
G1 X161.72 Y128.559
G1 X161.72 Y128.278
G1 X161.79 Y128.208
G1 X178.208 Y111.79 E.18782
G1 X178.278 Y111.72
G1 X177.997 Y111.72
G1 X177.927 Y111.79
G1 X161.79 Y127.927 E.18461
G1 X161.72 Y127.997
G1 X161.72 Y127.717
G1 X161.79 Y127.647
G1 X177.647 Y111.79 E.1814
G1 X177.717 Y111.72
G1 X177.436 Y111.72
G1 X177.366 Y111.79
G1 X161.79 Y127.366 E.17819
G1 X161.72 Y127.436
G1 X161.72 Y127.155
G1 X161.79 Y127.085
G1 X177.085 Y111.79 E.17498
G1 X177.155 Y111.72
G1 X176.874 Y111.72
G1 X176.804 Y111.79
G1 X161.79 Y126.804 E.17176
G1 X161.72 Y126.874
G1 X161.72 Y126.594
G1 X161.79 Y126.524
G1 X176.524 Y111.79 E.16855
G1 X176.594 Y111.72
G1 X176.313 Y111.72
G1 X176.243 Y111.79
G1 X161.79 Y126.243 E.16534
G1 X161.72 Y126.313
G1 X161.72 Y126.032
G1 X161.79 Y125.962
G1 X175.962 Y111.79 E.16213
G1 X176.032 Y111.72
G1 X175.751 Y111.72
G1 X175.681 Y111.79
G1 X161.79 Y125.681 E.15892
G1 X161.72 Y125.751
G1 X161.72 Y125.471
G1 X161.79 Y125.401
G1 X175.401 Y111.79 E.15571
G1 X175.471 Y111.72
G1 X175.19 Y111.72
G1 X175.12 Y111.79
G1 X161.79 Y125.12 E.15249
G1 X161.72 Y125.19
G1 X161.72 Y124.909
G1 X161.79 Y124.839
G1 X174.839 Y111.79 E.14928
G1 X174.909 Y111.72
G1 X174.628 Y111.72
G1 X174.558 Y111.79
G1 X161.79 Y124.558 E.14607
G1 X161.72 Y124.628
G1 X161.72 Y124.348
G1 X161.79 Y124.278
G1 X174.278 Y111.79 E.14286
G1 X174.348 Y111.72
G1 X174.067 Y111.72
G1 X173.997 Y111.79
G1 X161.79 Y123.997 E.13965
G1 X161.72 Y124.067
G1 X161.72 Y123.786
G1 X161.79 Y123.716
M73 P76 R4
G1 X173.716 Y111.79 E.13643
G1 X173.786 Y111.72
G1 X173.505 Y111.72
G1 X173.435 Y111.79
G1 X161.79 Y123.435 E.13322
G1 X161.72 Y123.505
G1 X161.72 Y123.224
G1 X161.79 Y123.154
G1 X173.155 Y111.79 E.13001
G1 X173.225 Y111.72
G1 X172.944 Y111.72
G1 X172.874 Y111.79
G1 X161.79 Y122.874 E.1268
G1 X161.72 Y122.944
G1 X161.72 Y122.663
G1 X161.79 Y122.593
G1 X172.593 Y111.79 E.12359
G1 X172.663 Y111.72
G1 X172.382 Y111.72
G1 X172.312 Y111.79
G1 X161.79 Y122.312 E.12037
G1 X161.72 Y122.382
G1 X161.72 Y122.101
G1 X161.79 Y122.031
G1 X172.031 Y111.79 E.11716
G1 X172.101 Y111.72
G1 X171.821 Y111.72
G1 X171.751 Y111.79
G1 X161.79 Y121.751 E.11395
G1 X161.72 Y121.821
G1 X161.72 Y121.54
G1 X161.79 Y121.47
G1 X171.47 Y111.79 E.11074
G1 X171.54 Y111.72
G1 X171.259 Y111.72
G1 X171.189 Y111.79
G1 X161.79 Y121.189 E.10753
G1 X161.72 Y121.259
G1 X161.72 Y120.978
G1 X161.79 Y120.908
G1 X170.908 Y111.79 E.10431
G1 X170.978 Y111.72
G1 X170.698 Y111.72
G1 X170.628 Y111.79
G1 X161.79 Y120.628 E.1011
G1 X161.72 Y120.698
G1 X161.72 Y120.417
G1 X161.79 Y120.347
G1 X170.347 Y111.79 E.09789
G1 X170.417 Y111.72
G1 X170.136 Y111.72
G1 X170.066 Y111.79
G1 X161.79 Y120.066 E.09468
G1 X161.72 Y120.136
G1 X161.72 Y119.855
G1 X161.79 Y119.785
G1 X169.785 Y111.79 E.09147
G1 X169.855 Y111.72
G1 X169.575 Y111.72
G1 X169.505 Y111.79
G1 X161.79 Y119.505 E.08826
G1 X161.72 Y119.575
G1 X161.72 Y119.294
G1 X161.79 Y119.224
G1 X169.224 Y111.79 E.08504
G1 X169.294 Y111.72
G1 X169.013 Y111.72
G1 X168.943 Y111.79
G1 X161.79 Y118.943 E.08183
G1 X161.72 Y119.013
G1 X161.72 Y118.732
G1 X161.79 Y118.662
M73 P76 R3
G1 X168.662 Y111.79 E.07862
G1 X168.732 Y111.72
G1 X168.452 Y111.72
G1 X168.382 Y111.79
G1 X161.79 Y118.382 E.07541
G1 X161.72 Y118.452
G1 X161.72 Y118.171
G1 X161.79 Y118.101
G1 X168.101 Y111.79 E.0722
G1 X168.171 Y111.72
G1 X167.89 Y111.72
G1 X167.82 Y111.79
G1 X161.79 Y117.82 E.06898
G1 X161.72 Y117.89
G1 X161.72 Y117.609
G1 X161.79 Y117.539
G1 X167.539 Y111.79 E.06577
G1 X167.609 Y111.72
G1 X167.328 Y111.72
G1 X167.258 Y111.79
G1 X161.79 Y117.258 E.06256
G1 X161.72 Y117.328
G1 X161.72 Y117.048
G1 X161.79 Y116.978
G1 X166.978 Y111.79 E.05935
G1 X167.048 Y111.72
G1 X166.767 Y111.72
G1 X166.697 Y111.79
G1 X161.79 Y116.697 E.05614
G1 X161.72 Y116.767
G1 X161.72 Y116.486
G1 X161.79 Y116.416
G1 X166.416 Y111.79 E.05292
G1 X166.486 Y111.72
G1 X166.205 Y111.72
G1 X166.135 Y111.79
G1 X161.79 Y116.135 E.04971
G1 X161.72 Y116.205
G1 X161.72 Y115.925
G1 X161.79 Y115.855
G1 X165.855 Y111.79 E.0465
G1 X165.925 Y111.72
G1 X165.644 Y111.72
G1 X165.574 Y111.79
G1 X161.79 Y115.574 E.04329
G1 X161.72 Y115.644
G1 X161.72 Y115.363
G1 X161.79 Y115.293
G1 X165.293 Y111.79 E.04008
G1 X165.363 Y111.72
G1 X165.082 Y111.72
G1 X165.012 Y111.79
G1 X161.79 Y115.012 E.03686
G1 X161.72 Y115.082
G1 X161.72 Y114.802
G1 X161.79 Y114.732
G1 X164.732 Y111.79 E.03365
G1 X164.802 Y111.72
G1 X164.521 Y111.72
G1 X164.451 Y111.79
G1 X161.79 Y114.451 E.03044
G1 X161.72 Y114.521
G1 X161.72 Y114.24
G1 X161.79 Y114.17
G1 X164.17 Y111.79 E.02723
G1 X164.24 Y111.72
G1 X163.959 Y111.72
G1 X163.889 Y111.79
G1 X161.79 Y113.889 E.02402
G1 X161.72 Y113.959
G1 X161.72 Y113.679
G1 X161.79 Y113.609
G1 X163.609 Y111.79 E.0208
G1 X163.679 Y111.72
G1 X163.398 Y111.72
G1 X163.328 Y111.79
G1 X161.79 Y113.328 E.01759
G1 X161.72 Y113.398
G1 X161.72 Y113.117
G1 X161.79 Y113.047
G1 X163.047 Y111.79 E.01438
G1 X163.117 Y111.72
G1 X162.836 Y111.72
G1 X162.766 Y111.79
G1 X161.79 Y112.766 E.01117
G1 X161.72 Y112.836
G1 X161.72 Y112.555
G1 X161.79 Y112.485
G1 X162.485 Y111.79 E.00796
G1 X162.555 Y111.72
G1 X162.275 Y111.72
G1 X162.205 Y111.79
G1 X161.79 Y112.205 E.00475
; WIPE_START
M204 S8000
G1 X162.205 Y111.79 E-.11146
G1 X162.275 Y111.72 E-.01881
G1 X162.555 Y111.72 E-.05334
G1 X162.485 Y111.79 E-.01881
G1 X161.825 Y112.451 E-.17758
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X167.31 Y117.758 Z.8 F60000
G1 X179.329 Y129.386 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.0607586
G1 F3000
M204 S8000
G1 X179.212 Y129.48 E.00024
G1 X179.16 Y129.549 E.00014
M204 S10000
G1 X180.235 Y128.791 F60000
; LINE_WIDTH: 0.100194
G1 F3000
M204 S8000
G1 X180.083 Y128.912 E.00062
; LINE_WIDTH: 0.0635907
G1 X179.932 Y129.033 E.00033
M204 S10000
G1 X180.991 Y128.316 F60000
; LINE_WIDTH: 0.100199
G1 F3000
M204 S8000
G1 X180.839 Y128.437 E.00062
; LINE_WIDTH: 0.0635928
G1 X180.688 Y128.558 E.00033
M204 S10000
G1 X181.747 Y127.841 F60000
; LINE_WIDTH: 0.100192
G1 F3000
M204 S8000
G1 X181.595 Y127.962 E.00062
; LINE_WIDTH: 0.0635811
G1 X181.443 Y128.083 E.00033
M204 S10000
G1 X182.503 Y127.366 F60000
; LINE_WIDTH: 0.100202
G1 F3000
M204 S8000
G1 X182.351 Y127.487 E.00062
; LINE_WIDTH: 0.0636032
G1 X182.199 Y127.608 E.00033
M204 S10000
G1 X183.259 Y126.891 F60000
; LINE_WIDTH: 0.100199
G1 F3000
M204 S8000
G1 X183.107 Y127.012 E.00062
; LINE_WIDTH: 0.0635928
G1 X182.955 Y127.133 E.00033
M204 S10000
G1 X184.014 Y126.416 F60000
; LINE_WIDTH: 0.100194
G1 F3000
M204 S8000
G1 X183.863 Y126.536 E.00062
; LINE_WIDTH: 0.0635907
G1 X183.711 Y126.657 E.00033
M204 S10000
G1 X184.77 Y125.94 F60000
; LINE_WIDTH: 0.100202
G1 F3000
M204 S8000
G1 X184.619 Y126.061 E.00062
; LINE_WIDTH: 0.0636032
G1 X184.467 Y126.182 E.00033
M204 S10000
G1 X185.526 Y125.465 F60000
; LINE_WIDTH: 0.100194
G1 F3000
M204 S8000
G1 X185.375 Y125.586 E.00062
; LINE_WIDTH: 0.0635912
G1 X185.223 Y125.707 E.00033
M204 S10000
G1 X186.282 Y124.99 F60000
; LINE_WIDTH: 0.100202
G1 F3000
M204 S8000
G1 X186.131 Y125.111 E.00062
; LINE_WIDTH: 0.0636032
G1 X185.979 Y125.232 E.00033
M204 S10000
G1 X187.038 Y124.515 F60000
; LINE_WIDTH: 0.100199
G1 F3000
M204 S8000
G1 X186.886 Y124.636 E.00062
; LINE_WIDTH: 0.0635928
G1 X186.735 Y124.757 E.00033
M204 S10000
G1 X187.794 Y124.04 F60000
; LINE_WIDTH: 0.100194
G1 F3000
M204 S8000
G1 X187.642 Y124.161 E.00062
; LINE_WIDTH: 0.0635907
G1 X187.491 Y124.282 E.00033
M204 S10000
G1 X188.55 Y123.565 F60000
; LINE_WIDTH: 0.100202
G1 F3000
M204 S8000
G1 X188.398 Y123.686 E.00062
; LINE_WIDTH: 0.0636032
G1 X188.247 Y123.807 E.00033
M204 S10000
G1 X189.306 Y123.09 F60000
; LINE_WIDTH: 0.100194
G1 F3000
M204 S8000
G1 X189.154 Y123.211 E.00062
; LINE_WIDTH: 0.0635912
G1 X189.003 Y123.331 E.00033
M204 S10000
G1 X190.062 Y122.614 F60000
; LINE_WIDTH: 0.100202
G1 F3000
M204 S8000
G1 X189.91 Y122.735 E.00062
; LINE_WIDTH: 0.0636032
G1 X189.758 Y122.856 E.00033
M204 S10000
G1 X190.818 Y122.139 F60000
; LINE_WIDTH: 0.100199
G1 F3000
M204 S8000
G1 X190.666 Y122.26 E.00062
; LINE_WIDTH: 0.0635928
G1 X190.514 Y122.381 E.00033
M204 S10000
G1 X191.573 Y121.664 F60000
; LINE_WIDTH: 0.100194
G1 F3000
M204 S8000
G1 X191.422 Y121.785 E.00062
; LINE_WIDTH: 0.0635907
G1 X191.27 Y121.906 E.00033
M204 S10000
G1 X192.22 Y121.276 F60000
; LINE_WIDTH: 0.0669073
G1 F3000
M204 S8000
G1 X192.026 Y121.431 E.00046
; WIPE_START
G1 X192.22 Y121.276 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X191.963 Y128.904 Z.8 F60000
G1 X191.953 Y129.21 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.22
G1 F6044.128
M204 S2000
G1 X192.21 Y128.953 E.00294
G1 X192.28 Y128.883
G1 X192.28 Y128.602
G1 X192.21 Y128.672
G1 X191.672 Y129.21 E.00615
G1 X191.602 Y129.28
G1 X191.321 Y129.28
G1 X191.391 Y129.21
G1 X192.21 Y128.391 E.00937
G1 X192.28 Y128.321
G1 X192.28 Y128.041
G1 X192.21 Y128.111
G1 X191.111 Y129.21 E.01258
G1 X191.041 Y129.28
G1 X190.76 Y129.28
G1 X190.83 Y129.21
G1 X192.21 Y127.83 E.01579
G1 X192.28 Y127.76
G1 X192.28 Y127.479
G1 X192.21 Y127.549
G1 X190.549 Y129.21 E.019
G1 X190.479 Y129.28
G1 X190.198 Y129.28
G1 X190.268 Y129.21
G1 X192.21 Y127.268 E.02221
G1 X192.28 Y127.198
G1 X192.28 Y126.918
G1 X192.21 Y126.988
G1 X189.988 Y129.21 E.02543
G1 X189.918 Y129.28
G1 X189.637 Y129.28
G1 X189.707 Y129.21
G1 X192.21 Y126.707 E.02864
G1 X192.28 Y126.637
G1 X192.28 Y126.356
G1 X192.21 Y126.426
G1 X189.426 Y129.21 E.03185
G1 X189.356 Y129.28
G1 X189.075 Y129.28
G1 X189.145 Y129.21
G1 X192.21 Y126.145 E.03506
G1 X192.28 Y126.075
G1 X192.28 Y125.794
G1 X192.21 Y125.864
G1 X188.864 Y129.21 E.03827
G1 X188.794 Y129.28
G1 X188.514 Y129.28
G1 X188.584 Y129.21
G1 X192.21 Y125.584 E.04149
G1 X192.28 Y125.514
G1 X192.28 Y125.233
G1 X192.21 Y125.303
G1 X188.303 Y129.21 E.0447
G1 X188.233 Y129.28
G1 X187.952 Y129.28
G1 X188.022 Y129.21
G1 X192.21 Y125.022 E.04791
G1 X192.28 Y124.952
G1 X192.28 Y124.671
G1 X192.21 Y124.741
G1 X187.741 Y129.21 E.05112
G1 X187.671 Y129.28
G1 X187.391 Y129.28
G1 X187.461 Y129.21
G1 X192.21 Y124.461 E.05433
G1 X192.28 Y124.391
G1 X192.28 Y124.11
G1 X192.21 Y124.18
G1 X187.18 Y129.21 E.05755
G1 X187.11 Y129.28
G1 X186.829 Y129.28
G1 X186.899 Y129.21
G1 X192.21 Y123.899 E.06076
G1 X192.28 Y123.829
G1 X192.28 Y123.548
G1 X192.21 Y123.618
G1 X186.618 Y129.21 E.06397
G1 X186.548 Y129.28
G1 X186.268 Y129.28
G1 X186.338 Y129.21
G1 X192.21 Y123.338 E.06718
G1 X192.28 Y123.268
G1 X192.28 Y122.987
G1 X192.21 Y123.057
G1 X186.057 Y129.21 E.07039
G1 X185.987 Y129.28
G1 X185.706 Y129.28
G1 X185.776 Y129.21
G1 X192.21 Y122.776 E.0736
G1 X192.28 Y122.706
G1 X191.944 Y122.762
G1 X191.874 Y122.832
G1 X185.495 Y129.21 E.07297
G1 X185.425 Y129.28
G1 X185.145 Y129.28
G1 X185.215 Y129.21
G1 X191.031 Y123.393 E.06654
M204 S10000
G1 X190.189 Y123.955 F60000
G1 F6044.128
M204 S2000
G1 X184.934 Y129.21 E.06012
G1 X184.864 Y129.28
G1 X184.583 Y129.28
G1 X184.653 Y129.21
G1 X189.347 Y124.516 E.0537
M204 S10000
G1 X188.504 Y125.078 F60000
G1 F6044.128
M204 S2000
G1 X184.372 Y129.21 E.04727
G1 X184.302 Y129.28
G1 X184.021 Y129.28
G1 X184.091 Y129.21
G1 X187.662 Y125.639 E.04085
M204 S10000
G1 X186.82 Y126.201 F60000
G1 F6044.128
M204 S2000
G1 X183.811 Y129.21 E.03442
G1 X183.741 Y129.28
G1 X183.46 Y129.28
G1 X183.53 Y129.21
G1 X185.978 Y126.763 E.028
M204 S10000
G1 X185.135 Y127.324 F60000
G1 F6044.128
M204 S2000
G1 X183.371 Y129.089 E.02019
G1 X183.301 Y129.159
G1 X183.235 Y128.943
G1 X183.305 Y128.873
G1 X184.293 Y127.886 E.0113
M204 S10000
G1 X191.404 Y123.146 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.0639377
G1 F3000
M204 S8000
G1 X191.233 Y123.286 E.00038
; LINE_WIDTH: 0.101262
G1 X191.063 Y123.425 E.00072
M204 S10000
G1 X190.561 Y123.708 F60000
; LINE_WIDTH: 0.0639406
G1 F3000
M204 S8000
G1 X190.391 Y123.847 E.00038
; LINE_WIDTH: 0.10127
G1 X190.221 Y123.987 E.00072
M204 S10000
G1 X189.719 Y124.269 F60000
; LINE_WIDTH: 0.0639408
G1 F3000
M204 S8000
G1 X189.549 Y124.409 E.00038
; LINE_WIDTH: 0.10127
G1 X189.379 Y124.548 E.00072
M204 S10000
G1 X188.877 Y124.831 F60000
; LINE_WIDTH: 0.0639404
G1 F3000
M204 S8000
G1 X188.706 Y124.97 E.00038
; LINE_WIDTH: 0.101269
G1 X188.536 Y125.11 E.00072
M204 S10000
G1 X188.034 Y125.392 F60000
; LINE_WIDTH: 0.0639408
G1 F3000
M204 S8000
G1 X187.864 Y125.532 E.00038
; LINE_WIDTH: 0.10127
G1 X187.694 Y125.671 E.00072
M204 S10000
G1 X187.192 Y125.954 F60000
; LINE_WIDTH: 0.0639408
G1 F3000
M204 S8000
G1 X187.022 Y126.093 E.00038
; LINE_WIDTH: 0.10127
G1 X186.852 Y126.233 E.00072
M204 S10000
G1 X186.35 Y126.515 F60000
; LINE_WIDTH: 0.0639409
G1 F3000
M204 S8000
G1 X186.18 Y126.655 E.00038
; LINE_WIDTH: 0.101271
G1 X186.009 Y126.794 E.00072
M204 S10000
G1 X185.507 Y127.077 F60000
; LINE_WIDTH: 0.0639384
G1 F3000
M204 S8000
G1 X185.337 Y127.216 E.00038
; LINE_WIDTH: 0.101263
G1 X185.167 Y127.356 E.00072
M204 S10000
G1 X184.665 Y127.638 F60000
; LINE_WIDTH: 0.0639408
G1 F3000
M204 S8000
G1 X184.495 Y127.778 E.00038
; LINE_WIDTH: 0.10127
G1 X184.325 Y127.917 E.00072
M204 S10000
G1 X183.823 Y128.2 F60000
; LINE_WIDTH: 0.0670364
G1 F3000
M204 S8000
G1 X183.627 Y128.36 E.00047
; LINE_WIDTH: 0.110558
G1 X183.432 Y128.52 E.00092
; LINE_WIDTH: 0.154079
G1 X183.237 Y128.68 E.00137
; OBJECT_ID: 5887
; COOLING_NODE: 0
; WIPE_START
G1 X183.432 Y128.52 E-.38
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 5909
M625
; start printing object, unique label id: 5887
M624 AQAAAAAAAAA=
M204 S10000
G1 X175.806 Y128.828 Z.8 F60000
G1 X126.384 Y130.826 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.21999
G1 F6044.427
M204 S8000
G1 X126.379 Y130.815 E.00009
G1 X126.267 Y130.716 E.00121
G1 X139.306 Y130.709 E.10547
G1 X139.602 Y130.537 E.00277
G1 X139.715 Y130.251 E.00249
G1 X139.716 Y129.767 E.00391
G1 X141.191 Y128.84 E.01409
G1 X141.53 Y128.627 E.00324
G1 F5876.836
G1 X141.868 Y128.414 E.00324
; LINE_WIDTH: 0.263145
M73 P77 R3
G1 F4965.14
G1 X142.313 Y128.161 E.00504
; LINE_WIDTH: 0.3063
G1 F4212.892
G1 X142.757 Y127.907 E.00594
G1 X144.443 Y126.831 E.02321
; LINE_WIDTH: 0.27945
G1 F4651.343
G1 X146.129 Y125.756 E.02102
; LINE_WIDTH: 0.25261
G1 F5191.434
G1 X147.815 Y124.68 E.01884
; LINE_WIDTH: 0.22577
G1 F5873.428
G1 X148.152 Y124.465 E.00333
G1 X149.501 Y123.604 E.01332
; LINE_WIDTH: 0.19893
G1 F6761.706
G1 X149.838 Y123.389 E.00289
G1 X150.247 Y123.128 E.00351
G1 F5989.115
G1 X150.585 Y122.913 E.00289
G1 F5068.386
G1 X150.922 Y122.698 E.00289
; LINE_WIDTH: 0.226154
G1 F4224.457
G1 X150.992 Y122.684 E.00059
; LINE_WIDTH: 0.275987
G1 F4082.373
G1 X151.061 Y122.669 E.00074
; LINE_WIDTH: 0.32582
G1 F3942.699
G1 X151.131 Y122.655 E.00088
G1 X151.089 Y122.713 E.00088
; LINE_WIDTH: 0.275987
G1 F4082.365
G1 X151.048 Y122.77 E.00074
; LINE_WIDTH: 0.226154
G1 F4224.462
G1 X151.006 Y122.828 E.00059
; LINE_WIDTH: 0.20316
G1 F5068.391
G1 X150.672 Y123.048 E.00296
G1 F5989.12
G1 X150.337 Y123.267 E.00296
G1 F6478.288
G1 X150.003 Y123.487 E.00296
G1 X149.669 Y123.707 E.00296
G1 X149.335 Y123.926 E.00296
; LINE_WIDTH: 0.23
G1 F5754.292
G1 X147.997 Y124.805 E.01359
G1 X147.663 Y125.024 E.0034
; LINE_WIDTH: 0.25684
G1 F5098.139
G1 X146.326 Y125.903 E.01534
G1 X145.992 Y126.123 E.00384
; LINE_WIDTH: 0.28368
G1 F4576.31
G1 X144.32 Y127.221 E.02137
; LINE_WIDTH: 0.3063
G1 F4212.892
G1 X142.912 Y128.146 E.01956
; LINE_WIDTH: 0.31137
G1 F4139.216
G1 X142.847 Y128.193 E.00094
G1 X142.792 Y128.466 E.00329
; LINE_WIDTH: 0.26568
G1 F4713.308
G1 X142.736 Y128.739 E.00277
; LINE_WIDTH: 0.21999
G1 F5602.569
G1 X142.852 Y129.122 E.00324
G1 F6044.427
G1 X142.925 Y129.364 E.00205
G1 X143.116 Y129.627 E.00263
G1 X143.4 Y129.716 E.00241
G1 X152.22 Y129.716 E.07134
G1 X152.306 Y129.709 E.0007
G1 X152.577 Y129.565 E.00248
G1 X152.709 Y129.306 E.00235
G1 X152.716 Y129.22 E.0007
G1 X152.716 Y122.989 E.0504
G1 X152.716 Y122.589 E.00324
G1 F6002.399
G1 X152.577 Y122.245 E.003
G1 F5144.02
G1 X152.484 Y122.169 E.00097
; LINE_WIDTH: 0.260175
G1 F4880.439
G1 X152.209 Y122.152 E.00268
; LINE_WIDTH: 0.30036
G1 F4302.618
G1 X151.934 Y122.135 E.00313
G1 X152.256 Y121.9 E.00452
; LINE_WIDTH: 0.260175
G1 F5026.915
G1 X152.577 Y121.666 E.00387
; LINE_WIDTH: 0.21999
G1 F5684.504
G1 X152.709 Y121.407 E.00235
G1 F6044.427
G1 X152.713 Y121.007 E.00324
G1 X152.716 Y120.678 E.00266
G1 X152.484 Y120.258 E.00388
G1 X139.716 Y112.233 E.12198
G1 X139.716 Y111.78 E.00366
G1 X139.602 Y111.463 E.00272
G1 X139.22 Y111.284 E.00341
G1 X121.694 Y111.291 E.14176
G1 X121.429 Y111.429 E.00242
G1 X121.284 Y111.78 E.00307
G1 X121.284 Y130.22 E.14916
G1 X121.33 Y130.332 E.00098
G1 X120.706 Y129.708 E.00715
G1 X120.706 Y110.706 E.15371
G1 X153.294 Y110.706 E.26361
G1 X153.294 Y114.287 E.02897
G1 X153.294 Y131.294 E.13757
G1 X126.506 Y131.294 E.21669
G1 X126.492 Y131.073 E.00179
G1 X126.384 Y130.826 E.00218
; COOLING_NODE: 0
; WIPE_START
G1 X126.379 Y130.815 E-.00223
G1 X126.267 Y130.716 E-.02838
G1 X128.106 Y130.715 E-.3494
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X135.602 Y129.278 Z.8 F60000
G1 X144.092 Y127.65 Z.8
G1 Z.4
G1 E.4 F1800
G1 F6044.427
M204 S8000
G1 X151.104 Y122.975 E.06817
G1 X152.062 Y122.337 E.00931
G1 X152.378 Y122.337 E.00256
G1 X152.434 Y122.382 E.00058
G1 X152.518 Y122.589 E.0018
G1 X152.518 Y129.22 E.05364
G1 X152.434 Y129.427 E.00181
G1 X152.22 Y129.518 E.00188
G1 X143.4 Y129.518 E.07134
G1 X143.23 Y129.464 E.00144
G1 X143.115 Y129.306 E.00158
G1 X142.926 Y128.681 E.00528
G1 X143.046 Y128.347 E.00287
G1 X144.092 Y127.65 E.01017
; COOLING_NODE: 0
M204 S10000
G1 X144.364 Y127.707 F60000
G1 F6044.427
M204 S8000
G1 X151.214 Y123.14 E.06659
G1 X152.167 Y122.505 E.00926
G1 X152.291 Y122.52 E.00101
G1 X152.319 Y122.589 E.0006
G1 X152.319 Y129.22 E.05364
G1 X152.241 Y129.317 E.00101
G1 X143.4 Y129.319 E.07151
G1 X143.305 Y129.249 E.00096
G1 X143.116 Y128.624 E.00528
G1 X143.156 Y128.512 E.00096
G1 X144.364 Y127.707 E.01175
; COOLING_NODE: 0
; WIPE_START
G1 X146.028 Y126.598 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X138.532 Y128.033 Z.8 F60000
G1 X124.52 Y130.716 Z.8
G1 Z.4
G1 E.4 F1800
G1 F6044.427
M204 S8000
G1 X124.387 Y130.864 E.00161
G1 X124.331 Y131.003 E.00121
G1 X124.294 Y131.294 E.00238
G1 X122.292 Y131.294 E.0162
G1 X121.684 Y130.686 E.00696
G1 X121.78 Y130.716 E.00082
G1 X124.52 Y130.716 E.02216
; COOLING_NODE: 0
; WIPE_START
G1 X124.387 Y130.864 E-.03784
G1 X124.331 Y131.003 E-.02836
G1 X124.294 Y131.294 E-.05586
G1 X122.937 Y131.294 E-.25794
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X126.407 Y130.517 Z.8 F60000
G1 Z.4
G1 E.4 F1800
G1 F6044.427
M204 S8000
G1 X125.94 Y130.517 E.00378
; LINE_WIDTH: 0.21909
G1 F6071.953
G1 X124.952 Y130.513 E.00795
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X122.58 Y130.517 E.01919
G1 X122.18 Y130.517 E.00324
G1 F5730.729
G1 X121.78 Y130.518 E.00324
; LINE_WIDTH: 0.26986
G1 F4830.918
G1 X121.552 Y130.448 E.00241
G1 X121.482 Y130.22 E.00241
; LINE_WIDTH: 0.21999
G1 F5730.729
G1 X121.482 Y129.82 E.00324
G1 F6044.427
G1 X121.482 Y129.42 E.00324
G1 X121.482 Y111.78 E.14269
G1 X121.569 Y111.569 E.00184
G1 X121.78 Y111.482 E.00184
G1 X139.22 Y111.482 E.14107
G1 X139.449 Y111.59 E.00205
G1 X139.518 Y111.78 E.00163
G1 X139.518 Y112.342 E.00455
G1 X152.378 Y120.426 E.12287
G1 X152.518 Y120.678 E.00233
G1 X152.518 Y121.322 E.0052
G1 X152.434 Y121.528 E.0018
G1 X139.518 Y129.658 E.12345
G1 X139.518 Y130.22 E.00455
G1 X139.449 Y130.41 E.00163
G1 X139.22 Y130.518 E.00205
G1 X126.407 Y130.517 E.10364
; COOLING_NODE: 0
M204 S10000
G1 X126.574 Y130.319 F60000
G1 F6044.427
M204 S8000
G1 X125.94 Y130.319 E.00513
G1 X121.78 Y130.319 E.03365
G1 X121.71 Y130.29 E.00061
G1 X121.681 Y130.22 E.00061
G1 X121.681 Y111.78 E.14916
G1 X121.763 Y111.682 E.00103
G1 X139.22 Y111.681 E.14121
G1 X139.296 Y111.717 E.00068
G1 X139.319 Y112.452 E.00595
G1 X152.273 Y120.594 E.12376
G1 X152.319 Y120.678 E.00078
G1 X152.319 Y121.322 E.0052
G1 X152.273 Y121.406 E.00078
G1 X139.319 Y129.548 E.12376
G1 X139.319 Y130.22 E.00544
G1 X139.237 Y130.318 E.00103
G1 X126.574 Y130.319 E.10243
; COOLING_NODE: 0
; WIPE_START
G1 X125.94 Y130.319 E-.12045
G1 X124.574 Y130.319 E-.25955
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X131.886 Y128.132 Z.8 F60000
G1 X151.934 Y122.135 Z.8
G1 Z.4
G1 E.4 F1800
; LINE_WIDTH: 0.32582
G1 F3942.699
M204 S8000
G1 X151.131 Y122.655 E.01187
; COOLING_NODE: 0
; WIPE_START
G1 X151.934 Y122.135 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X144.713 Y124.605 Z.8 F60000
G1 X126.212 Y130.932 Z.8
G1 Z.4
G1 E.4 F1800
; LINE_WIDTH: 0.21999
G1 F6044.427
M204 S8000
G1 X126.201 Y130.902 E.00026
G1 X126.03 Y130.751 E.00184
; LINE_WIDTH: 0.21967
G1 F6054.185
G1 X125.811 Y130.699 E.00182
; LINE_WIDTH: 0.20994
G1 F6366.724
G1 X124.952 Y130.701 E.00659
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X124.706 Y130.788 E.00211
G1 X124.571 Y130.939 E.00164
G1 X124.515 Y131.077 E.00121
G1 X124.493 Y131.493 E.00337
G1 X122.61 Y131.493 E.01523
G1 X122.21 Y131.493 E.00324
G1 F5796.179
G1 X122.067 Y131.35 E.00163
; LINE_WIDTH: 0.24662
G1 F5329.544
G1 X121.75 Y131.014 E.00424
; LINE_WIDTH: 0.27325
G1 F4765.877
G1 X121.432 Y130.678 E.00474
G1 X121.265 Y130.529 E.0023
; LINE_WIDTH: 0.24662
G1 F5329.544
G1 X121.097 Y130.38 E.00206
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X120.814 Y130.097 E.00324
G1 X120.507 Y129.79 E.00351
G1 X120.507 Y110.507 E.15598
G1 X153.493 Y110.507 E.26682
G1 X153.493 Y114.287 E.03057
G1 X153.493 Y131.493 E.13918
G1 X126.307 Y131.493 E.2199
G1 X126.307 Y131.189 E.00246
G1 X126.212 Y130.932 E.00222
; COOLING_NODE: 0
M204 S10000
G1 X126.043 Y131.037 F60000
G1 F6044.427
M204 S8000
G1 X126.022 Y130.989 E.00042
G1 X125.811 Y130.891 E.00188
G1 X124.953 Y130.895 E.00694
G1 X124.8 Y130.963 E.00136
G1 X124.691 Y131.189 E.00203
G1 X124.691 Y131.691 E.00406
G1 X122.128 Y131.691 E.02074
G1 X120.309 Y129.872 E.02081
G1 X120.309 Y110.309 E.15825
G1 X153.691 Y110.309 E.27003
G1 X153.691 Y114.287 E.03218
G1 X153.691 Y131.691 E.14078
G1 X126.109 Y131.691 E.22311
G1 X126.109 Y131.189 E.00406
G1 X126.043 Y131.037 E.00134
; COOLING_NODE: 0
M204 S250
G1 X125.891 Y131.131 F60000
; FEATURE: Outer wall
G1 F6044.427
M204 S5000
G1 X125.811 Y131.09 E.00073
G1 X124.951 Y131.098 E.00695
G1 X124.89 Y131.189 E.00089
G1 X124.89 Y131.89 E.00567
G1 X122.046 Y131.89 E.02301
G1 X120.11 Y129.954 E.02214
G1 X120.11 Y110.11 E.16052
G1 X153.89 Y110.11 E.27324
G1 X153.89 Y121 E.08809
G1 X153.89 Y131.89 E.08809
G1 X125.91 Y131.89 E.22633
G1 X125.891 Y131.131 E.00614
M204 S10000
G1 X126.793 Y130.785 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.22057
G1 F6026.819
M204 S8000
G1 X126.616 Y130.963 E.00203
G1 X126.646 Y131.035 E.00063
G1 X126.658 Y131.136 E.00083
G1 X126.724 Y131.136 E.00054
G1 X126.986 Y130.875 E.00299
G1 X127.267 Y130.874 E.00229
G1 X127.006 Y131.136 E.003
G1 X127.288 Y131.136 E.00228
G1 X127.549 Y130.874 E.003
G1 X127.831 Y130.874 E.00229
G1 X127.569 Y131.136 E.003
G1 X127.851 Y131.136 E.00228
G1 X128.113 Y130.874 E.003
G1 X128.394 Y130.874 E.00229
G1 X128.132 Y131.136 E.00301
G1 X128.414 Y131.136 E.00228
G1 X128.676 Y130.874 E.00301
G1 X128.958 Y130.873 E.00229
G1 X128.696 Y131.136 E.00301
G1 X128.977 Y131.136 E.00228
G1 X129.24 Y130.873 E.00301
G1 X129.522 Y130.873 E.00229
G1 X129.259 Y131.136 E.00302
G1 X129.54 Y131.136 E.00228
G1 X129.803 Y130.873 E.00302
G1 X130.085 Y130.873 E.00229
G1 X129.822 Y131.136 E.00302
G1 X130.103 Y131.136 E.00228
G1 X130.367 Y130.872 E.00302
G1 X130.649 Y130.872 E.00229
G1 X130.385 Y131.136 E.00302
G1 X130.667 Y131.136 E.00228
G1 X130.93 Y130.872 E.00303
G1 X131.212 Y130.872 E.00229
G1 X130.948 Y131.136 E.00303
G1 X131.23 Y131.136 E.00228
G1 X131.494 Y130.872 E.00303
G1 X131.776 Y130.871 E.00229
G1 X131.511 Y131.136 E.00303
G1 X131.793 Y131.136 E.00228
G1 X132.058 Y130.871 E.00304
G1 X132.339 Y130.871 E.00229
G1 X132.075 Y131.136 E.00304
G1 X132.356 Y131.136 E.00228
G1 X132.621 Y130.871 E.00304
G1 X132.903 Y130.871 E.00229
G1 X132.638 Y131.136 E.00304
G1 X132.919 Y131.136 E.00228
M73 P78 R3
G1 X133.185 Y130.87 E.00304
G1 X133.466 Y130.87 E.00229
G1 X133.201 Y131.136 E.00305
G1 X133.482 Y131.136 E.00228
G1 X133.748 Y130.87 E.00305
G1 X134.03 Y130.87 E.00229
G1 X133.764 Y131.136 E.00305
G1 X134.046 Y131.136 E.00228
G1 X134.312 Y130.87 E.00305
G1 X134.594 Y130.869 E.00229
G1 X134.327 Y131.136 E.00306
G1 X134.609 Y131.136 E.00228
G1 X134.875 Y130.869 E.00306
G1 X135.157 Y130.869 E.00229
G1 X134.89 Y131.136 E.00306
G1 X135.172 Y131.136 E.00228
G1 X135.439 Y130.869 E.00306
G1 X135.721 Y130.869 E.00229
G1 X135.454 Y131.136 E.00306
G1 X135.735 Y131.136 E.00228
G1 X136.002 Y130.868 E.00307
G1 X136.284 Y130.868 E.00229
G1 X136.017 Y131.136 E.00307
G1 X136.298 Y131.136 E.00228
G1 X136.566 Y130.868 E.00307
G1 X136.848 Y130.868 E.00229
G1 X136.58 Y131.136 E.00307
G1 X136.861 Y131.136 E.00228
G1 X137.13 Y130.868 E.00308
G1 X137.411 Y130.867 E.00229
G1 X137.143 Y131.136 E.00308
G1 X137.425 Y131.136 E.00228
G1 X137.693 Y130.867 E.00308
G1 X137.975 Y130.867 E.00229
G1 X137.706 Y131.136 E.00308
G1 X137.988 Y131.136 E.00228
G1 X138.257 Y130.867 E.00309
G1 X138.539 Y130.867 E.00229
G1 X138.269 Y131.136 E.00309
G1 X138.551 Y131.136 E.00228
G1 X138.82 Y130.866 E.00309
G1 X139.102 Y130.866 E.00229
G1 X138.743 Y131.225 E.00412
; WIPE_START
G1 X139.102 Y130.866 E-.09642
G1 X138.82 Y130.866 E-.05354
G1 X138.551 Y131.136 E-.07236
G1 X138.269 Y131.136 E-.0535
G1 X138.539 Y130.867 E-.07231
G1 X138.371 Y130.867 E-.03187
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X139.785 Y130.184 Z.8 F60000
G1 Z.4
G1 E.4 F1800
G1 F6026.819
M204 S8000
G1 X140.517 Y129.452 E.0084
G1 X141.275 Y128.975 E.00726
G1 X139.114 Y131.136 E.02479
G1 X139.396 Y131.136 E.00228
G1 X142.011 Y128.52 E.03001
G1 X142.573 Y128.24 E.00509
G1 X139.677 Y131.136 E.03322
G1 X139.959 Y131.136 E.00228
G1 X142.629 Y128.466 E.03063
G1 X142.586 Y128.791 E.00266
G1 X140.241 Y131.136 E.02691
G1 X140.522 Y131.136 E.00228
G1 X142.651 Y129.007 E.02443
G1 X142.717 Y129.223 E.00183
G1 X140.804 Y131.136 E.02195
G1 X141.085 Y131.136 E.00228
G1 X142.784 Y129.437 E.01949
G1 X142.812 Y129.509 E.00063
G1 X142.895 Y129.607 E.00104
G1 X141.367 Y131.136 E.01753
G1 X141.648 Y131.136 E.00228
G1 X143.025 Y129.759 E.01579
G1 X143.239 Y129.827 E.00182
G1 X141.93 Y131.136 E.01501
G1 X142.212 Y131.136 E.00228
G1 X143.472 Y129.875 E.01446
G1 X143.754 Y129.875 E.00228
G1 X142.493 Y131.136 E.01446
G1 X142.775 Y131.136 E.00228
G1 X144.035 Y129.875 E.01446
G1 X144.317 Y129.875 E.00228
G1 X143.056 Y131.136 E.01446
G1 X143.338 Y131.136 E.00228
G1 X144.599 Y129.875 E.01446
G1 X144.88 Y129.875 E.00228
G1 X143.62 Y131.136 E.01446
G1 X143.901 Y131.136 E.00228
G1 X145.162 Y129.875 E.01446
G1 X145.443 Y129.875 E.00228
G1 X144.183 Y131.136 E.01446
G1 X144.464 Y131.136 E.00228
G1 X145.725 Y129.875 E.01446
G1 X146.007 Y129.875 E.00228
G1 X144.746 Y131.136 E.01446
G1 X145.027 Y131.136 E.00228
G1 X146.288 Y129.875 E.01446
G1 X146.57 Y129.875 E.00228
G1 X145.309 Y131.136 E.01446
G1 X145.591 Y131.136 E.00228
G1 X146.851 Y129.875 E.01446
G1 X147.133 Y129.875 E.00228
G1 X145.872 Y131.136 E.01446
G1 X146.154 Y131.136 E.00228
G1 X147.414 Y129.875 E.01446
G1 X147.696 Y129.875 E.00228
G1 X146.435 Y131.136 E.01446
G1 X146.717 Y131.136 E.00228
G1 X147.978 Y129.875 E.01446
G1 X148.259 Y129.875 E.00228
G1 X146.999 Y131.136 E.01446
G1 X147.28 Y131.136 E.00228
G1 X148.541 Y129.875 E.01446
G1 X148.822 Y129.875 E.00228
G1 X147.562 Y131.136 E.01446
G1 X147.843 Y131.136 E.00228
G1 X149.104 Y129.875 E.01446
G1 X149.386 Y129.875 E.00228
G1 X148.125 Y131.136 E.01446
G1 X148.406 Y131.136 E.00228
G1 X149.667 Y129.875 E.01446
G1 X149.949 Y129.875 E.00228
G1 X148.688 Y131.136 E.01446
G1 X148.97 Y131.136 E.00228
G1 X150.23 Y129.875 E.01446
G1 X150.512 Y129.875 E.00228
G1 X149.251 Y131.136 E.01446
G1 X149.533 Y131.136 E.00228
G1 X150.793 Y129.875 E.01446
G1 X151.075 Y129.875 E.00228
G1 X149.814 Y131.136 E.01446
G1 X150.096 Y131.136 E.00228
G1 X151.357 Y129.875 E.01446
G1 X151.638 Y129.875 E.00228
G1 X150.378 Y131.136 E.01446
G1 X150.659 Y131.136 E.00228
G1 X151.92 Y129.875 E.01446
G1 X152.201 Y129.875 E.00228
G1 X150.851 Y131.225 E.01549
M204 S10000
G1 X152.822 Y131.225 F60000
G1 F6026.819
M204 S8000
G1 X153.136 Y130.912 E.00359
G1 X153.136 Y130.63 E.00228
G1 X152.63 Y131.136 E.0058
G1 X152.349 Y131.136 E.00228
G1 X153.136 Y130.349 E.00903
G1 X153.136 Y130.067 E.00228
G1 X152.067 Y131.136 E.01226
G1 X151.785 Y131.136 E.00228
G1 X153.136 Y129.785 E.01549
G1 X153.136 Y129.504 E.00228
G1 X151.504 Y131.136 E.01872
G1 X151.222 Y131.136 E.00228
G1 X153.136 Y129.222 E.02195
G1 X153.136 Y128.941 E.00228
G1 X152.875 Y129.201 E.00299
G1 X152.875 Y128.92 E.00228
G1 X153.136 Y128.659 E.00299
G1 X153.136 Y128.378 E.00228
G1 X152.875 Y128.638 E.00299
G1 X152.875 Y128.357 E.00228
G1 X153.136 Y128.096 E.00299
G1 X153.136 Y127.814 E.00228
G1 X152.875 Y128.075 E.00299
G1 X152.875 Y127.793 E.00228
G1 X153.136 Y127.533 E.00299
G1 X153.136 Y127.251 E.00228
G1 X152.875 Y127.512 E.00299
G1 X152.875 Y127.23 E.00228
G1 X153.136 Y126.97 E.00299
G1 X153.136 Y126.688 E.00228
G1 X152.875 Y126.949 E.00299
G1 X152.875 Y126.667 E.00228
G1 X153.136 Y126.406 E.00299
G1 X153.136 Y126.125 E.00228
G1 X152.875 Y126.386 E.00299
G1 X152.875 Y126.104 E.00228
G1 X153.136 Y125.843 E.00299
G1 X153.136 Y125.562 E.00228
G1 X152.875 Y125.822 E.00299
G1 X152.875 Y125.541 E.00228
G1 X153.136 Y125.28 E.00299
G1 X153.136 Y124.999 E.00228
G1 X152.875 Y125.259 E.00299
G1 X152.875 Y124.978 E.00228
G1 X153.136 Y124.717 E.00299
G1 X153.136 Y124.435 E.00228
G1 X152.875 Y124.696 E.00299
G1 X152.875 Y124.414 E.00228
G1 X153.136 Y124.154 E.00299
G1 X153.136 Y123.872 E.00228
G1 X152.875 Y124.133 E.00299
G1 X152.875 Y123.851 E.00228
G1 X153.136 Y123.591 E.00299
G1 X153.136 Y123.309 E.00228
G1 X152.875 Y123.57 E.00299
G1 X152.875 Y123.288 E.00228
G1 X153.136 Y123.027 E.00299
G1 X153.136 Y122.746 E.00228
G1 X152.875 Y123.007 E.00299
G1 X152.875 Y122.725 E.00228
G1 X153.136 Y122.464 E.00299
G1 X153.136 Y122.183 E.00228
G1 X152.837 Y122.482 E.00343
G1 X152.756 Y122.281 E.00176
G1 X153.136 Y121.901 E.00436
G1 X153.136 Y121.62 E.00228
G1 X152.653 Y122.102 E.00554
G1 X152.558 Y122.025 E.00099
G1 X152.448 Y122.025 E.00089
G1 X153.136 Y121.338 E.00789
G1 X153.136 Y121.056 E.00228
G1 X152.867 Y121.325 E.00308
G1 X152.871 Y121.04 E.00231
G1 X153.136 Y120.775 E.00304
G1 X153.136 Y120.493 E.00228
G1 X152.874 Y120.755 E.003
G1 X152.875 Y120.663 E.00074
G1 X152.807 Y120.54 E.00114
G1 X153.136 Y120.212 E.00377
G1 X153.136 Y119.93 E.00228
G1 X152.707 Y120.359 E.00492
G1 X152.607 Y120.177 E.00168
G1 X153.136 Y119.648 E.00607
G1 X153.136 Y119.367 E.00228
G1 X152.452 Y120.051 E.00784
G1 X152.279 Y119.942 E.00166
G1 X153.136 Y119.085 E.00983
G1 X153.136 Y118.804 E.00228
G1 X152.106 Y119.833 E.01181
G1 X151.933 Y119.725 E.00166
G1 X153.136 Y118.522 E.0138
G1 X153.136 Y118.241 E.00228
G1 X151.76 Y119.616 E.01578
G1 X151.587 Y119.507 E.00166
G1 X153.136 Y117.959 E.01776
G1 X153.136 Y117.677 E.00228
G1 X151.415 Y119.398 E.01975
G1 X151.242 Y119.29 E.00166
G1 X153.136 Y117.396 E.02173
G1 X153.136 Y117.114 E.00228
G1 X151.069 Y119.181 E.02371
G1 X150.896 Y119.072 E.00166
G1 X153.136 Y116.833 E.0257
G1 X153.136 Y116.551 E.00228
G1 X150.723 Y118.964 E.02768
G1 X150.55 Y118.855 E.00166
G1 X153.136 Y116.269 E.02966
G1 X153.136 Y115.988 E.00228
G1 X150.377 Y118.746 E.03165
G1 X150.204 Y118.638 E.00166
G1 X153.136 Y115.706 E.03363
G1 X153.136 Y115.425 E.00228
G1 X150.031 Y118.529 E.03562
G1 X149.858 Y118.42 E.00166
G1 X153.136 Y115.143 E.0376
G1 X153.136 Y114.861 E.00228
G1 X149.686 Y118.312 E.03958
G1 X149.513 Y118.203 E.00166
G1 X153.136 Y114.58 E.04157
G1 X153.136 Y114.298 E.00228
G1 X149.34 Y118.094 E.04355
G1 X149.167 Y117.986 E.00166
G1 X153.136 Y114.017 E.04553
G1 X153.136 Y113.735 E.00228
G1 X148.994 Y117.877 E.04752
G1 X148.821 Y117.768 E.00166
G1 X153.136 Y113.454 E.0495
G1 X153.136 Y113.172 E.00228
G1 X148.648 Y117.66 E.05148
G1 X148.475 Y117.551 E.00166
G1 X153.136 Y112.89 E.05347
G1 X153.136 Y112.609 E.00228
G1 X148.302 Y117.442 E.05545
G1 X148.129 Y117.334 E.00166
G1 X153.136 Y112.327 E.05744
G1 X153.136 Y112.046 E.00228
G1 X147.957 Y117.225 E.05942
G1 X147.784 Y117.116 E.00166
G1 X153.136 Y111.764 E.0614
G1 X153.136 Y111.482 E.00228
G1 X147.611 Y117.007 E.06339
G1 X147.438 Y116.899 E.00166
G1 X153.136 Y111.201 E.06537
G1 X153.136 Y110.919 E.00228
G1 X147.265 Y116.79 E.06735
G1 X147.092 Y116.681 E.00166
G1 X152.909 Y110.864 E.06674
G1 X152.628 Y110.864 E.00228
G1 X146.919 Y116.573 E.06549
G1 X146.746 Y116.464 E.00166
G1 X152.346 Y110.864 E.06425
G1 X152.064 Y110.864 E.00228
G1 X146.573 Y116.355 E.063
G1 X146.4 Y116.247 E.00166
G1 X151.783 Y110.864 E.06175
G1 X151.501 Y110.864 E.00228
G1 X146.228 Y116.138 E.0605
G1 X146.055 Y116.029 E.00166
G1 X151.22 Y110.864 E.05926
G1 X150.938 Y110.864 E.00228
G1 X145.882 Y115.921 E.05801
G1 X145.709 Y115.812 E.00166
G1 X150.657 Y110.864 E.05676
G1 X150.375 Y110.864 E.00228
G1 X145.536 Y115.703 E.05552
G1 X145.363 Y115.595 E.00166
G1 X150.093 Y110.864 E.05427
G1 X149.812 Y110.864 E.00228
G1 X145.19 Y115.486 E.05302
G1 X145.017 Y115.377 E.00166
G1 X149.53 Y110.864 E.05178
G1 X149.249 Y110.864 E.00228
G1 X144.844 Y115.269 E.05053
G1 X144.671 Y115.16 E.00166
G1 X148.967 Y110.864 E.04928
G1 X148.685 Y110.864 E.00228
G1 X144.498 Y115.051 E.04804
G1 X144.326 Y114.943 E.00166
G1 X148.404 Y110.864 E.04679
G1 X148.122 Y110.864 E.00228
G1 X144.153 Y114.834 E.04554
G1 X143.98 Y114.725 E.00166
G1 X147.841 Y110.864 E.0443
G1 X147.559 Y110.864 E.00228
G1 X143.807 Y114.616 E.04305
G1 X143.634 Y114.508 E.00166
G1 X147.278 Y110.864 E.0418
G1 X146.996 Y110.864 E.00228
G1 X143.461 Y114.399 E.04055
G1 X143.288 Y114.29 E.00166
G1 X146.714 Y110.864 E.03931
G1 X146.433 Y110.864 E.00228
G1 X143.115 Y114.182 E.03806
G1 X142.942 Y114.073 E.00166
G1 X146.151 Y110.864 E.03681
G1 X145.87 Y110.864 E.00228
G1 X142.769 Y113.964 E.03557
G1 X142.597 Y113.856 E.00166
G1 X145.588 Y110.864 E.03432
G1 X145.306 Y110.864 E.00228
G1 X142.424 Y113.747 E.03307
G1 X142.251 Y113.638 E.00166
G1 X145.025 Y110.864 E.03183
G1 X144.743 Y110.864 E.00228
G1 X142.078 Y113.53 E.03058
G1 X141.905 Y113.421 E.00166
G1 X144.462 Y110.864 E.02933
G1 X144.18 Y110.864 E.00228
G1 X141.732 Y113.312 E.02809
G1 X141.559 Y113.204 E.00166
G1 X143.899 Y110.864 E.02684
G1 X143.617 Y110.864 E.00228
G1 X141.386 Y113.095 E.02559
G1 X141.213 Y112.986 E.00166
G1 X143.335 Y110.864 E.02435
G1 X143.054 Y110.864 E.00228
G1 X141.04 Y112.878 E.0231
G1 X140.868 Y112.769 E.00166
G1 X142.772 Y110.864 E.02185
G1 X142.491 Y110.864 E.00228
G1 X140.695 Y112.66 E.0206
G1 X140.522 Y112.552 E.00166
G1 X142.209 Y110.864 E.01936
G1 X141.927 Y110.864 E.00228
G1 X140.349 Y112.443 E.01811
G1 X140.176 Y112.334 E.00166
G1 X141.646 Y110.864 E.01686
G1 X141.364 Y110.864 E.00228
G1 X140.003 Y112.226 E.01562
G1 X139.875 Y112.145 E.00123
G1 X139.875 Y112.072 E.00059
G1 X141.083 Y110.864 E.01386
G1 X140.801 Y110.864 E.00228
G1 X139.874 Y111.791 E.01064
G1 X139.874 Y111.732 E.00049
G1 X139.811 Y111.573 E.00139
G1 X140.519 Y110.864 E.00813
G1 X140.238 Y110.864 E.00228
G1 X139.731 Y111.371 E.00582
G1 X139.548 Y111.273 E.00169
G1 X139.956 Y110.864 E.00469
G1 X139.675 Y110.864 E.00228
G1 X139.356 Y111.183 E.00365
G1 X139.233 Y111.125 E.0011
G1 X139.132 Y111.125 E.00082
G1 X139.393 Y110.864 E.00299
G1 X139.112 Y110.864 E.00228
G1 X138.851 Y111.125 E.00299
G1 X138.569 Y111.125 E.00228
G1 X138.83 Y110.864 E.00299
G1 X138.548 Y110.864 E.00228
G1 X138.288 Y111.125 E.00299
G1 X138.006 Y111.125 E.00228
G1 X138.267 Y110.864 E.00299
G1 X137.985 Y110.864 E.00228
G1 X137.725 Y111.125 E.00299
G1 X137.443 Y111.125 E.00228
G1 X137.704 Y110.864 E.00299
G1 X137.422 Y110.864 E.00228
G1 X137.161 Y111.125 E.00299
G1 X136.88 Y111.125 E.00228
G1 X137.14 Y110.864 E.00299
G1 X136.859 Y110.864 E.00228
G1 X136.598 Y111.125 E.00299
G1 X136.317 Y111.125 E.00228
G1 X136.577 Y110.864 E.00299
G1 X136.296 Y110.864 E.00228
G1 X136.035 Y111.125 E.00299
G1 X135.753 Y111.125 E.00228
G1 X136.014 Y110.864 E.00299
G1 X135.733 Y110.864 E.00228
G1 X135.472 Y111.125 E.00299
G1 X135.19 Y111.125 E.00228
G1 X135.451 Y110.864 E.00299
G1 X135.169 Y110.864 E.00228
G1 X134.909 Y111.125 E.00299
G1 X134.627 Y111.125 E.00228
G1 X134.888 Y110.864 E.00299
G1 X134.606 Y110.864 E.00228
G1 X134.346 Y111.125 E.00299
G1 X134.064 Y111.125 E.00228
G1 X134.325 Y110.864 E.00299
G1 X134.043 Y110.864 E.00228
G1 X133.782 Y111.125 E.00299
G1 X133.501 Y111.125 E.00228
G1 X133.761 Y110.864 E.00299
G1 X133.48 Y110.864 E.00228
G1 X133.219 Y111.125 E.00299
G1 X132.938 Y111.125 E.00228
G1 X133.198 Y110.864 E.00299
G1 X132.917 Y110.864 E.00228
G1 X132.656 Y111.125 E.00299
G1 X132.374 Y111.125 E.00228
G1 X132.635 Y110.864 E.00299
G1 X132.354 Y110.864 E.00228
G1 X132.093 Y111.125 E.00299
G1 X131.811 Y111.125 E.00228
G1 X132.072 Y110.864 E.00299
G1 X131.79 Y110.864 E.00228
G1 X131.53 Y111.125 E.00299
G1 X131.248 Y111.125 E.00228
G1 X131.509 Y110.864 E.00299
G1 X131.227 Y110.864 E.00228
G1 X130.967 Y111.125 E.00299
G1 X130.685 Y111.125 E.00228
G1 X130.946 Y110.864 E.00299
G1 X130.664 Y110.864 E.00228
G1 X130.403 Y111.125 E.00299
G1 X130.122 Y111.125 E.00228
G1 X130.382 Y110.864 E.00299
G1 X130.101 Y110.864 E.00228
G1 X129.84 Y111.125 E.00299
G1 X129.559 Y111.125 E.00228
G1 X129.819 Y110.864 E.00299
G1 X129.538 Y110.864 E.00228
G1 X129.277 Y111.125 E.00299
G1 X128.995 Y111.125 E.00228
G1 X129.256 Y110.864 E.00299
G1 X128.975 Y110.864 E.00228
G1 X128.714 Y111.125 E.00299
G1 X128.432 Y111.125 E.00228
G1 X128.693 Y110.864 E.00299
G1 X128.411 Y110.864 E.00228
G1 X128.151 Y111.125 E.00299
G1 X127.869 Y111.125 E.00228
G1 X128.13 Y110.864 E.00299
G1 X127.848 Y110.864 E.00228
G1 X127.588 Y111.125 E.00299
G1 X127.306 Y111.125 E.00228
G1 X127.567 Y110.864 E.00299
G1 X127.285 Y110.864 E.00228
G1 X127.024 Y111.125 E.00299
G1 X126.743 Y111.125 E.00228
G1 X127.003 Y110.864 E.00299
G1 X126.722 Y110.864 E.00228
G1 X126.461 Y111.125 E.00299
G1 X126.18 Y111.125 E.00228
G1 X126.44 Y110.864 E.00299
G1 X126.159 Y110.864 E.00228
G1 X125.898 Y111.125 E.00299
G1 X125.616 Y111.125 E.00228
G1 X125.877 Y110.864 E.00299
G1 X125.596 Y110.864 E.00228
G1 X125.335 Y111.125 E.00299
G1 X125.053 Y111.125 E.00228
G1 X125.314 Y110.864 E.00299
G1 X125.032 Y110.864 E.00228
G1 X124.772 Y111.125 E.00299
G1 X124.49 Y111.125 E.00228
G1 X124.751 Y110.864 E.00299
G1 X124.469 Y110.864 E.00228
G1 X124.209 Y111.125 E.00299
G1 X123.927 Y111.125 E.00228
G1 X124.188 Y110.864 E.00299
G1 X123.906 Y110.864 E.00228
G1 X123.645 Y111.125 E.00299
G1 X123.364 Y111.125 E.00228
G1 X123.624 Y110.864 E.00299
G1 X123.343 Y110.864 E.00228
G1 X123.082 Y111.125 E.00299
G1 X122.801 Y111.125 E.00228
G1 X123.061 Y110.864 E.00299
G1 X122.78 Y110.864 E.00228
G1 X122.519 Y111.125 E.00299
G1 X122.237 Y111.125 E.00228
G1 X122.498 Y110.864 E.00299
G1 X122.217 Y110.864 E.00228
G1 X121.956 Y111.125 E.00299
G1 X121.664 Y111.135 E.00237
G1 X121.935 Y110.864 E.0031
G1 X121.653 Y110.864 E.00228
G1 X120.864 Y111.653 E.00905
G1 X120.864 Y111.935 E.00228
G1 X121.191 Y111.608 E.00375
G1 X121.125 Y111.768 E.00141
G1 X121.125 Y111.956 E.00152
G1 X120.864 Y112.217 E.00299
G1 X120.864 Y112.498 E.00228
G1 X121.125 Y112.237 E.00299
G1 X121.125 Y112.519 E.00228
G1 X120.864 Y112.78 E.00299
G1 X120.864 Y113.061 E.00228
G1 X121.125 Y112.801 E.00299
G1 X121.125 Y113.082 E.00228
G1 X120.864 Y113.343 E.00299
G1 X120.864 Y113.624 E.00228
G1 X121.125 Y113.364 E.00299
G1 X121.125 Y113.645 E.00228
G1 X120.864 Y113.906 E.00299
G1 X120.864 Y114.188 E.00228
G1 X121.125 Y113.927 E.00299
G1 X121.125 Y114.209 E.00228
G1 X120.864 Y114.469 E.00299
G1 X120.864 Y114.751 E.00228
G1 X121.125 Y114.49 E.00299
G1 X121.125 Y114.772 E.00228
G1 X120.864 Y115.032 E.00299
G1 X120.864 Y115.314 E.00228
G1 X121.125 Y115.053 E.00299
G1 X121.125 Y115.335 E.00228
G1 X120.864 Y115.596 E.00299
G1 X120.864 Y115.877 E.00228
G1 X121.125 Y115.616 E.00299
M73 P79 R3
G1 X121.125 Y115.898 E.00228
G1 X120.864 Y116.159 E.00299
G1 X120.864 Y116.44 E.00228
G1 X121.125 Y116.18 E.00299
G1 X121.125 Y116.461 E.00228
G1 X120.864 Y116.722 E.00299
G1 X120.864 Y117.003 E.00228
G1 X121.125 Y116.743 E.00299
G1 X121.125 Y117.024 E.00228
G1 X120.864 Y117.285 E.00299
G1 X120.864 Y117.567 E.00228
G1 X121.125 Y117.306 E.00299
G1 X121.125 Y117.588 E.00228
G1 X120.864 Y117.848 E.00299
G1 X120.864 Y118.13 E.00228
G1 X121.125 Y117.869 E.00299
G1 X121.125 Y118.151 E.00228
G1 X120.864 Y118.411 E.00299
G1 X120.864 Y118.693 E.00228
G1 X121.125 Y118.432 E.00299
G1 X121.125 Y118.714 E.00228
G1 X120.864 Y118.975 E.00299
G1 X120.864 Y119.256 E.00228
G1 X121.125 Y118.995 E.00299
G1 X121.125 Y119.277 E.00228
G1 X120.864 Y119.538 E.00299
G1 X120.864 Y119.819 E.00228
G1 X121.125 Y119.559 E.00299
G1 X121.125 Y119.84 E.00228
G1 X120.864 Y120.101 E.00299
G1 X120.864 Y120.382 E.00228
G1 X121.125 Y120.122 E.00299
G1 X121.125 Y120.403 E.00228
G1 X120.864 Y120.664 E.00299
G1 X120.864 Y120.946 E.00228
G1 X121.125 Y120.685 E.00299
G1 X121.125 Y120.967 E.00228
G1 X120.864 Y121.227 E.00299
G1 X120.864 Y121.509 E.00228
G1 X121.125 Y121.248 E.00299
G1 X121.125 Y121.53 E.00228
G1 X120.864 Y121.79 E.00299
G1 X120.864 Y122.072 E.00228
G1 X121.125 Y121.811 E.00299
G1 X121.125 Y122.093 E.00228
G1 X120.864 Y122.354 E.00299
G1 X120.864 Y122.635 E.00228
G1 X121.125 Y122.374 E.00299
G1 X121.125 Y122.656 E.00228
G1 X120.864 Y122.917 E.00299
G1 X120.864 Y123.198 E.00228
G1 X121.125 Y122.938 E.00299
G1 X121.125 Y123.219 E.00228
G1 X120.864 Y123.48 E.00299
G1 X120.864 Y123.761 E.00228
G1 X121.125 Y123.501 E.00299
G1 X121.125 Y123.782 E.00228
G1 X120.864 Y124.043 E.00299
G1 X120.864 Y124.325 E.00228
G1 X121.125 Y124.064 E.00299
G1 X121.125 Y124.346 E.00228
G1 X120.864 Y124.606 E.00299
G1 X120.864 Y124.888 E.00228
G1 X121.125 Y124.627 E.00299
G1 X121.125 Y124.909 E.00228
G1 X120.864 Y125.169 E.00299
G1 X120.864 Y125.451 E.00228
G1 X121.125 Y125.19 E.00299
G1 X121.125 Y125.472 E.00228
G1 X120.864 Y125.733 E.00299
G1 X120.864 Y126.014 E.00228
G1 X121.125 Y125.753 E.00299
G1 X121.125 Y126.035 E.00228
G1 X120.864 Y126.296 E.00299
G1 X120.864 Y126.577 E.00228
G1 X121.125 Y126.317 E.00299
G1 X121.125 Y126.598 E.00228
G1 X120.864 Y126.859 E.00299
G1 X120.864 Y127.14 E.00228
G1 X121.125 Y126.88 E.00299
G1 X121.125 Y127.161 E.00228
G1 X120.864 Y127.422 E.00299
G1 X120.864 Y127.704 E.00228
G1 X121.125 Y127.443 E.00299
G1 X121.125 Y127.725 E.00228
G1 X120.864 Y127.985 E.00299
G1 X120.864 Y128.267 E.00228
G1 X121.125 Y128.006 E.00299
G1 X121.125 Y128.288 E.00228
G1 X120.864 Y128.548 E.00299
G1 X120.864 Y128.83 E.00228
G1 X121.125 Y128.569 E.00299
G1 X121.125 Y128.851 E.00228
G1 X120.864 Y129.112 E.00299
G1 X120.864 Y129.393 E.00228
G1 X121.125 Y129.132 E.00299
G1 X121.125 Y129.414 E.00228
G1 X120.881 Y129.658 E.0028
G1 X121.021 Y129.799 E.00162
G1 X121.214 Y129.606 E.00221
; WIPE_START
G1 X121.021 Y129.799 E-.05182
G1 X120.881 Y129.658 E-.03783
G1 X121.125 Y129.414 E-.06565
G1 X121.125 Y129.132 E-.0535
G1 X120.864 Y129.393 E-.07005
G1 X120.864 Y129.112 E-.0535
G1 X121.042 Y128.934 E-.04765
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X124.179 Y130.91 Z.8 F60000
G1 Z.4
G1 E.4 F1800
; LINE_WIDTH: 0.211265
G1 F6322.275
M204 S8000
G1 X122.183 Y130.91 E.01544
G1 X122.373 Y131.1 E.00208
G1 X124.124 Y131.1 E.01354
G1 X124.171 Y130.939 E.0013
; WIPE_START
G1 X124.124 Y131.1 E-.03185
G1 X122.373 Y131.1 E-.33273
G1 X122.315 Y131.043 E-.01542
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X121.717 Y123.434 Z.8 F60000
G1 X120.775 Y111.461 Z.8
G1 Z.4
G1 E.4 F1800
; LINE_WIDTH: 0.22057
G1 F6026.819
M204 S8000
G1 X121.372 Y110.864 E.00685
G1 X121.09 Y110.864 E.00228
G1 X120.775 Y111.18 E.00362
; WIPE_START
G1 X121.09 Y110.864 E-.1078
G1 X121.372 Y110.864 E-.0681
G1 X120.775 Y111.461 E-.2041
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X128.073 Y113.697 Z.8 F60000
G1 X152.21 Y121.091 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.22
G1 F6044.128
M204 S2000
G1 X151.605 Y121.696 E.00692
M204 S10000
G1 X150.85 Y122.171 F60000
G1 F6044.128
M204 S2000
G1 X152.21 Y120.811 E.01556
G1 X152.28 Y120.741
G1 X152.186 Y120.554
G1 X152.116 Y120.624
G1 X150.094 Y122.646 E.02313
M204 S10000
G1 X149.338 Y123.122 F60000
G1 F6044.128
M204 S2000
G1 X151.943 Y120.516 E.02981
G1 X152.013 Y120.446
G1 X151.841 Y120.338
G1 X151.771 Y120.408
G1 X148.582 Y123.597 E.03648
M204 S10000
G1 X147.826 Y124.072 F60000
G1 F6044.128
M204 S2000
G1 X151.598 Y120.299 E.04316
G1 X151.668 Y120.229
G1 X151.496 Y120.121
G1 X151.426 Y120.191
G1 X147.07 Y124.547 E.04983
M204 S10000
G1 X146.314 Y125.022 F60000
G1 F6044.128
M204 S2000
G1 X151.254 Y120.083 E.05651
G1 X151.324 Y120.013
G1 X151.151 Y119.904
G1 X151.081 Y119.974
G1 X145.558 Y125.497 E.06318
M204 S10000
G1 X144.802 Y125.972 F60000
G1 F6044.128
M204 S2000
G1 X150.909 Y119.866 E.06986
G1 X150.979 Y119.796
G1 X150.806 Y119.688
G1 X150.736 Y119.758
G1 X144.046 Y126.448 E.07653
M204 S10000
G1 X143.291 Y126.923 F60000
G1 F6044.128
M204 S2000
G1 X150.564 Y119.649 E.08321
G1 X150.634 Y119.579
G1 X150.462 Y119.471
G1 X150.392 Y119.541
G1 X142.535 Y127.398 E.08988
M204 S10000
G1 X141.779 Y127.873 F60000
G1 F6044.128
M204 S2000
G1 X150.219 Y119.432 E.09656
G1 X150.289 Y119.362
G1 X150.117 Y119.254
G1 X150.047 Y119.324
G1 X141.023 Y128.348 E.10323
M204 S10000
G1 X140.267 Y128.823 F60000
G1 F6044.128
M204 S2000
G1 X149.874 Y119.216 E.10991
G1 X149.944 Y119.146
G1 X149.772 Y119.037
G1 X149.702 Y119.107
G1 X139.511 Y129.298 E.11658
G1 X139.441 Y129.368
G1 X139.28 Y129.81
G1 X139.21 Y129.88
G1 X138.88 Y130.21 E.00378
G1 X138.81 Y130.28
G1 X138.529 Y130.28
G1 X138.599 Y130.21
G1 X139.21 Y129.599 E.00699
; WIPE_START
M204 S8000
G1 X138.599 Y130.21 E-.16413
G1 X138.529 Y130.28 E-.01881
G1 X138.81 Y130.28 E-.05335
G1 X138.88 Y130.21 E-.01881
G1 X139.21 Y129.88 E-.08869
G1 X139.28 Y129.81 E-.01881
G1 X139.311 Y129.724 E-.01741
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X138.318 Y130.21 Z.8 F60000
G1 Z.4
G1 E.4 F1800
G1 F6044.128
M204 S2000
G1 X149.53 Y118.999 E.12825
G1 X149.6 Y118.929
G1 X149.427 Y118.821
G1 X149.357 Y118.891
G1 X138.038 Y130.21 E.12949
G1 X137.968 Y130.28
G1 X137.687 Y130.28
G1 X137.757 Y130.21
G1 X149.185 Y118.782 E.13073
G1 X149.255 Y118.712
G1 X149.082 Y118.604
G1 X149.012 Y118.674
G1 X137.476 Y130.21 E.13197
G1 X137.406 Y130.28
G1 X137.125 Y130.28
G1 X137.195 Y130.21
G1 X148.84 Y118.566 E.13321
G1 X148.91 Y118.496
G1 X148.738 Y118.387
G1 X148.668 Y118.457
G1 X136.915 Y130.21 E.13445
G1 X136.845 Y130.28
G1 X136.564 Y130.28
G1 X136.634 Y130.21
G1 X148.495 Y118.349 E.13569
G1 X148.565 Y118.279
G1 X148.393 Y118.17
G1 X148.323 Y118.24
G1 X136.353 Y130.21 E.13693
G1 X136.283 Y130.28
G1 X136.002 Y130.28
G1 X136.072 Y130.21
G1 X148.15 Y118.132 E.13817
G1 X148.22 Y118.062
G1 X148.048 Y117.954
G1 X147.978 Y118.024
G1 X135.792 Y130.21 E.13941
G1 X135.722 Y130.28
G1 X135.441 Y130.28
G1 X135.511 Y130.21
G1 X147.806 Y117.915 E.14065
G1 X147.876 Y117.845
G1 X147.703 Y117.737
G1 X147.633 Y117.807
G1 X135.23 Y130.21 E.14189
G1 X135.16 Y130.28
G1 X134.879 Y130.28
G1 X134.949 Y130.21
G1 X147.461 Y117.699 E.14313
G1 X147.531 Y117.629
G1 X147.358 Y117.52
G1 X147.288 Y117.59
G1 X134.669 Y130.21 E.14437
G1 X134.599 Y130.28
G1 X134.318 Y130.28
G1 X134.388 Y130.21
G1 X147.116 Y117.482 E.14561
G1 X147.186 Y117.412
G1 X147.014 Y117.304
G1 X146.944 Y117.374
G1 X134.107 Y130.21 E.14685
G1 X134.037 Y130.28
G1 X133.756 Y130.28
G1 X133.826 Y130.21
G1 X146.771 Y117.265 E.14809
G1 X146.841 Y117.195
G1 X146.669 Y117.087
G1 X146.599 Y117.157
G1 X133.546 Y130.21 E.14933
G1 X133.476 Y130.28
G1 X133.195 Y130.28
G1 X133.265 Y130.21
G1 X146.426 Y117.048 E.15057
G1 X146.496 Y116.978
G1 X146.324 Y116.87
G1 X146.254 Y116.94
G1 X132.984 Y130.21 E.15181
G1 X132.914 Y130.28
G1 X132.633 Y130.28
G1 X132.703 Y130.21
G1 X146.082 Y116.832 E.15305
G1 X146.152 Y116.762
G1 X145.979 Y116.653
G1 X145.909 Y116.723
G1 X132.422 Y130.21 E.15429
G1 X132.352 Y130.28
G1 X132.072 Y130.28
G1 X132.142 Y130.21
G1 X145.737 Y116.615 E.15553
G1 X145.807 Y116.545
G1 X145.634 Y116.437
G1 X145.564 Y116.507
G1 X131.861 Y130.21 E.15677
G1 X131.791 Y130.28
G1 X131.51 Y130.28
G1 X131.58 Y130.21
G1 X145.392 Y116.398 E.15801
G1 X145.462 Y116.328
G1 X145.29 Y116.22
G1 X145.22 Y116.29
G1 X131.299 Y130.21 E.15925
G1 X131.229 Y130.28
G1 X130.949 Y130.28
G1 X131.019 Y130.21
G1 X145.047 Y116.182 E.16049
G1 X145.117 Y116.112
G1 X144.945 Y116.003
G1 X144.875 Y116.073
G1 X130.738 Y130.21 E.16173
G1 X130.668 Y130.28
G1 X130.387 Y130.28
G1 X130.457 Y130.21
M73 P80 R3
G1 X144.702 Y115.965 E.16296
G1 X144.772 Y115.895
G1 X144.6 Y115.786
G1 X144.53 Y115.856
G1 X130.176 Y130.21 E.1642
G1 X130.106 Y130.28
G1 X129.826 Y130.28
G1 X129.896 Y130.21
G1 X144.358 Y115.748 E.16544
G1 X144.428 Y115.678
G1 X144.255 Y115.57
G1 X144.185 Y115.64
G1 X129.615 Y130.21 E.16668
G1 X129.545 Y130.28
G1 X129.264 Y130.28
G1 X129.334 Y130.21
G1 X144.013 Y115.531 E.16792
G1 X144.083 Y115.461
G1 X143.91 Y115.353
G1 X143.84 Y115.423
G1 X129.053 Y130.21 E.16916
G1 X128.983 Y130.28
G1 X128.703 Y130.28
G1 X128.773 Y130.21
G1 X143.668 Y115.315 E.1704
G1 X143.738 Y115.245
G1 X143.566 Y115.136
G1 X143.496 Y115.206
G1 X128.492 Y130.21 E.17164
G1 X128.422 Y130.28
G1 X128.141 Y130.28
G1 X128.211 Y130.21
G1 X143.323 Y115.098 E.17288
G1 X143.393 Y115.028
G1 X143.221 Y114.92
G1 X143.151 Y114.99
G1 X127.93 Y130.21 E.17412
G1 X127.86 Y130.28
G1 X127.579 Y130.28
G1 X127.649 Y130.21
G1 X142.978 Y114.881 E.17536
G1 X143.048 Y114.811
G1 X142.876 Y114.703
G1 X142.806 Y114.773
G1 X127.369 Y130.21 E.1766
G1 X127.299 Y130.28
G1 X127.018 Y130.28
G1 X127.088 Y130.21
G1 X142.634 Y114.664 E.17784
G1 X142.704 Y114.594
G1 X142.531 Y114.486
G1 X142.461 Y114.556
G1 X126.807 Y130.21 E.17908
G1 X126.737 Y130.28
G1 X126.456 Y130.28
G1 X126.526 Y130.21
G1 X142.289 Y114.448 E.18032
G1 X142.359 Y114.378
G1 X142.186 Y114.269
G1 X142.116 Y114.339
G1 X126.246 Y130.21 E.18156
G1 X126.176 Y130.28
G1 X125.895 Y130.28
G1 X125.965 Y130.21
G1 X141.944 Y114.231 E.1828
G1 X142.014 Y114.161
G1 X141.842 Y114.053
G1 X141.772 Y114.123
G1 X125.684 Y130.21 E.18404
G1 X125.614 Y130.28
G1 X125.333 Y130.28
G1 X125.403 Y130.21
G1 X141.599 Y114.014 E.18528
G1 X141.669 Y113.944
G1 X141.497 Y113.836
G1 X141.427 Y113.906
G1 X125.123 Y130.21 E.18652
G1 X125.053 Y130.28
G1 X124.772 Y130.28
G1 X124.842 Y130.21
G1 X141.254 Y113.798 E.18776
G1 X141.324 Y113.728
G1 X141.152 Y113.619
G1 X141.082 Y113.689
G1 X124.561 Y130.21 E.189
G1 X124.491 Y130.28
G1 X124.21 Y130.28
G1 X124.28 Y130.21
G1 X140.91 Y113.581 E.19024
G1 X140.98 Y113.511
G1 X140.807 Y113.402
G1 X140.737 Y113.472
G1 X124 Y130.21 E.19148
G1 X123.93 Y130.28
G1 X123.649 Y130.28
G1 X123.719 Y130.21
G1 X140.565 Y113.364 E.19272
G1 X140.635 Y113.294
G1 X140.462 Y113.186
G1 X140.392 Y113.256
G1 X123.438 Y130.21 E.19396
G1 X123.368 Y130.28
G1 X123.087 Y130.28
G1 X123.157 Y130.21
G1 X140.22 Y113.147 E.1952
G1 X140.29 Y113.077
G1 X140.118 Y112.969
G1 X140.048 Y113.039
G1 X122.876 Y130.21 E.19644
G1 X122.806 Y130.28
G1 X122.526 Y130.28
G1 X122.596 Y130.21
G1 X139.875 Y112.931 E.19768
G1 X139.945 Y112.861
G1 X139.773 Y112.752
G1 X139.703 Y112.822
G1 X122.315 Y130.21 E.19892
G1 X122.245 Y130.28
G1 X121.964 Y130.28
G1 X122.034 Y130.21
G1 X139.53 Y112.714 E.20016
G1 X139.6 Y112.644
G1 X139.428 Y112.535
G1 X139.358 Y112.605
G1 X121.79 Y130.174 E.20098
G1 X121.72 Y130.244
G1 X121.72 Y129.963
G1 X121.79 Y129.893
G1 X139.21 Y112.473 E.19929
G1 X139.28 Y112.403
G1 X139.28 Y112.122
G1 X139.21 Y112.192
G1 X121.79 Y129.612 E.19929
G1 X121.72 Y129.682
G1 X121.72 Y129.401
G1 X121.79 Y129.331
G1 X139.21 Y111.911 E.19929
G1 X139.28 Y111.841
G1 X139.121 Y111.72
G1 X139.051 Y111.79
G1 X121.79 Y129.051 E.19746
G1 X121.72 Y129.121
G1 X121.72 Y128.84
G1 X121.79 Y128.77
G1 X138.77 Y111.79 E.19425
G1 X138.84 Y111.72
G1 X138.559 Y111.72
G1 X138.489 Y111.79
G1 X121.79 Y128.489 E.19104
G1 X121.72 Y128.559
G1 X121.72 Y128.278
G1 X121.79 Y128.208
M73 P81 R3
G1 X138.208 Y111.79 E.18782
G1 X138.278 Y111.72
G1 X137.997 Y111.72
G1 X137.927 Y111.79
G1 X121.79 Y127.927 E.18461
G1 X121.72 Y127.997
G1 X121.72 Y127.717
G1 X121.79 Y127.647
G1 X137.647 Y111.79 E.1814
G1 X137.717 Y111.72
G1 X137.436 Y111.72
G1 X137.366 Y111.79
G1 X121.79 Y127.366 E.17819
G1 X121.72 Y127.436
G1 X121.72 Y127.155
G1 X121.79 Y127.085
G1 X137.085 Y111.79 E.17498
G1 X137.155 Y111.72
G1 X136.874 Y111.72
G1 X136.804 Y111.79
G1 X121.79 Y126.804 E.17176
G1 X121.72 Y126.874
G1 X121.72 Y126.594
G1 X121.79 Y126.524
G1 X136.524 Y111.79 E.16855
G1 X136.594 Y111.72
G1 X136.313 Y111.72
G1 X136.243 Y111.79
G1 X121.79 Y126.243 E.16534
G1 X121.72 Y126.313
G1 X121.72 Y126.032
G1 X121.79 Y125.962
G1 X135.962 Y111.79 E.16213
G1 X136.032 Y111.72
G1 X135.751 Y111.72
G1 X135.681 Y111.79
G1 X121.79 Y125.681 E.15892
G1 X121.72 Y125.751
G1 X121.72 Y125.471
G1 X121.79 Y125.401
G1 X135.401 Y111.79 E.15571
G1 X135.471 Y111.72
G1 X135.19 Y111.72
G1 X135.12 Y111.79
G1 X121.79 Y125.12 E.15249
G1 X121.72 Y125.19
G1 X121.72 Y124.909
G1 X121.79 Y124.839
G1 X134.839 Y111.79 E.14928
G1 X134.909 Y111.72
G1 X134.628 Y111.72
G1 X134.558 Y111.79
G1 X121.79 Y124.558 E.14607
G1 X121.72 Y124.628
G1 X121.72 Y124.348
G1 X121.79 Y124.278
G1 X134.278 Y111.79 E.14286
G1 X134.348 Y111.72
G1 X134.067 Y111.72
G1 X133.997 Y111.79
G1 X121.79 Y123.997 E.13965
G1 X121.72 Y124.067
G1 X121.72 Y123.786
G1 X121.79 Y123.716
G1 X133.716 Y111.79 E.13643
G1 X133.786 Y111.72
G1 X133.505 Y111.72
G1 X133.435 Y111.79
G1 X121.79 Y123.435 E.13322
G1 X121.72 Y123.505
G1 X121.72 Y123.224
G1 X121.79 Y123.154
G1 X133.155 Y111.79 E.13001
G1 X133.225 Y111.72
G1 X132.944 Y111.72
G1 X132.874 Y111.79
G1 X121.79 Y122.874 E.1268
G1 X121.72 Y122.944
G1 X121.72 Y122.663
G1 X121.79 Y122.593
G1 X132.593 Y111.79 E.12359
G1 X132.663 Y111.72
G1 X132.382 Y111.72
G1 X132.312 Y111.79
G1 X121.79 Y122.312 E.12037
G1 X121.72 Y122.382
G1 X121.72 Y122.101
G1 X121.79 Y122.031
G1 X132.031 Y111.79 E.11716
G1 X132.101 Y111.72
G1 X131.821 Y111.72
G1 X131.751 Y111.79
G1 X121.79 Y121.751 E.11395
G1 X121.72 Y121.821
G1 X121.72 Y121.54
G1 X121.79 Y121.47
G1 X131.47 Y111.79 E.11074
G1 X131.54 Y111.72
G1 X131.259 Y111.72
G1 X131.189 Y111.79
G1 X121.79 Y121.189 E.10753
G1 X121.72 Y121.259
G1 X121.72 Y120.978
G1 X121.79 Y120.908
G1 X130.908 Y111.79 E.10431
G1 X130.978 Y111.72
G1 X130.698 Y111.72
G1 X130.628 Y111.79
G1 X121.79 Y120.628 E.1011
G1 X121.72 Y120.698
G1 X121.72 Y120.417
G1 X121.79 Y120.347
G1 X130.347 Y111.79 E.09789
G1 X130.417 Y111.72
G1 X130.136 Y111.72
G1 X130.066 Y111.79
G1 X121.79 Y120.066 E.09468
G1 X121.72 Y120.136
G1 X121.72 Y119.855
G1 X121.79 Y119.785
G1 X129.785 Y111.79 E.09147
G1 X129.855 Y111.72
G1 X129.575 Y111.72
G1 X129.505 Y111.79
G1 X121.79 Y119.505 E.08826
G1 X121.72 Y119.575
G1 X121.72 Y119.294
G1 X121.79 Y119.224
G1 X129.224 Y111.79 E.08504
G1 X129.294 Y111.72
G1 X129.013 Y111.72
G1 X128.943 Y111.79
G1 X121.79 Y118.943 E.08183
G1 X121.72 Y119.013
G1 X121.72 Y118.732
G1 X121.79 Y118.662
G1 X128.662 Y111.79 E.07862
G1 X128.732 Y111.72
G1 X128.452 Y111.72
G1 X128.382 Y111.79
G1 X121.79 Y118.382 E.07541
G1 X121.72 Y118.452
G1 X121.72 Y118.171
G1 X121.79 Y118.101
G1 X128.101 Y111.79 E.0722
G1 X128.171 Y111.72
G1 X127.89 Y111.72
G1 X127.82 Y111.79
G1 X121.79 Y117.82 E.06898
G1 X121.72 Y117.89
G1 X121.72 Y117.609
G1 X121.79 Y117.539
G1 X127.539 Y111.79 E.06577
G1 X127.609 Y111.72
G1 X127.328 Y111.72
G1 X127.258 Y111.79
G1 X121.79 Y117.258 E.06256
G1 X121.72 Y117.328
G1 X121.72 Y117.048
G1 X121.79 Y116.978
G1 X126.978 Y111.79 E.05935
G1 X127.048 Y111.72
G1 X126.767 Y111.72
G1 X126.697 Y111.79
G1 X121.79 Y116.697 E.05614
G1 X121.72 Y116.767
G1 X121.72 Y116.486
G1 X121.79 Y116.416
G1 X126.416 Y111.79 E.05292
G1 X126.486 Y111.72
G1 X126.205 Y111.72
G1 X126.135 Y111.79
G1 X121.79 Y116.135 E.04971
G1 X121.72 Y116.205
G1 X121.72 Y115.925
G1 X121.79 Y115.855
G1 X125.855 Y111.79 E.0465
G1 X125.925 Y111.72
G1 X125.644 Y111.72
G1 X125.574 Y111.79
G1 X121.79 Y115.574 E.04329
G1 X121.72 Y115.644
G1 X121.72 Y115.363
G1 X121.79 Y115.293
G1 X125.293 Y111.79 E.04008
G1 X125.363 Y111.72
G1 X125.082 Y111.72
G1 X125.012 Y111.79
G1 X121.79 Y115.012 E.03686
G1 X121.72 Y115.082
G1 X121.72 Y114.802
G1 X121.79 Y114.732
G1 X124.732 Y111.79 E.03365
G1 X124.802 Y111.72
G1 X124.521 Y111.72
G1 X124.451 Y111.79
G1 X121.79 Y114.451 E.03044
G1 X121.72 Y114.521
G1 X121.72 Y114.24
G1 X121.79 Y114.17
G1 X124.17 Y111.79 E.02723
G1 X124.24 Y111.72
G1 X123.959 Y111.72
G1 X123.889 Y111.79
G1 X121.79 Y113.889 E.02402
G1 X121.72 Y113.959
G1 X121.72 Y113.679
G1 X121.79 Y113.609
G1 X123.609 Y111.79 E.0208
G1 X123.679 Y111.72
G1 X123.398 Y111.72
G1 X123.328 Y111.79
G1 X121.79 Y113.328 E.01759
G1 X121.72 Y113.398
G1 X121.72 Y113.117
G1 X121.79 Y113.047
G1 X123.047 Y111.79 E.01438
G1 X123.117 Y111.72
G1 X122.836 Y111.72
G1 X122.766 Y111.79
G1 X121.79 Y112.766 E.01117
G1 X121.72 Y112.836
G1 X121.72 Y112.555
G1 X121.79 Y112.485
G1 X122.485 Y111.79 E.00796
G1 X122.555 Y111.72
G1 X122.275 Y111.72
G1 X122.205 Y111.79
G1 X121.79 Y112.205 E.00475
; WIPE_START
M204 S8000
G1 X122.205 Y111.79 E-.11146
G1 X122.275 Y111.72 E-.01881
G1 X122.555 Y111.72 E-.05334
G1 X122.485 Y111.79 E-.01881
G1 X121.825 Y112.451 E-.17758
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X127.31 Y117.758 Z.8 F60000
G1 X139.329 Y129.386 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.0607586
G1 F3000
M204 S8000
G1 X139.212 Y129.48 E.00024
G1 X139.16 Y129.549 E.00014
M204 S10000
G1 X140.235 Y128.791 F60000
; LINE_WIDTH: 0.100194
G1 F3000
M204 S8000
G1 X140.083 Y128.912 E.00062
; LINE_WIDTH: 0.0635907
G1 X139.932 Y129.033 E.00033
M204 S10000
G1 X140.991 Y128.316 F60000
; LINE_WIDTH: 0.100199
G1 F3000
M204 S8000
G1 X140.839 Y128.437 E.00062
; LINE_WIDTH: 0.0635928
G1 X140.688 Y128.558 E.00033
M204 S10000
G1 X141.747 Y127.841 F60000
; LINE_WIDTH: 0.100192
G1 F3000
M204 S8000
G1 X141.595 Y127.962 E.00062
; LINE_WIDTH: 0.0635811
G1 X141.443 Y128.083 E.00033
M204 S10000
G1 X142.503 Y127.366 F60000
; LINE_WIDTH: 0.100202
G1 F3000
M204 S8000
G1 X142.351 Y127.487 E.00062
; LINE_WIDTH: 0.0636032
G1 X142.199 Y127.608 E.00033
M204 S10000
G1 X143.259 Y126.891 F60000
; LINE_WIDTH: 0.100199
G1 F3000
M204 S8000
G1 X143.107 Y127.012 E.00062
; LINE_WIDTH: 0.0635928
G1 X142.955 Y127.133 E.00033
M204 S10000
G1 X144.014 Y126.416 F60000
; LINE_WIDTH: 0.100194
G1 F3000
M204 S8000
G1 X143.863 Y126.536 E.00062
; LINE_WIDTH: 0.0635907
G1 X143.711 Y126.657 E.00033
M204 S10000
G1 X144.77 Y125.94 F60000
; LINE_WIDTH: 0.100202
G1 F3000
M204 S8000
G1 X144.619 Y126.061 E.00062
; LINE_WIDTH: 0.0636032
G1 X144.467 Y126.182 E.00033
M204 S10000
G1 X145.526 Y125.465 F60000
; LINE_WIDTH: 0.100194
G1 F3000
M204 S8000
G1 X145.375 Y125.586 E.00062
; LINE_WIDTH: 0.0635912
G1 X145.223 Y125.707 E.00033
M204 S10000
G1 X146.282 Y124.99 F60000
; LINE_WIDTH: 0.100202
G1 F3000
M204 S8000
G1 X146.131 Y125.111 E.00062
; LINE_WIDTH: 0.0636032
G1 X145.979 Y125.232 E.00033
M204 S10000
G1 X147.038 Y124.515 F60000
; LINE_WIDTH: 0.100199
G1 F3000
M204 S8000
G1 X146.886 Y124.636 E.00062
; LINE_WIDTH: 0.0635928
G1 X146.735 Y124.757 E.00033
M204 S10000
G1 X147.794 Y124.04 F60000
; LINE_WIDTH: 0.100194
G1 F3000
M204 S8000
G1 X147.642 Y124.161 E.00062
; LINE_WIDTH: 0.0635907
G1 X147.491 Y124.282 E.00033
M204 S10000
G1 X148.55 Y123.565 F60000
; LINE_WIDTH: 0.100202
G1 F3000
M204 S8000
G1 X148.398 Y123.686 E.00062
; LINE_WIDTH: 0.0636032
G1 X148.247 Y123.807 E.00033
M204 S10000
G1 X149.306 Y123.09 F60000
; LINE_WIDTH: 0.100194
G1 F3000
M204 S8000
M73 P82 R3
G1 X149.154 Y123.211 E.00062
; LINE_WIDTH: 0.0635912
G1 X149.002 Y123.331 E.00033
M204 S10000
G1 X150.062 Y122.614 F60000
; LINE_WIDTH: 0.100202
G1 F3000
M204 S8000
G1 X149.91 Y122.735 E.00062
; LINE_WIDTH: 0.0636032
G1 X149.758 Y122.856 E.00033
M204 S10000
G1 X150.818 Y122.139 F60000
; LINE_WIDTH: 0.100199
G1 F3000
M204 S8000
G1 X150.666 Y122.26 E.00062
; LINE_WIDTH: 0.0635928
G1 X150.514 Y122.381 E.00033
M204 S10000
G1 X151.573 Y121.664 F60000
; LINE_WIDTH: 0.100194
G1 F3000
M204 S8000
G1 X151.422 Y121.785 E.00062
; LINE_WIDTH: 0.0635907
G1 X151.27 Y121.906 E.00033
M204 S10000
G1 X152.22 Y121.276 F60000
; LINE_WIDTH: 0.0669073
G1 F3000
M204 S8000
G1 X152.026 Y121.431 E.00046
; WIPE_START
G1 X152.22 Y121.276 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X151.963 Y128.904 Z.8 F60000
G1 X151.953 Y129.21 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.22
G1 F6044.128
M204 S2000
G1 X152.21 Y128.953 E.00294
G1 X152.28 Y128.883
G1 X152.28 Y128.602
G1 X152.21 Y128.672
G1 X151.672 Y129.21 E.00615
G1 X151.602 Y129.28
G1 X151.321 Y129.28
G1 X151.391 Y129.21
G1 X152.21 Y128.391 E.00937
G1 X152.28 Y128.321
G1 X152.28 Y128.041
G1 X152.21 Y128.111
G1 X151.111 Y129.21 E.01258
G1 X151.041 Y129.28
G1 X150.76 Y129.28
G1 X150.83 Y129.21
G1 X152.21 Y127.83 E.01579
G1 X152.28 Y127.76
G1 X152.28 Y127.479
G1 X152.21 Y127.549
G1 X150.549 Y129.21 E.019
G1 X150.479 Y129.28
G1 X150.198 Y129.28
G1 X150.268 Y129.21
G1 X152.21 Y127.268 E.02221
G1 X152.28 Y127.198
G1 X152.28 Y126.918
G1 X152.21 Y126.988
G1 X149.988 Y129.21 E.02543
G1 X149.918 Y129.28
G1 X149.637 Y129.28
G1 X149.707 Y129.21
G1 X152.21 Y126.707 E.02864
G1 X152.28 Y126.637
G1 X152.28 Y126.356
G1 X152.21 Y126.426
G1 X149.426 Y129.21 E.03185
G1 X149.356 Y129.28
G1 X149.075 Y129.28
G1 X149.145 Y129.21
G1 X152.21 Y126.145 E.03506
G1 X152.28 Y126.075
G1 X152.28 Y125.794
G1 X152.21 Y125.864
G1 X148.864 Y129.21 E.03827
G1 X148.794 Y129.28
G1 X148.514 Y129.28
G1 X148.584 Y129.21
G1 X152.21 Y125.584 E.04149
G1 X152.28 Y125.514
G1 X152.28 Y125.233
G1 X152.21 Y125.303
G1 X148.303 Y129.21 E.0447
G1 X148.233 Y129.28
G1 X147.952 Y129.28
G1 X148.022 Y129.21
G1 X152.21 Y125.022 E.04791
G1 X152.28 Y124.952
G1 X152.28 Y124.671
G1 X152.21 Y124.741
G1 X147.741 Y129.21 E.05112
G1 X147.671 Y129.28
G1 X147.391 Y129.28
G1 X147.461 Y129.21
G1 X152.21 Y124.461 E.05433
G1 X152.28 Y124.391
G1 X152.28 Y124.11
G1 X152.21 Y124.18
G1 X147.18 Y129.21 E.05755
G1 X147.11 Y129.28
G1 X146.829 Y129.28
G1 X146.899 Y129.21
G1 X152.21 Y123.899 E.06076
G1 X152.28 Y123.829
G1 X152.28 Y123.548
G1 X152.21 Y123.618
G1 X146.618 Y129.21 E.06397
G1 X146.548 Y129.28
G1 X146.268 Y129.28
G1 X146.338 Y129.21
G1 X152.21 Y123.338 E.06718
G1 X152.28 Y123.268
G1 X152.28 Y122.987
G1 X152.21 Y123.057
G1 X146.057 Y129.21 E.07039
G1 X145.987 Y129.28
G1 X145.706 Y129.28
G1 X145.776 Y129.21
G1 X152.21 Y122.776 E.0736
G1 X152.28 Y122.706
G1 X151.944 Y122.762
G1 X151.874 Y122.832
G1 X145.495 Y129.21 E.07297
G1 X145.425 Y129.28
G1 X145.145 Y129.28
G1 X145.215 Y129.21
G1 X151.031 Y123.393 E.06654
M204 S10000
G1 X150.189 Y123.955 F60000
G1 F6044.128
M204 S2000
G1 X144.934 Y129.21 E.06012
G1 X144.864 Y129.28
M73 P82 R2
G1 X144.583 Y129.28
G1 X144.653 Y129.21
G1 X149.347 Y124.516 E.0537
M204 S10000
G1 X148.504 Y125.078 F60000
G1 F6044.128
M204 S2000
G1 X144.372 Y129.21 E.04727
G1 X144.302 Y129.28
G1 X144.021 Y129.28
G1 X144.091 Y129.21
G1 X147.662 Y125.639 E.04085
M204 S10000
G1 X146.82 Y126.201 F60000
G1 F6044.128
M204 S2000
G1 X143.811 Y129.21 E.03442
G1 X143.741 Y129.28
G1 X143.46 Y129.28
G1 X143.53 Y129.21
G1 X145.977 Y126.763 E.028
M204 S10000
G1 X145.135 Y127.324 F60000
G1 F6044.128
M204 S2000
G1 X143.371 Y129.089 E.02019
G1 X143.301 Y129.159
G1 X143.235 Y128.943
G1 X143.305 Y128.873
G1 X144.293 Y127.886 E.0113
M204 S10000
G1 X151.403 Y123.146 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.0639377
G1 F3000
M204 S8000
G1 X151.233 Y123.286 E.00038
; LINE_WIDTH: 0.101262
G1 X151.063 Y123.425 E.00072
M204 S10000
G1 X150.561 Y123.708 F60000
; LINE_WIDTH: 0.0639406
G1 F3000
M204 S8000
G1 X150.391 Y123.847 E.00038
; LINE_WIDTH: 0.10127
G1 X150.221 Y123.987 E.00072
M204 S10000
G1 X149.719 Y124.269 F60000
; LINE_WIDTH: 0.0639408
G1 F3000
M204 S8000
G1 X149.549 Y124.409 E.00038
; LINE_WIDTH: 0.10127
G1 X149.379 Y124.548 E.00072
M204 S10000
G1 X148.877 Y124.831 F60000
; LINE_WIDTH: 0.0639404
G1 F3000
M204 S8000
G1 X148.706 Y124.97 E.00038
; LINE_WIDTH: 0.101269
G1 X148.536 Y125.11 E.00072
M204 S10000
G1 X148.034 Y125.392 F60000
; LINE_WIDTH: 0.0639408
G1 F3000
M204 S8000
G1 X147.864 Y125.532 E.00038
; LINE_WIDTH: 0.10127
G1 X147.694 Y125.671 E.00072
M204 S10000
G1 X147.192 Y125.954 F60000
; LINE_WIDTH: 0.0639408
G1 F3000
M204 S8000
G1 X147.022 Y126.093 E.00038
; LINE_WIDTH: 0.10127
G1 X146.852 Y126.233 E.00072
M204 S10000
G1 X146.35 Y126.515 F60000
; LINE_WIDTH: 0.0639409
G1 F3000
M204 S8000
G1 X146.18 Y126.655 E.00038
; LINE_WIDTH: 0.101271
G1 X146.009 Y126.794 E.00072
M204 S10000
G1 X145.507 Y127.077 F60000
; LINE_WIDTH: 0.0639384
G1 F3000
M204 S8000
G1 X145.337 Y127.216 E.00038
; LINE_WIDTH: 0.101263
G1 X145.167 Y127.356 E.00072
M204 S10000
G1 X144.665 Y127.638 F60000
; LINE_WIDTH: 0.0639408
G1 F3000
M204 S8000
G1 X144.495 Y127.778 E.00038
; LINE_WIDTH: 0.10127
G1 X144.325 Y127.917 E.00072
M204 S10000
G1 X143.823 Y128.2 F60000
; LINE_WIDTH: 0.0670364
G1 F3000
M204 S8000
G1 X143.627 Y128.36 E.00047
; LINE_WIDTH: 0.110558
G1 X143.432 Y128.52 E.00092
; LINE_WIDTH: 0.154079
G1 X143.237 Y128.68 E.00137
; CHANGE_LAYER
; Z_HEIGHT: 0.5
; LAYER_HEIGHT: 0.1
; WIPE_START
G1 F3000
G1 X143.432 Y128.52 E-.38
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 5887
M625
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 5/7
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change

M106 S188.7
; OBJECT_ID: 5909
; COOLING_NODE: 0
; start printing object, unique label id: 5909
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z.8 I-.124 J1.211 P1  F60000
G1 X164.619 Y130.699 Z.8
G1 Z.5
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.21999
G1 F6044.427
M204 S8000
G1 X164.671 Y130.699 E.00042
G1 X164.308 Y131.054 E.00411
G1 X164.294 Y131.294 E.00194
G1 X162.692 Y131.294 E.01296
G1 X162.292 Y131.294 E.00324
G1 F5151.471
G1 X162.205 Y131.207 E.001
; LINE_WIDTH: 0.267315
G1 F4880.926
G1 X161.941 Y130.91 E.00399
; LINE_WIDTH: 0.31464
G1 F4093.049
G1 X161.677 Y130.612 E.00475
G1 X161.89 Y130.655 E.0026
; LINE_WIDTH: 0.267315
G1 F4535.63
G1 X162.103 Y130.699 E.00218
; LINE_WIDTH: 0.21999
G1 F5408.699
G1 X162.503 Y130.699 E.00324
G1 F6044.427
G1 X162.903 Y130.699 E.00324
G1 X164.619 Y130.699 E.01389
; COOLING_NODE: 0
; WIPE_START
G1 X164.671 Y130.699 E-.00975
G1 X164.308 Y131.054 E-.09655
G1 X164.294 Y131.294 E-.04566
G1 X163.094 Y131.294 E-.22805
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X170.685 Y130.499 Z.9 F60000
G1 X182.484 Y129.264 Z.9
G1 Z.5
G1 E.4 F1800
G1 F6044.427
M204 S8000
G1 X182.427 Y129.127 E.0012
G1 X182.422 Y128.741 E.00312
G1 X182.626 Y128.41 E.00314
G1 F5248
G1 X182.985 Y128.162 E.00353
; LINE_WIDTH: 0.266815
G1 F4313.496
G1 X183.055 Y128.087 E.00103
; LINE_WIDTH: 0.31364
G1 F4107.057
G1 X183.126 Y128.012 E.00122
G1 X184.797 Y126.914 E.02381
; LINE_WIDTH: 0.2868
G1 F4522.499
G1 X186.469 Y125.816 E.02162
; LINE_WIDTH: 0.25996
G1 F5031.447
G1 X188.14 Y124.717 E.01943
; LINE_WIDTH: 0.23312
G1 F5669.47
G1 X188.474 Y124.498 E.00345
G1 X189.812 Y123.619 E.0138
; LINE_WIDTH: 0.20628
G1 F6492.804
G1 X190.146 Y123.4 E.00301
G1 X191.483 Y122.521 E.01205
; LINE_WIDTH: 0.17944
G1 F6725.054
G1 X191.637 Y122.42 E.00119
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X192.329 Y122.362 E.00562
G1 X192.468 Y122.457 E.00136
G1 X192.706 Y122.98 E.00465
G1 X192.706 Y129.011 E.04878
G1 X192.695 Y129.131 E.00097
G1 X192.54 Y129.461 E.00295
G1 X192.131 Y129.695 E.00382
G1 X192.011 Y129.706 E.00097
G1 X183.118 Y129.706 E.07194
G1 X182.769 Y129.612 E.00292
G1 X182.538 Y129.394 E.00257
G1 X182.484 Y129.264 E.00114
; COOLING_NODE: 0
; WIPE_START
G1 X182.427 Y129.127 E-.02814
G1 X182.422 Y128.741 E-.07335
G1 X182.626 Y128.41 E-.07386
G1 X182.985 Y128.162 E-.08298
G1 X183.055 Y128.087 E-.01951
G1 X183.126 Y128.012 E-.01951
G1 X183.489 Y127.773 E-.08265
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X175.99 Y129.195 Z.9 F60000
G1 X168.06 Y130.699 Z.9
G1 Z.5
G1 E.4 F1800
G1 F6044.427
M204 S8000
G1 X179.017 Y130.689 E.08863
G1 X179.41 Y130.472 E.00364
G1 X179.522 Y130.35 E.00134
G1 X179.676 Y130.071 E.00257
G1 X179.704 Y129.762 E.00251
G1 X182.095 Y128.259 E.02284
G1 X182.434 Y128.046 E.00324
G1 F5165.867
G1 X182.773 Y127.834 E.00324
; LINE_WIDTH: 0.266815
G1 F4313.494
G1 X182.87 Y127.8 E.00103
; LINE_WIDTH: 0.31364
G1 F4107.057
G1 X182.967 Y127.767 E.00122
G1 X184.653 Y126.691 E.02381
; LINE_WIDTH: 0.2868
G1 F4522.499
G1 X186.339 Y125.615 E.02162
; LINE_WIDTH: 0.25996
G1 F5031.447
G1 X188.025 Y124.54 E.01943
; LINE_WIDTH: 0.23312
G1 F5669.47
G1 X188.362 Y124.325 E.00345
G1 X189.711 Y123.464 E.0138
; LINE_WIDTH: 0.20628
G1 F6492.804
G1 X190.048 Y123.249 E.00301
G1 X191.397 Y122.388 E.01205
; LINE_WIDTH: 0.17944
G1 F6961.406
G1 X191.553 Y122.289 E.00119
; LINE_WIDTH: 0.17697
G1 F6987.478
G1 X191.57 Y122.278 E.00013
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X192.307 Y121.84 E.00694
G1 X192.488 Y121.676 E.00198
G1 X192.688 Y121.286 E.00355
G1 X192.676 Y120.751 E.00432
G1 X192.463 Y120.289 E.00412
G1 X192.306 Y120.159 E.00164
G1 X179.704 Y112.238 E.1204
G1 X179.676 Y111.928 E.00251
G1 X179.522 Y111.65 E.00257
G1 X179.41 Y111.528 E.00134
G1 X178.897 Y111.301 E.00454
G1 X162.148 Y111.294 E.13548
G1 X161.882 Y111.347 E.0022
G1 X161.544 Y111.544 E.00316
G1 X161.394 Y111.77 E.00219
G1 X161.294 Y112.148 E.00316
G1 X161.294 Y129.586 E.14105
G1 X161.324 Y130.053 E.00379
; LINE_WIDTH: 0.253815
G1 F4976.445
G1 X161.413 Y130.254 E.00208
; LINE_WIDTH: 0.28764
G1 F4508.228
G1 X161.501 Y130.455 E.00238
G1 X161.36 Y130.338 E.00199
; LINE_WIDTH: 0.253815
G1 F4897.942
G1 X161.218 Y130.221 E.00174
; LINE_WIDTH: 0.21999
G1 F5803.708
G1 X160.936 Y129.938 E.00324
G1 F6044.427
G1 X160.706 Y129.708 E.00263
G1 X160.706 Y110.706 E.15371
G1 X193.294 Y110.706 E.26361
G1 X193.294 Y114.291 E.029
G1 X193.294 Y131.294 E.13754
G1 X168.506 Y131.294 E.20051
G1 X168.492 Y131.054 E.00194
G1 X168.06 Y130.699 E.00453
; COOLING_NODE: 0
; WIPE_START
G1 X170.06 Y130.697 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X165.94 Y130.758 Z.9 F60000
G1 Z.5
G1 E.4 F1800
G1 F6044.427
M204 S8000
G1 X165.811 Y130.694 E.00116
; LINE_WIDTH: 0.22141
G1 F6001.5
G1 X164.903 Y130.7 E.00739
G1 X164.502 Y131.093 E.00458
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X164.493 Y131.493 E.00324
G1 X162.21 Y131.493 E.01847
G1 X160.507 Y129.79 E.01948
G1 X160.507 Y110.507 E.15598
G1 X193.493 Y110.507 E.26682
G1 X193.493 Y114.291 E.03061
G1 X193.493 Y131.493 E.13914
G1 X168.307 Y131.493 E.20372
G1 X168.298 Y131.093 E.00324
G1 X167.811 Y130.694 E.00509
; LINE_WIDTH: 0.2214
G1 F6001.801
G1 X166.903 Y130.7 E.00739
G1 X166.594 Y130.89 E.00296
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X166.525 Y131.014 E.00114
G1 X166.496 Y131.496 E.00391
; LINE_WIDTH: 0.21367
G1 F6243.172
G1 X166.304 Y131.496 E.00151
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X166.275 Y131.014 E.00391
G1 X166.206 Y130.89 E.00114
G1 X165.94 Y130.758 E.0024
; COOLING_NODE: 0
M204 S10000
G1 X165.876 Y130.924 F60000
G1 F6044.427
M204 S8000
G1 X165.811 Y130.891 E.00059
G1 X164.938 Y130.896 E.00706
G1 X164.697 Y131.131 E.00272
G1 X164.691 Y131.691 E.00453
G1 X162.128 Y131.691 E.02074
G1 X160.309 Y129.872 E.02081
G1 X160.309 Y110.309 E.15825
G1 X193.691 Y110.309 E.27003
G1 X193.691 Y114.291 E.03222
G1 X193.691 Y131.691 E.14075
; object ids of layer 5 start: 5887,5909
M624 AwAAAAAAAAA=
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

; object ids of this layer5 end: 5887,5909
M625
G1 X168.109 Y131.691 E.20694
G1 X168.103 Y131.131 E.00453
G1 X167.811 Y130.891 E.00306
G1 X166.989 Y130.891 E.00664
G1 X166.752 Y131.01 E.00215
G1 X166.691 Y131.189 E.00153
G1 X166.691 Y131.691 E.00406
G1 X166.109 Y131.691 E.00472
G1 X166.109 Y131.189 E.00406
G1 X166.048 Y131.01 E.00153
G1 X165.876 Y130.924 E.00156
; COOLING_NODE: 0
M204 S250
G1 X165.811 Y131.09 F60000
; FEATURE: Outer wall
G1 F6044.427
M204 S5000
G1 X164.989 Y131.09 E.00664
G1 X164.89 Y131.189 E.00114
G1 X164.89 Y131.89 E.00567
G1 X162.046 Y131.89 E.02301
G1 X160.11 Y129.954 E.02214
G1 X160.11 Y110.11 E.16052
G1 X193.89 Y110.11 E.27324
G1 X193.89 Y114.291 E.03382
G1 X193.89 Y131.89 E.14235
G1 X167.91 Y131.89 E.21015
G1 X167.91 Y131.189 E.00567
G1 X167.811 Y131.09 E.00114
M73 P83 R2
G1 X166.989 Y131.09 E.00664
G1 X166.91 Y131.129 E.00071
G1 X166.89 Y131.189 E.00051
G1 X166.89 Y131.89 E.00567
G1 X165.91 Y131.89 E.00793
G1 X165.904 Y131.154 E.00595
G1 X165.811 Y131.09 E.00091
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X164.989 Y131.09 E-.15608
G1 X164.89 Y131.189 E-.02667
G1 X164.89 Y131.89 E-.13314
G1 X164.553 Y131.89 E-.06411
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X172.101 Y130.762 Z.9 F60000
G1 X182.663 Y129.185 Z.9
G1 Z.5
G1 E.4 F1800
; FEATURE: Inner wall
G1 F6044.427
M204 S8000
G1 X182.617 Y129.07 E.001
G1 X182.613 Y128.794 E.00223
G1 X182.817 Y128.513 E.00281
G1 X183.095 Y128.327 E.00271
G1 X191.735 Y122.567 E.084
G1 X192.238 Y122.539 E.00407
G1 X192.337 Y122.606 E.00097
G1 X192.507 Y122.98 E.00332
G1 X192.507 Y129.011 E.04878
G1 X192.389 Y129.332 E.00277
G1 X192.096 Y129.5 E.00273
G1 X192.011 Y129.507 E.0007
G1 X183.118 Y129.507 E.07194
G1 X182.869 Y129.44 E.00208
G1 X182.704 Y129.285 E.00184
G1 X182.663 Y129.185 E.00087
; COOLING_NODE: 0
M204 S10000
G1 X182.878 Y129.154 F60000
G1 F6044.427
M204 S8000
G1 X182.833 Y129.097 E.00059
G1 X182.805 Y128.847 E.00204
G1 X182.927 Y128.678 E.00168
G1 X183.205 Y128.492 E.00271
G1 X191.846 Y122.732 E.084
G1 X192.147 Y122.715 E.00244
G1 X192.207 Y122.756 E.00058
G1 X192.309 Y122.98 E.00199
G1 X192.309 Y129.011 E.04878
G1 X192.238 Y129.204 E.00166
G1 X192.062 Y129.304 E.00164
G1 X192.011 Y129.309 E.00042
G1 X183.118 Y129.309 E.07194
G1 X182.968 Y129.268 E.00125
G1 X182.878 Y129.154 E.00118
; COOLING_NODE: 1
M204 S250
G1 X183.023 Y129.039 F60000
; FEATURE: Outer wall
G1 F6044.427
M204 S5000
G1 X182.996 Y128.9 E.00115
G1 X183.316 Y128.657 E.00324
G1 X191.958 Y122.896 E.08402
G1 X192.076 Y122.905 E.00096
G1 X192.11 Y122.98 E.00066
G1 X192.11 Y129.011 E.04878
G1 X192.04 Y129.105 E.00095
G1 X183.118 Y129.11 E.07218
G1 X183.023 Y129.039 E.00096
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X182.996 Y128.9 E-.02707
G1 X183.316 Y128.657 E-.07614
G1 X184.528 Y127.849 E-.27679
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X182.176 Y120.588 Z.9 F60000
G1 X179.507 Y112.348 Z.9
G1 Z.5
G1 E.4 F1800
; FEATURE: Inner wall
G1 F6044.427
M204 S8000
G1 X192.201 Y120.327 E.12128
G1 X192.325 Y120.433 E.00132
G1 X192.478 Y120.763 E.00294
G1 X192.493 Y121.251 E.00395
G1 X192.33 Y121.555 E.00278
G1 X192.201 Y121.672 E.00141
G1 X179.507 Y129.652 E.12128
G1 X179.485 Y130.017 E.00296
G1 X179.264 Y130.338 E.00316
G1 X178.982 Y130.493 E.0026
G1 X167.811 Y130.499 E.09036
; LINE_WIDTH: 0.21691
G1 F6139.678
G1 X166.989 Y130.499 E.00654
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X165.811 Y130.499 E.00953
; LINE_WIDTH: 0.21691
G1 F6139.678
G1 X164.989 Y130.499 E.00654
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X162.103 Y130.501 E.02335
G1 X161.807 Y130.403 E.00252
G1 X161.665 Y130.291 E.00146
G1 X161.514 Y129.995 E.00268
G1 X161.493 Y129.586 E.00332
G1 X161.493 Y112.148 E.14105
G1 X161.577 Y111.846 E.00254
G1 X161.685 Y111.685 E.00157
G1 X161.958 Y111.531 E.00254
G1 X162.148 Y111.493 E.00157
G1 X178.897 Y111.499 E.13548
G1 X179.264 Y111.662 E.00324
G1 X179.485 Y111.983 E.00315
G1 X179.507 Y112.348 E.00296
; COOLING_NODE: 1
M204 S10000
G1 X179.31 Y112.459 F60000
G1 F6044.427
M204 S8000
G1 X192.095 Y120.495 E.12215
G1 X192.188 Y120.576 E.001
G1 X192.28 Y120.774 E.00176
G1 X192.297 Y121.217 E.00359
G1 X192.151 Y121.459 E.00229
G1 X179.31 Y129.541 E.12274
G1 X179.294 Y129.963 E.00342
G1 X179.117 Y130.205 E.00242
G1 X178.897 Y130.302 E.00195
G1 X166.989 Y130.302 E.09632
G1 X162.103 Y130.302 E.03953
G1 X161.839 Y130.179 E.00236
G1 X161.731 Y130.026 E.00151
G1 X161.691 Y129.852 E.00145
G1 X161.691 Y112.148 E.1432
G1 X161.761 Y111.922 E.00191
G1 X161.922 Y111.761 E.00184
G1 X162.148 Y111.691 E.00191
G1 X178.897 Y111.698 E.13548
G1 X179.117 Y111.795 E.00195
G1 X179.294 Y112.037 E.00242
G1 X179.31 Y112.459 E.00342
; COOLING_NODE: 2
M204 S250
G1 X179.112 Y112.569 F60000
; FEATURE: Outer wall
G1 F6044.427
M204 S5000
G1 X191.989 Y120.663 E.12303
G1 X192.081 Y120.785 E.00124
G1 X192.083 Y121.226 E.00356
G1 X191.99 Y121.336 E.00116
G1 X179.112 Y129.431 E.12303
G1 X179.081 Y129.949 E.0042
G1 X178.897 Y130.104 E.00195
G1 X166.989 Y130.104 E.09632
G1 X162.103 Y130.103 E.03953
G1 X161.946 Y130.01 E.00148
G1 X161.89 Y129.852 E.00136
G1 X161.89 Y112.148 E.1432
G1 X161.966 Y111.966 E.0016
G1 X162.148 Y111.89 E.0016
G1 X178.897 Y111.896 E.13548
G1 X179.081 Y112.051 E.00195
G1 X179.112 Y112.569 E.0042
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X180.806 Y113.634 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X175.888 Y119.471 Z.9 F60000
G1 X166.418 Y130.712 Z.9
G1 Z.5
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.30832
G1 F4183.226
M204 S8000
G1 X166.364 Y130.743 E.00073
G1 X166.418 Y130.774 E.00073
G1 X166.436 Y130.743 E.00042
; COOLING_NODE: 2
; WIPE_START
G1 X166.418 Y130.774 E-.08514
G1 X166.364 Y130.743 E-.14743
G1 X166.418 Y130.712 E-.14743
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X161.677 Y130.612 Z.9 F60000
G1 Z.5
G1 E.4 F1800
; LINE_WIDTH: 0.31464
G1 F4093.049
M204 S8000
G1 X161.501 Y130.455 E.00281
M204 S10000
G1 X161.209 Y129.986 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.22002
G1 F6043.513
M204 S8000
G1 X160.864 Y129.642 E.00394
G1 X160.864 Y129.361 E.00227
G1 X161.136 Y129.632 E.00311
G1 X161.136 Y129.351 E.00227
G1 X160.864 Y129.08 E.00311
G1 X160.864 Y128.799 E.00227
G1 X161.136 Y129.071 E.00311
G1 X161.136 Y128.79 E.00227
G1 X160.864 Y128.518 E.00311
G1 X160.864 Y128.238 E.00227
G1 X161.136 Y128.509 E.00311
G1 X161.136 Y128.228 E.00227
G1 X160.864 Y127.957 E.00311
G1 X160.864 Y127.676 E.00227
G1 X161.136 Y127.947 E.00311
G1 X161.136 Y127.667 E.00227
G1 X160.864 Y127.395 E.00311
G1 X160.864 Y127.114 E.00227
G1 X161.136 Y127.386 E.00311
G1 X161.136 Y127.105 E.00227
G1 X160.864 Y126.833 E.00311
G1 X160.864 Y126.553 E.00227
G1 X161.136 Y126.824 E.00311
G1 X161.136 Y126.543 E.00227
G1 X160.864 Y126.272 E.00311
G1 X160.864 Y125.991 E.00227
G1 X161.136 Y126.262 E.00311
G1 X161.136 Y125.982 E.00227
G1 X160.864 Y125.71 E.00311
G1 X160.864 Y125.429 E.00227
G1 X161.136 Y125.701 E.00311
G1 X161.136 Y125.42 E.00227
G1 X160.864 Y125.149 E.00311
G1 X160.864 Y124.868 E.00227
G1 X161.136 Y125.139 E.00311
G1 X161.136 Y124.858 E.00227
G1 X160.864 Y124.587 E.00311
G1 X160.864 Y124.306 E.00227
G1 X161.136 Y124.578 E.00311
G1 X161.136 Y124.297 E.00227
G1 X160.864 Y124.025 E.00311
G1 X160.864 Y123.745 E.00227
G1 X161.136 Y124.016 E.00311
G1 X161.136 Y123.735 E.00227
G1 X160.864 Y123.464 E.00311
G1 X160.864 Y123.183 E.00227
G1 X161.136 Y123.454 E.00311
G1 X161.136 Y123.174 E.00227
G1 X160.864 Y122.902 E.00311
G1 X160.864 Y122.621 E.00227
G1 X161.136 Y122.893 E.00311
G1 X161.136 Y122.612 E.00227
G1 X160.864 Y122.341 E.00311
G1 X160.864 Y122.06 E.00227
G1 X161.136 Y122.331 E.00311
G1 X161.136 Y122.05 E.00227
G1 X160.864 Y121.779 E.00311
G1 X160.864 Y121.498 E.00227
G1 X161.136 Y121.77 E.00311
G1 X161.136 Y121.489 E.00227
G1 X160.864 Y121.217 E.00311
G1 X160.864 Y120.937 E.00227
G1 X161.136 Y121.208 E.00311
G1 X161.136 Y120.927 E.00227
G1 X160.864 Y120.656 E.00311
G1 X160.864 Y120.375 E.00227
G1 X161.136 Y120.646 E.00311
G1 X161.136 Y120.366 E.00227
G1 X160.864 Y120.094 E.00311
G1 X160.864 Y119.813 E.00227
G1 X161.136 Y120.085 E.00311
G1 X161.136 Y119.804 E.00227
G1 X160.864 Y119.533 E.00311
G1 X160.864 Y119.252 E.00227
G1 X161.136 Y119.523 E.00311
G1 X161.136 Y119.242 E.00227
G1 X160.864 Y118.971 E.00311
G1 X160.864 Y118.69 E.00227
G1 X161.136 Y118.962 E.00311
G1 X161.136 Y118.681 E.00227
G1 X160.864 Y118.409 E.00311
G1 X160.864 Y118.128 E.00227
G1 X161.136 Y118.4 E.00311
G1 X161.136 Y118.119 E.00227
G1 X160.864 Y117.848 E.00311
G1 X160.864 Y117.567 E.00227
G1 X161.136 Y117.838 E.00311
G1 X161.136 Y117.557 E.00227
G1 X160.864 Y117.286 E.00311
G1 X160.864 Y117.005 E.00227
G1 X161.136 Y117.277 E.00311
G1 X161.136 Y116.996 E.00227
G1 X160.864 Y116.724 E.00311
G1 X160.864 Y116.444 E.00227
G1 X161.136 Y116.715 E.00311
G1 X161.136 Y116.434 E.00227
G1 X160.864 Y116.163 E.00311
G1 X160.864 Y115.882 E.00227
G1 X161.136 Y116.153 E.00311
G1 X161.136 Y115.873 E.00227
G1 X160.864 Y115.601 E.00311
G1 X160.864 Y115.32 E.00227
G1 X161.136 Y115.592 E.00311
G1 X161.136 Y115.311 E.00227
G1 X160.864 Y115.04 E.00311
G1 X160.864 Y114.759 E.00227
G1 X161.136 Y115.03 E.00311
G1 X161.136 Y114.749 E.00227
G1 X160.864 Y114.478 E.00311
G1 X160.864 Y114.197 E.00227
G1 X161.136 Y114.469 E.00311
G1 X161.136 Y114.188 E.00227
G1 X160.864 Y113.916 E.00311
G1 X160.864 Y113.636 E.00227
G1 X161.136 Y113.907 E.00311
G1 X161.136 Y113.626 E.00227
G1 X160.864 Y113.355 E.00311
G1 X160.864 Y113.074 E.00227
G1 X161.136 Y113.345 E.00311
G1 X161.136 Y113.065 E.00227
G1 X160.864 Y112.793 E.00311
G1 X160.864 Y112.512 E.00227
G1 X161.136 Y112.784 E.00311
G1 X161.136 Y112.503 E.00227
G1 X160.864 Y112.232 E.00311
G1 X160.864 Y111.951 E.00227
G1 X161.136 Y112.222 E.00311
G1 X161.169 Y111.975 E.00202
G1 X160.864 Y111.67 E.00349
G1 X160.864 Y111.389 E.00227
G1 X161.229 Y111.754 E.00417
G1 X161.334 Y111.578 E.00166
G1 X160.864 Y111.108 E.00537
G1 X160.864 Y110.864 E.00197
G1 X160.901 Y110.864 E.0003
G1 X161.453 Y111.417 E.00632
G1 X161.622 Y111.304 E.00164
G1 X161.182 Y110.864 E.00503
G1 X161.463 Y110.864 E.00227
G1 X161.806 Y111.207 E.00392
G1 X162.025 Y111.146 E.00185
G1 X161.743 Y110.864 E.00322
G1 X162.024 Y110.864 E.00227
G1 X162.296 Y111.136 E.00311
G1 X162.577 Y111.136 E.00227
G1 X162.305 Y110.864 E.00311
G1 X162.586 Y110.864 E.00227
G1 X162.858 Y111.136 E.00311
G1 X163.138 Y111.136 E.00227
G1 X162.867 Y110.864 E.00311
G1 X163.147 Y110.864 E.00227
G1 X163.419 Y111.136 E.00311
G1 X163.7 Y111.136 E.00227
G1 X163.428 Y110.864 E.00311
G1 X163.709 Y110.864 E.00227
G1 X163.981 Y111.136 E.00311
G1 X164.262 Y111.137 E.00227
G1 X163.99 Y110.864 E.00311
G1 X164.271 Y110.864 E.00227
G1 X164.543 Y111.137 E.00312
G1 X164.824 Y111.137 E.00227
G1 X164.552 Y110.864 E.00312
G1 X164.832 Y110.864 E.00227
G1 X165.105 Y111.137 E.00312
G1 X165.386 Y111.137 E.00227
G1 X165.113 Y110.864 E.00312
G1 X165.394 Y110.864 E.00227
G1 X165.667 Y111.137 E.00312
G1 X165.948 Y111.137 E.00227
G1 X165.675 Y110.864 E.00312
G1 X165.956 Y110.864 E.00227
G1 X166.229 Y111.137 E.00312
G1 X166.509 Y111.137 E.00227
G1 X166.236 Y110.864 E.00312
G1 X166.517 Y110.864 E.00227
G1 X166.79 Y111.137 E.00313
G1 X167.071 Y111.138 E.00227
G1 X166.798 Y110.864 E.00313
G1 X167.079 Y110.864 E.00227
G1 X167.352 Y111.138 E.00313
G1 X167.633 Y111.138 E.00227
G1 X167.36 Y110.864 E.00313
G1 X167.64 Y110.864 E.00227
G1 X167.914 Y111.138 E.00313
G1 X168.195 Y111.138 E.00227
G1 X167.921 Y110.864 E.00313
G1 X168.202 Y110.864 E.00227
G1 X168.476 Y111.138 E.00313
G1 X168.757 Y111.138 E.00227
G1 X168.483 Y110.864 E.00313
G1 X168.764 Y110.864 E.00227
G1 X169.038 Y111.138 E.00314
G1 X169.319 Y111.138 E.00227
G1 X169.044 Y110.864 E.00314
G1 X169.325 Y110.864 E.00227
G1 X169.6 Y111.139 E.00314
G1 X169.88 Y111.139 E.00227
G1 X169.606 Y110.864 E.00314
G1 X169.887 Y110.864 E.00227
G1 X170.161 Y111.139 E.00314
G1 X170.442 Y111.139 E.00227
G1 X170.168 Y110.864 E.00314
G1 X170.448 Y110.864 E.00227
G1 X170.723 Y111.139 E.00314
G1 X171.004 Y111.139 E.00227
G1 X170.729 Y110.864 E.00314
G1 X171.01 Y110.864 E.00227
G1 X171.285 Y111.139 E.00315
G1 X171.566 Y111.139 E.00227
G1 X171.291 Y110.864 E.00315
G1 X171.572 Y110.864 E.00227
G1 X171.847 Y111.139 E.00315
G1 X172.128 Y111.14 E.00227
G1 X171.852 Y110.864 E.00315
G1 X172.133 Y110.864 E.00227
G1 X172.409 Y111.14 E.00315
G1 X172.69 Y111.14 E.00227
G1 X172.414 Y110.864 E.00315
G1 X172.695 Y110.864 E.00227
G1 X172.97 Y111.14 E.00315
G1 X173.251 Y111.14 E.00227
G1 X172.976 Y110.864 E.00315
G1 X173.257 Y110.864 E.00227
G1 X173.532 Y111.14 E.00316
G1 X173.813 Y111.14 E.00227
G1 X173.537 Y110.864 E.00316
G1 X173.818 Y110.864 E.00227
G1 X174.094 Y111.14 E.00316
G1 X174.375 Y111.14 E.00227
G1 X174.099 Y110.864 E.00316
G1 X174.38 Y110.864 E.00227
G1 X174.656 Y111.141 E.00316
G1 X174.937 Y111.141 E.00227
G1 X174.661 Y110.864 E.00316
G1 X174.941 Y110.864 E.00227
G1 X175.218 Y111.141 E.00316
G1 X175.499 Y111.141 E.00227
G1 X175.222 Y110.864 E.00316
G1 X175.503 Y110.864 E.00227
G1 X175.78 Y111.141 E.00317
G1 X176.061 Y111.141 E.00227
G1 X175.784 Y110.864 E.00317
G1 X176.065 Y110.864 E.00227
G1 X176.341 Y111.141 E.00317
G1 X176.622 Y111.141 E.00227
G1 X176.345 Y110.864 E.00317
G1 X176.626 Y110.864 E.00227
G1 X176.903 Y111.141 E.00317
G1 X177.184 Y111.142 E.00227
G1 X176.907 Y110.864 E.00317
G1 X177.188 Y110.864 E.00227
G1 X177.465 Y111.142 E.00317
G1 X177.746 Y111.142 E.00227
G1 X177.469 Y110.864 E.00317
G1 X177.749 Y110.864 E.00227
G1 X178.027 Y111.142 E.00318
G1 X178.308 Y111.142 E.00227
G1 X178.03 Y110.864 E.00318
G1 X178.311 Y110.864 E.00227
G1 X178.589 Y111.142 E.00318
G1 X178.87 Y111.142 E.00227
G1 X178.592 Y110.864 E.00318
G1 X178.873 Y110.864 E.00227
G1 X180.659 Y112.65 E.02043
G1 X181.415 Y113.125 E.00722
G1 X179.153 Y110.864 E.02587
G1 X179.434 Y110.864 E.00227
G1 X182.171 Y113.601 E.03131
G1 X182.927 Y114.076 E.00722
G1 X179.715 Y110.864 E.03674
G1 X179.996 Y110.864 E.00227
G1 X183.683 Y114.551 E.04218
G1 X184.439 Y115.026 E.00722
G1 X180.277 Y110.864 E.04762
G1 X180.557 Y110.864 E.00227
G1 X185.195 Y115.502 E.05305
G1 X185.951 Y115.977 E.00722
G1 X180.838 Y110.864 E.05849
G1 X181.119 Y110.864 E.00227
G1 X186.707 Y116.452 E.06393
G1 X187.463 Y116.927 E.00722
G1 X181.4 Y110.864 E.06937
G1 X181.681 Y110.864 E.00227
G1 X188.219 Y117.402 E.0748
G1 X188.975 Y117.878 E.00722
G1 X181.962 Y110.864 E.08024
G1 X182.242 Y110.864 E.00227
G1 X189.731 Y118.353 E.08568
G1 X190.487 Y118.828 E.00722
G1 X182.523 Y110.864 E.09111
G1 X182.804 Y110.864 E.00227
G1 X191.243 Y119.303 E.09655
G1 X191.999 Y119.778 E.00722
G1 X183.085 Y110.864 E.10199
G1 X183.366 Y110.864 E.00227
G1 X193.136 Y120.634 E.11178
G1 X193.136 Y120.354 E.00227
G1 X183.646 Y110.864 E.10857
G1 X183.927 Y110.864 E.00227
G1 X193.136 Y120.073 E.10536
G1 X193.136 Y119.792 E.00227
G1 X184.208 Y110.864 E.10214
G1 X184.489 Y110.864 E.00227
G1 X193.136 Y119.511 E.09893
G1 X193.136 Y119.23 E.00227
M73 P84 R2
G1 X184.77 Y110.864 E.09572
G1 X185.05 Y110.864 E.00227
G1 X193.136 Y118.95 E.0925
G1 X193.136 Y118.669 E.00227
G1 X185.331 Y110.864 E.08929
G1 X185.612 Y110.864 E.00227
G1 X193.136 Y118.388 E.08608
G1 X193.136 Y118.107 E.00227
G1 X185.893 Y110.864 E.08287
G1 X186.174 Y110.864 E.00227
G1 X193.136 Y117.826 E.07965
G1 X193.136 Y117.546 E.00227
G1 X186.454 Y110.864 E.07644
G1 X186.735 Y110.864 E.00227
G1 X193.136 Y117.265 E.07323
G1 X193.136 Y116.984 E.00227
G1 X187.016 Y110.864 E.07002
G1 X187.297 Y110.864 E.00227
G1 X193.136 Y116.703 E.0668
G1 X193.136 Y116.422 E.00227
G1 X187.578 Y110.864 E.06359
G1 X187.858 Y110.864 E.00227
G1 X193.136 Y116.142 E.06038
G1 X193.136 Y115.861 E.00227
G1 X188.139 Y110.864 E.05717
G1 X188.42 Y110.864 E.00227
G1 X193.136 Y115.58 E.05395
G1 X193.136 Y115.299 E.00227
G1 X188.701 Y110.864 E.05074
G1 X188.982 Y110.864 E.00227
G1 X193.136 Y115.018 E.04753
G1 X193.136 Y114.738 E.00227
G1 X189.262 Y110.864 E.04431
G1 X189.543 Y110.864 E.00227
G1 X193.136 Y114.457 E.0411
G1 X193.136 Y114.176 E.00227
G1 X189.824 Y110.864 E.03789
G1 X190.105 Y110.864 E.00227
G1 X193.136 Y113.895 E.03468
G1 X193.136 Y113.614 E.00227
G1 X190.386 Y110.864 E.03146
G1 X190.666 Y110.864 E.00227
G1 X193.136 Y113.334 E.02825
G1 X193.136 Y113.053 E.00227
G1 X190.947 Y110.864 E.02504
G1 X191.228 Y110.864 E.00227
G1 X193.136 Y112.772 E.02183
G1 X193.136 Y112.491 E.00227
G1 X191.509 Y110.864 E.01861
G1 X191.79 Y110.864 E.00227
G1 X193.136 Y112.21 E.0154
G1 X193.136 Y111.929 E.00227
G1 X192.071 Y110.864 E.01219
G1 X192.351 Y110.864 E.00227
G1 X193.136 Y111.649 E.00897
G1 X193.136 Y111.368 E.00227
G1 X192.632 Y110.864 E.00576
G1 X192.913 Y110.864 E.00227
G1 X193.225 Y111.176 E.00357
; WIPE_START
G1 X192.913 Y110.864 E-.08387
G1 X192.632 Y110.864 E-.05335
G1 X193.136 Y111.368 E-.13531
G1 X193.136 Y111.649 E-.05335
G1 X192.934 Y111.447 E-.05412
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X192.302 Y119.053 Z.9 F60000
G1 X192.029 Y122.336 Z.9
G1 Z.5
G1 E.4 F1800
G1 F6043.513
M204 S8000
G1 X191.928 Y122.235 E.00116
G1 X192.108 Y122.134 E.00167
G1 X192.286 Y122.312 E.00204
M204 S10000
G1 X193.225 Y121.005 F60000
G1 F6043.513
M204 S8000
G1 X192.733 Y120.513 E.00563
G1 X192.834 Y120.731 E.00194
G1 X192.843 Y120.904 E.0014
G1 X193.136 Y121.196 E.00335
G1 X193.136 Y121.477 E.00227
G1 X192.855 Y121.196 E.00321
G1 X192.844 Y121.318 E.00099
G1 X192.799 Y121.421 E.00091
G1 X193.136 Y121.758 E.00385
G1 X193.136 Y122.039 E.00227
G1 X192.713 Y121.616 E.00484
G1 X192.684 Y121.681 E.00058
G1 X192.601 Y121.784 E.00107
G1 X193.136 Y122.319 E.00612
G1 X193.136 Y122.6 E.00227
G1 X192.457 Y121.922 E.00776
G1 X192.288 Y122.033 E.00164
G1 X193.136 Y122.881 E.0097
G1 X193.136 Y123.162 E.00227
G1 X192.8 Y122.826 E.00384
G1 X192.864 Y122.967 E.00125
G1 X192.864 Y123.171 E.00165
G1 X193.136 Y123.443 E.00311
G1 X193.136 Y123.723 E.00227
G1 X192.864 Y123.452 E.00311
G1 X192.864 Y123.733 E.00227
G1 X193.136 Y124.004 E.00311
G1 X193.136 Y124.285 E.00227
G1 X192.864 Y124.014 E.00311
G1 X192.864 Y124.294 E.00227
G1 X193.136 Y124.566 E.00311
G1 X193.136 Y124.847 E.00227
G1 X192.864 Y124.575 E.00311
G1 X192.864 Y124.856 E.00227
G1 X193.136 Y125.127 E.00311
G1 X193.136 Y125.408 E.00227
G1 X192.864 Y125.137 E.00311
G1 X192.864 Y125.418 E.00227
G1 X193.136 Y125.689 E.00311
G1 X193.136 Y125.97 E.00227
G1 X192.864 Y125.698 E.00311
G1 X192.864 Y125.979 E.00227
G1 X193.136 Y126.251 E.00311
G1 X193.136 Y126.531 E.00227
G1 X192.864 Y126.26 E.00311
G1 X192.864 Y126.541 E.00227
G1 X193.136 Y126.812 E.00311
G1 X193.136 Y127.093 E.00227
G1 X192.864 Y126.822 E.00311
G1 X192.864 Y127.102 E.00227
G1 X193.136 Y127.374 E.00311
G1 X193.136 Y127.655 E.00227
G1 X192.864 Y127.383 E.00311
G1 X192.864 Y127.664 E.00227
G1 X193.136 Y127.935 E.00311
G1 X193.136 Y128.216 E.00227
G1 X192.864 Y127.945 E.00311
G1 X192.864 Y128.226 E.00227
G1 X193.136 Y128.497 E.00311
G1 X193.136 Y128.778 E.00227
G1 X192.864 Y128.506 E.00311
G1 X192.864 Y128.787 E.00227
G1 X193.136 Y129.059 E.00311
G1 X193.136 Y129.339 E.00227
G1 X192.86 Y129.064 E.00316
G1 X192.851 Y129.164 E.00081
G1 X192.796 Y129.281 E.00105
G1 X193.136 Y129.62 E.00388
G1 X193.136 Y129.901 E.00227
G1 X192.706 Y129.472 E.00491
G1 X192.663 Y129.565 E.00084
G1 X192.576 Y129.622 E.00084
G1 X193.136 Y130.182 E.0064
G1 X193.136 Y130.463 E.00227
G1 X192.407 Y129.734 E.00833
G1 X192.27 Y129.826 E.00134
G1 X192.225 Y129.832 E.00037
G1 X193.136 Y130.743 E.01042
G1 X193.136 Y131.024 E.00227
G1 X191.976 Y129.864 E.01327
G1 X191.695 Y129.864 E.00227
G1 X192.966 Y131.136 E.01455
G1 X192.686 Y131.136 E.00227
G1 X191.414 Y129.864 E.01455
G1 X191.133 Y129.864 E.00227
G1 X192.405 Y131.136 E.01455
G1 X192.124 Y131.136 E.00227
G1 X190.852 Y129.864 E.01455
G1 X190.572 Y129.864 E.00227
G1 X191.843 Y131.136 E.01455
G1 X191.562 Y131.136 E.00227
G1 X190.291 Y129.864 E.01455
G1 X190.01 Y129.864 E.00227
G1 X191.281 Y131.136 E.01455
G1 X191.001 Y131.136 E.00227
G1 X189.729 Y129.864 E.01455
G1 X189.448 Y129.864 E.00227
G1 X190.72 Y131.136 E.01455
G1 X190.439 Y131.136 E.00227
G1 X189.168 Y129.864 E.01455
G1 X188.887 Y129.864 E.00227
G1 X190.158 Y131.136 E.01455
G1 X189.877 Y131.136 E.00227
G1 X188.606 Y129.864 E.01455
G1 X188.325 Y129.864 E.00227
G1 X189.597 Y131.136 E.01455
G1 X189.316 Y131.136 E.00227
G1 X188.044 Y129.864 E.01455
G1 X187.764 Y129.864 E.00227
G1 X189.035 Y131.136 E.01455
G1 X188.754 Y131.136 E.00227
G1 X187.483 Y129.864 E.01455
G1 X187.202 Y129.864 E.00227
G1 X188.473 Y131.136 E.01455
G1 X188.193 Y131.136 E.00227
G1 X186.921 Y129.864 E.01455
G1 X186.64 Y129.864 E.00227
G1 X187.912 Y131.136 E.01455
G1 X187.631 Y131.136 E.00227
G1 X186.36 Y129.864 E.01455
G1 X186.079 Y129.864 E.00227
G1 X187.35 Y131.136 E.01455
G1 X187.069 Y131.136 E.00227
G1 X185.798 Y129.864 E.01455
G1 X185.517 Y129.864 E.00227
G1 X186.789 Y131.136 E.01455
G1 X186.508 Y131.136 E.00227
G1 X185.236 Y129.864 E.01455
G1 X184.956 Y129.864 E.00227
G1 X186.227 Y131.136 E.01455
G1 X185.946 Y131.136 E.00227
G1 X184.675 Y129.864 E.01455
G1 X184.394 Y129.864 E.00227
G1 X185.665 Y131.136 E.01455
G1 X185.385 Y131.136 E.00227
G1 X184.113 Y129.864 E.01455
G1 X183.832 Y129.864 E.00227
G1 X185.104 Y131.136 E.01455
G1 X184.823 Y131.136 E.00227
G1 X183.552 Y129.864 E.01455
G1 X183.271 Y129.864 E.00227
G1 X184.542 Y131.136 E.01455
G1 X184.261 Y131.136 E.00227
G1 X182.946 Y129.82 E.01505
G1 X182.689 Y129.751 E.00215
G1 X182.405 Y129.483 E.00316
G1 X182.272 Y129.147 E.00293
G1 X181.774 Y128.649 E.0057
G1 X181.947 Y128.54 E.00165
G1 X182.269 Y128.862 E.00368
G1 X182.267 Y128.698 E.00133
G1 X182.312 Y128.625 E.0007
G1 X182.119 Y128.432 E.00221
G1 X182.291 Y128.323 E.00165
G1 X182.419 Y128.451 E.00146
G1 X182.532 Y128.283 E.00164
G1 X182.464 Y128.215 E.00078
G1 X182.636 Y128.107 E.00165
G1 X182.698 Y128.168 E.0007
G1 X182.864 Y128.053 E.00163
G1 X182.744 Y127.933 E.00137
; WIPE_START
G1 X182.864 Y128.053 E-.03215
G1 X182.698 Y128.168 E-.03834
G1 X182.636 Y128.107 E-.01654
G1 X182.464 Y128.215 E-.03869
G1 X182.532 Y128.283 E-.01834
G1 X182.419 Y128.451 E-.03844
G1 X182.291 Y128.323 E-.03429
G1 X182.119 Y128.432 E-.0387
G1 X182.312 Y128.625 E-.05185
G1 X182.267 Y128.698 E-.01643
G1 X182.269 Y128.862 E-.03114
G1 X182.175 Y128.769 E-.0251
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X184.07 Y131.225 Z.9 F60000
G1 Z.5
G1 E.4 F1800
G1 F6043.513
M204 S8000
G1 X181.602 Y128.757 E.02824
G1 X181.429 Y128.865 E.00165
G1 X183.7 Y131.136 E.02598
G1 X183.419 Y131.136 E.00227
G1 X181.257 Y128.974 E.02474
G1 X181.084 Y129.082 E.00165
G1 X183.138 Y131.136 E.0235
G1 X182.857 Y131.136 E.00227
G1 X180.912 Y129.19 E.02226
G1 X180.74 Y129.299 E.00165
G1 X182.576 Y131.136 E.02102
G1 X182.296 Y131.136 E.00227
G1 X180.567 Y129.407 E.01978
G1 X180.395 Y129.516 E.00165
G1 X182.015 Y131.136 E.01854
G1 X181.734 Y131.136 E.00227
G1 X180.222 Y129.624 E.0173
G1 X180.05 Y129.732 E.00165
G1 X181.453 Y131.136 E.01606
G1 X181.172 Y131.136 E.00227
G1 X179.877 Y129.841 E.01482
G1 X179.859 Y129.853 E.00018
G1 X179.834 Y130.078 E.00184
G1 X180.892 Y131.136 E.0121
G1 X180.611 Y131.136 E.00227
G1 X179.745 Y130.27 E.00991
G1 X179.644 Y130.45 E.00167
G1 X180.33 Y131.136 E.00784
G1 X180.049 Y131.136 E.00227
G1 X179.507 Y130.594 E.0062
G1 X179.326 Y130.693 E.00167
G1 X179.768 Y131.136 E.00506
G1 X179.488 Y131.136 E.00227
G1 X179.145 Y130.793 E.00392
G1 X179.049 Y130.846 E.00089
G1 X178.917 Y130.846 E.00107
G1 X179.207 Y131.136 E.00331
G1 X178.926 Y131.136 E.00227
G1 X178.637 Y130.846 E.00331
G1 X178.356 Y130.847 E.00227
G1 X178.645 Y131.136 E.00331
G1 X178.364 Y131.136 E.00227
G1 X178.076 Y130.847 E.0033
G1 X177.795 Y130.847 E.00227
G1 X178.084 Y131.136 E.0033
G1 X177.803 Y131.136 E.00227
G1 X177.515 Y130.848 E.0033
G1 X177.234 Y130.848 E.00227
G1 X177.522 Y131.136 E.00329
G1 X177.241 Y131.136 E.00227
G1 X176.954 Y130.848 E.00329
G1 X176.673 Y130.849 E.00227
G1 X176.96 Y131.136 E.00329
G1 X176.68 Y131.136 E.00227
G1 X176.393 Y130.849 E.00328
G1 X176.112 Y130.849 E.00227
G1 X176.399 Y131.136 E.00328
G1 X176.118 Y131.136 E.00227
G1 X175.832 Y130.849 E.00328
G1 X175.551 Y130.85 E.00227
G1 X175.837 Y131.136 E.00327
G1 X175.556 Y131.136 E.00227
G1 X175.271 Y130.85 E.00327
G1 X174.99 Y130.85 E.00227
G1 X175.276 Y131.136 E.00326
G1 X174.995 Y131.136 E.00227
G1 X174.71 Y130.851 E.00326
G1 X174.429 Y130.851 E.00227
G1 X174.714 Y131.136 E.00326
G1 X174.433 Y131.136 E.00227
G1 X174.149 Y130.851 E.00325
G1 X173.868 Y130.852 E.00227
G1 X174.152 Y131.136 E.00325
G1 X173.872 Y131.136 E.00227
G1 X173.588 Y130.852 E.00325
G1 X173.307 Y130.852 E.00227
G1 X173.591 Y131.136 E.00324
G1 X173.31 Y131.136 E.00227
G1 X173.027 Y130.853 E.00324
G1 X172.746 Y130.853 E.00227
G1 X173.029 Y131.136 E.00324
G1 X172.748 Y131.136 E.00227
G1 X172.466 Y130.853 E.00323
G1 X172.185 Y130.854 E.00227
G1 X172.467 Y131.136 E.00323
G1 X172.187 Y131.136 E.00227
G1 X171.905 Y130.854 E.00323
G1 X171.624 Y130.854 E.00227
G1 X171.906 Y131.136 E.00322
G1 X171.625 Y131.136 E.00227
G1 X171.344 Y130.854 E.00322
G1 X171.063 Y130.855 E.00227
G1 X171.344 Y131.136 E.00321
G1 X171.063 Y131.136 E.00227
G1 X170.783 Y130.855 E.00321
G1 X170.502 Y130.855 E.00227
G1 X170.783 Y131.136 E.00321
G1 X170.502 Y131.136 E.00227
G1 X170.222 Y130.856 E.0032
G1 X169.941 Y130.856 E.00227
G1 X170.221 Y131.136 E.0032
G1 X169.94 Y131.136 E.00227
G1 X169.661 Y130.856 E.0032
G1 X169.38 Y130.857 E.00227
G1 X169.659 Y131.136 E.00319
G1 X169.379 Y131.136 E.00227
G1 X169.1 Y130.857 E.00319
G1 X168.819 Y130.857 E.00227
G1 X169.098 Y131.136 E.00319
G1 X168.817 Y131.136 E.00227
G1 X168.45 Y130.768 E.0042
; WIPE_START
G1 X168.817 Y131.136 E-.09872
G1 X169.098 Y131.136 E-.05335
G1 X168.819 Y130.857 E-.07483
G1 X169.1 Y130.857 E-.0533
G1 X169.379 Y131.136 E-.07491
G1 X169.51 Y131.136 E-.02489
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X164.209 Y130.898 Z.9 F60000
G1 Z.5
G1 E.4 F1800
; LINE_WIDTH: 0.21986
G1 F6048.388
M204 S8000
G1 X162.176 Y130.898 E.01643
G1 X162.374 Y131.096 E.00227
G1 X164.105 Y131.096 E.01399
G1 X164.141 Y130.964 E.0011
G1 X164.188 Y130.919 E.00053
; WIPE_START
G1 X164.141 Y130.964 E-.01244
G1 X164.105 Y131.096 E-.02593
G1 X162.374 Y131.096 E-.32878
G1 X162.327 Y131.048 E-.01286
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X167.615 Y125.544 Z.9 F60000
G1 X180.187 Y112.459 Z.9
G1 Z.5
G1 E.4 F1800
; LINE_WIDTH: 0.22002
G1 F6043.513
M204 S8000
G1 X179.756 Y112.028 E.00493
; OBJECT_ID: 5887
; COOLING_NODE: 0
; WIPE_START
G1 X180.187 Y112.459 E-.38
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 5909
M625
; start printing object, unique label id: 5887
M624 AQAAAAAAAAA=
M204 S10000
G1 X172.935 Y114.84 Z.9 F60000
G1 X124.619 Y130.699 Z.9
G1 Z.5
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.21999
G1 F6044.427
M204 S8000
G1 X124.671 Y130.699 E.00042
G1 X124.308 Y131.054 E.00411
G1 X124.294 Y131.294 E.00194
G1 X122.692 Y131.294 E.01296
G1 X122.292 Y131.294 E.00324
G1 F5151.471
G1 X122.205 Y131.207 E.001
; LINE_WIDTH: 0.267315
G1 F4880.926
G1 X121.941 Y130.91 E.00399
; LINE_WIDTH: 0.31464
G1 F4093.049
G1 X121.677 Y130.612 E.00475
G1 X121.89 Y130.655 E.0026
; LINE_WIDTH: 0.267315
G1 F4535.63
G1 X122.103 Y130.699 E.00218
; LINE_WIDTH: 0.21999
G1 F5408.699
G1 X122.503 Y130.699 E.00324
G1 F6044.427
G1 X122.903 Y130.699 E.00324
G1 X124.619 Y130.699 E.01389
; COOLING_NODE: 0
; WIPE_START
G1 X124.671 Y130.699 E-.00975
G1 X124.308 Y131.054 E-.09655
G1 X124.294 Y131.294 E-.04566
G1 X123.094 Y131.294 E-.22805
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X130.685 Y130.499 Z.9 F60000
G1 X142.484 Y129.264 Z.9
G1 Z.5
G1 E.4 F1800
G1 F6044.427
M204 S8000
G1 X142.427 Y129.127 E.0012
G1 X142.422 Y128.741 E.00312
G1 X142.626 Y128.41 E.00314
G1 F5248
G1 X142.985 Y128.162 E.00353
; LINE_WIDTH: 0.266815
G1 F4313.496
G1 X143.055 Y128.087 E.00103
; LINE_WIDTH: 0.31364
G1 F4107.057
G1 X143.126 Y128.012 E.00122
G1 X144.797 Y126.914 E.02381
; LINE_WIDTH: 0.2868
G1 F4522.499
G1 X146.469 Y125.816 E.02162
; LINE_WIDTH: 0.25996
G1 F5031.447
G1 X148.14 Y124.717 E.01943
; LINE_WIDTH: 0.23312
G1 F5669.47
G1 X148.474 Y124.498 E.00345
G1 X149.812 Y123.619 E.0138
; LINE_WIDTH: 0.20628
G1 F6492.804
G1 X150.146 Y123.4 E.00301
G1 X151.483 Y122.521 E.01205
; LINE_WIDTH: 0.17944
G1 F6725.054
G1 X151.637 Y122.42 E.00119
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X152.329 Y122.362 E.00562
G1 X152.468 Y122.457 E.00136
G1 X152.706 Y122.98 E.00465
G1 X152.706 Y129.011 E.04878
G1 X152.695 Y129.131 E.00097
G1 X152.54 Y129.461 E.00295
G1 X152.131 Y129.695 E.00382
G1 X152.011 Y129.706 E.00097
G1 X143.118 Y129.706 E.07194
G1 X142.769 Y129.612 E.00292
G1 X142.538 Y129.394 E.00257
G1 X142.484 Y129.264 E.00114
; COOLING_NODE: 0
; WIPE_START
G1 X142.427 Y129.127 E-.02814
G1 X142.422 Y128.741 E-.07335
G1 X142.626 Y128.41 E-.07386
G1 X142.985 Y128.162 E-.08298
G1 X143.055 Y128.087 E-.01951
G1 X143.126 Y128.012 E-.01951
G1 X143.489 Y127.773 E-.08265
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X135.982 Y129.153 Z.9 F60000
G1 X126.336 Y130.926 Z.9
G1 Z.5
G1 E.4 F1800
G1 F6044.427
M204 S8000
G1 X126.06 Y130.699 E.00289
G1 X139.017 Y130.689 E.1048
G1 X139.41 Y130.472 E.00364
G1 X139.522 Y130.35 E.00134
G1 X139.676 Y130.071 E.00257
G1 X139.704 Y129.762 E.00251
G1 X142.095 Y128.259 E.02284
G1 X142.434 Y128.046 E.00324
G1 F5165.867
G1 X142.773 Y127.834 E.00324
; LINE_WIDTH: 0.266815
G1 F4313.494
G1 X142.87 Y127.8 E.00103
; LINE_WIDTH: 0.31364
G1 F4107.057
G1 X142.967 Y127.767 E.00122
G1 X144.653 Y126.691 E.02381
; LINE_WIDTH: 0.2868
G1 F4522.499
G1 X146.339 Y125.615 E.02162
; LINE_WIDTH: 0.25996
G1 F5031.447
G1 X148.025 Y124.54 E.01943
; LINE_WIDTH: 0.23312
G1 F5669.47
G1 X148.362 Y124.325 E.00345
G1 X149.711 Y123.464 E.0138
; LINE_WIDTH: 0.20628
G1 F6492.804
G1 X150.048 Y123.249 E.00301
G1 X151.397 Y122.388 E.01205
; LINE_WIDTH: 0.17944
G1 F6961.406
G1 X151.553 Y122.289 E.00119
; LINE_WIDTH: 0.17697
G1 F6987.478
G1 X151.57 Y122.278 E.00013
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X152.307 Y121.84 E.00694
G1 X152.488 Y121.676 E.00198
G1 X152.688 Y121.286 E.00355
G1 X152.676 Y120.751 E.00432
G1 X152.463 Y120.289 E.00412
G1 X152.306 Y120.159 E.00164
G1 X139.704 Y112.238 E.1204
G1 X139.676 Y111.928 E.00251
G1 X139.522 Y111.65 E.00257
G1 X139.41 Y111.528 E.00134
G1 X138.897 Y111.301 E.00454
G1 X122.148 Y111.294 E.13548
G1 X121.882 Y111.347 E.0022
G1 X121.544 Y111.544 E.00316
G1 X121.394 Y111.77 E.00219
G1 X121.294 Y112.148 E.00316
G1 X121.294 Y129.586 E.14105
G1 X121.324 Y130.053 E.00379
; LINE_WIDTH: 0.253815
G1 F4976.445
G1 X121.412 Y130.254 E.00208
; LINE_WIDTH: 0.28764
G1 F4508.228
G1 X121.501 Y130.455 E.00238
G1 X121.36 Y130.338 E.00199
; LINE_WIDTH: 0.253815
G1 F4897.942
G1 X121.218 Y130.221 E.00174
; LINE_WIDTH: 0.21999
G1 F5803.708
G1 X120.936 Y129.938 E.00324
G1 F6044.427
G1 X120.706 Y129.708 E.00263
G1 X120.706 Y110.706 E.15371
G1 X153.294 Y110.706 E.26361
G1 X153.294 Y114.291 E.029
G1 X153.294 Y131.294 E.13754
G1 X126.506 Y131.294 E.21669
G1 X126.492 Y131.054 E.00194
G1 X126.336 Y130.926 E.00163
; COOLING_NODE: 0
M204 S10000
M73 P85 R2
G1 X126.198 Y131.011 F60000
G1 F6044.427
M204 S8000
G1 X125.811 Y130.694 E.00405
; LINE_WIDTH: 0.22141
G1 F6001.5
G1 X124.903 Y130.7 E.00739
G1 X124.502 Y131.093 E.00458
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X124.493 Y131.493 E.00324
G1 X122.21 Y131.493 E.01847
G1 X120.507 Y129.79 E.01948
G1 X120.507 Y110.507 E.15598
G1 X153.493 Y110.507 E.26682
G1 X153.493 Y114.291 E.03061
G1 X153.493 Y131.493 E.13914
G1 X126.307 Y131.493 E.2199
G1 X126.298 Y131.093 E.00324
G1 X126.198 Y131.011 E.00104
; COOLING_NODE: 0
M204 S10000
G1 X126.06 Y131.096 F60000
G1 F6044.427
M204 S8000
G1 X125.811 Y130.891 E.00261
G1 X124.938 Y130.896 E.00706
G1 X124.697 Y131.131 E.00272
G1 X124.691 Y131.691 E.00453
G1 X122.128 Y131.691 E.02074
G1 X120.309 Y129.872 E.02081
G1 X120.309 Y110.309 E.15825
G1 X153.691 Y110.309 E.27003
G1 X153.691 Y114.291 E.03222
G1 X153.691 Y131.691 E.14075
G1 X126.109 Y131.691 E.22311
G1 X126.103 Y131.131 E.00453
G1 X126.06 Y131.096 E.00045
; COOLING_NODE: 0
M204 S250
G1 X125.91 Y131.189 F60000
; FEATURE: Outer wall
G1 F6044.427
M204 S5000
G1 X125.811 Y131.09 E.00114
G1 X124.989 Y131.09 E.00664
G1 X124.89 Y131.189 E.00114
G1 X124.89 Y131.89 E.00567
G1 X122.046 Y131.89 E.02301
G1 X120.11 Y129.954 E.02214
G1 X120.11 Y110.11 E.16052
G1 X153.89 Y110.11 E.27324
G1 X153.89 Y114.291 E.03382
G1 X153.89 Y131.89 E.14235
G1 X125.91 Y131.89 E.22633
G1 X125.91 Y131.189 E.00567
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X125.811 Y131.09 E-.02667
G1 X124.989 Y131.09 E-.15608
G1 X124.89 Y131.189 E-.02667
G1 X124.89 Y131.89 E-.13314
G1 X124.693 Y131.89 E-.03744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X132.24 Y130.754 Z.9 F60000
G1 X142.663 Y129.185 Z.9
G1 Z.5
G1 E.4 F1800
; FEATURE: Inner wall
G1 F6044.427
M204 S8000
G1 X142.617 Y129.07 E.001
G1 X142.613 Y128.794 E.00223
G1 X142.817 Y128.513 E.00281
G1 X143.095 Y128.327 E.00271
G1 X151.735 Y122.567 E.084
G1 X152.238 Y122.539 E.00407
G1 X152.337 Y122.606 E.00097
G1 X152.507 Y122.98 E.00332
G1 X152.507 Y129.011 E.04878
G1 X152.389 Y129.332 E.00277
G1 X152.096 Y129.5 E.00273
G1 X152.011 Y129.507 E.0007
G1 X143.118 Y129.507 E.07194
G1 X142.869 Y129.44 E.00208
G1 X142.704 Y129.285 E.00184
G1 X142.663 Y129.185 E.00087
; COOLING_NODE: 0
M204 S10000
G1 X142.878 Y129.154 F60000
G1 F6044.427
M204 S8000
G1 X142.832 Y129.097 E.00059
G1 X142.805 Y128.847 E.00204
G1 X142.927 Y128.678 E.00168
G1 X143.205 Y128.492 E.00271
G1 X151.846 Y122.732 E.084
G1 X152.147 Y122.715 E.00244
G1 X152.207 Y122.756 E.00058
G1 X152.309 Y122.98 E.00199
G1 X152.309 Y129.011 E.04878
G1 X152.238 Y129.204 E.00166
G1 X152.062 Y129.304 E.00164
G1 X152.011 Y129.309 E.00042
G1 X143.118 Y129.309 E.07194
G1 X142.968 Y129.268 E.00125
G1 X142.878 Y129.154 E.00118
; COOLING_NODE: 1
M204 S250
G1 X143.023 Y129.039 F60000
; FEATURE: Outer wall
G1 F6044.427
M204 S5000
G1 X142.996 Y128.9 E.00115
G1 X143.316 Y128.657 E.00324
G1 X151.958 Y122.896 E.08402
G1 X152.076 Y122.905 E.00096
G1 X152.11 Y122.98 E.00066
G1 X152.11 Y129.011 E.04878
G1 X152.04 Y129.105 E.00095
G1 X143.118 Y129.11 E.07218
G1 X143.023 Y129.039 E.00096
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X142.996 Y128.9 E-.02707
G1 X143.316 Y128.657 E-.07614
G1 X144.528 Y127.849 E-.27679
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X142.176 Y120.588 Z.9 F60000
G1 X139.507 Y112.348 Z.9
G1 Z.5
G1 E.4 F1800
; FEATURE: Inner wall
G1 F6044.427
M204 S8000
G1 X152.201 Y120.327 E.12128
G1 X152.325 Y120.433 E.00132
G1 X152.478 Y120.763 E.00294
G1 X152.493 Y121.251 E.00395
G1 X152.33 Y121.555 E.00278
G1 X152.201 Y121.672 E.00141
G1 X139.507 Y129.652 E.12128
G1 X139.485 Y130.017 E.00296
G1 X139.264 Y130.338 E.00316
G1 X138.982 Y130.493 E.0026
G1 X125.811 Y130.499 E.10654
; LINE_WIDTH: 0.21691
G1 F6139.678
G1 X124.989 Y130.499 E.00654
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X122.103 Y130.501 E.02335
G1 X121.807 Y130.403 E.00252
G1 X121.665 Y130.291 E.00146
G1 X121.514 Y129.995 E.00268
G1 X121.493 Y129.586 E.00332
G1 X121.493 Y112.148 E.14105
G1 X121.577 Y111.846 E.00254
G1 X121.685 Y111.685 E.00157
G1 X121.958 Y111.531 E.00254
G1 X122.148 Y111.493 E.00157
G1 X138.897 Y111.499 E.13548
G1 X139.264 Y111.662 E.00324
G1 X139.485 Y111.983 E.00315
G1 X139.507 Y112.348 E.00296
; COOLING_NODE: 1
M204 S10000
G1 X139.31 Y112.459 F60000
G1 F6044.427
M204 S8000
G1 X152.095 Y120.495 E.12215
G1 X152.188 Y120.576 E.001
G1 X152.28 Y120.774 E.00176
G1 X152.297 Y121.217 E.00359
G1 X152.151 Y121.459 E.00229
G1 X139.31 Y129.541 E.12274
G1 X139.294 Y129.963 E.00342
G1 X139.117 Y130.205 E.00242
G1 X138.897 Y130.302 E.00195
G1 X122.103 Y130.302 E.13584
G1 X121.805 Y130.15 E.0027
G1 X121.704 Y129.938 E.0019
G1 X121.691 Y129.586 E.00285
G1 X121.691 Y112.148 E.14105
G1 X121.761 Y111.922 E.00191
G1 X121.922 Y111.761 E.00184
G1 X122.148 Y111.691 E.00191
G1 X138.897 Y111.698 E.13548
G1 X139.117 Y111.795 E.00195
G1 X139.294 Y112.037 E.00242
G1 X139.31 Y112.459 E.00342
; COOLING_NODE: 2
M204 S250
G1 X139.112 Y112.569 F60000
; FEATURE: Outer wall
G1 F6044.427
M204 S5000
G1 X151.989 Y120.663 E.12303
G1 X152.081 Y120.785 E.00124
G1 X152.083 Y121.226 E.00356
G1 X151.99 Y121.336 E.00116
G1 X139.112 Y129.431 E.12303
G1 X139.081 Y129.949 E.0042
G1 X138.897 Y130.104 E.00195
G1 X122.103 Y130.103 E.13584
G1 X121.946 Y130.01 E.00148
G1 X121.89 Y129.852 E.00136
G1 X121.89 Y112.148 E.1432
G1 X121.966 Y111.966 E.0016
G1 X122.148 Y111.89 E.0016
G1 X138.897 Y111.896 E.13548
G1 X139.081 Y112.051 E.00195
G1 X139.112 Y112.569 E.0042
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X140.806 Y113.634 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X135.097 Y118.7 Z.9 F60000
G1 X121.677 Y130.612 Z.9
G1 Z.5
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.31464
G1 F4093.049
M204 S8000
G1 X121.501 Y130.455 E.00281
M204 S10000
G1 X121.208 Y129.986 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.22002
G1 F6043.513
M204 S8000
G1 X120.864 Y129.642 E.00394
G1 X120.864 Y129.361 E.00227
G1 X121.136 Y129.632 E.00311
G1 X121.136 Y129.351 E.00227
G1 X120.864 Y129.08 E.00311
G1 X120.864 Y128.799 E.00227
G1 X121.136 Y129.071 E.00311
G1 X121.136 Y128.79 E.00227
G1 X120.864 Y128.518 E.00311
G1 X120.864 Y128.238 E.00227
G1 X121.136 Y128.509 E.00311
G1 X121.136 Y128.228 E.00227
G1 X120.864 Y127.957 E.00311
G1 X120.864 Y127.676 E.00227
G1 X121.136 Y127.947 E.00311
G1 X121.136 Y127.667 E.00227
G1 X120.864 Y127.395 E.00311
G1 X120.864 Y127.114 E.00227
G1 X121.136 Y127.386 E.00311
G1 X121.136 Y127.105 E.00227
G1 X120.864 Y126.833 E.00311
G1 X120.864 Y126.553 E.00227
G1 X121.136 Y126.824 E.00311
G1 X121.136 Y126.543 E.00227
G1 X120.864 Y126.272 E.00311
G1 X120.864 Y125.991 E.00227
G1 X121.136 Y126.262 E.00311
G1 X121.136 Y125.982 E.00227
G1 X120.864 Y125.71 E.00311
G1 X120.864 Y125.429 E.00227
G1 X121.136 Y125.701 E.00311
G1 X121.136 Y125.42 E.00227
G1 X120.864 Y125.149 E.00311
G1 X120.864 Y124.868 E.00227
G1 X121.136 Y125.139 E.00311
G1 X121.136 Y124.858 E.00227
G1 X120.864 Y124.587 E.00311
G1 X120.864 Y124.306 E.00227
G1 X121.136 Y124.578 E.00311
G1 X121.136 Y124.297 E.00227
G1 X120.864 Y124.025 E.00311
G1 X120.864 Y123.745 E.00227
G1 X121.136 Y124.016 E.00311
G1 X121.136 Y123.735 E.00227
G1 X120.864 Y123.464 E.00311
G1 X120.864 Y123.183 E.00227
G1 X121.136 Y123.454 E.00311
G1 X121.136 Y123.174 E.00227
G1 X120.864 Y122.902 E.00311
G1 X120.864 Y122.621 E.00227
G1 X121.136 Y122.893 E.00311
G1 X121.136 Y122.612 E.00227
G1 X120.864 Y122.341 E.00311
G1 X120.864 Y122.06 E.00227
G1 X121.136 Y122.331 E.00311
G1 X121.136 Y122.05 E.00227
G1 X120.864 Y121.779 E.00311
G1 X120.864 Y121.498 E.00227
G1 X121.136 Y121.77 E.00311
G1 X121.136 Y121.489 E.00227
G1 X120.864 Y121.217 E.00311
G1 X120.864 Y120.937 E.00227
G1 X121.136 Y121.208 E.00311
G1 X121.136 Y120.927 E.00227
G1 X120.864 Y120.656 E.00311
G1 X120.864 Y120.375 E.00227
G1 X121.136 Y120.646 E.00311
G1 X121.136 Y120.366 E.00227
G1 X120.864 Y120.094 E.00311
G1 X120.864 Y119.813 E.00227
G1 X121.136 Y120.085 E.00311
G1 X121.136 Y119.804 E.00227
G1 X120.864 Y119.533 E.00311
G1 X120.864 Y119.252 E.00227
G1 X121.136 Y119.523 E.00311
G1 X121.136 Y119.242 E.00227
G1 X120.864 Y118.971 E.00311
G1 X120.864 Y118.69 E.00227
G1 X121.136 Y118.962 E.00311
G1 X121.136 Y118.681 E.00227
G1 X120.864 Y118.409 E.00311
G1 X120.864 Y118.128 E.00227
G1 X121.136 Y118.4 E.00311
G1 X121.136 Y118.119 E.00227
G1 X120.864 Y117.848 E.00311
G1 X120.864 Y117.567 E.00227
G1 X121.136 Y117.838 E.00311
G1 X121.136 Y117.557 E.00227
G1 X120.864 Y117.286 E.00311
G1 X120.864 Y117.005 E.00227
G1 X121.136 Y117.277 E.00311
G1 X121.136 Y116.996 E.00227
G1 X120.864 Y116.724 E.00311
G1 X120.864 Y116.444 E.00227
G1 X121.136 Y116.715 E.00311
G1 X121.136 Y116.434 E.00227
G1 X120.864 Y116.163 E.00311
G1 X120.864 Y115.882 E.00227
G1 X121.136 Y116.153 E.00311
G1 X121.136 Y115.873 E.00227
G1 X120.864 Y115.601 E.00311
G1 X120.864 Y115.32 E.00227
G1 X121.136 Y115.592 E.00311
G1 X121.136 Y115.311 E.00227
G1 X120.864 Y115.04 E.00311
G1 X120.864 Y114.759 E.00227
G1 X121.136 Y115.03 E.00311
G1 X121.136 Y114.749 E.00227
G1 X120.864 Y114.478 E.00311
G1 X120.864 Y114.197 E.00227
G1 X121.136 Y114.469 E.00311
G1 X121.136 Y114.188 E.00227
G1 X120.864 Y113.916 E.00311
G1 X120.864 Y113.636 E.00227
G1 X121.136 Y113.907 E.00311
G1 X121.136 Y113.626 E.00227
G1 X120.864 Y113.355 E.00311
G1 X120.864 Y113.074 E.00227
G1 X121.136 Y113.345 E.00311
G1 X121.136 Y113.065 E.00227
G1 X120.864 Y112.793 E.00311
G1 X120.864 Y112.512 E.00227
G1 X121.136 Y112.784 E.00311
G1 X121.136 Y112.503 E.00227
G1 X120.864 Y112.232 E.00311
G1 X120.864 Y111.951 E.00227
G1 X121.136 Y112.222 E.00311
G1 X121.169 Y111.975 E.00202
G1 X120.864 Y111.67 E.00349
G1 X120.864 Y111.389 E.00227
G1 X121.229 Y111.754 E.00417
G1 X121.334 Y111.578 E.00166
G1 X120.864 Y111.108 E.00537
G1 X120.864 Y110.864 E.00197
G1 X120.901 Y110.864 E.0003
G1 X121.453 Y111.417 E.00632
G1 X121.622 Y111.304 E.00164
G1 X121.182 Y110.864 E.00503
G1 X121.463 Y110.864 E.00227
G1 X121.806 Y111.207 E.00392
G1 X122.025 Y111.146 E.00185
G1 X121.743 Y110.864 E.00322
G1 X122.024 Y110.864 E.00227
M73 P86 R2
G1 X122.296 Y111.136 E.00311
G1 X122.577 Y111.136 E.00227
G1 X122.305 Y110.864 E.00311
G1 X122.586 Y110.864 E.00227
G1 X122.858 Y111.136 E.00311
G1 X123.138 Y111.136 E.00227
G1 X122.867 Y110.864 E.00311
G1 X123.147 Y110.864 E.00227
G1 X123.419 Y111.136 E.00311
G1 X123.7 Y111.136 E.00227
G1 X123.428 Y110.864 E.00311
G1 X123.709 Y110.864 E.00227
G1 X123.981 Y111.136 E.00311
G1 X124.262 Y111.137 E.00227
G1 X123.99 Y110.864 E.00311
G1 X124.271 Y110.864 E.00227
G1 X124.543 Y111.137 E.00312
G1 X124.824 Y111.137 E.00227
G1 X124.552 Y110.864 E.00312
G1 X124.832 Y110.864 E.00227
G1 X125.105 Y111.137 E.00312
G1 X125.386 Y111.137 E.00227
G1 X125.113 Y110.864 E.00312
G1 X125.394 Y110.864 E.00227
G1 X125.667 Y111.137 E.00312
G1 X125.948 Y111.137 E.00227
G1 X125.675 Y110.864 E.00312
G1 X125.956 Y110.864 E.00227
G1 X126.229 Y111.137 E.00312
G1 X126.509 Y111.137 E.00227
G1 X126.236 Y110.864 E.00312
G1 X126.517 Y110.864 E.00227
G1 X126.79 Y111.137 E.00313
G1 X127.071 Y111.138 E.00227
G1 X126.798 Y110.864 E.00313
G1 X127.079 Y110.864 E.00227
G1 X127.352 Y111.138 E.00313
G1 X127.633 Y111.138 E.00227
G1 X127.36 Y110.864 E.00313
G1 X127.64 Y110.864 E.00227
G1 X127.914 Y111.138 E.00313
G1 X128.195 Y111.138 E.00227
G1 X127.921 Y110.864 E.00313
G1 X128.202 Y110.864 E.00227
G1 X128.476 Y111.138 E.00313
G1 X128.757 Y111.138 E.00227
G1 X128.483 Y110.864 E.00313
G1 X128.764 Y110.864 E.00227
G1 X129.038 Y111.138 E.00314
G1 X129.319 Y111.138 E.00227
G1 X129.044 Y110.864 E.00314
G1 X129.325 Y110.864 E.00227
G1 X129.6 Y111.139 E.00314
G1 X129.88 Y111.139 E.00227
G1 X129.606 Y110.864 E.00314
G1 X129.887 Y110.864 E.00227
G1 X130.161 Y111.139 E.00314
G1 X130.442 Y111.139 E.00227
G1 X130.168 Y110.864 E.00314
G1 X130.448 Y110.864 E.00227
G1 X130.723 Y111.139 E.00314
G1 X131.004 Y111.139 E.00227
G1 X130.729 Y110.864 E.00314
G1 X131.01 Y110.864 E.00227
G1 X131.285 Y111.139 E.00315
G1 X131.566 Y111.139 E.00227
G1 X131.291 Y110.864 E.00315
G1 X131.572 Y110.864 E.00227
G1 X131.847 Y111.139 E.00315
G1 X132.128 Y111.14 E.00227
G1 X131.852 Y110.864 E.00315
G1 X132.133 Y110.864 E.00227
G1 X132.409 Y111.14 E.00315
G1 X132.69 Y111.14 E.00227
G1 X132.414 Y110.864 E.00315
G1 X132.695 Y110.864 E.00227
G1 X132.97 Y111.14 E.00315
G1 X133.251 Y111.14 E.00227
G1 X132.976 Y110.864 E.00315
G1 X133.257 Y110.864 E.00227
G1 X133.532 Y111.14 E.00316
G1 X133.813 Y111.14 E.00227
G1 X133.537 Y110.864 E.00316
G1 X133.818 Y110.864 E.00227
G1 X134.094 Y111.14 E.00316
G1 X134.375 Y111.14 E.00227
G1 X134.099 Y110.864 E.00316
G1 X134.38 Y110.864 E.00227
G1 X134.656 Y111.141 E.00316
G1 X134.937 Y111.141 E.00227
G1 X134.661 Y110.864 E.00316
G1 X134.941 Y110.864 E.00227
G1 X135.218 Y111.141 E.00316
G1 X135.499 Y111.141 E.00227
G1 X135.222 Y110.864 E.00316
G1 X135.503 Y110.864 E.00227
G1 X135.78 Y111.141 E.00317
G1 X136.061 Y111.141 E.00227
G1 X135.784 Y110.864 E.00317
G1 X136.065 Y110.864 E.00227
G1 X136.341 Y111.141 E.00317
G1 X136.622 Y111.141 E.00227
G1 X136.345 Y110.864 E.00317
G1 X136.626 Y110.864 E.00227
G1 X136.903 Y111.141 E.00317
G1 X137.184 Y111.142 E.00227
G1 X136.907 Y110.864 E.00317
G1 X137.188 Y110.864 E.00227
G1 X137.465 Y111.142 E.00317
G1 X137.746 Y111.142 E.00227
G1 X137.469 Y110.864 E.00317
G1 X137.749 Y110.864 E.00227
G1 X138.027 Y111.142 E.00318
G1 X138.308 Y111.142 E.00227
G1 X138.03 Y110.864 E.00318
G1 X138.311 Y110.864 E.00227
G1 X138.589 Y111.142 E.00318
G1 X138.87 Y111.142 E.00227
G1 X138.592 Y110.864 E.00318
G1 X138.873 Y110.864 E.00227
G1 X140.659 Y112.65 E.02043
G1 X141.415 Y113.125 E.00722
G1 X139.153 Y110.864 E.02587
G1 X139.434 Y110.864 E.00227
G1 X142.171 Y113.601 E.03131
G1 X142.927 Y114.076 E.00722
G1 X139.715 Y110.864 E.03674
G1 X139.996 Y110.864 E.00227
G1 X143.683 Y114.551 E.04218
G1 X144.439 Y115.026 E.00722
G1 X140.277 Y110.864 E.04762
G1 X140.557 Y110.864 E.00227
G1 X145.195 Y115.502 E.05305
G1 X145.951 Y115.977 E.00722
G1 X140.838 Y110.864 E.05849
G1 X141.119 Y110.864 E.00227
G1 X146.707 Y116.452 E.06393
G1 X147.463 Y116.927 E.00722
G1 X141.4 Y110.864 E.06937
G1 X141.681 Y110.864 E.00227
G1 X148.219 Y117.402 E.0748
G1 X148.975 Y117.878 E.00722
G1 X141.962 Y110.864 E.08024
G1 X142.242 Y110.864 E.00227
G1 X149.731 Y118.353 E.08568
G1 X150.487 Y118.828 E.00722
G1 X142.523 Y110.864 E.09111
G1 X142.804 Y110.864 E.00227
G1 X151.243 Y119.303 E.09655
G1 X151.999 Y119.778 E.00722
G1 X143.085 Y110.864 E.10199
G1 X143.366 Y110.864 E.00227
G1 X153.136 Y120.634 E.11178
G1 X153.136 Y120.354 E.00227
G1 X143.646 Y110.864 E.10857
G1 X143.927 Y110.864 E.00227
G1 X153.136 Y120.073 E.10536
G1 X153.136 Y119.792 E.00227
G1 X144.208 Y110.864 E.10214
G1 X144.489 Y110.864 E.00227
G1 X153.136 Y119.511 E.09893
G1 X153.136 Y119.23 E.00227
G1 X144.77 Y110.864 E.09572
G1 X145.05 Y110.864 E.00227
G1 X153.136 Y118.95 E.0925
G1 X153.136 Y118.669 E.00227
G1 X145.331 Y110.864 E.08929
G1 X145.612 Y110.864 E.00227
G1 X153.136 Y118.388 E.08608
G1 X153.136 Y118.107 E.00227
G1 X145.893 Y110.864 E.08287
G1 X146.174 Y110.864 E.00227
G1 X153.136 Y117.826 E.07965
G1 X153.136 Y117.546 E.00227
G1 X146.454 Y110.864 E.07644
G1 X146.735 Y110.864 E.00227
G1 X153.136 Y117.265 E.07323
G1 X153.136 Y116.984 E.00227
G1 X147.016 Y110.864 E.07002
G1 X147.297 Y110.864 E.00227
G1 X153.136 Y116.703 E.0668
G1 X153.136 Y116.422 E.00227
G1 X147.578 Y110.864 E.06359
G1 X147.858 Y110.864 E.00227
G1 X153.136 Y116.142 E.06038
G1 X153.136 Y115.861 E.00227
G1 X148.139 Y110.864 E.05717
G1 X148.42 Y110.864 E.00227
G1 X153.136 Y115.58 E.05395
G1 X153.136 Y115.299 E.00227
G1 X148.701 Y110.864 E.05074
G1 X148.982 Y110.864 E.00227
G1 X153.136 Y115.018 E.04753
G1 X153.136 Y114.738 E.00227
G1 X149.262 Y110.864 E.04431
G1 X149.543 Y110.864 E.00227
G1 X153.136 Y114.457 E.0411
G1 X153.136 Y114.176 E.00227
G1 X149.824 Y110.864 E.03789
G1 X150.105 Y110.864 E.00227
G1 X153.136 Y113.895 E.03468
G1 X153.136 Y113.614 E.00227
G1 X150.386 Y110.864 E.03146
G1 X150.666 Y110.864 E.00227
G1 X153.136 Y113.334 E.02825
G1 X153.136 Y113.053 E.00227
G1 X150.947 Y110.864 E.02504
G1 X151.228 Y110.864 E.00227
G1 X153.136 Y112.772 E.02183
G1 X153.136 Y112.491 E.00227
G1 X151.509 Y110.864 E.01861
G1 X151.79 Y110.864 E.00227
G1 X153.136 Y112.21 E.0154
G1 X153.136 Y111.929 E.00227
G1 X152.071 Y110.864 E.01219
G1 X152.351 Y110.864 E.00227
G1 X153.136 Y111.649 E.00897
G1 X153.136 Y111.368 E.00227
G1 X152.632 Y110.864 E.00576
G1 X152.913 Y110.864 E.00227
G1 X153.225 Y111.176 E.00357
; WIPE_START
G1 X152.913 Y110.864 E-.08387
G1 X152.632 Y110.864 E-.05335
G1 X153.136 Y111.368 E-.13531
G1 X153.136 Y111.649 E-.05335
G1 X152.934 Y111.447 E-.05412
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X152.302 Y119.053 Z.9 F60000
G1 X152.029 Y122.336 Z.9
G1 Z.5
G1 E.4 F1800
G1 F6043.513
M204 S8000
G1 X151.928 Y122.235 E.00116
G1 X152.108 Y122.134 E.00167
G1 X152.286 Y122.312 E.00204
M204 S10000
G1 X153.225 Y121.005 F60000
G1 F6043.513
M204 S8000
G1 X152.733 Y120.513 E.00563
G1 X152.834 Y120.731 E.00194
G1 X152.843 Y120.904 E.0014
G1 X153.136 Y121.196 E.00335
G1 X153.136 Y121.477 E.00227
G1 X152.855 Y121.196 E.00321
G1 X152.844 Y121.318 E.00099
G1 X152.799 Y121.421 E.00091
G1 X153.136 Y121.758 E.00385
G1 X153.136 Y122.039 E.00227
G1 X152.713 Y121.616 E.00484
G1 X152.684 Y121.681 E.00058
G1 X152.601 Y121.784 E.00107
G1 X153.136 Y122.319 E.00612
G1 X153.136 Y122.6 E.00227
G1 X152.457 Y121.922 E.00776
G1 X152.288 Y122.033 E.00164
G1 X153.136 Y122.881 E.0097
G1 X153.136 Y123.162 E.00227
G1 X152.8 Y122.826 E.00384
G1 X152.864 Y122.967 E.00125
G1 X152.864 Y123.171 E.00165
G1 X153.136 Y123.443 E.00311
G1 X153.136 Y123.723 E.00227
G1 X152.864 Y123.452 E.00311
G1 X152.864 Y123.733 E.00227
G1 X153.136 Y124.004 E.00311
G1 X153.136 Y124.285 E.00227
G1 X152.864 Y124.014 E.00311
G1 X152.864 Y124.294 E.00227
G1 X153.136 Y124.566 E.00311
G1 X153.136 Y124.847 E.00227
G1 X152.864 Y124.575 E.00311
G1 X152.864 Y124.856 E.00227
G1 X153.136 Y125.127 E.00311
G1 X153.136 Y125.408 E.00227
G1 X152.864 Y125.137 E.00311
G1 X152.864 Y125.418 E.00227
G1 X153.136 Y125.689 E.00311
G1 X153.136 Y125.97 E.00227
G1 X152.864 Y125.698 E.00311
G1 X152.864 Y125.979 E.00227
G1 X153.136 Y126.251 E.00311
G1 X153.136 Y126.531 E.00227
G1 X152.864 Y126.26 E.00311
G1 X152.864 Y126.541 E.00227
G1 X153.136 Y126.812 E.00311
G1 X153.136 Y127.093 E.00227
G1 X152.864 Y126.822 E.00311
G1 X152.864 Y127.102 E.00227
G1 X153.136 Y127.374 E.00311
G1 X153.136 Y127.655 E.00227
G1 X152.864 Y127.383 E.00311
G1 X152.864 Y127.664 E.00227
G1 X153.136 Y127.935 E.00311
G1 X153.136 Y128.216 E.00227
G1 X152.864 Y127.945 E.00311
G1 X152.864 Y128.226 E.00227
G1 X153.136 Y128.497 E.00311
G1 X153.136 Y128.778 E.00227
G1 X152.864 Y128.506 E.00311
G1 X152.864 Y128.787 E.00227
G1 X153.136 Y129.059 E.00311
G1 X153.136 Y129.339 E.00227
G1 X152.86 Y129.064 E.00316
G1 X152.851 Y129.164 E.00081
G1 X152.796 Y129.281 E.00105
G1 X153.136 Y129.62 E.00388
G1 X153.136 Y129.901 E.00227
G1 X152.706 Y129.472 E.00491
G1 X152.663 Y129.565 E.00084
G1 X152.576 Y129.622 E.00084
G1 X153.136 Y130.182 E.0064
G1 X153.136 Y130.463 E.00227
G1 X152.407 Y129.734 E.00833
G1 X152.27 Y129.826 E.00134
G1 X152.225 Y129.832 E.00037
G1 X153.136 Y130.743 E.01042
G1 X153.136 Y131.024 E.00227
G1 X151.976 Y129.864 E.01327
G1 X151.695 Y129.864 E.00227
G1 X152.966 Y131.136 E.01455
G1 X152.686 Y131.136 E.00227
G1 X151.414 Y129.864 E.01455
G1 X151.133 Y129.864 E.00227
G1 X152.405 Y131.136 E.01455
G1 X152.124 Y131.136 E.00227
G1 X150.852 Y129.864 E.01455
G1 X150.572 Y129.864 E.00227
G1 X151.843 Y131.136 E.01455
G1 X151.562 Y131.136 E.00227
G1 X150.291 Y129.864 E.01455
G1 X150.01 Y129.864 E.00227
G1 X151.281 Y131.136 E.01455
G1 X151.001 Y131.136 E.00227
G1 X149.729 Y129.864 E.01455
G1 X149.448 Y129.864 E.00227
G1 X150.72 Y131.136 E.01455
G1 X150.439 Y131.136 E.00227
G1 X149.168 Y129.864 E.01455
G1 X148.887 Y129.864 E.00227
G1 X150.158 Y131.136 E.01455
G1 X149.877 Y131.136 E.00227
G1 X148.606 Y129.864 E.01455
G1 X148.325 Y129.864 E.00227
G1 X149.597 Y131.136 E.01455
G1 X149.316 Y131.136 E.00227
G1 X148.044 Y129.864 E.01455
G1 X147.764 Y129.864 E.00227
G1 X149.035 Y131.136 E.01455
G1 X148.754 Y131.136 E.00227
G1 X147.483 Y129.864 E.01455
G1 X147.202 Y129.864 E.00227
G1 X148.473 Y131.136 E.01455
G1 X148.193 Y131.136 E.00227
G1 X146.921 Y129.864 E.01455
G1 X146.64 Y129.864 E.00227
G1 X147.912 Y131.136 E.01455
G1 X147.631 Y131.136 E.00227
G1 X146.36 Y129.864 E.01455
G1 X146.079 Y129.864 E.00227
G1 X147.35 Y131.136 E.01455
G1 X147.069 Y131.136 E.00227
G1 X145.798 Y129.864 E.01455
G1 X145.517 Y129.864 E.00227
G1 X146.789 Y131.136 E.01455
G1 X146.508 Y131.136 E.00227
G1 X145.236 Y129.864 E.01455
G1 X144.956 Y129.864 E.00227
G1 X146.227 Y131.136 E.01455
G1 X145.946 Y131.136 E.00227
G1 X144.675 Y129.864 E.01455
G1 X144.394 Y129.864 E.00227
G1 X145.665 Y131.136 E.01455
G1 X145.385 Y131.136 E.00227
G1 X144.113 Y129.864 E.01455
G1 X143.832 Y129.864 E.00227
G1 X145.104 Y131.136 E.01455
G1 X144.823 Y131.136 E.00227
G1 X143.552 Y129.864 E.01455
G1 X143.271 Y129.864 E.00227
G1 X144.542 Y131.136 E.01455
G1 X144.261 Y131.136 E.00227
G1 X142.946 Y129.82 E.01505
G1 X142.689 Y129.751 E.00215
G1 X142.405 Y129.483 E.00316
G1 X142.272 Y129.147 E.00293
G1 X141.774 Y128.649 E.0057
G1 X141.947 Y128.54 E.00165
G1 X142.269 Y128.862 E.00368
G1 X142.267 Y128.698 E.00133
G1 X142.312 Y128.625 E.0007
G1 X142.119 Y128.432 E.00221
G1 X142.291 Y128.323 E.00165
G1 X142.419 Y128.451 E.00146
G1 X142.532 Y128.283 E.00164
G1 X142.464 Y128.215 E.00078
G1 X142.636 Y128.107 E.00165
G1 X142.698 Y128.168 E.0007
G1 X142.864 Y128.053 E.00163
G1 X142.744 Y127.933 E.00137
; WIPE_START
G1 X142.864 Y128.053 E-.03215
G1 X142.698 Y128.168 E-.03834
G1 X142.636 Y128.107 E-.01654
G1 X142.464 Y128.215 E-.03869
G1 X142.532 Y128.283 E-.01834
G1 X142.419 Y128.451 E-.03844
G1 X142.291 Y128.323 E-.03429
G1 X142.119 Y128.432 E-.0387
G1 X142.312 Y128.625 E-.05185
G1 X142.267 Y128.698 E-.01643
G1 X142.269 Y128.862 E-.03114
G1 X142.175 Y128.769 E-.0251
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X144.07 Y131.225 Z.9 F60000
G1 Z.5
G1 E.4 F1800
G1 F6043.513
M204 S8000
G1 X141.602 Y128.757 E.02824
G1 X141.429 Y128.865 E.00165
G1 X143.7 Y131.136 E.02598
G1 X143.419 Y131.136 E.00227
G1 X141.257 Y128.974 E.02474
G1 X141.084 Y129.082 E.00165
G1 X143.138 Y131.136 E.0235
G1 X142.857 Y131.136 E.00227
G1 X140.912 Y129.19 E.02226
G1 X140.74 Y129.299 E.00165
G1 X142.576 Y131.136 E.02102
G1 X142.296 Y131.136 E.00227
G1 X140.567 Y129.407 E.01978
G1 X140.395 Y129.516 E.00165
G1 X142.015 Y131.136 E.01854
G1 X141.734 Y131.136 E.00227
G1 X140.222 Y129.624 E.0173
G1 X140.05 Y129.732 E.00165
G1 X141.453 Y131.136 E.01606
G1 X141.172 Y131.136 E.00227
G1 X139.877 Y129.841 E.01482
G1 X139.859 Y129.853 E.00018
G1 X139.834 Y130.078 E.00184
G1 X140.892 Y131.136 E.0121
G1 X140.611 Y131.136 E.00227
G1 X139.745 Y130.27 E.00991
G1 X139.644 Y130.45 E.00167
G1 X140.33 Y131.136 E.00784
G1 X140.049 Y131.136 E.00227
G1 X139.507 Y130.594 E.0062
G1 X139.326 Y130.693 E.00167
G1 X139.768 Y131.136 E.00506
G1 X139.488 Y131.136 E.00227
G1 X139.145 Y130.793 E.00392
G1 X139.049 Y130.846 E.00089
G1 X138.917 Y130.846 E.00107
G1 X139.207 Y131.136 E.00331
G1 X138.926 Y131.136 E.00227
G1 X138.637 Y130.846 E.00331
G1 X138.356 Y130.847 E.00227
G1 X138.645 Y131.136 E.00331
G1 X138.364 Y131.136 E.00227
G1 X138.075 Y130.847 E.00331
G1 X137.795 Y130.847 E.00227
G1 X138.084 Y131.136 E.0033
G1 X137.803 Y131.136 E.00227
G1 X137.514 Y130.847 E.0033
G1 X137.234 Y130.848 E.00227
G1 X137.522 Y131.136 E.0033
G1 X137.241 Y131.136 E.00227
G1 X136.953 Y130.848 E.00329
G1 X136.673 Y130.848 E.00227
G1 X136.96 Y131.136 E.00329
G1 X136.68 Y131.136 E.00227
G1 X136.392 Y130.848 E.00329
G1 X136.112 Y130.849 E.00227
G1 X136.399 Y131.136 E.00328
G1 X136.118 Y131.136 E.00227
G1 X135.831 Y130.849 E.00328
G1 X135.551 Y130.849 E.00227
G1 X135.837 Y131.136 E.00328
G1 X135.556 Y131.136 E.00227
G1 X135.27 Y130.849 E.00328
G1 X134.99 Y130.85 E.00227
G1 X135.276 Y131.136 E.00327
G1 X134.995 Y131.136 E.00227
G1 X134.709 Y130.85 E.00327
G1 X134.428 Y130.85 E.00227
G1 X134.714 Y131.136 E.00327
G1 X134.433 Y131.136 E.00227
G1 X134.148 Y130.85 E.00326
G1 X133.867 Y130.851 E.00227
G1 X134.152 Y131.136 E.00326
G1 X133.871 Y131.136 E.00227
G1 X133.587 Y130.851 E.00326
G1 X133.306 Y130.851 E.00227
G1 X133.591 Y131.136 E.00325
G1 X133.31 Y131.136 E.00227
G1 X133.026 Y130.852 E.00325
G1 X132.745 Y130.852 E.00227
G1 X133.029 Y131.136 E.00325
G1 X132.748 Y131.136 E.00227
G1 X132.465 Y130.852 E.00325
G1 X132.184 Y130.852 E.00227
G1 X132.467 Y131.136 E.00324
G1 X132.187 Y131.136 E.00227
G1 X131.904 Y130.853 E.00324
G1 X131.623 Y130.853 E.00227
G1 X131.906 Y131.136 E.00324
G1 X131.625 Y131.136 E.00227
G1 X131.342 Y130.853 E.00323
G1 X131.062 Y130.853 E.00227
G1 X131.344 Y131.136 E.00323
G1 X131.063 Y131.136 E.00227
G1 X130.781 Y130.854 E.00323
G1 X130.501 Y130.854 E.00227
G1 X130.783 Y131.136 E.00322
G1 X130.502 Y131.136 E.00227
G1 X130.22 Y130.854 E.00322
G1 X129.94 Y130.854 E.00227
G1 X130.221 Y131.136 E.00322
G1 X129.94 Y131.136 E.00227
G1 X129.659 Y130.855 E.00322
G1 X129.379 Y130.855 E.00227
G1 X129.659 Y131.136 E.00321
G1 X129.379 Y131.136 E.00227
G1 X129.098 Y130.855 E.00321
G1 X128.818 Y130.855 E.00227
G1 X129.098 Y131.136 E.00321
G1 X128.817 Y131.136 E.00227
G1 X128.537 Y130.856 E.0032
G1 X128.256 Y130.856 E.00227
G1 X128.536 Y131.136 E.0032
G1 X128.255 Y131.136 E.00227
G1 X127.976 Y130.856 E.0032
G1 X127.695 Y130.857 E.00227
G1 X127.975 Y131.136 E.00319
G1 X127.694 Y131.136 E.00227
G1 X127.415 Y130.857 E.00319
G1 X127.134 Y130.857 E.00227
G1 X127.413 Y131.136 E.00319
M73 P87 R2
G1 X127.132 Y131.136 E.00227
G1 X126.854 Y130.857 E.00319
G1 X126.573 Y130.858 E.00227
G1 X126.941 Y131.225 E.0042
; WIPE_START
G1 X126.573 Y130.858 E-.09875
G1 X126.854 Y130.857 E-.0533
G1 X127.132 Y131.136 E-.07481
G1 X127.413 Y131.136 E-.05335
G1 X127.134 Y130.857 E-.07488
G1 X127.265 Y130.857 E-.0249
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X124.209 Y130.898 Z.9 F60000
G1 Z.5
G1 E.4 F1800
; LINE_WIDTH: 0.21986
G1 F6048.388
M204 S8000
G1 X122.176 Y130.898 E.01643
G1 X122.374 Y131.096 E.00227
G1 X124.105 Y131.096 E.01399
G1 X124.141 Y130.964 E.0011
G1 X124.188 Y130.919 E.00053
; WIPE_START
G1 X124.141 Y130.964 E-.01244
G1 X124.105 Y131.096 E-.02593
G1 X122.374 Y131.096 E-.32878
G1 X122.327 Y131.048 E-.01286
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X127.615 Y125.544 Z.9 F60000
G1 X140.187 Y112.459 Z.9
G1 Z.5
G1 E.4 F1800
; LINE_WIDTH: 0.22002
G1 F6043.513
M204 S8000
G1 X139.756 Y112.028 E.00493
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.1
; WIPE_START
G1 F6043.513
G1 X140.187 Y112.459 E-.38
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 5887
M625
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 6/7
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change

; OBJECT_ID: 5909
; COOLING_NODE: 0
; start printing object, unique label id: 5909
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z.9 I-.728 J.975 P1  F60000
G1 X164.614 Y130.699 Z.9
G1 Z.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.21999
G1 F6044.427
M204 S8000
G1 X164.671 Y130.699 E.00046
G1 X164.308 Y131.054 E.00411
G1 X164.294 Y131.294 E.00194
G1 X162.692 Y131.294 E.01296
G1 X162.292 Y131.294 E.00324
G1 F5151.064
G1 X162.205 Y131.207 E.001
; LINE_WIDTH: 0.267335
G1 F4880.529
G1 X161.941 Y130.91 E.00399
; LINE_WIDTH: 0.31468
G1 F4092.491
G1 X161.677 Y130.612 E.00476
G1 X161.89 Y130.655 E.0026
; LINE_WIDTH: 0.267335
G1 F4535.038
G1 X162.103 Y130.699 E.00218
; LINE_WIDTH: 0.21999
G1 F5408.053
G1 X162.503 Y130.699 E.00324
G1 F6044.427
G1 X162.903 Y130.699 E.00324
G1 X164.614 Y130.699 E.01384
; COOLING_NODE: 0
; WIPE_START
G1 X164.671 Y130.699 E-.01075
G1 X164.308 Y131.054 E-.09654
G1 X164.294 Y131.294 E-.04566
G1 X163.099 Y131.294 E-.22705
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X170.69 Y130.499 Z1 F60000
G1 X182.484 Y129.264 Z1
G1 Z.6
G1 E.4 F1800
G1 F6044.427
M204 S8000
G1 X182.427 Y129.127 E.0012
G1 X182.422 Y128.741 E.00312
G1 X182.626 Y128.41 E.00314
G1 F5247.982
G1 X182.985 Y128.162 E.00353
; LINE_WIDTH: 0.266815
G1 F4313.496
G1 X183.055 Y128.087 E.00103
; LINE_WIDTH: 0.31364
G1 F4107.057
G1 X183.126 Y128.012 E.00122
G1 X184.797 Y126.914 E.02381
; LINE_WIDTH: 0.2868
G1 F4522.499
G1 X186.469 Y125.816 E.02162
; LINE_WIDTH: 0.25996
G1 F5031.447
G1 X188.14 Y124.717 E.01943
; LINE_WIDTH: 0.23312
G1 F5669.47
G1 X188.474 Y124.498 E.00345
G1 X189.812 Y123.619 E.0138
; LINE_WIDTH: 0.20628
G1 F6492.804
G1 X190.146 Y123.4 E.00301
G1 X191.483 Y122.521 E.01205
; LINE_WIDTH: 0.17944
G1 F6725.071
G1 X191.637 Y122.42 E.00119
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X192.329 Y122.362 E.00562
G1 X192.468 Y122.457 E.00136
G1 X192.706 Y122.98 E.00465
G1 X192.706 Y129.011 E.04878
G1 X192.695 Y129.131 E.00097
G1 X192.54 Y129.461 E.00295
G1 X192.131 Y129.695 E.00382
G1 X192.011 Y129.706 E.00097
G1 X183.118 Y129.706 E.07194
G1 X182.769 Y129.612 E.00292
G1 X182.538 Y129.394 E.00257
G1 X182.484 Y129.264 E.00114
; COOLING_NODE: 0
; WIPE_START
G1 X182.427 Y129.127 E-.02814
G1 X182.422 Y128.741 E-.07335
G1 X182.626 Y128.41 E-.07386
G1 X182.985 Y128.162 E-.08298
G1 X183.055 Y128.087 E-.01951
G1 X183.126 Y128.012 E-.01951
G1 X183.489 Y127.773 E-.08264
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X175.99 Y129.195 Z1 F60000
G1 X168.06 Y130.699 Z1
G1 Z.6
G1 E.4 F1800
G1 F6044.427
M204 S8000
G1 X179.017 Y130.689 E.08863
G1 X179.412 Y130.471 E.00365
G1 X179.676 Y130.071 E.00387
G1 X179.704 Y129.762 E.00251
G1 X182.095 Y128.259 E.02285
G1 X182.434 Y128.046 E.00324
G1 F5165.867
G1 X182.773 Y127.834 E.00324
; LINE_WIDTH: 0.266815
G1 F4313.494
G1 X182.87 Y127.8 E.00103
; LINE_WIDTH: 0.31364
G1 F4107.057
G1 X182.967 Y127.767 E.00122
G1 X184.653 Y126.691 E.02381
; LINE_WIDTH: 0.2868
G1 F4522.499
G1 X186.339 Y125.615 E.02162
; LINE_WIDTH: 0.25996
G1 F5031.447
G1 X188.025 Y124.54 E.01943
; LINE_WIDTH: 0.23312
G1 F5669.47
G1 X188.362 Y124.325 E.00345
G1 X189.711 Y123.464 E.0138
; LINE_WIDTH: 0.20628
G1 F6492.804
G1 X190.048 Y123.249 E.00301
G1 X191.397 Y122.388 E.01205
; LINE_WIDTH: 0.17944
G1 F6961.406
G1 X191.553 Y122.289 E.00119
; LINE_WIDTH: 0.17697
G1 F6987.496
G1 X191.57 Y122.278 E.00013
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X192.307 Y121.84 E.00694
G1 X192.488 Y121.676 E.00198
G1 X192.688 Y121.285 E.00355
G1 X192.676 Y120.751 E.00432
G1 X192.463 Y120.289 E.00412
G1 X192.306 Y120.159 E.00164
G1 X179.704 Y112.238 E.1204
G1 X179.676 Y111.929 E.00251
G1 X179.522 Y111.65 E.00258
G1 X179.41 Y111.528 E.00134
G1 X178.897 Y111.301 E.00454
G1 X162.148 Y111.294 E.13548
G1 X161.882 Y111.347 E.0022
G1 X161.544 Y111.544 E.00316
G1 X161.394 Y111.769 E.00219
G1 X161.294 Y112.148 E.00316
G1 X161.294 Y129.586 E.14105
G1 X161.327 Y130.062 E.00386
; LINE_WIDTH: 0.253595
G1 F4977.943
G1 X161.415 Y130.26 E.00205
; LINE_WIDTH: 0.2872
G1 F4515.692
G1 X161.503 Y130.458 E.00235
G1 X161.365 Y130.344 E.00193
; LINE_WIDTH: 0.253595
G1 F4895.01
G1 X161.228 Y130.23 E.00169
; LINE_WIDTH: 0.21999
G1 F5800.516
G1 X160.945 Y129.947 E.00324
G1 F6044.427
G1 X160.706 Y129.708 E.00274
G1 X160.706 Y110.706 E.15371
G1 X193.294 Y110.706 E.26361
G1 X193.294 Y114.291 E.029
G1 X193.294 Y131.294 E.13754
G1 X168.506 Y131.294 E.20051
G1 X168.492 Y131.054 E.00194
G1 X168.06 Y130.699 E.00453
; COOLING_NODE: 0
; WIPE_START
G1 X170.06 Y130.697 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X165.94 Y130.758 Z1 F60000
G1 Z.6
G1 E.4 F1800
G1 F6044.427
M204 S8000
G1 X165.811 Y130.694 E.00116
; LINE_WIDTH: 0.2214
G1 F6001.801
G1 X164.903 Y130.7 E.00739
G1 X164.502 Y131.093 E.00458
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X164.493 Y131.493 E.00324
G1 X162.21 Y131.493 E.01847
G1 X160.507 Y129.79 E.01948
G1 X160.507 Y110.507 E.15598
G1 X193.493 Y110.507 E.26682
G1 X193.493 Y114.291 E.03061
G1 X193.493 Y131.493 E.13914
G1 X168.307 Y131.493 E.20372
G1 X168.298 Y131.093 E.00324
G1 X167.811 Y130.694 E.00509
; LINE_WIDTH: 0.2214
G1 F6001.801
G1 X166.903 Y130.7 E.00739
G1 X166.594 Y130.89 E.00296
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X166.525 Y131.014 E.00114
G1 X166.496 Y131.496 E.00391
; LINE_WIDTH: 0.21367
G1 F6243.172
G1 X166.304 Y131.496 E.00151
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X166.275 Y131.014 E.00391
G1 X166.206 Y130.89 E.00114
G1 X165.94 Y130.758 E.0024
; COOLING_NODE: 0
M204 S10000
G1 X165.876 Y130.924 F60000
G1 F6044.427
M204 S8000
G1 X165.811 Y130.891 E.00059
G1 X164.938 Y130.896 E.00706
G1 X164.697 Y131.131 E.00272
G1 X164.691 Y131.691 E.00453
G1 X162.128 Y131.691 E.02074
G1 X160.309 Y129.872 E.02081
G1 X160.309 Y110.309 E.15825
G1 X193.691 Y110.309 E.27003
G1 X193.691 Y114.291 E.03222
G1 X193.691 Y131.691 E.14075
; object ids of layer 6 start: 5887,5909
M624 AwAAAAAAAAA=
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

; object ids of this layer6 end: 5887,5909
M625
G1 X168.109 Y131.691 E.20694
G1 X168.103 Y131.131 E.00453
G1 X167.811 Y130.891 E.00306
G1 X166.989 Y130.891 E.00664
G1 X166.752 Y131.01 E.00215
G1 X166.691 Y131.189 E.00153
G1 X166.691 Y131.691 E.00406
G1 X166.109 Y131.691 E.00472
G1 X166.109 Y131.189 E.00406
G1 X166.048 Y131.01 E.00153
G1 X165.876 Y130.924 E.00156
; COOLING_NODE: 0
M204 S250
G1 X165.811 Y131.09 F60000
; FEATURE: Outer wall
G1 F6044.427
M204 S5000
G1 X164.989 Y131.09 E.00664
G1 X164.89 Y131.189 E.00114
G1 X164.89 Y131.89 E.00567
G1 X162.046 Y131.89 E.02301
G1 X160.11 Y129.954 E.02214
G1 X160.11 Y110.11 E.16052
G1 X193.89 Y110.11 E.27324
G1 X193.89 Y114.291 E.03382
G1 X193.89 Y131.89 E.14235
G1 X167.91 Y131.89 E.21015
G1 X167.91 Y131.189 E.00567
G1 X167.811 Y131.09 E.00114
G1 X166.989 Y131.09 E.00664
G1 X166.91 Y131.129 E.00071
G1 X166.89 Y131.189 E.00051
G1 X166.89 Y131.89 E.00567
G1 X165.91 Y131.89 E.00793
G1 X165.904 Y131.154 E.00595
G1 X165.811 Y131.09 E.00091
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X164.989 Y131.09 E-.15608
G1 X164.89 Y131.189 E-.02667
G1 X164.89 Y131.89 E-.13314
G1 X164.553 Y131.89 E-.06411
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X172.101 Y130.762 Z1 F60000
G1 X182.663 Y129.185 Z1
G1 Z.6
G1 E.4 F1800
; FEATURE: Inner wall
G1 F6044.427
M204 S8000
G1 X182.617 Y129.07 E.001
G1 X182.613 Y128.794 E.00223
G1 X182.817 Y128.513 E.00281
G1 X183.095 Y128.327 E.00271
G1 X191.735 Y122.567 E.084
G1 X192.238 Y122.539 E.00407
G1 X192.337 Y122.606 E.00097
G1 X192.507 Y122.98 E.00332
G1 X192.507 Y129.011 E.04878
G1 X192.389 Y129.332 E.00277
G1 X192.096 Y129.5 E.00273
G1 X192.011 Y129.507 E.0007
G1 X183.118 Y129.507 E.07194
G1 X182.869 Y129.44 E.00208
G1 X182.704 Y129.285 E.00184
G1 X182.663 Y129.185 E.00087
; COOLING_NODE: 0
M204 S10000
G1 X182.878 Y129.154 F60000
G1 F6044.427
M204 S8000
G1 X182.832 Y129.097 E.00059
G1 X182.805 Y128.847 E.00204
G1 X182.927 Y128.678 E.00168
G1 X183.205 Y128.492 E.00271
G1 X191.846 Y122.732 E.084
G1 X192.147 Y122.715 E.00244
G1 X192.207 Y122.756 E.00058
G1 X192.309 Y122.98 E.00199
G1 X192.309 Y129.011 E.04878
G1 X192.238 Y129.204 E.00166
G1 X192.062 Y129.304 E.00164
G1 X192.011 Y129.309 E.00042
G1 X183.118 Y129.309 E.07194
G1 X182.968 Y129.268 E.00125
G1 X182.878 Y129.154 E.00118
; COOLING_NODE: 1
M204 S250
G1 X183.023 Y129.039 F60000
; FEATURE: Outer wall
G1 F6044.427
M204 S5000
G1 X182.996 Y128.9 E.00115
G1 X183.316 Y128.657 E.00324
G1 X191.958 Y122.896 E.08402
G1 X192.076 Y122.905 E.00096
G1 X192.11 Y122.98 E.00066
G1 X192.11 Y129.011 E.04878
G1 X192.04 Y129.105 E.00095
G1 X183.118 Y129.11 E.07218
G1 X183.023 Y129.039 E.00096
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X182.996 Y128.9 E-.02707
G1 X183.316 Y128.657 E-.07614
G1 X184.528 Y127.849 E-.27679
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X182.176 Y120.588 Z1 F60000
G1 X179.507 Y112.348 Z1
G1 Z.6
G1 E.4 F1800
; FEATURE: Inner wall
G1 F6044.427
M204 S8000
G1 X192.201 Y120.327 E.12128
G1 X192.325 Y120.432 E.00132
G1 X192.478 Y120.763 E.00294
G1 X192.493 Y121.251 E.00395
G1 X192.331 Y121.555 E.00278
G1 X192.201 Y121.672 E.00141
G1 X179.507 Y129.652 E.12128
G1 X179.485 Y130.017 E.00296
G1 X179.265 Y130.337 E.00314
G1 X178.983 Y130.493 E.00261
G1 X167.811 Y130.499 E.09037
; LINE_WIDTH: 0.21691
G1 F6139.678
G1 X166.989 Y130.499 E.00654
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X165.811 Y130.499 E.00953
; LINE_WIDTH: 0.21691
G1 F6139.678
G1 X164.989 Y130.499 E.00654
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X162.103 Y130.501 E.02335
G1 X161.811 Y130.406 E.00248
G1 X161.667 Y130.293 E.00148
G1 X161.516 Y130.002 E.00266
G1 X161.493 Y129.586 E.00337
G1 X161.493 Y112.148 E.14105
G1 X161.577 Y111.846 E.00254
G1 X161.685 Y111.685 E.00156
G1 X161.958 Y111.531 E.00253
G1 X162.148 Y111.493 E.00157
G1 X178.897 Y111.499 E.13548
G1 X179.263 Y111.662 E.00324
G1 X179.485 Y111.983 E.00316
G1 X179.507 Y112.348 E.00296
; COOLING_NODE: 1
M204 S10000
M73 P88 R2
G1 X179.31 Y112.459 F60000
G1 F6044.427
M204 S8000
G1 X192.095 Y120.495 E.12215
G1 X192.188 Y120.576 E.001
G1 X192.28 Y120.774 E.00176
G1 X192.297 Y121.217 E.00359
G1 X192.151 Y121.459 E.00229
G1 X179.31 Y129.541 E.12274
G1 X179.294 Y129.963 E.00341
G1 X179.118 Y130.204 E.00242
G1 X178.897 Y130.302 E.00195
G1 X166.989 Y130.302 E.09632
G1 X162.103 Y130.302 E.03952
G1 X161.843 Y130.183 E.00231
G1 X161.734 Y130.032 E.0015
G1 X161.691 Y129.852 E.0015
G1 X161.691 Y112.148 E.1432
G1 X161.761 Y111.922 E.00191
G1 X161.922 Y111.761 E.00184
G1 X162.148 Y111.691 E.00191
G1 X178.897 Y111.698 E.13548
G1 X179.117 Y111.795 E.00195
G1 X179.294 Y112.037 E.00243
G1 X179.31 Y112.459 E.00342
; COOLING_NODE: 2
M204 S250
G1 X179.112 Y112.569 F60000
; FEATURE: Outer wall
G1 F6044.427
M204 S5000
G1 X191.989 Y120.663 E.12303
G1 X192.081 Y120.785 E.00124
G1 X192.083 Y121.226 E.00356
G1 X191.99 Y121.336 E.00116
G1 X179.112 Y129.431 E.12303
G1 X179.081 Y129.948 E.0042
G1 X178.897 Y130.104 E.00195
G1 X166.989 Y130.104 E.09632
G1 X162.103 Y130.104 E.03952
G1 X161.948 Y130.013 E.00145
G1 X161.89 Y129.852 E.00138
G1 X161.89 Y112.148 E.1432
G1 X161.966 Y111.965 E.0016
G1 X162.148 Y111.89 E.0016
G1 X178.896 Y111.896 E.13548
G1 X179.081 Y112.051 E.00195
G1 X179.112 Y112.569 E.0042
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X180.806 Y113.634 E-.38
; WIPE_END
M73 P88 R1
G1 E-.02 F1800
M204 S10000
G1 X175.888 Y119.471 Z1 F60000
G1 X166.418 Y130.712 Z1
G1 Z.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.3083
G1 F4183.517
M204 S8000
G1 X166.364 Y130.743 E.00073
G1 X166.418 Y130.774 E.00073
G1 X166.436 Y130.743 E.00042
; COOLING_NODE: 2
; WIPE_START
G1 X166.418 Y130.774 E-.08514
G1 X166.364 Y130.743 E-.14743
G1 X166.418 Y130.712 E-.14743
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X161.677 Y130.612 Z1 F60000
G1 Z.6
G1 E.4 F1800
; LINE_WIDTH: 0.31468
G1 F4092.491
M204 S8000
G1 X161.503 Y130.458 E.00278
M204 S10000
G1 X161.225 Y129.596 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.22057
G1 F6026.819
M204 S8000
G1 X161.022 Y129.799 E.00233
G1 X160.881 Y129.658 E.00162
G1 X161.136 Y129.403 E.00293
G1 X161.136 Y129.122 E.00228
G1 X160.864 Y129.393 E.00311
G1 X160.864 Y129.112 E.00228
G1 X161.136 Y128.84 E.00311
G1 X161.136 Y128.559 E.00228
G1 X160.864 Y128.83 E.00311
G1 X160.864 Y128.548 E.00228
G1 X161.136 Y128.277 E.00311
G1 X161.136 Y127.995 E.00228
G1 X160.864 Y128.267 E.00311
G1 X160.864 Y127.985 E.00228
G1 X161.136 Y127.714 E.00311
G1 X161.136 Y127.432 E.00228
G1 X160.864 Y127.704 E.00311
G1 X160.864 Y127.422 E.00228
G1 X161.136 Y127.151 E.00311
G1 X161.136 Y126.869 E.00228
G1 X160.864 Y127.14 E.00311
G1 X160.864 Y126.859 E.00228
G1 X161.136 Y126.587 E.00311
G1 X161.136 Y126.306 E.00228
G1 X160.864 Y126.577 E.00311
G1 X160.864 Y126.296 E.00228
G1 X161.136 Y126.024 E.00311
G1 X161.136 Y125.743 E.00228
G1 X160.864 Y126.014 E.00311
G1 X160.864 Y125.733 E.00228
G1 X161.136 Y125.461 E.00311
G1 X161.136 Y125.18 E.00228
G1 X160.864 Y125.451 E.00311
G1 X160.864 Y125.169 E.00228
G1 X161.136 Y124.898 E.00311
G1 X161.136 Y124.616 E.00228
G1 X160.864 Y124.888 E.00311
G1 X160.864 Y124.606 E.00228
G1 X161.136 Y124.335 E.00311
G1 X161.136 Y124.053 E.00228
G1 X160.864 Y124.325 E.00311
G1 X160.864 Y124.043 E.00228
G1 X161.136 Y123.772 E.00311
G1 X161.136 Y123.49 E.00228
G1 X160.864 Y123.761 E.00311
G1 X160.864 Y123.48 E.00228
G1 X161.136 Y123.208 E.00311
G1 X161.136 Y122.927 E.00228
G1 X160.864 Y123.198 E.00311
G1 X160.864 Y122.917 E.00228
G1 X161.136 Y122.645 E.00311
G1 X161.136 Y122.364 E.00228
G1 X160.864 Y122.635 E.00311
G1 X160.864 Y122.354 E.00228
G1 X161.136 Y122.082 E.00311
G1 X161.136 Y121.801 E.00228
G1 X160.864 Y122.072 E.00311
G1 X160.864 Y121.79 E.00228
G1 X161.136 Y121.519 E.00311
G1 X161.136 Y121.237 E.00228
G1 X160.864 Y121.509 E.00311
G1 X160.864 Y121.227 E.00228
G1 X161.136 Y120.956 E.00311
G1 X161.136 Y120.674 E.00228
G1 X160.864 Y120.946 E.00311
G1 X160.864 Y120.664 E.00228
G1 X161.136 Y120.393 E.00311
G1 X161.136 Y120.111 E.00228
G1 X160.864 Y120.382 E.00311
G1 X160.864 Y120.101 E.00228
G1 X161.136 Y119.829 E.00311
G1 X161.136 Y119.548 E.00228
G1 X160.864 Y119.819 E.00311
G1 X160.864 Y119.538 E.00228
G1 X161.136 Y119.266 E.00311
G1 X161.136 Y118.985 E.00228
G1 X160.864 Y119.256 E.00311
G1 X160.864 Y118.975 E.00228
G1 X161.136 Y118.703 E.00311
G1 X161.136 Y118.422 E.00228
G1 X160.864 Y118.693 E.00311
G1 X160.864 Y118.411 E.00228
G1 X161.136 Y118.14 E.00311
G1 X161.136 Y117.858 E.00228
G1 X160.864 Y118.13 E.00311
G1 X160.864 Y117.848 E.00228
G1 X161.136 Y117.577 E.00311
G1 X161.136 Y117.295 E.00228
G1 X160.864 Y117.567 E.00311
G1 X160.864 Y117.285 E.00228
G1 X161.136 Y117.014 E.00311
G1 X161.136 Y116.732 E.00228
G1 X160.864 Y117.003 E.00311
G1 X160.864 Y116.722 E.00228
G1 X161.136 Y116.45 E.00311
G1 X161.136 Y116.169 E.00228
G1 X160.864 Y116.44 E.00311
G1 X160.864 Y116.159 E.00228
G1 X161.136 Y115.887 E.00311
G1 X161.136 Y115.606 E.00228
G1 X160.864 Y115.877 E.00311
G1 X160.864 Y115.595 E.00228
G1 X161.136 Y115.324 E.00311
G1 X161.136 Y115.043 E.00228
G1 X160.864 Y115.314 E.00311
G1 X160.864 Y115.032 E.00228
G1 X161.136 Y114.761 E.00311
G1 X161.136 Y114.479 E.00228
G1 X160.864 Y114.751 E.00311
G1 X160.864 Y114.469 E.00228
G1 X161.136 Y114.198 E.00311
G1 X161.136 Y113.916 E.00228
G1 X160.864 Y114.188 E.00311
G1 X160.864 Y113.906 E.00228
G1 X161.136 Y113.635 E.00311
G1 X161.136 Y113.353 E.00228
G1 X160.864 Y113.624 E.00311
G1 X160.864 Y113.343 E.00228
G1 X161.136 Y113.071 E.00311
G1 X161.136 Y112.79 E.00228
G1 X160.864 Y113.061 E.00311
G1 X160.864 Y112.78 E.00228
G1 X161.136 Y112.508 E.00311
G1 X161.136 Y112.227 E.00228
G1 X160.864 Y112.498 E.00311
G1 X160.864 Y112.216 E.00228
G1 X161.185 Y111.896 E.00368
G1 X161.25 Y111.703 E.00165
G1 X161.431 Y111.431 E.00265
G1 X161.704 Y111.249 E.00266
G1 X161.905 Y111.176 E.00174
G1 X162.217 Y110.864 E.00358
G1 X162.498 Y110.864 E.00228
G1 X162.227 Y111.136 E.00311
G1 X162.508 Y111.136 E.00228
G1 X162.78 Y110.864 E.00312
G1 X163.061 Y110.864 E.00228
G1 X162.79 Y111.136 E.00312
G1 X163.071 Y111.136 E.00228
G1 X163.343 Y110.864 E.00312
G1 X163.624 Y110.864 E.00228
G1 X163.353 Y111.136 E.00312
G1 X163.634 Y111.136 E.00228
G1 X163.906 Y110.864 E.00312
G1 X164.188 Y110.864 E.00228
G1 X163.916 Y111.136 E.00312
G1 X164.197 Y111.136 E.00228
G1 X164.469 Y110.864 E.00312
G1 X164.751 Y110.864 E.00228
G1 X164.478 Y111.137 E.00312
G1 X164.76 Y111.137 E.00228
G1 X165.032 Y110.864 E.00313
G1 X165.314 Y110.864 E.00228
G1 X165.041 Y111.137 E.00313
G1 X165.323 Y111.137 E.00228
G1 X165.596 Y110.864 E.00313
G1 X165.877 Y110.864 E.00228
G1 X165.604 Y111.137 E.00313
G1 X165.886 Y111.137 E.00228
G1 X166.159 Y110.864 E.00313
G1 X166.44 Y110.864 E.00228
G1 X166.167 Y111.137 E.00313
G1 X166.449 Y111.137 E.00228
G1 X166.722 Y110.864 E.00313
G1 X167.003 Y110.864 E.00228
G1 X166.73 Y111.137 E.00313
G1 X167.012 Y111.138 E.00228
G1 X167.285 Y110.864 E.00314
G1 X167.567 Y110.864 E.00228
G1 X167.293 Y111.138 E.00314
G1 X167.575 Y111.138 E.00228
G1 X167.848 Y110.864 E.00314
G1 X168.13 Y110.864 E.00228
G1 X167.856 Y111.138 E.00314
G1 X168.138 Y111.138 E.00228
G1 X168.411 Y110.864 E.00314
G1 X168.693 Y110.864 E.00228
G1 X168.419 Y111.138 E.00314
G1 X168.701 Y111.138 E.00228
G1 X168.975 Y110.864 E.00314
G1 X169.256 Y110.864 E.00228
G1 X168.982 Y111.138 E.00314
G1 X169.264 Y111.138 E.00228
G1 X169.538 Y110.864 E.00315
G1 X169.819 Y110.864 E.00228
G1 X169.545 Y111.139 E.00315
G1 X169.827 Y111.139 E.00228
G1 X170.101 Y110.864 E.00315
G1 X170.382 Y110.864 E.00228
G1 X170.108 Y111.139 E.00315
G1 X170.389 Y111.139 E.00228
G1 X170.664 Y110.864 E.00315
G1 X170.946 Y110.864 E.00228
G1 X170.671 Y111.139 E.00315
G1 X170.952 Y111.139 E.00228
G1 X171.227 Y110.864 E.00315
G1 X171.509 Y110.864 E.00228
G1 X171.234 Y111.139 E.00315
G1 X171.515 Y111.139 E.00228
G1 X171.79 Y110.864 E.00316
G1 X172.072 Y110.864 E.00228
G1 X171.797 Y111.139 E.00316
G1 X172.078 Y111.14 E.00228
G1 X172.354 Y110.864 E.00316
G1 X172.635 Y110.864 E.00228
G1 X172.36 Y111.14 E.00316
G1 X172.641 Y111.14 E.00228
G1 X172.917 Y110.864 E.00316
G1 X173.198 Y110.864 E.00228
G1 X172.923 Y111.14 E.00316
G1 X173.204 Y111.14 E.00228
G1 X173.48 Y110.864 E.00316
G1 X173.761 Y110.864 E.00228
G1 X173.486 Y111.14 E.00316
G1 X173.767 Y111.14 E.00228
G1 X174.043 Y110.864 E.00316
G1 X174.325 Y110.864 E.00228
G1 X174.049 Y111.14 E.00317
G1 X174.33 Y111.14 E.00228
G1 X174.606 Y110.864 E.00317
G1 X174.888 Y110.864 E.00228
G1 X174.612 Y111.14 E.00317
G1 X174.893 Y111.141 E.00228
G1 X175.169 Y110.864 E.00317
G1 X175.451 Y110.864 E.00228
G1 X175.175 Y111.141 E.00317
G1 X175.456 Y111.141 E.00228
G1 X175.733 Y110.864 E.00317
G1 X176.014 Y110.864 E.00228
G1 X175.737 Y111.141 E.00317
G1 X176.019 Y111.141 E.00228
G1 X176.296 Y110.864 E.00317
G1 X176.577 Y110.864 E.00228
G1 X176.3 Y111.141 E.00318
G1 X176.582 Y111.141 E.00228
G1 X176.859 Y110.864 E.00318
G1 X177.14 Y110.864 E.00228
G1 X176.863 Y111.141 E.00318
G1 X177.145 Y111.141 E.00228
G1 X177.422 Y110.864 E.00318
G1 X177.704 Y110.864 E.00228
G1 X177.426 Y111.142 E.00318
G1 X177.708 Y111.142 E.00228
G1 X177.985 Y110.864 E.00318
G1 X178.267 Y110.864 E.00228
G1 X177.989 Y111.142 E.00318
G1 X178.271 Y111.142 E.00228
G1 X178.548 Y110.864 E.00318
G1 X178.83 Y110.864 E.00228
G1 X178.552 Y111.142 E.00319
G1 X178.834 Y111.142 E.00228
G1 X179.112 Y110.864 E.00319
G1 X179.393 Y110.864 E.00228
G1 X179.052 Y111.205 E.00391
G1 X179.247 Y111.292 E.00173
G1 X179.675 Y110.864 E.0049
G1 X179.956 Y110.864 E.00228
G1 X179.443 Y111.378 E.00589
G1 X179.519 Y111.412 E.00068
G1 X179.601 Y111.501 E.00098
G1 X180.238 Y110.864 E.00731
G1 X180.519 Y110.864 E.00228
G1 X179.712 Y111.672 E.00926
G1 X179.813 Y111.853 E.00168
G1 X180.801 Y110.864 E.01134
G1 X181.083 Y110.864 E.00228
G1 X179.853 Y112.094 E.01411
G1 X179.859 Y112.147 E.00044
G1 X179.995 Y112.233 E.00131
G1 X181.364 Y110.864 E.01571
G1 X181.646 Y110.864 E.00228
G1 X180.168 Y112.342 E.01695
G1 X180.341 Y112.451 E.00166
G1 X181.927 Y110.864 E.0182
G1 X182.209 Y110.864 E.00228
G1 X180.514 Y112.559 E.01945
G1 X180.687 Y112.668 E.00166
G1 X182.491 Y110.864 E.02069
G1 X182.772 Y110.864 E.00228
G1 X180.86 Y112.777 E.02194
G1 X181.033 Y112.885 E.00166
G1 X183.054 Y110.864 E.02319
G1 X183.335 Y110.864 E.00228
G1 X181.206 Y112.994 E.02443
G1 X181.378 Y113.103 E.00166
G1 X183.617 Y110.864 E.02568
G1 X183.898 Y110.864 E.00228
G1 X181.551 Y113.211 E.02693
G1 X181.724 Y113.32 E.00166
G1 X184.18 Y110.864 E.02817
G1 X184.462 Y110.864 E.00228
G1 X181.897 Y113.429 E.02942
G1 X182.07 Y113.537 E.00166
G1 X184.743 Y110.864 E.03067
G1 X185.025 Y110.864 E.00228
G1 X182.243 Y113.646 E.03192
G1 X182.416 Y113.755 E.00166
G1 X185.306 Y110.864 E.03316
G1 X185.588 Y110.864 E.00228
G1 X182.589 Y113.863 E.03441
G1 X182.762 Y113.972 E.00166
G1 X185.87 Y110.864 E.03566
G1 X186.151 Y110.864 E.00228
G1 X182.935 Y114.081 E.0369
G1 X183.107 Y114.19 E.00166
G1 X186.433 Y110.864 E.03815
G1 X186.714 Y110.864 E.00228
G1 X183.28 Y114.298 E.0394
G1 X183.453 Y114.407 E.00166
G1 X186.996 Y110.864 E.04064
G1 X187.277 Y110.864 E.00228
G1 X183.626 Y114.516 E.04189
G1 X183.799 Y114.624 E.00166
G1 X187.559 Y110.864 E.04314
G1 X187.841 Y110.864 E.00228
G1 X183.972 Y114.733 E.04438
G1 X184.145 Y114.842 E.00166
G1 X188.122 Y110.864 E.04563
G1 X188.404 Y110.864 E.00228
G1 X184.318 Y114.95 E.04688
G1 X184.491 Y115.059 E.00166
G1 X188.685 Y110.864 E.04812
G1 X188.967 Y110.864 E.00228
G1 X184.664 Y115.168 E.04937
G1 X184.837 Y115.276 E.00166
G1 X189.249 Y110.864 E.05062
G1 X189.53 Y110.864 E.00228
G1 X185.009 Y115.385 E.05187
G1 X185.182 Y115.494 E.00166
G1 X189.812 Y110.864 E.05311
G1 X190.093 Y110.864 E.00228
G1 X185.355 Y115.602 E.05436
G1 X185.528 Y115.711 E.00166
G1 X190.375 Y110.864 E.05561
G1 X190.656 Y110.864 E.00228
G1 X185.701 Y115.82 E.05685
G1 X185.874 Y115.928 E.00166
G1 X190.938 Y110.864 E.0581
G1 X191.22 Y110.864 E.00228
G1 X186.047 Y116.037 E.05935
G1 X186.22 Y116.146 E.00166
G1 X191.501 Y110.864 E.06059
G1 X191.783 Y110.864 E.00228
G1 X186.393 Y116.254 E.06184
G1 X186.566 Y116.363 E.00166
G1 X192.064 Y110.864 E.06309
G1 X192.346 Y110.864 E.00228
G1 X186.738 Y116.472 E.06433
G1 X186.911 Y116.581 E.00166
G1 X192.628 Y110.864 E.06558
G1 X192.909 Y110.864 E.00228
G1 X187.084 Y116.689 E.06683
G1 X187.257 Y116.798 E.00166
G1 X193.136 Y110.919 E.06744
G1 X193.136 Y111.201 E.00228
G1 X187.43 Y116.907 E.06546
G1 X187.603 Y117.015 E.00166
G1 X193.136 Y111.482 E.06348
G1 X193.136 Y111.764 E.00228
G1 X187.776 Y117.124 E.06149
G1 X187.949 Y117.233 E.00166
G1 X193.136 Y112.046 E.05951
G1 X193.136 Y112.327 E.00228
G1 X188.122 Y117.341 E.05753
G1 X188.295 Y117.45 E.00166
G1 X193.136 Y112.609 E.05554
G1 X193.136 Y112.89 E.00228
G1 X188.467 Y117.559 E.05356
G1 X188.64 Y117.667 E.00166
G1 X193.136 Y113.172 E.05157
G1 X193.136 Y113.454 E.00228
G1 X188.813 Y117.776 E.04959
G1 X188.986 Y117.885 E.00166
G1 X193.136 Y113.735 E.04761
G1 X193.136 Y114.017 E.00228
G1 X189.159 Y117.993 E.04562
G1 X189.332 Y118.102 E.00166
G1 X193.136 Y114.298 E.04364
G1 X193.136 Y114.58 E.00228
G1 X189.505 Y118.211 E.04166
G1 X189.678 Y118.319 E.00166
G1 X193.136 Y114.861 E.03967
G1 X193.136 Y115.143 E.00228
G1 X189.851 Y118.428 E.03769
G1 X190.024 Y118.537 E.00166
G1 X193.136 Y115.425 E.0357
G1 X193.136 Y115.706 E.00228
G1 X190.196 Y118.645 E.03372
G1 X190.369 Y118.754 E.00166
G1 X193.136 Y115.988 E.03174
G1 X193.136 Y116.269 E.00228
G1 X190.542 Y118.863 E.02975
G1 X190.715 Y118.972 E.00166
G1 X193.136 Y116.551 E.02777
G1 X193.136 Y116.833 E.00228
G1 X190.888 Y119.08 E.02579
G1 X191.061 Y119.189 E.00166
G1 X193.136 Y117.114 E.0238
G1 X193.136 Y117.396 E.00228
G1 X191.234 Y119.298 E.02182
G1 X191.407 Y119.406 E.00166
G1 X193.136 Y117.677 E.01984
G1 X193.136 Y117.959 E.00228
G1 X191.58 Y119.515 E.01785
G1 X191.753 Y119.624 E.00166
G1 X193.136 Y118.24 E.01587
G1 X193.136 Y118.522 E.00228
G1 X191.926 Y119.732 E.01388
G1 X192.098 Y119.841 E.00166
G1 X193.136 Y118.804 E.0119
G1 X193.136 Y119.085 E.00228
G1 X192.271 Y119.95 E.00992
M73 P89 R1
G1 X192.439 Y120.064 E.00164
G1 X193.136 Y119.367 E.008
G1 X193.136 Y119.648 E.00228
G1 X192.587 Y120.197 E.00629
G1 X192.676 Y120.39 E.00172
G1 X193.136 Y119.93 E.00527
G1 X193.136 Y120.212 E.00228
G1 X192.765 Y120.582 E.00425
G1 X192.834 Y120.731 E.00133
G1 X192.837 Y120.792 E.00049
G1 X193.136 Y120.493 E.00343
G1 X193.136 Y120.775 E.00228
G1 X192.852 Y121.059 E.00326
G1 X192.844 Y121.318 E.0021
G1 X192.821 Y121.371 E.00048
G1 X193.136 Y121.056 E.00361
G1 X193.136 Y121.338 E.00228
G1 X192.248 Y122.226 E.01019
G1 X192.391 Y122.213 E.00117
G1 X192.481 Y122.274 E.00089
G1 X193.136 Y121.62 E.00751
G1 X193.136 Y121.901 E.00228
G1 X192.616 Y122.421 E.00596
G1 X192.704 Y122.614 E.00173
G1 X193.136 Y122.183 E.00495
G1 X193.136 Y122.464 E.00228
G1 X192.792 Y122.808 E.00394
G1 X192.864 Y122.967 E.00142
G1 X192.864 Y123.017 E.00041
G1 X193.136 Y122.746 E.00311
G1 X193.136 Y123.027 E.00228
G1 X192.864 Y123.299 E.00311
G1 X192.864 Y123.58 E.00228
G1 X193.136 Y123.309 E.00311
G1 X193.136 Y123.591 E.00228
G1 X192.864 Y123.862 E.00311
G1 X192.864 Y124.144 E.00228
G1 X193.136 Y123.872 E.00311
G1 X193.136 Y124.154 E.00228
G1 X192.864 Y124.425 E.00311
G1 X192.864 Y124.707 E.00228
G1 X193.136 Y124.435 E.00311
G1 X193.136 Y124.717 E.00228
G1 X192.864 Y124.988 E.00311
G1 X192.864 Y125.27 E.00228
G1 X193.136 Y124.999 E.00311
G1 X193.136 Y125.28 E.00228
G1 X192.864 Y125.552 E.00311
G1 X192.864 Y125.833 E.00228
G1 X193.136 Y125.562 E.00311
G1 X193.136 Y125.843 E.00228
G1 X192.864 Y126.115 E.00311
G1 X192.864 Y126.396 E.00228
G1 X193.136 Y126.125 E.00311
G1 X193.136 Y126.406 E.00228
G1 X192.864 Y126.678 E.00311
G1 X192.864 Y126.959 E.00228
G1 X193.136 Y126.688 E.00311
G1 X193.136 Y126.97 E.00228
G1 X192.864 Y127.241 E.00311
G1 X192.864 Y127.523 E.00228
G1 X193.136 Y127.251 E.00311
G1 X193.136 Y127.533 E.00228
G1 X192.864 Y127.804 E.00311
G1 X192.864 Y128.086 E.00228
G1 X193.136 Y127.814 E.00311
G1 X193.136 Y128.096 E.00228
G1 X192.864 Y128.367 E.00311
G1 X192.864 Y128.649 E.00228
G1 X193.136 Y128.378 E.00311
G1 X193.136 Y128.659 E.00228
G1 X192.864 Y128.931 E.00311
G1 X192.851 Y129.164 E.00189
G1 X192.797 Y129.28 E.00104
G1 X193.136 Y128.941 E.00389
G1 X193.136 Y129.222 E.00228
G1 X191.222 Y131.136 E.02195
G1 X191.504 Y131.136 E.00228
G1 X193.136 Y129.504 E.01872
G1 X193.136 Y129.785 E.00228
G1 X191.785 Y131.136 E.01549
G1 X192.067 Y131.136 E.00228
G1 X193.136 Y130.067 E.01226
G1 X193.136 Y130.349 E.00228
G1 X192.349 Y131.136 E.00903
G1 X192.63 Y131.136 E.00228
G1 X193.136 Y130.63 E.0058
G1 X193.136 Y130.912 E.00228
G1 X192.822 Y131.225 E.00359
M204 S10000
G1 X190.851 Y131.225 F60000
G1 F6026.819
M204 S8000
G1 X192.248 Y129.829 E.01602
G1 X191.931 Y129.864 E.00259
G1 X190.659 Y131.136 E.01459
G1 X190.378 Y131.136 E.00228
G1 X191.649 Y129.864 E.01459
G1 X191.367 Y129.864 E.00228
G1 X190.096 Y131.136 E.01459
G1 X189.814 Y131.136 E.00228
G1 X191.086 Y129.864 E.01459
G1 X190.804 Y129.864 E.00228
G1 X189.533 Y131.136 E.01459
G1 X189.251 Y131.136 E.00228
G1 X190.523 Y129.864 E.01459
G1 X190.241 Y129.864 E.00228
G1 X188.97 Y131.136 E.01459
G1 X188.688 Y131.136 E.00228
G1 X189.959 Y129.864 E.01459
G1 X189.678 Y129.864 E.00228
G1 X188.406 Y131.136 E.01459
G1 X188.125 Y131.136 E.00228
G1 X189.396 Y129.864 E.01459
G1 X189.115 Y129.864 E.00228
G1 X187.843 Y131.136 E.01459
G1 X187.562 Y131.136 E.00228
G1 X188.833 Y129.864 E.01459
G1 X188.552 Y129.864 E.00228
G1 X187.28 Y131.136 E.01459
G1 X186.999 Y131.136 E.00228
G1 X188.27 Y129.864 E.01459
G1 X187.988 Y129.864 E.00228
G1 X186.717 Y131.136 E.01459
G1 X186.435 Y131.136 E.00228
G1 X187.707 Y129.864 E.01459
G1 X187.425 Y129.864 E.00228
G1 X186.154 Y131.136 E.01459
G1 X185.872 Y131.136 E.00228
G1 X187.144 Y129.864 E.01459
G1 X186.862 Y129.864 E.00228
G1 X185.591 Y131.136 E.01459
G1 X185.309 Y131.136 E.00228
G1 X186.58 Y129.864 E.01459
G1 X186.299 Y129.864 E.00228
G1 X185.027 Y131.136 E.01459
G1 X184.746 Y131.136 E.00228
G1 X186.017 Y129.864 E.01459
G1 X185.736 Y129.864 E.00228
G1 X184.464 Y131.136 E.01459
G1 X184.183 Y131.136 E.00228
G1 X185.454 Y129.864 E.01459
G1 X185.173 Y129.864 E.00228
G1 X183.901 Y131.136 E.01459
G1 X183.62 Y131.136 E.00228
G1 X184.891 Y129.864 E.01459
G1 X184.609 Y129.864 E.00228
G1 X183.338 Y131.136 E.01459
G1 X183.056 Y131.136 E.00228
G1 X184.328 Y129.864 E.01459
G1 X184.046 Y129.864 E.00228
G1 X182.775 Y131.136 E.01459
G1 X182.493 Y131.136 E.00228
G1 X183.765 Y129.864 E.01459
G1 X183.483 Y129.864 E.00228
G1 X182.212 Y131.136 E.01459
G1 X181.93 Y131.136 E.00228
G1 X183.201 Y129.864 E.01459
G1 X183.11 Y129.864 E.00074
G1 X182.96 Y129.824 E.00126
G1 X181.648 Y131.136 E.01505
G1 X181.367 Y131.136 E.00228
G1 X182.738 Y129.764 E.01573
G1 X182.69 Y129.751 E.00041
G1 X182.576 Y129.645 E.00126
G1 X181.085 Y131.136 E.01711
G1 X180.804 Y131.136 E.00228
G1 X182.431 Y129.508 E.01867
G1 X182.405 Y129.483 E.00029
G1 X182.337 Y129.321 E.00143
G1 X180.522 Y131.136 E.02082
G1 X180.24 Y131.136 E.00228
G1 X182.272 Y129.105 E.0233
G1 X182.268 Y128.826 E.00226
G1 X179.959 Y131.136 E.02649
G1 X179.677 Y131.136 E.00228
G1 X182.825 Y127.988 E.03611
G1 X182.067 Y128.464 E.00726
G1 X179.396 Y131.136 E.03065
G1 X179.114 Y131.136 E.00228
G1 X181.309 Y128.941 E.02518
G1 X180.551 Y129.418 E.00726
G1 X179.802 Y130.166 E.00859
G1 X179.645 Y130.45 E.00263
G1 X179.523 Y130.585 E.00148
G1 X179.212 Y130.756 E.00288
G1 X178.833 Y131.136 E.00436
G1 X178.551 Y131.136 E.00228
G1 X178.841 Y130.846 E.00332
G1 X178.559 Y130.846 E.00229
G1 X178.269 Y131.136 E.00332
G1 X177.988 Y131.136 E.00228
G1 X178.277 Y130.847 E.00332
G1 X177.995 Y130.847 E.00229
G1 X177.706 Y131.136 E.00331
G1 X177.425 Y131.136 E.00228
G1 X177.713 Y130.847 E.00331
G1 X177.431 Y130.848 E.00229
G1 X177.143 Y131.136 E.0033
G1 X176.861 Y131.136 E.00228
G1 X177.149 Y130.848 E.0033
G1 X176.867 Y130.848 E.00229
G1 X176.58 Y131.136 E.0033
G1 X176.298 Y131.136 E.00228
G1 X176.585 Y130.849 E.00329
G1 X176.304 Y130.849 E.00229
G1 X176.017 Y131.136 E.00329
G1 X175.735 Y131.136 E.00228
G1 X176.022 Y130.849 E.00329
G1 X175.74 Y130.85 E.00229
G1 X175.454 Y131.136 E.00328
G1 X175.172 Y131.136 E.00228
G1 X175.458 Y130.85 E.00328
G1 X175.176 Y130.85 E.00229
G1 X174.89 Y131.136 E.00328
G1 X174.609 Y131.136 E.00228
G1 X174.894 Y130.85 E.00327
G1 X174.612 Y130.851 E.00229
G1 X174.327 Y131.136 E.00327
G1 X174.046 Y131.136 E.00228
G1 X174.33 Y130.851 E.00327
G1 X174.048 Y130.851 E.00229
G1 X173.764 Y131.136 E.00326
G1 X173.482 Y131.136 E.00228
G1 X173.766 Y130.852 E.00326
G1 X173.485 Y130.852 E.00229
G1 X173.201 Y131.136 E.00325
G1 X172.919 Y131.136 E.00228
G1 X173.203 Y130.852 E.00325
G1 X172.921 Y130.853 E.00229
G1 X172.638 Y131.136 E.00325
G1 X172.356 Y131.136 E.00228
G1 X172.639 Y130.853 E.00324
G1 X172.357 Y130.853 E.00229
G1 X172.075 Y131.136 E.00324
G1 X171.793 Y131.136 E.00228
G1 X172.075 Y130.854 E.00324
G1 X171.793 Y130.854 E.00229
G1 X171.511 Y131.136 E.00323
G1 X171.23 Y131.136 E.00228
G1 X171.511 Y130.854 E.00323
G1 X171.229 Y130.855 E.00229
G1 X170.948 Y131.136 E.00323
G1 X170.667 Y131.136 E.00228
G1 X170.947 Y130.855 E.00322
G1 X170.666 Y130.855 E.00229
G1 X170.385 Y131.136 E.00322
G1 X170.103 Y131.136 E.00228
G1 X170.384 Y130.855 E.00321
G1 X170.102 Y130.856 E.00229
G1 X169.822 Y131.136 E.00321
G1 X169.54 Y131.136 E.00228
G1 X169.82 Y130.856 E.00321
G1 X169.538 Y130.856 E.00229
G1 X169.259 Y131.136 E.0032
G1 X168.977 Y131.136 E.00228
G1 X169.256 Y130.857 E.0032
G1 X168.974 Y130.857 E.00229
G1 X168.696 Y131.136 E.0032
G1 X168.659 Y131.136 E.0003
G1 X168.647 Y131.005 E.00107
G1 X168.591 Y130.959 E.00059
G1 X168.782 Y130.768 E.00219
; WIPE_START
G1 X168.591 Y130.959 E-.05134
G1 X168.647 Y131.005 E-.01376
G1 X168.659 Y131.136 E-.02494
G1 X168.696 Y131.136 E-.00695
G1 X168.974 Y130.857 E-.07488
G1 X169.256 Y130.857 E-.05356
G1 X168.977 Y131.136 E-.07496
G1 X169.259 Y131.136 E-.0535
G1 X169.356 Y131.039 E-.02609
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X164.209 Y130.898 Z1 F60000
G1 Z.6
G1 E.4 F1800
; LINE_WIDTH: 0.21986
G1 F6048.388
M204 S8000
G1 X162.176 Y130.898 E.01643
G1 X162.374 Y131.096 E.00227
G1 X164.105 Y131.096 E.01399
G1 X164.141 Y130.964 E.0011
G1 X164.188 Y130.919 E.00053
; WIPE_START
G1 X164.141 Y130.964 E-.01244
G1 X164.105 Y131.096 E-.02593
G1 X162.374 Y131.096 E-.32877
G1 X162.327 Y131.048 E-.01286
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X161.706 Y123.441 Z1 F60000
G1 X160.775 Y112.024 Z1
G1 Z.6
G1 E.4 F1800
; LINE_WIDTH: 0.22057
G1 F6026.819
M204 S8000
G1 X161.935 Y110.864 E.01331
G1 X161.653 Y110.864 E.00228
G1 X160.864 Y111.653 E.00905
G1 X160.864 Y111.372 E.00228
G1 X161.372 Y110.864 E.00582
G1 X161.09 Y110.864 E.00228
G1 X160.775 Y111.179 E.00362
; WIPE_START
G1 X161.09 Y110.864 E-.0847
G1 X161.372 Y110.864 E-.0535
G1 X160.864 Y111.372 E-.13636
G1 X160.864 Y111.653 E-.0535
G1 X161.058 Y111.46 E-.05194
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X168.253 Y114.006 Z1 F60000
G1 X191.839 Y122.353 Z1
G1 Z.6
G1 E.4 F1800
G1 F6026.819
M204 S8000
G1 X192.228 Y121.964 E.00446
; OBJECT_ID: 5887
; COOLING_NODE: 0
; WIPE_START
G1 X191.839 Y122.353 E-.38
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 5909
M625
; start printing object, unique label id: 5887
M624 AQAAAAAAAAA=
M204 S10000
G1 X184.264 Y123.294 Z1 F60000
G1 X124.614 Y130.699 Z1
G1 Z.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.21999
G1 F6044.427
M204 S8000
G1 X124.671 Y130.699 E.00046
G1 X124.308 Y131.054 E.00411
G1 X124.294 Y131.294 E.00194
G1 X122.692 Y131.294 E.01296
G1 X122.292 Y131.294 E.00324
G1 F5151.064
G1 X122.205 Y131.207 E.001
; LINE_WIDTH: 0.267335
G1 F4880.529
G1 X121.941 Y130.91 E.00399
; LINE_WIDTH: 0.31468
G1 F4092.491
G1 X121.677 Y130.612 E.00476
G1 X121.89 Y130.655 E.0026
; LINE_WIDTH: 0.267335
G1 F4535.038
G1 X122.103 Y130.699 E.00218
; LINE_WIDTH: 0.21999
G1 F5408.053
G1 X122.503 Y130.699 E.00324
G1 F6044.427
G1 X122.903 Y130.699 E.00324
G1 X124.614 Y130.699 E.01384
; COOLING_NODE: 0
; WIPE_START
G1 X124.671 Y130.699 E-.01075
G1 X124.308 Y131.054 E-.09654
G1 X124.294 Y131.294 E-.04566
G1 X123.099 Y131.294 E-.22705
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X130.69 Y130.499 Z1 F60000
G1 X142.484 Y129.264 Z1
G1 Z.6
G1 E.4 F1800
G1 F6044.427
M204 S8000
G1 X142.427 Y129.127 E.0012
G1 X142.422 Y128.741 E.00312
G1 X142.626 Y128.41 E.00314
G1 F5247.982
G1 X142.985 Y128.162 E.00353
; LINE_WIDTH: 0.266815
G1 F4313.496
G1 X143.055 Y128.087 E.00103
; LINE_WIDTH: 0.31364
G1 F4107.057
G1 X143.126 Y128.012 E.00122
G1 X144.797 Y126.914 E.02381
; LINE_WIDTH: 0.2868
G1 F4522.499
G1 X146.469 Y125.816 E.02162
; LINE_WIDTH: 0.25996
G1 F5031.447
G1 X148.14 Y124.717 E.01943
; LINE_WIDTH: 0.23312
G1 F5669.47
G1 X148.474 Y124.498 E.00345
G1 X149.812 Y123.619 E.0138
; LINE_WIDTH: 0.20628
G1 F6492.804
G1 X150.146 Y123.4 E.00301
G1 X151.483 Y122.521 E.01205
; LINE_WIDTH: 0.17944
G1 F6725.071
G1 X151.637 Y122.42 E.00119
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X152.329 Y122.362 E.00562
G1 X152.468 Y122.457 E.00136
G1 X152.706 Y122.98 E.00465
G1 X152.706 Y129.011 E.04878
G1 X152.695 Y129.131 E.00097
G1 X152.54 Y129.461 E.00295
G1 X152.131 Y129.695 E.00382
G1 X152.011 Y129.706 E.00097
G1 X143.118 Y129.706 E.07194
G1 X142.769 Y129.612 E.00292
G1 X142.538 Y129.394 E.00257
G1 X142.484 Y129.264 E.00114
; COOLING_NODE: 0
; WIPE_START
G1 X142.427 Y129.127 E-.02814
G1 X142.422 Y128.741 E-.07335
G1 X142.626 Y128.41 E-.07386
G1 X142.985 Y128.162 E-.08298
G1 X143.055 Y128.087 E-.01951
G1 X143.126 Y128.012 E-.01951
G1 X143.489 Y127.773 E-.08264
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X135.982 Y129.153 Z1 F60000
G1 X126.336 Y130.926 Z1
G1 Z.6
G1 E.4 F1800
G1 F6044.427
M204 S8000
G1 X126.06 Y130.699 E.00289
G1 X139.017 Y130.689 E.10481
G1 X139.412 Y130.471 E.00365
G1 X139.676 Y130.071 E.00387
G1 X139.704 Y129.762 E.00251
G1 X142.095 Y128.259 E.02285
G1 X142.434 Y128.046 E.00324
G1 F5165.867
G1 X142.773 Y127.834 E.00324
; LINE_WIDTH: 0.266815
G1 F4313.494
G1 X142.87 Y127.8 E.00103
; LINE_WIDTH: 0.31364
G1 F4107.057
G1 X142.967 Y127.767 E.00122
G1 X144.653 Y126.691 E.02381
; LINE_WIDTH: 0.2868
G1 F4522.499
G1 X146.339 Y125.615 E.02162
; LINE_WIDTH: 0.25996
G1 F5031.447
G1 X148.025 Y124.54 E.01943
; LINE_WIDTH: 0.23312
G1 F5669.47
G1 X148.362 Y124.325 E.00345
G1 X149.711 Y123.464 E.0138
; LINE_WIDTH: 0.20628
G1 F6492.804
G1 X150.048 Y123.249 E.00301
G1 X151.397 Y122.388 E.01205
; LINE_WIDTH: 0.17944
G1 F6961.406
G1 X151.553 Y122.289 E.00119
; LINE_WIDTH: 0.17697
G1 F6987.496
G1 X151.57 Y122.278 E.00013
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X152.307 Y121.84 E.00694
G1 X152.488 Y121.676 E.00198
G1 X152.688 Y121.285 E.00355
G1 X152.676 Y120.751 E.00432
G1 X152.463 Y120.289 E.00412
G1 X152.306 Y120.159 E.00164
G1 X139.704 Y112.238 E.1204
G1 X139.676 Y111.929 E.00251
G1 X139.522 Y111.65 E.00258
G1 X139.41 Y111.528 E.00134
G1 X138.897 Y111.301 E.00454
G1 X122.148 Y111.294 E.13548
G1 X121.882 Y111.347 E.0022
G1 X121.544 Y111.544 E.00316
G1 X121.394 Y111.769 E.00219
G1 X121.294 Y112.148 E.00316
G1 X121.294 Y129.586 E.14105
G1 X121.327 Y130.062 E.00386
; LINE_WIDTH: 0.253595
G1 F4977.943
G1 X121.415 Y130.26 E.00205
; LINE_WIDTH: 0.2872
G1 F4515.692
G1 X121.503 Y130.458 E.00235
G1 X121.365 Y130.344 E.00193
; LINE_WIDTH: 0.253595
G1 F4895.01
G1 X121.228 Y130.23 E.00169
; LINE_WIDTH: 0.21999
G1 F5800.516
G1 X120.945 Y129.947 E.00324
G1 F6044.427
G1 X120.706 Y129.708 E.00274
G1 X120.706 Y110.706 E.15371
G1 X153.294 Y110.706 E.26361
G1 X153.294 Y114.291 E.029
G1 X153.294 Y131.294 E.13754
G1 X126.506 Y131.294 E.21669
G1 X126.492 Y131.054 E.00194
G1 X126.336 Y130.926 E.00163
; COOLING_NODE: 0
M204 S10000
G1 X126.198 Y131.011 F60000
G1 F6044.427
M204 S8000
G1 X125.811 Y130.694 E.00405
; LINE_WIDTH: 0.2214
G1 F6001.801
G1 X124.903 Y130.7 E.00739
G1 X124.502 Y131.093 E.00458
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X124.493 Y131.493 E.00324
G1 X122.21 Y131.493 E.01847
G1 X120.507 Y129.79 E.01948
G1 X120.507 Y110.507 E.15598
G1 X153.493 Y110.507 E.26682
G1 X153.493 Y114.291 E.03061
G1 X153.493 Y131.493 E.13914
G1 X126.307 Y131.493 E.2199
G1 X126.298 Y131.093 E.00324
G1 X126.198 Y131.011 E.00104
; COOLING_NODE: 0
M204 S10000
G1 X126.06 Y131.096 F60000
G1 F6044.427
M204 S8000
G1 X125.811 Y130.891 E.00261
G1 X124.938 Y130.896 E.00706
G1 X124.697 Y131.131 E.00272
G1 X124.691 Y131.691 E.00453
G1 X122.128 Y131.691 E.02074
G1 X120.309 Y129.872 E.02081
G1 X120.309 Y110.309 E.15825
G1 X153.691 Y110.309 E.27003
G1 X153.691 Y114.291 E.03222
G1 X153.691 Y131.691 E.14075
G1 X126.109 Y131.691 E.22311
G1 X126.103 Y131.131 E.00453
G1 X126.06 Y131.096 E.00045
; COOLING_NODE: 0
M204 S250
G1 X125.91 Y131.189 F60000
; FEATURE: Outer wall
M73 P90 R1
G1 F6044.427
M204 S5000
G1 X125.811 Y131.09 E.00114
G1 X124.989 Y131.09 E.00664
G1 X124.89 Y131.189 E.00114
G1 X124.89 Y131.89 E.00567
G1 X122.046 Y131.89 E.02301
G1 X120.11 Y129.954 E.02214
G1 X120.11 Y110.11 E.16052
G1 X153.89 Y110.11 E.27324
G1 X153.89 Y114.291 E.03382
G1 X153.89 Y131.89 E.14235
G1 X125.91 Y131.89 E.22633
G1 X125.91 Y131.189 E.00567
; COOLING_NODE: 0
; WIPE_START
M204 S8000
G1 X125.811 Y131.09 E-.02667
G1 X124.989 Y131.09 E-.15608
G1 X124.89 Y131.189 E-.02667
G1 X124.89 Y131.89 E-.13314
G1 X124.693 Y131.89 E-.03744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X132.24 Y130.754 Z1 F60000
G1 X142.663 Y129.185 Z1
G1 Z.6
G1 E.4 F1800
; FEATURE: Inner wall
G1 F6044.427
M204 S8000
G1 X142.617 Y129.07 E.001
G1 X142.613 Y128.794 E.00223
G1 X142.816 Y128.513 E.00281
G1 X143.095 Y128.327 E.00271
G1 X151.735 Y122.567 E.084
G1 X152.238 Y122.539 E.00407
G1 X152.337 Y122.606 E.00097
G1 X152.507 Y122.98 E.00332
G1 X152.507 Y129.011 E.04878
G1 X152.389 Y129.332 E.00277
G1 X152.096 Y129.5 E.00273
G1 X152.011 Y129.507 E.0007
G1 X143.118 Y129.507 E.07194
G1 X142.869 Y129.44 E.00208
G1 X142.704 Y129.285 E.00184
G1 X142.663 Y129.185 E.00087
; COOLING_NODE: 0
M204 S10000
G1 X142.878 Y129.154 F60000
G1 F6044.427
M204 S8000
G1 X142.832 Y129.097 E.00059
G1 X142.805 Y128.847 E.00204
G1 X142.927 Y128.678 E.00168
G1 X143.205 Y128.492 E.00271
G1 X151.846 Y122.732 E.084
G1 X152.147 Y122.715 E.00244
G1 X152.207 Y122.756 E.00058
G1 X152.309 Y122.98 E.00199
G1 X152.309 Y129.011 E.04878
G1 X152.238 Y129.204 E.00166
G1 X152.062 Y129.304 E.00164
G1 X152.011 Y129.309 E.00042
G1 X143.118 Y129.309 E.07194
G1 X142.968 Y129.268 E.00125
G1 X142.878 Y129.154 E.00118
; COOLING_NODE: 1
M204 S250
G1 X143.022 Y129.039 F60000
; FEATURE: Outer wall
G1 F6044.427
M204 S5000
G1 X142.996 Y128.9 E.00115
G1 X143.316 Y128.657 E.00324
G1 X151.958 Y122.896 E.08402
G1 X152.076 Y122.905 E.00096
G1 X152.11 Y122.98 E.00066
G1 X152.11 Y129.011 E.04878
G1 X152.04 Y129.105 E.00095
G1 X143.118 Y129.11 E.07218
G1 X143.022 Y129.039 E.00096
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X142.996 Y128.9 E-.02707
G1 X143.316 Y128.657 E-.07614
G1 X144.528 Y127.849 E-.27679
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X142.176 Y120.588 Z1 F60000
G1 X139.507 Y112.348 Z1
G1 Z.6
G1 E.4 F1800
; FEATURE: Inner wall
G1 F6044.427
M204 S8000
G1 X152.201 Y120.327 E.12128
G1 X152.325 Y120.432 E.00132
G1 X152.478 Y120.763 E.00294
G1 X152.493 Y121.251 E.00395
G1 X152.331 Y121.555 E.00278
G1 X152.201 Y121.672 E.00141
G1 X139.507 Y129.652 E.12128
G1 X139.485 Y130.017 E.00296
G1 X139.265 Y130.337 E.00314
G1 X138.983 Y130.493 E.00261
G1 X125.811 Y130.499 E.10655
; LINE_WIDTH: 0.21691
G1 F6139.678
G1 X124.989 Y130.499 E.00654
; LINE_WIDTH: 0.21999
G1 F6044.427
G1 X122.103 Y130.501 E.02335
G1 X121.811 Y130.406 E.00248
G1 X121.667 Y130.293 E.00148
G1 X121.516 Y130.002 E.00266
G1 X121.493 Y129.586 E.00337
G1 X121.493 Y112.148 E.14105
G1 X121.577 Y111.846 E.00254
G1 X121.685 Y111.685 E.00156
G1 X121.958 Y111.531 E.00253
G1 X122.148 Y111.493 E.00157
G1 X138.897 Y111.499 E.13548
G1 X139.263 Y111.662 E.00324
G1 X139.485 Y111.983 E.00316
G1 X139.507 Y112.348 E.00296
; COOLING_NODE: 1
M204 S10000
G1 X139.31 Y112.459 F60000
G1 F6044.427
M204 S8000
G1 X152.095 Y120.495 E.12215
G1 X152.188 Y120.576 E.001
G1 X152.28 Y120.774 E.00176
G1 X152.297 Y121.217 E.00359
G1 X152.151 Y121.459 E.00229
G1 X139.31 Y129.541 E.12274
G1 X139.294 Y129.963 E.00341
G1 X139.118 Y130.204 E.00242
G1 X138.897 Y130.302 E.00195
G1 X122.103 Y130.302 E.13584
G1 X121.807 Y130.153 E.00268
G1 X121.705 Y129.942 E.0019
G1 X121.691 Y129.586 E.00288
G1 X121.691 Y112.148 E.14105
G1 X121.761 Y111.922 E.00191
G1 X121.922 Y111.761 E.00184
G1 X122.148 Y111.691 E.00191
G1 X138.897 Y111.698 E.13548
G1 X139.117 Y111.795 E.00195
G1 X139.294 Y112.037 E.00243
G1 X139.31 Y112.459 E.00342
; COOLING_NODE: 2
M204 S250
G1 X139.112 Y112.569 F60000
; FEATURE: Outer wall
G1 F6044.427
M204 S5000
G1 X151.989 Y120.663 E.12303
G1 X152.081 Y120.785 E.00124
G1 X152.083 Y121.226 E.00356
G1 X151.99 Y121.336 E.00116
G1 X139.112 Y129.431 E.12303
G1 X139.081 Y129.948 E.0042
G1 X138.897 Y130.104 E.00195
G1 X122.103 Y130.104 E.13584
G1 X121.948 Y130.013 E.00145
G1 X121.89 Y129.852 E.00138
G1 X121.89 Y112.148 E.1432
G1 X121.966 Y111.965 E.0016
G1 X122.148 Y111.89 E.0016
G1 X138.896 Y111.896 E.13548
G1 X139.081 Y112.051 E.00195
G1 X139.112 Y112.569 E.0042
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X140.806 Y113.634 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X135.097 Y118.7 Z1 F60000
G1 X121.677 Y130.612 Z1
G1 Z.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.31468
G1 F4092.491
M204 S8000
G1 X121.503 Y130.458 E.00278
M204 S10000
G1 X121.225 Y129.596 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.22057
G1 F6026.819
M204 S8000
G1 X121.022 Y129.799 E.00233
G1 X120.881 Y129.658 E.00162
G1 X121.136 Y129.403 E.00293
G1 X121.136 Y129.122 E.00228
G1 X120.864 Y129.393 E.00311
G1 X120.864 Y129.112 E.00228
G1 X121.136 Y128.84 E.00311
G1 X121.136 Y128.559 E.00228
G1 X120.864 Y128.83 E.00311
G1 X120.864 Y128.548 E.00228
G1 X121.136 Y128.277 E.00311
G1 X121.136 Y127.995 E.00228
G1 X120.864 Y128.267 E.00311
G1 X120.864 Y127.985 E.00228
G1 X121.136 Y127.714 E.00311
G1 X121.136 Y127.432 E.00228
G1 X120.864 Y127.704 E.00311
G1 X120.864 Y127.422 E.00228
G1 X121.136 Y127.151 E.00311
G1 X121.136 Y126.869 E.00228
G1 X120.864 Y127.14 E.00311
G1 X120.864 Y126.859 E.00228
G1 X121.136 Y126.587 E.00311
G1 X121.136 Y126.306 E.00228
G1 X120.864 Y126.577 E.00311
G1 X120.864 Y126.296 E.00228
G1 X121.136 Y126.024 E.00311
G1 X121.136 Y125.743 E.00228
G1 X120.864 Y126.014 E.00311
G1 X120.864 Y125.733 E.00228
G1 X121.136 Y125.461 E.00311
G1 X121.136 Y125.18 E.00228
G1 X120.864 Y125.451 E.00311
G1 X120.864 Y125.169 E.00228
G1 X121.136 Y124.898 E.00311
G1 X121.136 Y124.616 E.00228
G1 X120.864 Y124.888 E.00311
G1 X120.864 Y124.606 E.00228
G1 X121.136 Y124.335 E.00311
G1 X121.136 Y124.053 E.00228
G1 X120.864 Y124.325 E.00311
G1 X120.864 Y124.043 E.00228
G1 X121.136 Y123.772 E.00311
G1 X121.136 Y123.49 E.00228
G1 X120.864 Y123.761 E.00311
G1 X120.864 Y123.48 E.00228
G1 X121.136 Y123.208 E.00311
G1 X121.136 Y122.927 E.00228
G1 X120.864 Y123.198 E.00311
G1 X120.864 Y122.917 E.00228
G1 X121.136 Y122.645 E.00311
G1 X121.136 Y122.364 E.00228
G1 X120.864 Y122.635 E.00311
G1 X120.864 Y122.354 E.00228
G1 X121.136 Y122.082 E.00311
G1 X121.136 Y121.801 E.00228
G1 X120.864 Y122.072 E.00311
G1 X120.864 Y121.79 E.00228
G1 X121.136 Y121.519 E.00311
G1 X121.136 Y121.237 E.00228
G1 X120.864 Y121.509 E.00311
G1 X120.864 Y121.227 E.00228
G1 X121.136 Y120.956 E.00311
G1 X121.136 Y120.674 E.00228
G1 X120.864 Y120.946 E.00311
G1 X120.864 Y120.664 E.00228
G1 X121.136 Y120.393 E.00311
G1 X121.136 Y120.111 E.00228
G1 X120.864 Y120.382 E.00311
G1 X120.864 Y120.101 E.00228
G1 X121.136 Y119.829 E.00311
G1 X121.136 Y119.548 E.00228
G1 X120.864 Y119.819 E.00311
G1 X120.864 Y119.538 E.00228
G1 X121.136 Y119.266 E.00311
G1 X121.136 Y118.985 E.00228
G1 X120.864 Y119.256 E.00311
G1 X120.864 Y118.975 E.00228
G1 X121.136 Y118.703 E.00311
G1 X121.136 Y118.422 E.00228
G1 X120.864 Y118.693 E.00311
G1 X120.864 Y118.411 E.00228
G1 X121.136 Y118.14 E.00311
G1 X121.136 Y117.858 E.00228
G1 X120.864 Y118.13 E.00311
G1 X120.864 Y117.848 E.00228
G1 X121.136 Y117.577 E.00311
G1 X121.136 Y117.295 E.00228
G1 X120.864 Y117.567 E.00311
G1 X120.864 Y117.285 E.00228
G1 X121.136 Y117.014 E.00311
G1 X121.136 Y116.732 E.00228
G1 X120.864 Y117.003 E.00311
G1 X120.864 Y116.722 E.00228
G1 X121.136 Y116.45 E.00311
G1 X121.136 Y116.169 E.00228
G1 X120.864 Y116.44 E.00311
G1 X120.864 Y116.159 E.00228
G1 X121.136 Y115.887 E.00311
G1 X121.136 Y115.606 E.00228
G1 X120.864 Y115.877 E.00311
G1 X120.864 Y115.595 E.00228
G1 X121.136 Y115.324 E.00311
G1 X121.136 Y115.043 E.00228
G1 X120.864 Y115.314 E.00311
G1 X120.864 Y115.032 E.00228
G1 X121.136 Y114.761 E.00311
G1 X121.136 Y114.479 E.00228
G1 X120.864 Y114.751 E.00311
G1 X120.864 Y114.469 E.00228
G1 X121.136 Y114.198 E.00311
G1 X121.136 Y113.916 E.00228
G1 X120.864 Y114.188 E.00311
G1 X120.864 Y113.906 E.00228
G1 X121.136 Y113.635 E.00311
G1 X121.136 Y113.353 E.00228
G1 X120.864 Y113.624 E.00311
G1 X120.864 Y113.343 E.00228
G1 X121.136 Y113.071 E.00311
G1 X121.136 Y112.79 E.00228
G1 X120.864 Y113.061 E.00311
G1 X120.864 Y112.78 E.00228
G1 X121.136 Y112.508 E.00311
G1 X121.136 Y112.227 E.00228
G1 X120.864 Y112.498 E.00311
G1 X120.864 Y112.216 E.00228
G1 X121.185 Y111.896 E.00368
G1 X121.25 Y111.703 E.00165
G1 X121.431 Y111.431 E.00265
G1 X121.704 Y111.249 E.00266
G1 X121.905 Y111.176 E.00174
G1 X122.216 Y110.864 E.00358
G1 X122.498 Y110.864 E.00228
G1 X122.227 Y111.136 E.00311
G1 X122.508 Y111.136 E.00228
G1 X122.78 Y110.864 E.00312
G1 X123.061 Y110.864 E.00228
G1 X122.79 Y111.136 E.00312
G1 X123.071 Y111.136 E.00228
G1 X123.343 Y110.864 E.00312
G1 X123.624 Y110.864 E.00228
G1 X123.353 Y111.136 E.00312
G1 X123.634 Y111.136 E.00228
G1 X123.906 Y110.864 E.00312
G1 X124.188 Y110.864 E.00228
G1 X123.915 Y111.136 E.00312
G1 X124.197 Y111.136 E.00228
G1 X124.469 Y110.864 E.00312
G1 X124.751 Y110.864 E.00228
G1 X124.478 Y111.137 E.00312
G1 X124.76 Y111.137 E.00228
G1 X125.032 Y110.864 E.00313
G1 X125.314 Y110.864 E.00228
G1 X125.041 Y111.137 E.00313
G1 X125.323 Y111.137 E.00228
G1 X125.595 Y110.864 E.00313
G1 X125.877 Y110.864 E.00228
G1 X125.604 Y111.137 E.00313
G1 X125.886 Y111.137 E.00228
G1 X126.159 Y110.864 E.00313
G1 X126.44 Y110.864 E.00228
G1 X126.167 Y111.137 E.00313
G1 X126.449 Y111.137 E.00228
G1 X126.722 Y110.864 E.00313
G1 X127.003 Y110.864 E.00228
G1 X126.73 Y111.137 E.00313
G1 X127.012 Y111.138 E.00228
G1 X127.285 Y110.864 E.00314
G1 X127.567 Y110.864 E.00228
G1 X127.293 Y111.138 E.00314
G1 X127.575 Y111.138 E.00228
G1 X127.848 Y110.864 E.00314
G1 X128.13 Y110.864 E.00228
G1 X127.856 Y111.138 E.00314
G1 X128.138 Y111.138 E.00228
G1 X128.411 Y110.864 E.00314
G1 X128.693 Y110.864 E.00228
G1 X128.419 Y111.138 E.00314
G1 X128.701 Y111.138 E.00228
G1 X128.975 Y110.864 E.00314
G1 X129.256 Y110.864 E.00228
G1 X128.982 Y111.138 E.00314
G1 X129.264 Y111.138 E.00228
G1 X129.538 Y110.864 E.00315
G1 X129.819 Y110.864 E.00228
G1 X129.545 Y111.139 E.00315
G1 X129.826 Y111.139 E.00228
G1 X130.101 Y110.864 E.00315
G1 X130.382 Y110.864 E.00228
G1 X130.108 Y111.139 E.00315
G1 X130.389 Y111.139 E.00228
G1 X130.664 Y110.864 E.00315
G1 X130.946 Y110.864 E.00228
G1 X130.671 Y111.139 E.00315
G1 X130.952 Y111.139 E.00228
G1 X131.227 Y110.864 E.00315
G1 X131.509 Y110.864 E.00228
G1 X131.234 Y111.139 E.00315
G1 X131.515 Y111.139 E.00228
G1 X131.79 Y110.864 E.00316
G1 X132.072 Y110.864 E.00228
G1 X131.797 Y111.139 E.00316
G1 X132.078 Y111.14 E.00228
G1 X132.354 Y110.864 E.00316
G1 X132.635 Y110.864 E.00228
G1 X132.36 Y111.14 E.00316
G1 X132.641 Y111.14 E.00228
G1 X132.917 Y110.864 E.00316
G1 X133.198 Y110.864 E.00228
G1 X132.923 Y111.14 E.00316
G1 X133.204 Y111.14 E.00228
G1 X133.48 Y110.864 E.00316
G1 X133.761 Y110.864 E.00228
G1 X133.486 Y111.14 E.00316
G1 X133.767 Y111.14 E.00228
G1 X134.043 Y110.864 E.00316
G1 X134.325 Y110.864 E.00228
G1 X134.049 Y111.14 E.00317
G1 X134.33 Y111.14 E.00228
G1 X134.606 Y110.864 E.00317
G1 X134.888 Y110.864 E.00228
G1 X134.612 Y111.14 E.00317
G1 X134.893 Y111.141 E.00228
G1 X135.169 Y110.864 E.00317
G1 X135.451 Y110.864 E.00228
G1 X135.175 Y111.141 E.00317
G1 X135.456 Y111.141 E.00228
G1 X135.733 Y110.864 E.00317
G1 X136.014 Y110.864 E.00228
G1 X135.737 Y111.141 E.00317
G1 X136.019 Y111.141 E.00228
G1 X136.296 Y110.864 E.00317
G1 X136.577 Y110.864 E.00228
G1 X136.3 Y111.141 E.00318
G1 X136.582 Y111.141 E.00228
G1 X136.859 Y110.864 E.00318
G1 X137.14 Y110.864 E.00228
G1 X136.863 Y111.141 E.00318
G1 X137.145 Y111.141 E.00228
G1 X137.422 Y110.864 E.00318
G1 X137.704 Y110.864 E.00228
G1 X137.426 Y111.142 E.00318
G1 X137.708 Y111.142 E.00228
G1 X137.985 Y110.864 E.00318
G1 X138.267 Y110.864 E.00228
G1 X137.989 Y111.142 E.00318
G1 X138.271 Y111.142 E.00228
G1 X138.548 Y110.864 E.00318
G1 X138.83 Y110.864 E.00228
G1 X138.552 Y111.142 E.00319
G1 X138.834 Y111.142 E.00228
G1 X139.112 Y110.864 E.00319
G1 X139.393 Y110.864 E.00228
G1 X139.052 Y111.205 E.00391
G1 X139.247 Y111.292 E.00173
G1 X139.675 Y110.864 E.0049
G1 X139.956 Y110.864 E.00228
G1 X139.443 Y111.378 E.00589
G1 X139.519 Y111.412 E.00068
G1 X139.601 Y111.501 E.00098
G1 X140.238 Y110.864 E.00731
G1 X140.519 Y110.864 E.00228
G1 X139.712 Y111.672 E.00926
G1 X139.813 Y111.853 E.00168
G1 X140.801 Y110.864 E.01134
G1 X141.083 Y110.864 E.00228
G1 X139.853 Y112.094 E.01411
G1 X139.859 Y112.147 E.00044
G1 X139.995 Y112.233 E.00131
G1 X141.364 Y110.864 E.01571
G1 X141.646 Y110.864 E.00228
G1 X140.168 Y112.342 E.01695
G1 X140.341 Y112.451 E.00166
G1 X141.927 Y110.864 E.0182
G1 X142.209 Y110.864 E.00228
G1 X140.514 Y112.559 E.01945
G1 X140.687 Y112.668 E.00166
G1 X142.491 Y110.864 E.02069
G1 X142.772 Y110.864 E.00228
G1 X140.86 Y112.777 E.02194
G1 X141.033 Y112.885 E.00166
G1 X143.054 Y110.864 E.02319
G1 X143.335 Y110.864 E.00228
G1 X141.206 Y112.994 E.02443
G1 X141.378 Y113.103 E.00166
G1 X143.617 Y110.864 E.02568
G1 X143.898 Y110.864 E.00228
G1 X141.551 Y113.211 E.02693
G1 X141.724 Y113.32 E.00166
G1 X144.18 Y110.864 E.02817
G1 X144.462 Y110.864 E.00228
G1 X141.897 Y113.429 E.02942
G1 X142.07 Y113.537 E.00166
G1 X144.743 Y110.864 E.03067
G1 X145.025 Y110.864 E.00228
G1 X142.243 Y113.646 E.03192
G1 X142.416 Y113.755 E.00166
G1 X145.306 Y110.864 E.03316
G1 X145.588 Y110.864 E.00228
G1 X142.589 Y113.863 E.03441
G1 X142.762 Y113.972 E.00166
G1 X145.87 Y110.864 E.03566
G1 X146.151 Y110.864 E.00228
G1 X142.935 Y114.081 E.0369
G1 X143.107 Y114.19 E.00166
G1 X146.433 Y110.864 E.03815
G1 X146.714 Y110.864 E.00228
G1 X143.28 Y114.298 E.0394
G1 X143.453 Y114.407 E.00166
G1 X146.996 Y110.864 E.04064
G1 X147.277 Y110.864 E.00228
G1 X143.626 Y114.516 E.04189
G1 X143.799 Y114.624 E.00166
G1 X147.559 Y110.864 E.04314
G1 X147.841 Y110.864 E.00228
G1 X143.972 Y114.733 E.04438
G1 X144.145 Y114.842 E.00166
G1 X148.122 Y110.864 E.04563
G1 X148.404 Y110.864 E.00228
M73 P91 R1
G1 X144.318 Y114.95 E.04688
G1 X144.491 Y115.059 E.00166
G1 X148.685 Y110.864 E.04812
G1 X148.967 Y110.864 E.00228
G1 X144.664 Y115.168 E.04937
G1 X144.836 Y115.276 E.00166
G1 X149.249 Y110.864 E.05062
G1 X149.53 Y110.864 E.00228
G1 X145.009 Y115.385 E.05187
G1 X145.182 Y115.494 E.00166
G1 X149.812 Y110.864 E.05311
G1 X150.093 Y110.864 E.00228
G1 X145.355 Y115.602 E.05436
G1 X145.528 Y115.711 E.00166
G1 X150.375 Y110.864 E.05561
G1 X150.656 Y110.864 E.00228
G1 X145.701 Y115.82 E.05685
G1 X145.874 Y115.928 E.00166
G1 X150.938 Y110.864 E.0581
G1 X151.22 Y110.864 E.00228
G1 X146.047 Y116.037 E.05935
G1 X146.22 Y116.146 E.00166
G1 X151.501 Y110.864 E.06059
G1 X151.783 Y110.864 E.00228
G1 X146.393 Y116.254 E.06184
G1 X146.566 Y116.363 E.00166
G1 X152.064 Y110.864 E.06309
G1 X152.346 Y110.864 E.00228
G1 X146.738 Y116.472 E.06433
G1 X146.911 Y116.581 E.00166
G1 X152.628 Y110.864 E.06558
G1 X152.909 Y110.864 E.00228
G1 X147.084 Y116.689 E.06683
G1 X147.257 Y116.798 E.00166
G1 X153.136 Y110.919 E.06744
G1 X153.136 Y111.201 E.00228
G1 X147.43 Y116.907 E.06546
G1 X147.603 Y117.015 E.00166
G1 X153.136 Y111.482 E.06348
G1 X153.136 Y111.764 E.00228
G1 X147.776 Y117.124 E.06149
G1 X147.949 Y117.233 E.00166
G1 X153.136 Y112.046 E.05951
G1 X153.136 Y112.327 E.00228
G1 X148.122 Y117.341 E.05753
G1 X148.295 Y117.45 E.00166
G1 X153.136 Y112.609 E.05554
G1 X153.136 Y112.89 E.00228
G1 X148.467 Y117.559 E.05356
G1 X148.64 Y117.667 E.00166
G1 X153.136 Y113.172 E.05157
G1 X153.136 Y113.454 E.00228
G1 X148.813 Y117.776 E.04959
G1 X148.986 Y117.885 E.00166
G1 X153.136 Y113.735 E.04761
G1 X153.136 Y114.017 E.00228
G1 X149.159 Y117.993 E.04562
G1 X149.332 Y118.102 E.00166
G1 X153.136 Y114.298 E.04364
G1 X153.136 Y114.58 E.00228
G1 X149.505 Y118.211 E.04166
G1 X149.678 Y118.319 E.00166
G1 X153.136 Y114.861 E.03967
G1 X153.136 Y115.143 E.00228
G1 X149.851 Y118.428 E.03769
G1 X150.024 Y118.537 E.00166
G1 X153.136 Y115.425 E.0357
G1 X153.136 Y115.706 E.00228
G1 X150.196 Y118.645 E.03372
G1 X150.369 Y118.754 E.00166
G1 X153.136 Y115.988 E.03174
G1 X153.136 Y116.269 E.00228
G1 X150.542 Y118.863 E.02975
G1 X150.715 Y118.972 E.00166
G1 X153.136 Y116.551 E.02777
G1 X153.136 Y116.833 E.00228
G1 X150.888 Y119.08 E.02579
G1 X151.061 Y119.189 E.00166
G1 X153.136 Y117.114 E.0238
G1 X153.136 Y117.396 E.00228
G1 X151.234 Y119.298 E.02182
G1 X151.407 Y119.406 E.00166
G1 X153.136 Y117.677 E.01984
G1 X153.136 Y117.959 E.00228
G1 X151.58 Y119.515 E.01785
G1 X151.753 Y119.624 E.00166
G1 X153.136 Y118.24 E.01587
G1 X153.136 Y118.522 E.00228
G1 X151.925 Y119.732 E.01388
G1 X152.098 Y119.841 E.00166
G1 X153.136 Y118.804 E.0119
G1 X153.136 Y119.085 E.00228
G1 X152.271 Y119.95 E.00992
G1 X152.439 Y120.064 E.00164
G1 X153.136 Y119.367 E.008
G1 X153.136 Y119.648 E.00228
G1 X152.587 Y120.197 E.00629
G1 X152.676 Y120.39 E.00172
G1 X153.136 Y119.93 E.00527
G1 X153.136 Y120.212 E.00228
G1 X152.765 Y120.582 E.00425
G1 X152.834 Y120.731 E.00133
G1 X152.837 Y120.792 E.00049
G1 X153.136 Y120.493 E.00343
G1 X153.136 Y120.775 E.00228
G1 X152.852 Y121.059 E.00326
G1 X152.844 Y121.318 E.0021
G1 X152.821 Y121.371 E.00048
G1 X153.136 Y121.056 E.00361
G1 X153.136 Y121.338 E.00228
G1 X152.248 Y122.226 E.01019
G1 X152.391 Y122.213 E.00117
G1 X152.481 Y122.274 E.00089
G1 X153.136 Y121.62 E.00751
G1 X153.136 Y121.901 E.00228
G1 X152.616 Y122.421 E.00596
G1 X152.704 Y122.614 E.00173
G1 X153.136 Y122.183 E.00495
G1 X153.136 Y122.464 E.00228
G1 X152.792 Y122.808 E.00394
G1 X152.864 Y122.967 E.00142
G1 X152.864 Y123.017 E.00041
G1 X153.136 Y122.746 E.00311
G1 X153.136 Y123.027 E.00228
G1 X152.864 Y123.299 E.00311
G1 X152.864 Y123.58 E.00228
G1 X153.136 Y123.309 E.00311
G1 X153.136 Y123.591 E.00228
G1 X152.864 Y123.862 E.00311
G1 X152.864 Y124.144 E.00228
G1 X153.136 Y123.872 E.00311
G1 X153.136 Y124.154 E.00228
G1 X152.864 Y124.425 E.00311
G1 X152.864 Y124.707 E.00228
G1 X153.136 Y124.435 E.00311
G1 X153.136 Y124.717 E.00228
G1 X152.864 Y124.988 E.00311
G1 X152.864 Y125.27 E.00228
G1 X153.136 Y124.999 E.00311
G1 X153.136 Y125.28 E.00228
G1 X152.864 Y125.552 E.00311
G1 X152.864 Y125.833 E.00228
G1 X153.136 Y125.562 E.00311
G1 X153.136 Y125.843 E.00228
G1 X152.864 Y126.115 E.00311
G1 X152.864 Y126.396 E.00228
G1 X153.136 Y126.125 E.00311
G1 X153.136 Y126.406 E.00228
G1 X152.864 Y126.678 E.00311
G1 X152.864 Y126.959 E.00228
G1 X153.136 Y126.688 E.00311
G1 X153.136 Y126.97 E.00228
G1 X152.864 Y127.241 E.00311
G1 X152.864 Y127.523 E.00228
G1 X153.136 Y127.251 E.00311
G1 X153.136 Y127.533 E.00228
G1 X152.864 Y127.804 E.00311
G1 X152.864 Y128.086 E.00228
G1 X153.136 Y127.814 E.00311
G1 X153.136 Y128.096 E.00228
G1 X152.864 Y128.367 E.00311
G1 X152.864 Y128.649 E.00228
G1 X153.136 Y128.378 E.00311
G1 X153.136 Y128.659 E.00228
G1 X152.864 Y128.931 E.00311
G1 X152.851 Y129.164 E.00189
G1 X152.797 Y129.28 E.00104
G1 X153.136 Y128.941 E.00389
G1 X153.136 Y129.222 E.00228
G1 X151.222 Y131.136 E.02195
G1 X151.504 Y131.136 E.00228
G1 X153.136 Y129.504 E.01872
G1 X153.136 Y129.785 E.00228
G1 X151.785 Y131.136 E.01549
G1 X152.067 Y131.136 E.00228
G1 X153.136 Y130.067 E.01226
G1 X153.136 Y130.349 E.00228
G1 X152.349 Y131.136 E.00903
G1 X152.63 Y131.136 E.00228
G1 X153.136 Y130.63 E.0058
G1 X153.136 Y130.912 E.00228
G1 X152.822 Y131.225 E.00359
M204 S10000
G1 X150.851 Y131.225 F60000
G1 F6026.819
M204 S8000
G1 X152.248 Y129.829 E.01602
G1 X151.931 Y129.864 E.00259
G1 X150.659 Y131.136 E.01459
G1 X150.378 Y131.136 E.00228
G1 X151.649 Y129.864 E.01459
G1 X151.367 Y129.864 E.00228
G1 X150.096 Y131.136 E.01459
G1 X149.814 Y131.136 E.00228
G1 X151.086 Y129.864 E.01459
G1 X150.804 Y129.864 E.00228
G1 X149.533 Y131.136 E.01459
G1 X149.251 Y131.136 E.00228
G1 X150.523 Y129.864 E.01459
G1 X150.241 Y129.864 E.00228
G1 X148.97 Y131.136 E.01459
G1 X148.688 Y131.136 E.00228
G1 X149.959 Y129.864 E.01459
G1 X149.678 Y129.864 E.00228
G1 X148.406 Y131.136 E.01459
G1 X148.125 Y131.136 E.00228
G1 X149.396 Y129.864 E.01459
G1 X149.115 Y129.864 E.00228
G1 X147.843 Y131.136 E.01459
G1 X147.562 Y131.136 E.00228
G1 X148.833 Y129.864 E.01459
G1 X148.551 Y129.864 E.00228
G1 X147.28 Y131.136 E.01459
G1 X146.999 Y131.136 E.00228
G1 X148.27 Y129.864 E.01459
G1 X147.988 Y129.864 E.00228
G1 X146.717 Y131.136 E.01459
G1 X146.435 Y131.136 E.00228
G1 X147.707 Y129.864 E.01459
G1 X147.425 Y129.864 E.00228
G1 X146.154 Y131.136 E.01459
G1 X145.872 Y131.136 E.00228
G1 X147.144 Y129.864 E.01459
G1 X146.862 Y129.864 E.00228
G1 X145.591 Y131.136 E.01459
G1 X145.309 Y131.136 E.00228
G1 X146.58 Y129.864 E.01459
G1 X146.299 Y129.864 E.00228
G1 X145.027 Y131.136 E.01459
G1 X144.746 Y131.136 E.00228
G1 X146.017 Y129.864 E.01459
G1 X145.736 Y129.864 E.00228
G1 X144.464 Y131.136 E.01459
G1 X144.183 Y131.136 E.00228
G1 X145.454 Y129.864 E.01459
G1 X145.172 Y129.864 E.00228
G1 X143.901 Y131.136 E.01459
G1 X143.619 Y131.136 E.00228
G1 X144.891 Y129.864 E.01459
G1 X144.609 Y129.864 E.00228
G1 X143.338 Y131.136 E.01459
G1 X143.056 Y131.136 E.00228
G1 X144.328 Y129.864 E.01459
G1 X144.046 Y129.864 E.00228
G1 X142.775 Y131.136 E.01459
G1 X142.493 Y131.136 E.00228
G1 X143.765 Y129.864 E.01459
G1 X143.483 Y129.864 E.00228
G1 X142.212 Y131.136 E.01459
G1 X141.93 Y131.136 E.00228
G1 X143.201 Y129.864 E.01459
G1 X143.11 Y129.864 E.00074
G1 X142.96 Y129.824 E.00126
G1 X141.648 Y131.136 E.01505
G1 X141.367 Y131.136 E.00228
G1 X142.738 Y129.764 E.01573
G1 X142.689 Y129.751 E.00041
G1 X142.576 Y129.645 E.00126
G1 X141.085 Y131.136 E.01711
G1 X140.804 Y131.136 E.00228
G1 X142.431 Y129.508 E.01867
G1 X142.405 Y129.483 E.00029
G1 X142.337 Y129.321 E.00143
G1 X140.522 Y131.136 E.02082
G1 X140.24 Y131.136 E.00228
G1 X142.272 Y129.105 E.0233
G1 X142.268 Y128.826 E.00226
G1 X139.959 Y131.136 E.02649
G1 X139.677 Y131.136 E.00228
G1 X142.825 Y127.988 E.03611
G1 X142.067 Y128.464 E.00726
G1 X139.396 Y131.136 E.03065
G1 X139.114 Y131.136 E.00228
G1 X141.309 Y128.941 E.02518
G1 X140.551 Y129.418 E.00726
G1 X139.802 Y130.166 E.00859
G1 X139.645 Y130.45 E.00263
G1 X139.523 Y130.585 E.00148
G1 X139.212 Y130.756 E.00288
G1 X138.833 Y131.136 E.00436
G1 X138.551 Y131.136 E.00228
G1 X138.841 Y130.846 E.00332
G1 X138.559 Y130.846 E.00229
G1 X138.269 Y131.136 E.00332
G1 X137.988 Y131.136 E.00228
G1 X138.277 Y130.847 E.00332
G1 X137.995 Y130.847 E.00229
G1 X137.706 Y131.136 E.00331
G1 X137.425 Y131.136 E.00228
G1 X137.713 Y130.847 E.00331
G1 X137.431 Y130.847 E.00229
G1 X137.143 Y131.136 E.00331
G1 X136.861 Y131.136 E.00228
G1 X137.15 Y130.848 E.0033
G1 X136.868 Y130.848 E.00229
G1 X136.58 Y131.136 E.0033
G1 X136.298 Y131.136 E.00228
G1 X136.586 Y130.848 E.0033
G1 X136.304 Y130.848 E.00229
G1 X136.017 Y131.136 E.0033
G1 X135.735 Y131.136 E.00228
G1 X136.022 Y130.849 E.00329
G1 X135.74 Y130.849 E.00229
G1 X135.454 Y131.136 E.00329
G1 X135.172 Y131.136 E.00228
G1 X135.458 Y130.849 E.00329
G1 X135.177 Y130.849 E.00229
G1 X134.89 Y131.136 E.00328
G1 X134.609 Y131.136 E.00228
G1 X134.895 Y130.85 E.00328
G1 X134.613 Y130.85 E.00229
G1 X134.327 Y131.136 E.00328
G1 X134.046 Y131.136 E.00228
G1 X134.331 Y130.85 E.00327
G1 X134.049 Y130.851 E.00229
G1 X133.764 Y131.136 E.00327
G1 X133.482 Y131.136 E.00228
G1 X133.767 Y130.851 E.00327
G1 X133.486 Y130.851 E.00229
G1 X133.201 Y131.136 E.00327
G1 X132.919 Y131.136 E.00228
G1 X133.204 Y130.851 E.00326
G1 X132.922 Y130.852 E.00229
G1 X132.638 Y131.136 E.00326
G1 X132.356 Y131.136 E.00228
G1 X132.64 Y130.852 E.00326
G1 X132.358 Y130.852 E.00229
G1 X132.075 Y131.136 E.00325
G1 X131.793 Y131.136 E.00228
G1 X132.076 Y130.852 E.00325
G1 X131.794 Y130.853 E.00229
G1 X131.511 Y131.136 E.00325
G1 X131.23 Y131.136 E.00228
G1 X131.513 Y130.853 E.00324
G1 X131.231 Y130.853 E.00229
G1 X130.948 Y131.136 E.00324
G1 X130.667 Y131.136 E.00228
G1 X130.949 Y130.853 E.00324
G1 X130.667 Y130.854 E.00229
G1 X130.385 Y131.136 E.00324
G1 X130.103 Y131.136 E.00228
G1 X130.385 Y130.854 E.00323
G1 X130.103 Y130.854 E.00229
G1 X129.822 Y131.136 E.00323
G1 X129.54 Y131.136 E.00228
G1 X129.821 Y130.855 E.00323
G1 X129.54 Y130.855 E.00229
G1 X129.259 Y131.136 E.00322
G1 X128.977 Y131.136 E.00228
G1 X129.258 Y130.855 E.00322
G1 X128.976 Y130.855 E.00229
G1 X128.696 Y131.136 E.00322
G1 X128.414 Y131.136 E.00228
G1 X128.694 Y130.856 E.00321
G1 X128.412 Y130.856 E.00229
G1 X128.132 Y131.136 E.00321
G1 X127.851 Y131.136 E.00228
G1 X128.13 Y130.856 E.00321
G1 X127.849 Y130.856 E.00229
G1 X127.569 Y131.136 E.00321
G1 X127.288 Y131.136 E.00228
G1 X127.567 Y130.857 E.0032
G1 X127.285 Y130.857 E.00229
G1 X127.006 Y131.136 E.0032
G1 X126.724 Y131.136 E.00228
G1 X127.003 Y130.857 E.0032
G1 X126.721 Y130.857 E.00229
G1 X126.543 Y131.036 E.00204
; WIPE_START
G1 X126.721 Y130.857 E-.04786
G1 X127.003 Y130.857 E-.05355
G1 X126.724 Y131.136 E-.07485
G1 X127.006 Y131.136 E-.0535
G1 X127.285 Y130.857 E-.07492
G1 X127.567 Y130.857 E-.05355
G1 X127.486 Y130.938 E-.02176
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X124.209 Y130.898 Z1 F60000
G1 Z.6
G1 E.4 F1800
; LINE_WIDTH: 0.21986
G1 F6048.388
M204 S8000
G1 X122.176 Y130.898 E.01643
G1 X122.374 Y131.096 E.00227
G1 X124.105 Y131.096 E.01399
G1 X124.141 Y130.964 E.0011
G1 X124.188 Y130.919 E.00053
; WIPE_START
G1 X124.141 Y130.964 E-.01244
G1 X124.105 Y131.096 E-.02593
G1 X122.374 Y131.096 E-.32877
G1 X122.327 Y131.048 E-.01286
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X121.706 Y123.441 Z1 F60000
G1 X120.775 Y112.024 Z1
G1 Z.6
G1 E.4 F1800
; LINE_WIDTH: 0.22057
G1 F6026.819
M204 S8000
G1 X121.935 Y110.864 E.01331
G1 X121.653 Y110.864 E.00228
G1 X120.864 Y111.653 E.00905
G1 X120.864 Y111.372 E.00228
G1 X121.372 Y110.864 E.00582
G1 X121.09 Y110.864 E.00228
G1 X120.775 Y111.179 E.00362
; WIPE_START
G1 X121.09 Y110.864 E-.0847
G1 X121.372 Y110.864 E-.0535
G1 X120.864 Y111.372 E-.13636
G1 X120.864 Y111.653 E-.0535
G1 X121.058 Y111.46 E-.05194
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X128.253 Y114.006 Z1 F60000
G1 X151.839 Y122.353 Z1
G1 Z.6
G1 E.4 F1800
G1 F6026.819
M204 S8000
G1 X152.228 Y121.964 E.00446
; CHANGE_LAYER
; Z_HEIGHT: 0.7
; LAYER_HEIGHT: 0.1
; WIPE_START
G1 F6026.819
G1 X151.839 Y122.353 E-.38
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 5887
M625
;======== H2D 20250710 layer_change ========
; layer num/total_layer_count: 7/7
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change

M106 S186.15
; OBJECT_ID: 5909
; COOLING_NODE: 0
; start printing object, unique label id: 5909
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z1 I-.645 J1.032 P1  F60000
G1 X165.811 Y131.09 Z1
G1 Z.7
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.21999
G1 F6044.427
M204 S5000
G1 X164.989 Y131.09 E.00664
G1 X164.89 Y131.189 E.00114
G1 X164.89 Y131.89 E.00567
G1 X162.046 Y131.89 E.02301
G1 X160.11 Y129.954 E.02214
G1 X160.11 Y110.11 E.16052
G1 X193.89 Y110.11 E.27324
G1 X193.89 Y114.291 E.03382
G1 X193.89 Y131.89 E.14235
; object ids of layer 7 start: 5887,5909
M624 AwAAAAAAAAA=
;======== H2D 20260731========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
    

    
        M971 S11 C10 O0
        M1004 S5 P1  ; external shutter
    
    
    
M623
; SKIPPABLE_END

; object ids of this layer7 end: 5887,5909
M625
G1 X167.91 Y131.89 E.21015
G1 X167.91 Y131.189 E.00567
G1 X167.811 Y131.09 E.00114
G1 X166.989 Y131.09 E.00664
G1 X166.91 Y131.129 E.00071
G1 X166.89 Y131.189 E.00051
G1 X166.89 Y131.89 E.00567
G1 X165.91 Y131.89 E.00793
G1 X165.904 Y131.154 E.00595
G1 X165.811 Y131.09 E.00091
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X164.989 Y131.09 E-.15608
G1 X164.89 Y131.189 E-.02667
G1 X164.89 Y131.89 E-.13314
G1 X164.553 Y131.89 E-.06411
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X172.096 Y130.726 Z1.1 F60000
G1 X183.023 Y129.039 Z1.1
G1 Z.7
G1 E.4 F1800
G1 F6044.427
M204 S5000
G1 X182.996 Y128.9 E.00115
G1 X183.037 Y128.843 E.00056
G1 X191.958 Y122.896 E.08673
G1 X192.076 Y122.905 E.00096
G1 X192.11 Y122.98 E.00066
G1 X192.11 Y129.011 E.04878
M73 P92 R1
G1 X192.086 Y129.075 E.00055
G1 X192.011 Y129.11 E.00067
G1 X183.118 Y129.11 E.07194
G1 X183.023 Y129.039 E.00096
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X182.996 Y128.9 E-.02707
G1 X183.037 Y128.843 E-.01318
G1 X184.525 Y127.851 E-.33975
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X181.977 Y120.657 Z1.1 F60000
G1 X179.112 Y112.569 Z1.1
G1 Z.7
G1 E.4 F1800
G1 F6044.427
M204 S5000
G1 X191.989 Y120.663 E.12303
G1 X192.081 Y120.786 E.00124
G1 X192.082 Y121.226 E.00356
G1 X191.99 Y121.336 E.00116
G1 X179.112 Y129.431 E.12303
G1 X179.081 Y129.948 E.0042
G1 X178.897 Y130.104 E.00195
G1 X162.103 Y130.104 E.13584
G1 X161.955 Y130.022 E.00137
G1 X161.89 Y129.852 E.00148
G1 X161.89 Y112.148 E.14321
G1 X161.966 Y111.965 E.0016
G1 X162.148 Y111.89 E.0016
G1 X178.897 Y111.896 E.13548
G1 X179.081 Y112.051 E.00195
G1 X179.112 Y112.569 E.0042
; WIPE_START
M204 S8000
G1 X180.806 Y113.634 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X188.18 Y111.665 Z1.1 F60000
G1 X193.594 Y110.219 Z1.1
G1 Z.7
G1 E.4 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.22
G1 F6044.128
M204 S2000
G1 X193.781 Y110.406 E.00214
G1 X193.851 Y110.476
G1 X193.851 Y110.757
G1 X193.781 Y110.687
G1 X193.313 Y110.219 E.00535
G1 X193.243 Y110.149
G1 X192.962 Y110.149
G1 X193.032 Y110.219
G1 X193.781 Y110.968 E.00857
G1 X193.851 Y111.038
G1 X193.851 Y111.319
G1 X193.781 Y111.249
G1 X192.751 Y110.219 E.01178
G1 X192.681 Y110.149
G1 X192.401 Y110.149
G1 X192.471 Y110.219
G1 X193.781 Y111.529 E.01499
G1 X193.851 Y111.599
G1 X193.851 Y111.88
G1 X193.781 Y111.81
G1 X192.19 Y110.219 E.0182
G1 X192.12 Y110.149
G1 X191.839 Y110.149
G1 X191.909 Y110.219
G1 X193.781 Y112.091 E.02141
G1 X193.851 Y112.161
G1 X193.851 Y112.442
G1 X193.781 Y112.372
G1 X191.628 Y110.219 E.02463
G1 X191.558 Y110.149
G1 X191.277 Y110.149
G1 X191.347 Y110.219
G1 X193.781 Y112.653 E.02784
G1 X193.851 Y112.723
G1 X193.851 Y113.003
G1 X193.781 Y112.933
G1 X191.067 Y110.219 E.03105
G1 X190.997 Y110.149
G1 X190.716 Y110.149
G1 X190.786 Y110.219
G1 X193.781 Y113.214 E.03426
G1 X193.851 Y113.284
G1 X193.851 Y113.565
G1 X193.781 Y113.495
G1 X190.505 Y110.219 E.03747
G1 X190.435 Y110.149
G1 X190.154 Y110.149
G1 X190.224 Y110.219
G1 X193.781 Y113.776 E.04069
G1 X193.851 Y113.846
G1 X193.851 Y114.126
G1 X193.781 Y114.056
G1 X189.944 Y110.219 E.0439
G1 X189.874 Y110.149
G1 X189.593 Y110.149
G1 X189.663 Y110.219
G1 X193.781 Y114.337 E.04711
G1 X193.851 Y114.407
G1 X193.851 Y114.688
G1 X193.781 Y114.618
G1 X189.382 Y110.219 E.05032
G1 X189.312 Y110.149
G1 X189.031 Y110.149
G1 X189.101 Y110.219
G1 X193.781 Y114.899 E.05353
G1 X193.851 Y114.969
G1 X193.851 Y115.249
G1 X193.781 Y115.179
G1 X188.821 Y110.219 E.05674
G1 X188.751 Y110.149
G1 X188.47 Y110.149
G1 X188.54 Y110.219
G1 X193.781 Y115.46 E.05996
G1 X193.851 Y115.53
G1 X193.851 Y115.811
G1 X193.781 Y115.741
G1 X188.259 Y110.219 E.06317
G1 X188.189 Y110.149
G1 X187.908 Y110.149
G1 X187.978 Y110.219
G1 X193.781 Y116.022 E.06638
G1 X193.851 Y116.092
G1 X193.851 Y116.372
G1 X193.781 Y116.302
G1 X187.698 Y110.219 E.06959
G1 X187.628 Y110.149
G1 X187.347 Y110.149
G1 X187.417 Y110.219
G1 X193.781 Y116.583 E.0728
G1 X193.851 Y116.653
G1 X193.851 Y116.934
G1 X193.781 Y116.864
G1 X187.136 Y110.219 E.07602
G1 X187.066 Y110.149
G1 X186.785 Y110.149
G1 X186.855 Y110.219
G1 X193.781 Y117.145 E.07923
G1 X193.851 Y117.215
G1 X193.851 Y117.496
G1 X193.781 Y117.426
G1 X186.574 Y110.219 E.08244
G1 X186.504 Y110.149
G1 X186.224 Y110.149
G1 X186.294 Y110.219
G1 X193.781 Y117.706 E.08565
G1 X193.851 Y117.776
G1 X193.851 Y118.057
G1 X193.781 Y117.987
G1 X186.013 Y110.219 E.08886
G1 X185.943 Y110.149
G1 X185.662 Y110.149
G1 X185.732 Y110.219
G1 X193.781 Y118.268 E.09208
G1 X193.851 Y118.338
G1 X193.851 Y118.619
G1 X193.781 Y118.549
G1 X185.451 Y110.219 E.09529
G1 X185.381 Y110.149
G1 X185.101 Y110.149
G1 X185.171 Y110.219
G1 X193.781 Y118.829 E.0985
G1 X193.851 Y118.899
G1 X193.851 Y119.18
G1 X193.781 Y119.11
G1 X184.89 Y110.219 E.10171
G1 X184.82 Y110.149
G1 X184.539 Y110.149
G1 X184.609 Y110.219
G1 X193.781 Y119.391 E.10492
G1 X193.851 Y119.461
G1 X193.851 Y119.742
G1 X193.781 Y119.672
G1 X184.328 Y110.219 E.10814
G1 X184.258 Y110.149
G1 X183.978 Y110.149
G1 X184.048 Y110.219
G1 X193.781 Y119.952 E.11135
G1 X193.851 Y120.022
G1 X193.851 Y120.303
G1 X193.781 Y120.233
G1 X183.767 Y110.219 E.11456
G1 X183.697 Y110.149
G1 X183.416 Y110.149
G1 X183.486 Y110.219
G1 X193.781 Y120.514 E.11777
G1 X193.851 Y120.584
G1 X193.851 Y120.865
G1 X193.781 Y120.795
G1 X183.205 Y110.219 E.12098
G1 X183.135 Y110.149
G1 X182.855 Y110.149
G1 X182.925 Y110.219
G1 X193.781 Y121.075 E.1242
G1 X193.851 Y121.145
G1 X193.851 Y121.426
G1 X193.781 Y121.356
G1 X182.644 Y110.219 E.12741
G1 X182.574 Y110.149
G1 X182.293 Y110.149
G1 X182.363 Y110.219
G1 X193.781 Y121.637 E.13062
G1 X193.851 Y121.707
G1 X193.851 Y121.988
G1 X193.781 Y121.918
G1 X182.082 Y110.219 E.13383
G1 X182.012 Y110.149
G1 X181.732 Y110.149
G1 X181.802 Y110.219
G1 X193.781 Y122.199 E.13704
G1 X193.851 Y122.269
G1 X193.851 Y122.549
G1 X193.781 Y122.479
G1 X192.196 Y120.894 E.01814
G1 X192.126 Y120.824
G1 X192.139 Y121.118
G1 X192.209 Y121.188
G1 X193.781 Y122.76 E.01798
G1 X193.851 Y122.83
G1 X193.851 Y123.111
G1 X193.781 Y123.041
G1 X192.105 Y121.365 E.01917
G1 X192.035 Y121.295
G1 X191.88 Y121.42
G1 X191.95 Y121.49
G1 X193.781 Y123.322 E.02095
G1 X193.851 Y123.392
G1 X193.851 Y123.672
G1 X193.781 Y123.602
G1 X191.777 Y121.599 E.02292
G1 X191.707 Y121.529
G1 X191.535 Y121.637
G1 X191.605 Y121.707
G1 X193.781 Y123.883 E.02489
G1 X193.851 Y123.953
G1 X193.851 Y124.234
G1 X193.781 Y124.164
G1 X191.433 Y121.816 E.02686
G1 X191.363 Y121.746
G1 X191.19 Y121.854
G1 X191.26 Y121.924
G1 X193.781 Y124.445 E.02884
G1 X193.851 Y124.515
G1 X193.851 Y124.795
G1 X193.781 Y124.725
G1 X192.219 Y123.164 E.01787
G1 X192.149 Y123.094
G1 X192.149 Y123.374
G1 X192.219 Y123.444
G1 X193.781 Y125.006 E.01787
G1 X193.851 Y125.076
G1 X193.851 Y125.357
G1 X193.781 Y125.287
G1 X192.219 Y123.725 E.01787
G1 X192.149 Y123.655
G1 X192.149 Y123.936
G1 X192.219 Y124.006
G1 X193.781 Y125.568 E.01787
G1 X193.851 Y125.638
G1 X193.851 Y125.918
G1 X193.781 Y125.848
G1 X192.219 Y124.287 E.01787
G1 X192.149 Y124.217
G1 X192.149 Y124.498
G1 X192.219 Y124.568
G1 X193.781 Y126.129 E.01787
G1 X193.851 Y126.199
G1 X193.851 Y126.48
G1 X193.781 Y126.41
G1 X192.219 Y124.848 E.01787
G1 X192.149 Y124.778
G1 X192.149 Y125.059
G1 X192.219 Y125.129
G1 X193.781 Y126.691 E.01787
G1 X193.851 Y126.761
G1 X193.851 Y127.041
G1 X193.781 Y126.971
G1 X192.219 Y125.41 E.01787
G1 X192.149 Y125.34
G1 X192.149 Y125.621
G1 X192.219 Y125.691
G1 X193.781 Y127.252 E.01787
G1 X193.851 Y127.322
G1 X193.851 Y127.603
G1 X193.781 Y127.533
G1 X192.219 Y125.971 E.01787
G1 X192.149 Y125.901
G1 X192.149 Y126.182
G1 X192.219 Y126.252
G1 X193.781 Y127.814 E.01787
G1 X193.851 Y127.884
G1 X193.851 Y128.165
G1 X193.781 Y128.095
G1 X192.219 Y126.533 E.01787
G1 X192.149 Y126.463
G1 X192.149 Y126.744
G1 X192.219 Y126.814
G1 X193.781 Y128.375 E.01787
G1 X193.851 Y128.445
G1 X193.851 Y128.726
G1 X193.781 Y128.656
G1 X192.219 Y127.094 E.01787
G1 X192.149 Y127.024
G1 X192.149 Y127.305
G1 X192.219 Y127.375
G1 X193.781 Y128.937 E.01787
G1 X193.851 Y129.007
G1 X193.851 Y129.288
G1 X193.781 Y129.218
G1 X192.219 Y127.656 E.01787
G1 X192.149 Y127.586
G1 X192.149 Y127.867
G1 X192.219 Y127.937
G1 X193.781 Y129.498 E.01787
G1 X193.851 Y129.568
G1 X193.851 Y129.849
G1 X193.781 Y129.779
G1 X192.219 Y128.217 E.01787
G1 X192.149 Y128.147
G1 X192.149 Y128.428
G1 X192.219 Y128.498
G1 X193.781 Y130.06 E.01787
G1 X193.851 Y130.13
G1 X193.851 Y130.411
G1 X193.781 Y130.341
G1 X192.219 Y128.779 E.01787
G1 X192.149 Y128.709
G1 X192.136 Y128.977
G1 X192.206 Y129.047
G1 X193.781 Y130.621 E.01801
G1 X193.851 Y130.691
G1 X193.851 Y130.972
G1 X193.781 Y130.902
G1 X192.082 Y129.204 E.01943
G1 X192.012 Y129.134
G1 X191.747 Y129.149
G1 X191.817 Y129.219
G1 X193.781 Y131.183 E.02247
G1 X193.851 Y131.253
G1 X193.851 Y131.534
G1 X193.781 Y131.464
G1 X191.536 Y129.219 E.02568
G1 X191.466 Y129.149
G1 X191.186 Y129.149
G1 X191.256 Y129.219
G1 X193.781 Y131.744 E.02889
G1 X193.851 Y131.814
G1 X193.606 Y131.851
G1 X193.536 Y131.781
G1 X190.975 Y129.219 E.02931
G1 X190.905 Y129.149
G1 X190.624 Y129.149
G1 X190.694 Y129.219
G1 X193.256 Y131.781 E.02931
G1 X193.326 Y131.851
G1 X193.045 Y131.851
G1 X192.975 Y131.781
G1 X190.413 Y129.219 E.02931
G1 X190.343 Y129.149
G1 X190.062 Y129.149
G1 X190.132 Y129.219
G1 X192.694 Y131.781 E.02931
G1 X192.764 Y131.851
G1 X192.483 Y131.851
G1 X192.413 Y131.781
G1 X189.852 Y129.219 E.02931
G1 X189.782 Y129.149
G1 X189.501 Y129.149
G1 X189.571 Y129.219
G1 X192.133 Y131.781 E.02931
G1 X192.203 Y131.851
G1 X191.922 Y131.851
G1 X191.852 Y131.781
G1 X189.29 Y129.219 E.02931
G1 X189.22 Y129.149
G1 X188.939 Y129.149
G1 X189.009 Y129.219
G1 X191.571 Y131.781 E.02931
G1 X191.641 Y131.851
G1 X191.36 Y131.851
G1 X191.29 Y131.781
G1 X188.729 Y129.219 E.02931
G1 X188.659 Y129.149
G1 X188.378 Y129.149
G1 X188.448 Y129.219
G1 X191.01 Y131.781 E.02931
G1 X191.08 Y131.851
G1 X190.799 Y131.851
G1 X190.729 Y131.781
G1 X188.167 Y129.219 E.02931
G1 X188.097 Y129.149
G1 X187.816 Y129.149
G1 X187.886 Y129.219
G1 X190.448 Y131.781 E.02931
G1 X190.518 Y131.851
M73 P93 R1
G1 X190.237 Y131.851
G1 X190.167 Y131.781
G1 X187.606 Y129.219 E.02931
G1 X187.536 Y129.149
G1 X187.255 Y129.149
G1 X187.325 Y129.219
G1 X189.887 Y131.781 E.02931
G1 X189.957 Y131.851
G1 X189.676 Y131.851
G1 X189.606 Y131.781
G1 X187.044 Y129.219 E.02931
G1 X186.974 Y129.149
G1 X186.693 Y129.149
G1 X186.763 Y129.219
G1 X189.325 Y131.781 E.02931
G1 X189.395 Y131.851
G1 X189.114 Y131.851
G1 X189.044 Y131.781
G1 X186.483 Y129.219 E.02931
G1 X186.413 Y129.149
G1 X186.132 Y129.149
G1 X186.202 Y129.219
G1 X188.763 Y131.781 E.02931
G1 X188.833 Y131.851
G1 X188.553 Y131.851
G1 X188.483 Y131.781
G1 X185.921 Y129.219 E.02931
G1 X185.851 Y129.149
G1 X185.57 Y129.149
G1 X185.64 Y129.219
G1 X188.202 Y131.781 E.02931
G1 X188.272 Y131.851
G1 X187.991 Y131.851
G1 X187.921 Y131.781
G1 X185.359 Y129.219 E.02931
G1 X185.289 Y129.149
G1 X185.009 Y129.149
G1 X185.079 Y129.219
G1 X187.64 Y131.781 E.02931
G1 X187.71 Y131.851
G1 X187.43 Y131.851
G1 X187.36 Y131.781
G1 X184.798 Y129.219 E.02931
G1 X184.728 Y129.149
G1 X184.447 Y129.149
G1 X184.517 Y129.219
G1 X187.079 Y131.781 E.02931
G1 X187.149 Y131.851
G1 X186.868 Y131.851
G1 X186.798 Y131.781
G1 X184.236 Y129.219 E.02931
G1 X184.166 Y129.149
G1 X183.886 Y129.149
G1 X183.956 Y129.219
G1 X186.517 Y131.781 E.02931
G1 X186.587 Y131.851
G1 X186.307 Y131.851
G1 X186.237 Y131.781
G1 X183.675 Y129.219 E.02931
G1 X183.605 Y129.149
G1 X183.324 Y129.149
G1 X183.394 Y129.219
G1 X185.956 Y131.781 E.02931
G1 X186.026 Y131.851
G1 X185.745 Y131.851
G1 X185.675 Y131.781
G1 X183.112 Y129.218 E.02932
; WIPE_START
M204 S8000
G1 X184.527 Y130.632 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X189.756 Y125.073 Z1.1 F60000
G1 X191.875 Y122.82 Z1.1
G1 Z.7
G1 E.4 F1800
G1 F6044.128
M204 S2000
G1 X191.088 Y122.032 E.00901
G1 X191.018 Y121.962
G1 X190.845 Y122.071
G1 X190.915 Y122.141
G1 X191.707 Y122.932 E.00905
G1 X191.777 Y123.002
G1 X191.608 Y123.114
G1 X191.538 Y123.044
G1 X190.743 Y122.249 E.0091
G1 X190.673 Y122.179
G1 X190.501 Y122.287
G1 X190.571 Y122.357
G1 X191.37 Y123.157 E.00914
G1 X191.44 Y123.227
G1 X191.271 Y123.339
G1 X191.201 Y123.269
G1 X190.398 Y122.466 E.00919
G1 X190.328 Y122.396
G1 X190.156 Y122.504
G1 X190.226 Y122.574
G1 X191.033 Y123.381 E.00923
G1 X191.103 Y123.451
G1 X190.935 Y123.564
G1 X190.865 Y123.494
G1 X190.053 Y122.682 E.00928
G1 X189.983 Y122.612
G1 X189.811 Y122.721
G1 X189.881 Y122.791
G1 X190.696 Y123.606 E.00932
G1 X190.766 Y123.676
G1 X190.598 Y123.788
G1 X190.528 Y123.718
G1 X189.709 Y122.899 E.00937
G1 X189.639 Y122.829
G1 X189.466 Y122.938
G1 X189.536 Y123.008
G1 X190.359 Y123.831 E.00941
G1 X190.429 Y123.901
G1 X190.261 Y124.013
G1 X190.191 Y123.943
G1 X189.364 Y123.116 E.00946
G1 X189.294 Y123.046
G1 X189.121 Y123.154
G1 X189.191 Y123.224
G1 X190.022 Y124.055 E.0095
G1 X190.092 Y124.125
G1 X189.924 Y124.237
G1 X189.854 Y124.167
G1 X189.019 Y123.333 E.00955
G1 X188.949 Y123.263
G1 X188.777 Y123.371
G1 X188.847 Y123.441
G1 X189.685 Y124.28 E.0096
G1 X189.755 Y124.35
G1 X189.587 Y124.462
G1 X189.517 Y124.392
G1 X188.674 Y123.549 E.00964
G1 X188.604 Y123.479
G1 X188.432 Y123.588
G1 X188.502 Y123.658
G1 X189.348 Y124.504 E.00969
G1 X189.418 Y124.574
G1 X189.25 Y124.687
G1 X189.18 Y124.617
G1 X188.329 Y123.766 E.00973
G1 X188.259 Y123.696
G1 X188.087 Y123.804
G1 X188.157 Y123.874
G1 X189.011 Y124.729 E.00978
G1 X189.081 Y124.799
G1 X188.913 Y124.911
G1 X188.843 Y124.841
G1 X187.985 Y123.983 E.00982
G1 X187.915 Y123.913
G1 X187.742 Y124.021
G1 X187.812 Y124.091
G1 X188.675 Y124.954 E.00987
G1 X188.745 Y125.024
G1 X188.576 Y125.136
G1 X188.506 Y125.066
G1 X187.64 Y124.2 E.00991
G1 X187.57 Y124.13
G1 X187.397 Y124.238
G1 X187.467 Y124.308
G1 X188.338 Y125.178 E.00996
G1 X188.408 Y125.248
G1 X188.239 Y125.361
G1 X188.169 Y125.291
G1 X187.295 Y124.416 E.01
G1 X187.225 Y124.346
G1 X187.053 Y124.455
G1 X187.123 Y124.525
G1 X188.001 Y125.403 E.01005
G1 X188.071 Y125.473
G1 X187.902 Y125.585
G1 X187.832 Y125.515
G1 X186.95 Y124.633 E.01009
G1 X186.88 Y124.563
G1 X186.708 Y124.671
G1 X186.778 Y124.741
G1 X187.664 Y125.627 E.01014
G1 X187.734 Y125.697
G1 X187.565 Y125.81
G1 X187.495 Y125.74
G1 X186.605 Y124.85 E.01018
G1 X186.535 Y124.78
G1 X186.363 Y124.888
G1 X186.433 Y124.958
G1 X187.327 Y125.852 E.01023
G1 X187.397 Y125.922
G1 X187.228 Y126.034
G1 X187.158 Y125.964
G1 X186.261 Y125.067 E.01027
G1 X186.191 Y124.997
G1 X186.018 Y125.105
G1 X186.088 Y125.175
G1 X186.99 Y126.077 E.01032
G1 X187.06 Y126.147
G1 X186.891 Y126.259
G1 X186.821 Y126.189
G1 X185.916 Y125.283 E.01036
G1 X185.846 Y125.213
G1 X185.673 Y125.322
G1 X185.743 Y125.392
G1 X186.653 Y126.301 E.01041
G1 X186.723 Y126.371
G1 X186.555 Y126.484
G1 X186.485 Y126.414
G1 X185.571 Y125.5 E.01045
G1 X185.501 Y125.43
G1 X185.329 Y125.538
G1 X185.399 Y125.608
G1 X186.316 Y126.526 E.0105
G1 X186.386 Y126.596
G1 X186.218 Y126.708
G1 X186.148 Y126.638
G1 X185.226 Y125.717 E.01054
G1 X185.156 Y125.647
G1 X184.984 Y125.755
G1 X185.054 Y125.825
G1 X185.979 Y126.75 E.01059
G1 X186.049 Y126.82
G1 X185.881 Y126.933
G1 X185.811 Y126.863
G1 X184.881 Y125.933 E.01063
G1 X184.811 Y125.863
G1 X184.639 Y125.972
G1 X184.709 Y126.042
G1 X185.642 Y126.975 E.01068
G1 X185.712 Y127.045
G1 X185.544 Y127.157
G1 X185.474 Y127.087
G1 X184.537 Y126.15 E.01072
G1 X184.467 Y126.08
G1 X184.294 Y126.189
G1 X184.364 Y126.259
G1 X185.305 Y127.2 E.01077
G1 X185.375 Y127.27
G1 X185.207 Y127.382
G1 X185.137 Y127.312
G1 X184.192 Y126.367 E.01081
G1 X184.122 Y126.297
G1 X183.949 Y126.405
G1 X184.019 Y126.475
G1 X184.968 Y127.424 E.01086
G1 X185.038 Y127.494
G1 X184.87 Y127.607
G1 X184.8 Y127.537
G1 X183.847 Y126.584 E.0109
G1 X183.777 Y126.514
G1 X183.605 Y126.622
G1 X183.675 Y126.692
G1 X184.632 Y127.649 E.01095
G1 X184.702 Y127.719
G1 X184.533 Y127.831
G1 X184.463 Y127.761
G1 X183.502 Y126.8 E.01099
G1 X183.432 Y126.73
G1 X183.26 Y126.839
G1 X183.33 Y126.909
G1 X184.295 Y127.874 E.01104
G1 X184.365 Y127.944
G1 X184.196 Y128.056
G1 X184.126 Y127.986
G1 X183.157 Y127.017 E.01108
G1 X183.087 Y126.947
G1 X182.915 Y127.055
G1 X182.985 Y127.125
G1 X183.958 Y128.098 E.01113
G1 X184.028 Y128.168
G1 X183.859 Y128.28
G1 X183.789 Y128.21
G1 X182.813 Y127.234 E.01117
G1 X182.743 Y127.164
G1 X182.57 Y127.272
G1 X182.64 Y127.342
G1 X183.621 Y128.323 E.01122
G1 X183.691 Y128.393
G1 X183.522 Y128.505
G1 X183.452 Y128.435
G1 X182.468 Y127.451 E.01126
G1 X182.398 Y127.381
G1 X182.225 Y127.489
G1 X182.295 Y127.559
G1 X183.284 Y128.547 E.01131
G1 X183.354 Y128.617
G1 X183.185 Y128.73
G1 X183.115 Y128.66
G1 X182.123 Y127.667 E.01135
G1 X182.053 Y127.597
G1 X181.881 Y127.706
G1 X181.951 Y127.776
G1 X182.955 Y128.78 E.01149
G1 X183.025 Y128.85
G1 X182.969 Y129.075
G1 X182.899 Y129.005
G1 X181.778 Y127.884 E.01282
G1 X181.708 Y127.814
G1 X181.536 Y127.922
G1 X181.606 Y127.992
G1 X185.394 Y131.781 E.04334
G1 X185.464 Y131.851
G1 X185.184 Y131.851
G1 X185.114 Y131.781
G1 X181.433 Y128.101 E.0421
G1 X181.363 Y128.031
G1 X181.191 Y128.139
G1 X181.261 Y128.209
G1 X184.833 Y131.781 E.04086
G1 X184.903 Y131.851
G1 X184.622 Y131.851
G1 X184.552 Y131.781
G1 X181.089 Y128.317 E.03962
G1 X181.019 Y128.247
G1 X180.846 Y128.356
G1 X180.916 Y128.426
G1 X184.271 Y131.781 E.03838
G1 X184.341 Y131.851
G1 X184.06 Y131.851
G1 X183.99 Y131.781
G1 X180.744 Y128.534 E.03714
G1 X180.674 Y128.464
G1 X180.501 Y128.573
G1 X180.571 Y128.643
G1 X183.71 Y131.781 E.0359
G1 X183.78 Y131.851
G1 X183.499 Y131.851
G1 X183.429 Y131.781
G1 X180.399 Y128.751 E.03466
G1 X180.329 Y128.681
G1 X180.157 Y128.789
G1 X180.227 Y128.859
G1 X183.148 Y131.781 E.03342
G1 X183.218 Y131.851
G1 X182.937 Y131.851
G1 X182.867 Y131.781
G1 X180.054 Y128.968 E.03218
G1 X179.984 Y128.898
G1 X179.812 Y129.006
G1 X179.882 Y129.076
G1 X182.587 Y131.781 E.03094
G1 X182.657 Y131.851
G1 X182.376 Y131.851
G1 X182.306 Y131.781
G1 X179.709 Y129.184 E.0297
G1 X179.639 Y129.114
G1 X179.467 Y129.223
G1 X179.537 Y129.293
G1 X182.025 Y131.781 E.02846
G1 X182.095 Y131.851
G1 X181.814 Y131.851
G1 X181.744 Y131.781
G1 X179.365 Y129.401 E.02722
G1 X179.295 Y129.331
G1 X179.15 Y129.467
G1 X179.22 Y129.537
G1 X181.464 Y131.781 E.02567
G1 X181.534 Y131.851
G1 X181.253 Y131.851
G1 X181.183 Y131.781
G1 X179.212 Y129.81 E.02254
G1 X179.142 Y129.74
G1 X179.083 Y129.962
G1 X179.153 Y130.032
G1 X180.902 Y131.781 E.02001
G1 X180.972 Y131.851
G1 X180.691 Y131.851
G1 X180.621 Y131.781
G1 X179.009 Y130.168 E.01845
G1 X178.939 Y130.098
G1 X178.699 Y130.14
G1 X178.769 Y130.21
G1 X180.341 Y131.781 E.01797
G1 X180.411 Y131.851
G1 X180.13 Y131.851
G1 X180.06 Y131.781
G1 X178.489 Y130.21 E.01797
G1 X178.419 Y130.14
G1 X178.138 Y130.14
G1 X178.208 Y130.21
G1 X179.779 Y131.781 E.01797
G1 X179.849 Y131.851
G1 X179.568 Y131.851
G1 X179.498 Y131.781
G1 X177.927 Y130.21 E.01797
G1 X177.857 Y130.14
G1 X177.577 Y130.14
G1 X177.647 Y130.21
G1 X179.217 Y131.781 E.01797
G1 X179.287 Y131.851
G1 X179.007 Y131.851
G1 X178.937 Y131.781
G1 X177.366 Y130.21 E.01797
G1 X177.296 Y130.14
G1 X177.015 Y130.14
G1 X177.085 Y130.21
G1 X178.656 Y131.781 E.01797
G1 X178.726 Y131.851
G1 X178.445 Y131.851
G1 X178.375 Y131.781
G1 X176.804 Y130.21 E.01797
G1 X176.734 Y130.14
G1 X176.454 Y130.14
G1 X176.524 Y130.21
G1 X178.094 Y131.781 E.01797
G1 X178.164 Y131.851
G1 X177.884 Y131.851
G1 X177.814 Y131.781
G1 X176.243 Y130.21 E.01797
G1 X176.173 Y130.14
G1 X175.892 Y130.14
G1 X175.962 Y130.21
G1 X177.533 Y131.781 E.01797
G1 X177.603 Y131.851
G1 X177.322 Y131.851
G1 X177.252 Y131.781
G1 X175.682 Y130.21 E.01797
G1 X175.612 Y130.14
G1 X175.331 Y130.14
G1 X175.401 Y130.21
G1 X176.971 Y131.781 E.01797
G1 X177.041 Y131.851
G1 X176.761 Y131.851
G1 X176.691 Y131.781
G1 X175.12 Y130.21 E.01797
G1 X175.05 Y130.14
G1 X174.769 Y130.14
G1 X174.839 Y130.21
G1 X176.41 Y131.781 E.01797
G1 X176.48 Y131.851
G1 X176.199 Y131.851
G1 X176.129 Y131.781
G1 X174.559 Y130.211 E.01796
G1 X174.489 Y130.141
G1 X174.208 Y130.141
G1 X174.278 Y130.211
G1 X175.848 Y131.781 E.01796
G1 X175.918 Y131.851
G1 X175.638 Y131.851
G1 X175.568 Y131.781
G1 X173.997 Y130.211 E.01796
G1 X173.927 Y130.141
G1 X173.647 Y130.141
G1 X173.717 Y130.211
G1 X175.287 Y131.781 E.01796
G1 X175.357 Y131.851
G1 X175.076 Y131.851
G1 X175.006 Y131.781
G1 X173.436 Y130.211 E.01796
G1 X173.366 Y130.141
G1 X173.085 Y130.141
G1 X173.155 Y130.211
G1 X174.725 Y131.781 E.01796
G1 X174.795 Y131.851
G1 X174.515 Y131.851
G1 X174.445 Y131.781
G1 X172.874 Y130.211 E.01796
G1 X172.804 Y130.141
G1 X172.524 Y130.141
G1 X172.594 Y130.211
G1 X174.164 Y131.781 E.01796
G1 X174.234 Y131.851
G1 X173.953 Y131.851
G1 X173.883 Y131.781
G1 X172.313 Y130.211 E.01796
G1 X172.243 Y130.141
G1 X171.962 Y130.141
G1 X172.032 Y130.211
G1 X173.602 Y131.781 E.01796
G1 X173.672 Y131.851
G1 X173.391 Y131.851
G1 X173.321 Y131.781
G1 X171.752 Y130.211 E.01796
G1 X171.682 Y130.141
G1 X171.401 Y130.141
G1 X171.471 Y130.211
G1 X173.041 Y131.781 E.01796
G1 X173.111 Y131.851
G1 X172.83 Y131.851
G1 X172.76 Y131.781
G1 X171.19 Y130.211 E.01796
G1 X171.12 Y130.141
G1 X170.839 Y130.141
G1 X170.909 Y130.211
G1 X172.479 Y131.781 E.01796
G1 X172.549 Y131.851
G1 X172.268 Y131.851
G1 X172.198 Y131.781
G1 X170.629 Y130.211 E.01796
G1 X170.559 Y130.141
G1 X170.278 Y130.141
G1 X170.348 Y130.211
G1 X171.918 Y131.781 E.01796
G1 X171.988 Y131.851
G1 X171.707 Y131.851
G1 X171.637 Y131.781
G1 X170.067 Y130.211 E.01796
G1 X169.997 Y130.141
G1 X169.717 Y130.141
G1 X169.787 Y130.211
G1 X171.356 Y131.781 E.01795
G1 X171.426 Y131.851
G1 X171.145 Y131.851
G1 X171.075 Y131.781
G1 X169.506 Y130.211 E.01795
G1 X169.436 Y130.141
G1 X169.155 Y130.141
G1 X169.225 Y130.211
G1 X170.795 Y131.781 E.01795
G1 X170.865 Y131.851
G1 X170.584 Y131.851
G1 X170.514 Y131.781
G1 X168.944 Y130.212 E.01795
G1 X168.874 Y130.142
G1 X168.594 Y130.142
G1 X168.664 Y130.212
G1 X170.233 Y131.781 E.01795
G1 X170.303 Y131.851
G1 X170.022 Y131.851
G1 X169.952 Y131.781
G1 X168.383 Y130.212 E.01795
G1 X168.313 Y130.142
G1 X168.032 Y130.142
G1 X168.102 Y130.212
G1 X169.672 Y131.781 E.01795
G1 X169.742 Y131.851
G1 X169.461 Y131.851
G1 X169.391 Y131.781
G1 X167.822 Y130.212 E.01795
G1 X167.752 Y130.142
G1 X167.471 Y130.142
G1 X167.541 Y130.212
G1 X169.11 Y131.781 E.01795
G1 X169.18 Y131.851
G1 X168.899 Y131.851
G1 X168.829 Y131.781
G1 X167.26 Y130.212 E.01795
G1 X167.19 Y130.142
G1 X166.909 Y130.142
G1 X166.979 Y130.212
G1 X167.748 Y130.981 E.0088
G1 X167.818 Y131.051
G1 X167.538 Y131.051
G1 X167.468 Y130.981
G1 X166.699 Y130.212 E.0088
G1 X166.629 Y130.142
G1 X166.348 Y130.142
G1 X166.418 Y130.212
G1 X167.187 Y130.981 E.0088
G1 X167.257 Y131.051
G1 X166.995 Y131.07
G1 X166.925 Y131
G1 X166.137 Y130.212 E.00902
G1 X166.067 Y130.142
G1 X165.787 Y130.142
G1 X165.857 Y130.212
G1 X166.794 Y131.149 E.01072
G1 X166.864 Y131.219
G1 X166.851 Y131.487
G1 X166.781 Y131.417
G1 X165.576 Y130.212 E.01378
G1 X165.506 Y130.142
G1 X165.225 Y130.142
G1 X165.295 Y130.212
G1 X166.781 Y131.698 E.017
G1 X166.851 Y131.768
G1 X166.653 Y131.851
G1 X166.583 Y131.781
G1 X166.008 Y131.206 E.00658
G1 X165.938 Y131.136
G1 X165.943 Y131.422
G1 X166.013 Y131.492
G1 X166.302 Y131.781 E.0033
M204 S10000
G1 X165.783 Y130.981 F60000
G1 F6044.128
M204 S2000
G1 X165.014 Y130.212 E.00879
G1 X164.944 Y130.142
G1 X164.664 Y130.142
G1 X164.734 Y130.212
G1 X165.503 Y130.982 E.0088
G1 X165.573 Y131.052
G1 X165.294 Y131.053
G1 X165.224 Y130.983
G1 X164.453 Y130.212 E.00882
G1 X164.383 Y130.142
G1 X164.102 Y130.142
G1 X164.172 Y130.212
G1 X164.947 Y130.987 E.00887
G1 X165.017 Y131.057
G1 X164.875 Y131.196
G1 X164.805 Y131.126
G1 X163.892 Y130.212 E.01045
G1 X163.822 Y130.142
G1 X163.541 Y130.142
G1 X163.611 Y130.212
G1 X164.783 Y131.385 E.01341
G1 X164.853 Y131.455
G1 X164.852 Y131.734
G1 X164.782 Y131.664
G1 X163.33 Y130.213 E.0166
G1 X163.26 Y130.143
G1 X162.979 Y130.143
G1 X163.049 Y130.213
G1 X164.618 Y131.781 E.01794
G1 X164.688 Y131.851
G1 X164.407 Y131.851
G1 X164.337 Y131.781
G1 X162.769 Y130.213 E.01794
G1 X162.699 Y130.143
G1 X162.418 Y130.143
G1 X162.488 Y130.213
G1 X164.056 Y131.781 E.01794
G1 X164.126 Y131.851
G1 X163.845 Y131.851
G1 X163.775 Y131.781
G1 X162.207 Y130.213 E.01794
; WIPE_START
M204 S8000
G1 X163.622 Y131.627 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X168.016 Y131.248 Z1.1 F60000
G1 Z.7
G1 E.4 F1800
G1 F6044.128
M204 S2000
G1 X168.548 Y131.781 E.00609
G1 X168.618 Y131.851
G1 X168.338 Y131.851
G1 X168.268 Y131.781
G1 X168.018 Y131.531 E.00286
; WIPE_START
M204 S8000
G1 X168.268 Y131.781 E-.08476
G1 X168.338 Y131.851 E-.02373
G1 X168.618 Y131.851 E-.06729
G1 X168.548 Y131.781 E-.02373
G1 X168.016 Y131.248 E-.18049
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X172.14 Y124.826 Z1.1 F60000
G1 X181.521 Y110.219 Z1.1
G1 Z.7
G1 E.4 F1800
G1 F6044.128
M204 S2000
G1 X191.576 Y120.275 E.11504
M204 S10000
M73 P94 R1
G1 X190.821 Y119.8 F60000
G1 F6044.128
M204 S2000
G1 X181.24 Y110.219 E.1096
G1 X181.17 Y110.149
G1 X180.889 Y110.149
G1 X180.959 Y110.219
G1 X190.065 Y119.325 E.10417
M204 S10000
G1 X189.309 Y118.849 F60000
G1 F6044.128
M204 S2000
G1 X180.678 Y110.219 E.09873
G1 X180.608 Y110.149
G1 X180.328 Y110.149
G1 X180.398 Y110.219
G1 X188.553 Y118.374 E.09329
M204 S10000
G1 X187.797 Y117.899 F60000
G1 F6044.128
M204 S2000
G1 X180.117 Y110.219 E.08786
G1 X180.047 Y110.149
G1 X179.766 Y110.149
G1 X179.836 Y110.219
G1 X187.041 Y117.424 E.08242
M204 S10000
G1 X186.285 Y116.949 F60000
G1 F6044.128
M204 S2000
G1 X179.555 Y110.219 E.07699
G1 X179.485 Y110.149
G1 X179.205 Y110.149
G1 X179.275 Y110.219
M73 P94 R0
G1 X185.529 Y116.474 E.07155
M204 S10000
G1 X184.773 Y115.999 F60000
G1 F6044.128
M204 S2000
G1 X178.994 Y110.219 E.06612
G1 X178.924 Y110.149
G1 X178.643 Y110.149
G1 X178.713 Y110.219
G1 X184.017 Y115.524 E.06068
M204 S10000
G1 X183.262 Y115.048 F60000
G1 F6044.128
M204 S2000
G1 X178.432 Y110.219 E.05525
G1 X178.362 Y110.149
G1 X178.082 Y110.149
G1 X178.152 Y110.219
G1 X182.506 Y114.573 E.04981
M204 S10000
G1 X181.75 Y114.098 F60000
G1 F6044.128
M204 S2000
G1 X177.871 Y110.219 E.04437
G1 X177.801 Y110.149
G1 X177.52 Y110.149
G1 X177.59 Y110.219
G1 X180.994 Y113.623 E.03894
M204 S10000
G1 X180.238 Y113.148 F60000
G1 F6044.128
M204 S2000
G1 X179.21 Y112.12 E.01176
G1 X178.877 Y111.787
G1 X177.309 Y110.219 E.01794
G1 X177.239 Y110.149
G1 X176.959 Y110.149
G1 X177.029 Y110.219
G1 X178.597 Y111.787 E.01794
G1 X178.667 Y111.857
G1 X178.386 Y111.857
G1 X178.316 Y111.787
G1 X176.748 Y110.219 E.01794
G1 X176.678 Y110.149
G1 X176.397 Y110.149
G1 X176.467 Y110.219
G1 X178.035 Y111.787 E.01794
G1 X178.105 Y111.857
G1 X177.824 Y111.857
G1 X177.754 Y111.787
G1 X176.186 Y110.219 E.01793
G1 X176.116 Y110.149
G1 X175.835 Y110.149
G1 X175.905 Y110.219
G1 X177.473 Y111.787 E.01793
G1 X177.543 Y111.857
G1 X177.262 Y111.857
G1 X177.192 Y111.787
G1 X175.625 Y110.219 E.01793
G1 X175.555 Y110.149
G1 X175.274 Y110.149
G1 X175.344 Y110.219
G1 X176.911 Y111.787 E.01793
G1 X176.981 Y111.857
G1 X176.7 Y111.856
G1 X176.63 Y111.786
G1 X175.063 Y110.219 E.01793
G1 X174.993 Y110.149
G1 X174.712 Y110.149
G1 X174.782 Y110.219
G1 X176.35 Y111.786 E.01793
G1 X176.42 Y111.856
G1 X176.139 Y111.856
G1 X176.069 Y111.786
G1 X174.502 Y110.219 E.01793
G1 X174.432 Y110.149
G1 X174.151 Y110.149
G1 X174.221 Y110.219
G1 X175.788 Y111.786 E.01793
G1 X175.858 Y111.856
G1 X175.577 Y111.856
G1 X175.507 Y111.786
G1 X173.94 Y110.219 E.01792
G1 X173.87 Y110.149
G1 X173.589 Y110.149
G1 X173.659 Y110.219
G1 X175.226 Y111.786 E.01792
G1 X175.296 Y111.856
G1 X175.015 Y111.856
G1 X174.945 Y111.786
G1 X173.379 Y110.219 E.01792
G1 X173.309 Y110.149
G1 X173.028 Y110.149
G1 X173.098 Y110.219
G1 X174.664 Y111.786 E.01792
G1 X174.734 Y111.856
G1 X174.453 Y111.856
G1 X174.383 Y111.786
G1 X172.817 Y110.219 E.01792
G1 X172.747 Y110.149
G1 X172.466 Y110.149
G1 X172.536 Y110.219
G1 X174.103 Y111.785 E.01792
G1 X174.173 Y111.855
G1 X173.892 Y111.855
G1 X173.822 Y111.785
G1 X172.256 Y110.219 E.01792
G1 X172.186 Y110.149
G1 X171.905 Y110.149
G1 X171.975 Y110.219
G1 X173.541 Y111.785 E.01792
G1 X173.611 Y111.855
G1 X173.33 Y111.855
G1 X173.26 Y111.785
G1 X171.694 Y110.219 E.01791
G1 X171.624 Y110.149
G1 X171.343 Y110.149
G1 X171.413 Y110.219
G1 X172.979 Y111.785 E.01791
G1 X173.049 Y111.855
G1 X172.768 Y111.855
G1 X172.698 Y111.785
G1 X171.132 Y110.219 E.01791
G1 X171.062 Y110.149
G1 X170.782 Y110.149
G1 X170.852 Y110.219
G1 X172.417 Y111.785 E.01791
G1 X172.487 Y111.855
G1 X172.206 Y111.855
G1 X172.136 Y111.785
G1 X170.571 Y110.219 E.01791
G1 X170.501 Y110.149
G1 X170.22 Y110.149
G1 X170.29 Y110.219
G1 X171.856 Y111.785 E.01791
G1 X171.926 Y111.855
G1 X171.645 Y111.854
G1 X171.575 Y111.784
G1 X170.009 Y110.219 E.01791
G1 X169.939 Y110.149
G1 X169.659 Y110.149
G1 X169.729 Y110.219
G1 X171.294 Y111.784 E.01791
G1 X171.364 Y111.854
G1 X171.083 Y111.854
G1 X171.013 Y111.784
G1 X169.448 Y110.219 E.0179
G1 X169.378 Y110.149
G1 X169.097 Y110.149
G1 X169.167 Y110.219
G1 X170.732 Y111.784 E.0179
G1 X170.802 Y111.854
G1 X170.521 Y111.854
G1 X170.451 Y111.784
G1 X168.886 Y110.219 E.0179
G1 X168.816 Y110.149
G1 X168.536 Y110.149
G1 X168.606 Y110.219
G1 X170.17 Y111.784 E.0179
G1 X170.24 Y111.854
G1 X169.959 Y111.854
G1 X169.889 Y111.784
G1 X168.325 Y110.219 E.0179
G1 X168.255 Y110.149
G1 X167.974 Y110.149
G1 X168.044 Y110.219
G1 X169.609 Y111.784 E.0179
G1 X169.679 Y111.854
G1 X169.398 Y111.854
G1 X169.328 Y111.784
G1 X167.763 Y110.219 E.0179
G1 X167.693 Y110.149
G1 X167.413 Y110.149
G1 X167.483 Y110.219
G1 X169.047 Y111.783 E.0179
G1 X169.117 Y111.853
G1 X168.836 Y111.853
G1 X168.766 Y111.783
G1 X167.202 Y110.219 E.01789
G1 X167.132 Y110.149
G1 X166.851 Y110.149
G1 X166.921 Y110.219
G1 X168.485 Y111.783 E.01789
G1 X168.555 Y111.853
G1 X168.274 Y111.853
G1 X168.204 Y111.783
G1 X166.64 Y110.219 E.01789
G1 X166.57 Y110.149
G1 X166.289 Y110.149
G1 X166.359 Y110.219
G1 X167.923 Y111.783 E.01789
G1 X167.993 Y111.853
G1 X167.713 Y111.853
G1 X167.643 Y111.783
G1 X166.079 Y110.219 E.01789
G1 X166.009 Y110.149
G1 X165.728 Y110.149
G1 X165.798 Y110.219
G1 X167.362 Y111.783 E.01789
G1 X167.432 Y111.853
G1 X167.151 Y111.853
G1 X167.081 Y111.783
G1 X165.517 Y110.219 E.01789
G1 X165.447 Y110.149
G1 X165.166 Y110.149
G1 X165.236 Y110.219
G1 X166.8 Y111.783 E.01789
G1 X166.87 Y111.853
G1 X166.589 Y111.852
G1 X166.519 Y111.782
G1 X164.956 Y110.219 E.01788
G1 X164.886 Y110.149
G1 X164.605 Y110.149
G1 X164.675 Y110.219
G1 X166.238 Y111.782 E.01788
G1 X166.308 Y111.852
G1 X166.027 Y111.852
G1 X165.957 Y111.782
G1 X164.394 Y110.219 E.01788
G1 X164.324 Y110.149
G1 X164.043 Y110.149
G1 X164.113 Y110.219
G1 X165.676 Y111.782 E.01788
G1 X165.746 Y111.852
G1 X165.466 Y111.852
G1 X165.396 Y111.782
G1 X163.833 Y110.219 E.01788
G1 X163.763 Y110.149
G1 X163.482 Y110.149
G1 X163.552 Y110.219
G1 X165.115 Y111.782 E.01788
G1 X165.185 Y111.852
G1 X164.904 Y111.852
G1 X164.834 Y111.782
G1 X163.271 Y110.219 E.01788
G1 X163.201 Y110.149
G1 X162.92 Y110.149
G1 X162.99 Y110.219
G1 X164.553 Y111.782 E.01788
G1 X164.623 Y111.852
G1 X164.342 Y111.852
G1 X164.272 Y111.782
G1 X162.71 Y110.219 E.01787
G1 X162.64 Y110.149
G1 X162.359 Y110.149
G1 X162.429 Y110.219
G1 X163.991 Y111.782 E.01787
G1 X164.061 Y111.852
G1 X163.78 Y111.851
G1 X163.71 Y111.781
G1 X162.148 Y110.219 E.01787
G1 X162.078 Y110.149
G1 X161.797 Y110.149
G1 X161.867 Y110.219
G1 X163.429 Y111.781 E.01787
G1 X163.499 Y111.851
G1 X163.219 Y111.851
G1 X163.149 Y111.781
G1 X161.587 Y110.219 E.01787
G1 X161.517 Y110.149
G1 X161.236 Y110.149
G1 X161.306 Y110.219
G1 X162.868 Y111.781 E.01787
G1 X162.938 Y111.851
G1 X162.657 Y111.851
G1 X162.587 Y111.781
G1 X161.025 Y110.219 E.01787
G1 X160.955 Y110.149
G1 X160.674 Y110.149
G1 X160.744 Y110.219
G1 X162.306 Y111.781 E.01787
G1 X162.376 Y111.851
G1 X162.125 Y111.881
G1 X162.055 Y111.811
G1 X160.463 Y110.219 E.01821
G1 X160.393 Y110.149
G1 X160.149 Y110.186
G1 X160.219 Y110.256
G1 X161.876 Y111.912 E.01895
G1 X161.946 Y111.982
G1 X161.859 Y112.176
G1 X161.789 Y112.106
G1 X160.219 Y110.536 E.01796
G1 X160.149 Y110.466
G1 X160.149 Y110.747
G1 X160.219 Y110.817
G1 X161.781 Y112.379 E.01787
G1 X161.851 Y112.449
G1 X161.851 Y112.73
G1 X161.781 Y112.66
G1 X160.219 Y111.098 E.01787
G1 X160.149 Y111.028
G1 X160.149 Y111.309
G1 X160.219 Y111.379
G1 X161.781 Y112.94 E.01787
G1 X161.851 Y113.01
G1 X161.851 Y113.291
G1 X161.781 Y113.221
G1 X160.219 Y111.659 E.01787
G1 X160.149 Y111.589
G1 X160.149 Y111.87
G1 X160.219 Y111.94
G1 X161.781 Y113.502 E.01787
G1 X161.851 Y113.572
G1 X161.851 Y113.853
G1 X161.781 Y113.783
G1 X160.219 Y112.221 E.01787
G1 X160.149 Y112.151
G1 X160.149 Y112.432
G1 X160.219 Y112.502
G1 X161.781 Y114.063 E.01787
G1 X161.851 Y114.133
G1 X161.851 Y114.414
G1 X161.781 Y114.344
G1 X160.219 Y112.783 E.01787
G1 X160.149 Y112.713
G1 X160.149 Y112.993
G1 X160.219 Y113.063
G1 X161.781 Y114.625 E.01787
G1 X161.851 Y114.695
G1 X161.851 Y114.976
G1 X161.781 Y114.906
G1 X160.219 Y113.344 E.01787
G1 X160.149 Y113.274
G1 X160.149 Y113.555
G1 X160.219 Y113.625
G1 X161.781 Y115.186 E.01787
G1 X161.851 Y115.256
G1 X161.851 Y115.537
G1 X161.781 Y115.467
G1 X160.219 Y113.906 E.01787
G1 X160.149 Y113.836
G1 X160.149 Y114.116
G1 X160.219 Y114.186
G1 X161.781 Y115.748 E.01787
G1 X161.851 Y115.818
G1 X161.851 Y116.099
G1 X161.781 Y116.029
G1 X160.219 Y114.467 E.01787
G1 X160.149 Y114.397
G1 X160.149 Y114.678
G1 X160.219 Y114.748
G1 X161.781 Y116.31 E.01787
G1 X161.851 Y116.38
G1 X161.851 Y116.66
G1 X161.781 Y116.59
G1 X160.219 Y115.029 E.01787
G1 X160.149 Y114.959
G1 X160.149 Y115.239
G1 X160.219 Y115.309
G1 X161.781 Y116.871 E.01787
G1 X161.851 Y116.941
G1 X161.851 Y117.222
G1 X161.781 Y117.152
G1 X160.219 Y115.59 E.01787
G1 X160.149 Y115.52
G1 X160.149 Y115.801
G1 X160.219 Y115.871
G1 X161.781 Y117.433 E.01787
G1 X161.851 Y117.503
G1 X161.851 Y117.783
G1 X161.781 Y117.713
G1 X160.219 Y116.152 E.01787
G1 X160.149 Y116.082
G1 X160.149 Y116.362
G1 X160.219 Y116.432
G1 X161.781 Y117.994 E.01787
G1 X161.851 Y118.064
G1 X161.851 Y118.345
G1 X161.781 Y118.275
G1 X160.219 Y116.713 E.01787
G1 X160.149 Y116.643
G1 X160.149 Y116.924
G1 X160.219 Y116.994
G1 X161.781 Y118.556 E.01787
G1 X161.851 Y118.626
G1 X161.851 Y118.906
G1 X161.781 Y118.836
G1 X160.219 Y117.275 E.01787
G1 X160.149 Y117.205
G1 X160.149 Y117.485
G1 X160.219 Y117.555
G1 X161.781 Y119.117 E.01787
G1 X161.851 Y119.187
G1 X161.851 Y119.468
G1 X161.781 Y119.398
G1 X160.219 Y117.836 E.01787
G1 X160.149 Y117.766
G1 X160.149 Y118.047
G1 X160.219 Y118.117
G1 X161.781 Y119.679 E.01787
G1 X161.851 Y119.749
G1 X161.851 Y120.029
G1 X161.781 Y119.959
G1 X160.219 Y118.398 E.01787
G1 X160.149 Y118.328
G1 X160.149 Y118.609
G1 X160.219 Y118.679
G1 X161.781 Y120.24 E.01787
G1 X161.851 Y120.31
G1 X161.851 Y120.591
G1 X161.781 Y120.521
G1 X160.219 Y118.959 E.01787
G1 X160.149 Y118.889
G1 X160.149 Y119.17
G1 X160.219 Y119.24
G1 X161.781 Y120.802 E.01787
G1 X161.851 Y120.872
G1 X161.851 Y121.153
G1 X161.781 Y121.083
G1 X160.219 Y119.521 E.01787
G1 X160.149 Y119.451
G1 X160.149 Y119.732
G1 X160.219 Y119.802
G1 X161.781 Y121.363 E.01787
G1 X161.851 Y121.433
G1 X161.851 Y121.714
G1 X161.781 Y121.644
G1 X160.219 Y120.082 E.01787
G1 X160.149 Y120.012
G1 X160.149 Y120.293
G1 X160.219 Y120.363
G1 X161.781 Y121.925 E.01787
G1 X161.851 Y121.995
G1 X161.851 Y122.276
G1 X161.781 Y122.206
G1 X160.219 Y120.644 E.01787
G1 X160.149 Y120.574
G1 X160.149 Y120.855
G1 X160.219 Y120.925
G1 X161.781 Y122.486 E.01787
G1 X161.851 Y122.556
G1 X161.851 Y122.837
G1 X161.781 Y122.767
G1 X160.219 Y121.205 E.01787
G1 X160.149 Y121.135
G1 X160.149 Y121.416
G1 X160.219 Y121.486
G1 X161.781 Y123.048 E.01787
G1 X161.851 Y123.118
G1 X161.851 Y123.399
G1 X161.781 Y123.329
G1 X160.219 Y121.767 E.01787
G1 X160.149 Y121.697
G1 X160.149 Y121.978
G1 X160.219 Y122.048
G1 X161.781 Y123.609 E.01787
G1 X161.851 Y123.679
G1 X161.851 Y123.96
G1 X161.781 Y123.89
G1 X160.219 Y122.328 E.01787
G1 X160.149 Y122.258
G1 X160.149 Y122.539
G1 X160.219 Y122.609
G1 X161.781 Y124.171 E.01787
G1 X161.851 Y124.241
G1 X161.851 Y124.522
G1 X161.781 Y124.452
G1 X160.219 Y122.89 E.01787
G1 X160.149 Y122.82
G1 X160.149 Y123.101
G1 X160.219 Y123.171
G1 X161.781 Y124.732 E.01787
G1 X161.851 Y124.802
G1 X161.851 Y125.083
G1 X161.781 Y125.013
G1 X160.219 Y123.452 E.01787
G1 X160.149 Y123.382
G1 X160.149 Y123.662
G1 X160.219 Y123.732
G1 X161.781 Y125.294 E.01787
G1 X161.851 Y125.364
G1 X161.851 Y125.645
G1 X161.781 Y125.575
G1 X160.219 Y124.013 E.01787
G1 X160.149 Y123.943
G1 X160.149 Y124.224
G1 X160.219 Y124.294
G1 X161.781 Y125.855 E.01787
G1 X161.851 Y125.925
G1 X161.851 Y126.206
G1 X161.781 Y126.136
G1 X160.219 Y124.575 E.01787
G1 X160.149 Y124.505
G1 X160.149 Y124.785
G1 X160.219 Y124.855
G1 X161.781 Y126.417 E.01787
G1 X161.851 Y126.487
G1 X161.851 Y126.768
G1 X161.781 Y126.698
G1 X160.219 Y125.136 E.01787
G1 X160.149 Y125.066
G1 X160.149 Y125.347
G1 X160.219 Y125.417
G1 X161.781 Y126.979 E.01787
G1 X161.851 Y127.049
G1 X161.851 Y127.329
G1 X161.781 Y127.259
G1 X160.219 Y125.698 E.01787
G1 X160.149 Y125.628
G1 X160.149 Y125.908
G1 X160.219 Y125.978
G1 X161.781 Y127.54 E.01787
G1 X161.851 Y127.61
G1 X161.851 Y127.891
G1 X161.781 Y127.821
G1 X160.219 Y126.259 E.01787
G1 X160.149 Y126.189
G1 X160.149 Y126.47
G1 X160.219 Y126.54
G1 X161.781 Y128.102 E.01787
G1 X161.851 Y128.172
G1 X161.851 Y128.452
G1 X161.781 Y128.382
G1 X160.219 Y126.821 E.01787
G1 X160.149 Y126.751
G1 X160.149 Y127.031
G1 X160.219 Y127.101
G1 X161.781 Y128.663 E.01787
G1 X161.851 Y128.733
G1 X161.851 Y129.014
G1 X161.781 Y128.944
G1 X160.219 Y127.382 E.01787
G1 X160.149 Y127.312
G1 X160.149 Y127.593
G1 X160.219 Y127.663
G1 X161.781 Y129.225 E.01787
G1 X161.851 Y129.295
G1 X161.851 Y129.575
G1 X161.781 Y129.505
G1 X160.219 Y127.944 E.01787
G1 X160.149 Y127.874
G1 X160.149 Y128.155
G1 X160.219 Y128.225
G1 X161.781 Y129.786 E.01787
; WIPE_START
M204 S8000
G1 X160.367 Y128.372 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
M73 P95 R0
G1 X160.219 Y128.505 Z1.1 F60000
G1 Z.7
G1 E.4 F1800
G1 F6044.128
M204 S2000
G1 X163.495 Y131.781 E.03747
G1 X163.565 Y131.851
G1 X163.284 Y131.851
G1 X163.214 Y131.781
G1 X160.219 Y128.786 E.03426
G1 X160.149 Y128.716
G1 X160.149 Y128.997
G1 X160.219 Y129.067
G1 X162.933 Y131.781 E.03105
G1 X163.003 Y131.851
G1 X162.722 Y131.851
G1 X162.652 Y131.781
G1 X160.219 Y129.348 E.02784
G1 X160.149 Y129.278
G1 X160.149 Y129.558
G1 X160.219 Y129.628
G1 X162.372 Y131.781 E.02462
; WIPE_START
M204 S8000
G1 X160.957 Y130.367 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X161.803 Y129.941 Z1.1 F60000
G1 Z.7
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.0863843
G1 F3000
M204 S8000
G1 X161.758 Y129.856 E.00025
G1 X161.786 Y129.781 E.00021
M204 S10000
G1 X162.167 Y130.254 F60000
; LINE_WIDTH: 0.0556802
G1 F3000
M204 S8000
G1 X162.069 Y130.202 E.00015
; WIPE_START
G1 X162.167 Y130.254 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X162.164 Y131.791 Z1.1 F60000
G1 Z.7
G1 E.4 F1800
; LINE_WIDTH: 0.13063
G1 F3000
M204 S8000
G1 X160.209 Y129.836 E.0123
; WIPE_START
G1 X161.623 Y131.25 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X168.063 Y131.202 Z1.1 F60000
G1 Z.7
G1 E.4 F1800
; LINE_WIDTH: 0.0632995
G1 F3000
M204 S8000
G1 X167.925 Y131.053 E.00035
; WIPE_START
G1 X168.063 Y131.202 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X175.632 Y130.222 Z1.1 F60000
G1 X183.072 Y129.259 Z1.1
G1 Z.7
G1 E.4 F1800
; LINE_WIDTH: 0.0805705
G1 F3000
M204 S8000
G1 X182.971 Y129.177 E.00031
; WIPE_START
G1 X183.072 Y129.259 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X188.489 Y123.882 Z1.1 F60000
G1 X191.912 Y120.485 Z1.1
G1 Z.7
G1 E.4 F1800
; LINE_WIDTH: 0.0635916
G1 F3000
M204 S8000
G1 X191.76 Y120.364 E.00033
; LINE_WIDTH: 0.1002
G1 X191.608 Y120.243 E.00062
M204 S10000
G1 X191.156 Y120.01 F60000
; LINE_WIDTH: 0.0635875
G1 F3000
M204 S8000
G1 X191.004 Y119.889 E.00033
; LINE_WIDTH: 0.100189
G1 X190.853 Y119.768 E.00062
M204 S10000
G1 X190.4 Y119.535 F60000
; LINE_WIDTH: 0.0635838
G1 F3000
M204 S8000
G1 X190.248 Y119.414 E.00033
; LINE_WIDTH: 0.100197
G1 X190.097 Y119.293 E.00062
M204 S10000
G1 X189.644 Y119.059 F60000
; LINE_WIDTH: 0.0635916
G1 F3000
M204 S8000
G1 X189.492 Y118.938 E.00033
; LINE_WIDTH: 0.1002
G1 X189.341 Y118.818 E.00062
M204 S10000
G1 X188.888 Y118.584 F60000
; LINE_WIDTH: 0.0635838
G1 F3000
M204 S8000
G1 X188.736 Y118.463 E.00033
; LINE_WIDTH: 0.100197
G1 X188.585 Y118.342 E.00062
M204 S10000
G1 X188.132 Y118.109 F60000
; LINE_WIDTH: 0.0635838
G1 F3000
M204 S8000
G1 X187.981 Y117.988 E.00033
; LINE_WIDTH: 0.100197
G1 X187.829 Y117.867 E.00062
M204 S10000
G1 X187.376 Y117.634 F60000
; LINE_WIDTH: 0.0635881
G1 F3000
M204 S8000
G1 X187.225 Y117.513 E.00033
; LINE_WIDTH: 0.10019
G1 X187.073 Y117.392 E.00062
M204 S10000
G1 X186.62 Y117.159 F60000
; LINE_WIDTH: 0.0635838
G1 F3000
M204 S8000
G1 X186.469 Y117.038 E.00033
; LINE_WIDTH: 0.100197
G1 X186.317 Y116.917 E.00062
M204 S10000
G1 X185.864 Y116.684 F60000
; LINE_WIDTH: 0.0635916
G1 F3000
M204 S8000
G1 X185.713 Y116.563 E.00033
; LINE_WIDTH: 0.1002
G1 X185.561 Y116.442 E.00062
M204 S10000
G1 X185.109 Y116.209 F60000
; LINE_WIDTH: 0.0635881
G1 F3000
M204 S8000
G1 X184.957 Y116.088 E.00033
; LINE_WIDTH: 0.10019
G1 X184.805 Y115.967 E.00062
M204 S10000
G1 X184.353 Y115.733 F60000
; LINE_WIDTH: 0.0635838
G1 F3000
M204 S8000
G1 X184.201 Y115.613 E.00033
; LINE_WIDTH: 0.100197
G1 X184.049 Y115.492 E.00062
M204 S10000
G1 X183.597 Y115.258 F60000
; LINE_WIDTH: 0.0635875
G1 F3000
M204 S8000
G1 X183.445 Y115.137 E.00033
; LINE_WIDTH: 0.100189
G1 X183.293 Y115.016 E.00062
M204 S10000
G1 X182.841 Y114.783 F60000
; LINE_WIDTH: 0.0635874
G1 F3000
M204 S8000
G1 X182.689 Y114.662 E.00033
; LINE_WIDTH: 0.100189
G1 X182.538 Y114.541 E.00062
M204 S10000
G1 X182.085 Y114.308 F60000
; LINE_WIDTH: 0.0635838
G1 F3000
M204 S8000
G1 X181.933 Y114.187 E.00033
; LINE_WIDTH: 0.100197
G1 X181.782 Y114.066 E.00062
M204 S10000
G1 X181.329 Y113.833 F60000
; LINE_WIDTH: 0.0635881
G1 F3000
M204 S8000
G1 X181.177 Y113.712 E.00033
; LINE_WIDTH: 0.10019
G1 X181.026 Y113.591 E.00062
M204 S10000
G1 X180.573 Y113.358 F60000
; LINE_WIDTH: 0.0635874
G1 F3000
M204 S8000
G1 X180.422 Y113.237 E.00033
; LINE_WIDTH: 0.100189
G1 X180.27 Y113.116 E.00062
M204 S10000
G1 X179.817 Y112.883 F60000
; LINE_WIDTH: 0.0697523
G1 F3000
M204 S8000
G1 X179.614 Y112.721 E.00051
; LINE_WIDTH: 0.118682
G1 X179.411 Y112.559 E.00103
; LINE_WIDTH: 0.167613
G1 X179.208 Y112.397 E.00155
; OBJECT_ID: 5887
; COOLING_NODE: 0
; WIPE_START
G1 X179.411 Y112.559 E-.38
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 5909
M625
; start printing object, unique label id: 5887
M624 AQAAAAAAAAA=
M204 S10000
G1 X172.203 Y115.069 Z1.1 F60000
G1 X125.91 Y131.189 Z1.1
G1 Z.7
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.21999
G1 F6044.427
M204 S5000
G1 X125.811 Y131.09 E.00114
G1 X124.989 Y131.09 E.00664
G1 X124.89 Y131.189 E.00114
G1 X124.89 Y131.89 E.00567
G1 X122.046 Y131.89 E.02301
G1 X120.11 Y129.954 E.02214
G1 X120.11 Y110.11 E.16052
G1 X153.89 Y110.11 E.27324
G1 X153.89 Y114.291 E.03382
G1 X153.89 Y131.89 E.14235
G1 X125.91 Y131.89 E.22633
G1 X125.91 Y131.189 E.00567
; COOLING_NODE: 1
; WIPE_START
M204 S8000
G1 X125.811 Y131.09 E-.02667
G1 X124.989 Y131.09 E-.15608
G1 X124.89 Y131.189 E-.02667
G1 X124.89 Y131.89 E-.13314
G1 X124.693 Y131.89 E-.03744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X132.235 Y130.717 Z1.1 F60000
G1 X143.022 Y129.039 Z1.1
G1 Z.7
G1 E.4 F1800
G1 F6044.427
M204 S5000
G1 X142.996 Y128.9 E.00115
G1 X143.025 Y128.852 E.00045
G1 X151.958 Y122.896 E.08684
G1 X152.076 Y122.905 E.00096
G1 X152.11 Y122.98 E.00066
G1 X152.11 Y129.011 E.04878
G1 X152.04 Y129.105 E.00095
G1 X143.118 Y129.11 E.07218
G1 X143.022 Y129.039 E.00096
; COOLING_NODE: 2
; WIPE_START
M204 S8000
G1 X142.996 Y128.9 E-.02707
G1 X143.025 Y128.852 E-.01055
G1 X144.525 Y127.853 E-.34238
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X141.977 Y120.658 Z1.1 F60000
G1 X139.112 Y112.569 Z1.1
G1 Z.7
G1 E.4 F1800
G1 F6044.427
M204 S5000
G1 X151.989 Y120.663 E.12303
G1 X152.081 Y120.786 E.00124
G1 X152.082 Y121.226 E.00356
G1 X151.99 Y121.336 E.00116
G1 X139.112 Y129.431 E.12303
G1 X139.081 Y129.948 E.0042
G1 X138.897 Y130.104 E.00195
G1 X122.103 Y130.104 E.13584
G1 X121.955 Y130.022 E.00137
G1 X121.89 Y129.852 E.00148
G1 X121.89 Y112.148 E.14321
G1 X121.966 Y111.965 E.0016
G1 X122.148 Y111.89 E.0016
G1 X138.896 Y111.896 E.13548
G1 X139.081 Y112.051 E.00195
G1 X139.112 Y112.569 E.0042
; WIPE_START
M204 S8000
G1 X140.806 Y113.634 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X148.18 Y111.665 Z1.1 F60000
G1 X153.594 Y110.219 Z1.1
G1 Z.7
G1 E.4 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.22
G1 F6044.128
M204 S2000
G1 X153.781 Y110.406 E.00214
G1 X153.851 Y110.476
G1 X153.851 Y110.757
G1 X153.781 Y110.687
G1 X153.313 Y110.219 E.00535
G1 X153.243 Y110.149
G1 X152.962 Y110.149
G1 X153.032 Y110.219
G1 X153.781 Y110.968 E.00857
G1 X153.851 Y111.038
G1 X153.851 Y111.319
G1 X153.781 Y111.249
G1 X152.751 Y110.219 E.01178
G1 X152.681 Y110.149
G1 X152.401 Y110.149
G1 X152.471 Y110.219
G1 X153.781 Y111.529 E.01499
G1 X153.851 Y111.599
G1 X153.851 Y111.88
G1 X153.781 Y111.81
G1 X152.19 Y110.219 E.0182
G1 X152.12 Y110.149
G1 X151.839 Y110.149
G1 X151.909 Y110.219
G1 X153.781 Y112.091 E.02141
G1 X153.851 Y112.161
G1 X153.851 Y112.442
G1 X153.781 Y112.372
G1 X151.628 Y110.219 E.02463
G1 X151.558 Y110.149
G1 X151.277 Y110.149
G1 X151.347 Y110.219
G1 X153.781 Y112.653 E.02784
G1 X153.851 Y112.723
G1 X153.851 Y113.003
G1 X153.781 Y112.933
G1 X151.067 Y110.219 E.03105
G1 X150.997 Y110.149
G1 X150.716 Y110.149
G1 X150.786 Y110.219
G1 X153.781 Y113.214 E.03426
G1 X153.851 Y113.284
G1 X153.851 Y113.565
G1 X153.781 Y113.495
G1 X150.505 Y110.219 E.03747
G1 X150.435 Y110.149
G1 X150.154 Y110.149
G1 X150.224 Y110.219
G1 X153.781 Y113.776 E.04069
G1 X153.851 Y113.846
G1 X153.851 Y114.126
G1 X153.781 Y114.056
G1 X149.944 Y110.219 E.0439
G1 X149.874 Y110.149
G1 X149.593 Y110.149
G1 X149.663 Y110.219
G1 X153.781 Y114.337 E.04711
G1 X153.851 Y114.407
G1 X153.851 Y114.688
G1 X153.781 Y114.618
G1 X149.382 Y110.219 E.05032
G1 X149.312 Y110.149
G1 X149.031 Y110.149
G1 X149.101 Y110.219
G1 X153.781 Y114.899 E.05353
G1 X153.851 Y114.969
G1 X153.851 Y115.249
G1 X153.781 Y115.179
G1 X148.821 Y110.219 E.05674
G1 X148.751 Y110.149
G1 X148.47 Y110.149
G1 X148.54 Y110.219
G1 X153.781 Y115.46 E.05996
G1 X153.851 Y115.53
G1 X153.851 Y115.811
G1 X153.781 Y115.741
G1 X148.259 Y110.219 E.06317
G1 X148.189 Y110.149
G1 X147.908 Y110.149
G1 X147.978 Y110.219
G1 X153.781 Y116.022 E.06638
G1 X153.851 Y116.092
G1 X153.851 Y116.372
G1 X153.781 Y116.302
G1 X147.698 Y110.219 E.06959
G1 X147.628 Y110.149
G1 X147.347 Y110.149
G1 X147.417 Y110.219
G1 X153.781 Y116.583 E.0728
G1 X153.851 Y116.653
G1 X153.851 Y116.934
G1 X153.781 Y116.864
G1 X147.136 Y110.219 E.07602
G1 X147.066 Y110.149
G1 X146.785 Y110.149
G1 X146.855 Y110.219
G1 X153.781 Y117.145 E.07923
G1 X153.851 Y117.215
G1 X153.851 Y117.496
G1 X153.781 Y117.426
G1 X146.574 Y110.219 E.08244
G1 X146.504 Y110.149
G1 X146.224 Y110.149
G1 X146.294 Y110.219
G1 X153.781 Y117.706 E.08565
G1 X153.851 Y117.776
G1 X153.851 Y118.057
G1 X153.781 Y117.987
G1 X146.013 Y110.219 E.08886
G1 X145.943 Y110.149
G1 X145.662 Y110.149
G1 X145.732 Y110.219
G1 X153.781 Y118.268 E.09208
G1 X153.851 Y118.338
G1 X153.851 Y118.619
G1 X153.781 Y118.549
G1 X145.451 Y110.219 E.09529
G1 X145.381 Y110.149
G1 X145.101 Y110.149
G1 X145.171 Y110.219
G1 X153.781 Y118.829 E.0985
G1 X153.851 Y118.899
G1 X153.851 Y119.18
G1 X153.781 Y119.11
G1 X144.89 Y110.219 E.10171
G1 X144.82 Y110.149
G1 X144.539 Y110.149
G1 X144.609 Y110.219
G1 X153.781 Y119.391 E.10492
G1 X153.851 Y119.461
G1 X153.851 Y119.742
G1 X153.781 Y119.672
G1 X144.328 Y110.219 E.10814
G1 X144.258 Y110.149
G1 X143.978 Y110.149
G1 X144.048 Y110.219
G1 X153.781 Y119.952 E.11135
G1 X153.851 Y120.022
G1 X153.851 Y120.303
G1 X153.781 Y120.233
G1 X143.767 Y110.219 E.11456
G1 X143.697 Y110.149
G1 X143.416 Y110.149
G1 X143.486 Y110.219
G1 X153.781 Y120.514 E.11777
G1 X153.851 Y120.584
G1 X153.851 Y120.865
G1 X153.781 Y120.795
G1 X143.205 Y110.219 E.12098
G1 X143.135 Y110.149
G1 X142.855 Y110.149
G1 X142.925 Y110.219
G1 X153.781 Y121.075 E.1242
G1 X153.851 Y121.145
G1 X153.851 Y121.426
G1 X153.781 Y121.356
G1 X142.644 Y110.219 E.12741
G1 X142.574 Y110.149
G1 X142.293 Y110.149
G1 X142.363 Y110.219
G1 X153.781 Y121.637 E.13062
G1 X153.851 Y121.707
G1 X153.851 Y121.988
G1 X153.781 Y121.918
M73 P96 R0
G1 X142.082 Y110.219 E.13383
G1 X142.012 Y110.149
G1 X141.731 Y110.149
G1 X141.801 Y110.219
G1 X153.781 Y122.199 E.13704
G1 X153.851 Y122.269
G1 X153.851 Y122.549
G1 X153.781 Y122.479
G1 X152.196 Y120.894 E.01814
G1 X152.126 Y120.824
G1 X152.139 Y121.118
G1 X152.209 Y121.188
G1 X153.781 Y122.76 E.01798
G1 X153.851 Y122.83
G1 X153.851 Y123.111
G1 X153.781 Y123.041
G1 X152.105 Y121.365 E.01917
G1 X152.035 Y121.295
G1 X151.88 Y121.42
G1 X151.95 Y121.49
G1 X153.781 Y123.322 E.02095
G1 X153.851 Y123.392
G1 X153.851 Y123.672
G1 X153.781 Y123.602
G1 X151.777 Y121.599 E.02292
G1 X151.707 Y121.529
G1 X151.535 Y121.637
G1 X151.605 Y121.707
G1 X153.781 Y123.883 E.02489
G1 X153.851 Y123.953
G1 X153.851 Y124.234
G1 X153.781 Y124.164
G1 X151.433 Y121.816 E.02686
G1 X151.363 Y121.746
G1 X151.19 Y121.854
G1 X151.26 Y121.924
G1 X153.781 Y124.445 E.02884
G1 X153.851 Y124.515
G1 X153.851 Y124.795
G1 X153.781 Y124.725
G1 X152.219 Y123.164 E.01787
G1 X152.149 Y123.094
G1 X152.149 Y123.374
G1 X152.219 Y123.444
G1 X153.781 Y125.006 E.01787
G1 X153.851 Y125.076
G1 X153.851 Y125.357
G1 X153.781 Y125.287
G1 X152.219 Y123.725 E.01787
G1 X152.149 Y123.655
G1 X152.149 Y123.936
G1 X152.219 Y124.006
G1 X153.781 Y125.568 E.01787
G1 X153.851 Y125.638
G1 X153.851 Y125.918
G1 X153.781 Y125.848
G1 X152.219 Y124.287 E.01787
G1 X152.149 Y124.217
G1 X152.149 Y124.498
G1 X152.219 Y124.568
G1 X153.781 Y126.129 E.01787
G1 X153.851 Y126.199
G1 X153.851 Y126.48
G1 X153.781 Y126.41
G1 X152.219 Y124.848 E.01787
G1 X152.149 Y124.778
G1 X152.149 Y125.059
G1 X152.219 Y125.129
G1 X153.781 Y126.691 E.01787
G1 X153.851 Y126.761
G1 X153.851 Y127.041
G1 X153.781 Y126.971
G1 X152.219 Y125.41 E.01787
G1 X152.149 Y125.34
G1 X152.149 Y125.621
G1 X152.219 Y125.691
G1 X153.781 Y127.252 E.01787
G1 X153.851 Y127.322
G1 X153.851 Y127.603
G1 X153.781 Y127.533
G1 X152.219 Y125.971 E.01787
G1 X152.149 Y125.901
G1 X152.149 Y126.182
G1 X152.219 Y126.252
G1 X153.781 Y127.814 E.01787
G1 X153.851 Y127.884
G1 X153.851 Y128.165
G1 X153.781 Y128.095
G1 X152.219 Y126.533 E.01787
G1 X152.149 Y126.463
G1 X152.149 Y126.744
G1 X152.219 Y126.814
G1 X153.781 Y128.375 E.01787
G1 X153.851 Y128.445
G1 X153.851 Y128.726
G1 X153.781 Y128.656
G1 X152.219 Y127.094 E.01787
G1 X152.149 Y127.024
G1 X152.149 Y127.305
G1 X152.219 Y127.375
G1 X153.781 Y128.937 E.01787
G1 X153.851 Y129.007
G1 X153.851 Y129.288
G1 X153.781 Y129.218
G1 X152.219 Y127.656 E.01787
G1 X152.149 Y127.586
G1 X152.149 Y127.867
G1 X152.219 Y127.937
G1 X153.781 Y129.498 E.01787
G1 X153.851 Y129.568
G1 X153.851 Y129.849
G1 X153.781 Y129.779
G1 X152.219 Y128.217 E.01787
G1 X152.149 Y128.147
G1 X152.149 Y128.428
G1 X152.219 Y128.498
G1 X153.781 Y130.06 E.01787
G1 X153.851 Y130.13
G1 X153.851 Y130.411
G1 X153.781 Y130.341
G1 X152.219 Y128.779 E.01787
G1 X152.149 Y128.709
G1 X152.136 Y128.977
G1 X152.206 Y129.047
G1 X153.781 Y130.621 E.01801
G1 X153.851 Y130.691
G1 X153.851 Y130.972
G1 X153.781 Y130.902
G1 X152.082 Y129.204 E.01943
G1 X152.012 Y129.134
G1 X151.747 Y129.149
G1 X151.817 Y129.219
G1 X153.781 Y131.183 E.02247
G1 X153.851 Y131.253
G1 X153.851 Y131.534
G1 X153.781 Y131.464
G1 X151.536 Y129.219 E.02568
G1 X151.466 Y129.149
G1 X151.186 Y129.149
G1 X151.256 Y129.219
G1 X153.781 Y131.744 E.02889
G1 X153.851 Y131.814
G1 X153.606 Y131.851
G1 X153.536 Y131.781
G1 X150.975 Y129.219 E.02931
G1 X150.905 Y129.149
G1 X150.624 Y129.149
G1 X150.694 Y129.219
G1 X153.256 Y131.781 E.02931
G1 X153.326 Y131.851
G1 X153.045 Y131.851
G1 X152.975 Y131.781
G1 X150.413 Y129.219 E.02931
G1 X150.343 Y129.149
G1 X150.062 Y129.149
G1 X150.132 Y129.219
G1 X152.694 Y131.781 E.02931
G1 X152.764 Y131.851
G1 X152.483 Y131.851
G1 X152.413 Y131.781
G1 X149.852 Y129.219 E.02931
G1 X149.782 Y129.149
G1 X149.501 Y129.149
G1 X149.571 Y129.219
G1 X152.133 Y131.781 E.02931
G1 X152.203 Y131.851
G1 X151.922 Y131.851
G1 X151.852 Y131.781
G1 X149.29 Y129.219 E.02931
G1 X149.22 Y129.149
G1 X148.939 Y129.149
G1 X149.009 Y129.219
G1 X151.571 Y131.781 E.02931
G1 X151.641 Y131.851
G1 X151.36 Y131.851
G1 X151.29 Y131.781
G1 X148.729 Y129.219 E.02931
G1 X148.659 Y129.149
G1 X148.378 Y129.149
G1 X148.448 Y129.219
G1 X151.01 Y131.781 E.02931
G1 X151.08 Y131.851
G1 X150.799 Y131.851
G1 X150.729 Y131.781
G1 X148.167 Y129.219 E.02931
G1 X148.097 Y129.149
G1 X147.816 Y129.149
G1 X147.886 Y129.219
G1 X150.448 Y131.781 E.02931
G1 X150.518 Y131.851
G1 X150.237 Y131.851
G1 X150.167 Y131.781
G1 X147.606 Y129.219 E.02931
G1 X147.536 Y129.149
G1 X147.255 Y129.149
G1 X147.325 Y129.219
G1 X149.887 Y131.781 E.02931
G1 X149.957 Y131.851
G1 X149.676 Y131.851
G1 X149.606 Y131.781
G1 X147.044 Y129.219 E.02931
G1 X146.974 Y129.149
G1 X146.693 Y129.149
G1 X146.763 Y129.219
G1 X149.325 Y131.781 E.02931
G1 X149.395 Y131.851
G1 X149.114 Y131.851
G1 X149.044 Y131.781
G1 X146.483 Y129.219 E.02931
G1 X146.413 Y129.149
G1 X146.132 Y129.149
G1 X146.202 Y129.219
G1 X148.763 Y131.781 E.02931
G1 X148.833 Y131.851
G1 X148.553 Y131.851
G1 X148.483 Y131.781
G1 X145.921 Y129.219 E.02931
G1 X145.851 Y129.149
G1 X145.57 Y129.149
G1 X145.64 Y129.219
G1 X148.202 Y131.781 E.02931
G1 X148.272 Y131.851
G1 X147.991 Y131.851
G1 X147.921 Y131.781
G1 X145.359 Y129.219 E.02931
G1 X145.289 Y129.149
G1 X145.009 Y129.149
G1 X145.079 Y129.219
G1 X147.64 Y131.781 E.02931
G1 X147.71 Y131.851
G1 X147.43 Y131.851
G1 X147.36 Y131.781
G1 X144.798 Y129.219 E.02931
G1 X144.728 Y129.149
G1 X144.447 Y129.149
G1 X144.517 Y129.219
G1 X147.079 Y131.781 E.02931
G1 X147.149 Y131.851
G1 X146.868 Y131.851
G1 X146.798 Y131.781
G1 X144.236 Y129.219 E.02931
G1 X144.166 Y129.149
G1 X143.886 Y129.149
G1 X143.956 Y129.219
G1 X146.517 Y131.781 E.02931
G1 X146.587 Y131.851
G1 X146.307 Y131.851
G1 X146.237 Y131.781
G1 X143.675 Y129.219 E.02931
G1 X143.605 Y129.149
G1 X143.324 Y129.149
G1 X143.394 Y129.219
G1 X145.956 Y131.781 E.02931
G1 X146.026 Y131.851
G1 X145.745 Y131.851
G1 X145.675 Y131.781
G1 X143.112 Y129.218 E.02932
; WIPE_START
M204 S8000
G1 X144.527 Y130.632 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X149.156 Y124.564 Z1.1 F60000
G1 X151.088 Y122.032 Z1.1
G1 Z.7
G1 E.4 F1800
G1 F6044.128
M204 S2000
G1 X151.875 Y122.82 E.00901
G1 X151.945 Y122.89
G1 X151.777 Y123.002
G1 X151.707 Y122.932
G1 X150.915 Y122.141 E.00905
G1 X150.845 Y122.071
G1 X150.673 Y122.179
G1 X150.743 Y122.249
G1 X151.538 Y123.044 E.0091
G1 X151.608 Y123.114
G1 X151.44 Y123.227
G1 X151.37 Y123.157
G1 X150.571 Y122.357 E.00914
G1 X150.501 Y122.287
G1 X150.328 Y122.396
G1 X150.398 Y122.466
G1 X151.201 Y123.269 E.00919
G1 X151.271 Y123.339
G1 X151.103 Y123.451
G1 X151.033 Y123.381
G1 X150.226 Y122.574 E.00923
G1 X150.156 Y122.504
G1 X149.983 Y122.612
G1 X150.053 Y122.682
G1 X150.864 Y123.494 E.00928
G1 X150.934 Y123.564
G1 X150.766 Y123.676
G1 X150.696 Y123.606
G1 X149.881 Y122.791 E.00932
G1 X149.811 Y122.721
G1 X149.639 Y122.829
G1 X149.709 Y122.899
G1 X150.528 Y123.718 E.00937
G1 X150.598 Y123.788
G1 X150.429 Y123.901
G1 X150.359 Y123.831
G1 X149.536 Y123.008 E.00941
G1 X149.466 Y122.938
G1 X149.294 Y123.046
G1 X149.364 Y123.116
G1 X150.191 Y123.943 E.00946
G1 X150.261 Y124.013
G1 X150.092 Y124.125
G1 X150.022 Y124.055
G1 X149.191 Y123.224 E.0095
G1 X149.121 Y123.154
G1 X148.949 Y123.263
G1 X149.019 Y123.333
G1 X149.854 Y124.167 E.00955
G1 X149.924 Y124.237
G1 X149.755 Y124.35
G1 X149.685 Y124.28
G1 X148.847 Y123.441 E.0096
G1 X148.777 Y123.371
G1 X148.604 Y123.479
G1 X148.674 Y123.549
G1 X149.517 Y124.392 E.00964
G1 X149.587 Y124.462
G1 X149.418 Y124.574
G1 X149.348 Y124.504
G1 X148.502 Y123.658 E.00969
G1 X148.432 Y123.588
G1 X148.259 Y123.696
G1 X148.329 Y123.766
G1 X149.18 Y124.617 E.00973
G1 X149.25 Y124.687
G1 X149.081 Y124.799
G1 X149.011 Y124.729
G1 X148.157 Y123.874 E.00978
G1 X148.087 Y123.804
G1 X147.915 Y123.913
G1 X147.985 Y123.983
G1 X148.843 Y124.841 E.00982
G1 X148.913 Y124.911
G1 X148.745 Y125.024
G1 X148.675 Y124.954
G1 X147.812 Y124.091 E.00987
G1 X147.742 Y124.021
G1 X147.57 Y124.13
G1 X147.64 Y124.2
G1 X148.506 Y125.066 E.00991
G1 X148.576 Y125.136
G1 X148.408 Y125.248
G1 X148.338 Y125.178
G1 X147.467 Y124.308 E.00996
G1 X147.397 Y124.238
G1 X147.225 Y124.346
G1 X147.295 Y124.416
G1 X148.169 Y125.291 E.01
G1 X148.239 Y125.361
G1 X148.071 Y125.473
G1 X148.001 Y125.403
G1 X147.123 Y124.525 E.01005
G1 X147.053 Y124.455
G1 X146.88 Y124.563
G1 X146.95 Y124.633
G1 X147.832 Y125.515 E.01009
G1 X147.902 Y125.585
G1 X147.734 Y125.697
G1 X147.664 Y125.627
G1 X146.778 Y124.741 E.01014
G1 X146.708 Y124.671
G1 X146.535 Y124.78
G1 X146.605 Y124.85
G1 X147.495 Y125.74 E.01018
G1 X147.565 Y125.81
G1 X147.397 Y125.922
G1 X147.327 Y125.852
G1 X146.433 Y124.958 E.01023
G1 X146.363 Y124.888
G1 X146.191 Y124.997
G1 X146.261 Y125.067
G1 X147.158 Y125.964 E.01027
G1 X147.228 Y126.034
G1 X147.06 Y126.147
G1 X146.99 Y126.077
G1 X146.088 Y125.175 E.01032
G1 X146.018 Y125.105
G1 X145.846 Y125.213
G1 X145.916 Y125.283
G1 X146.821 Y126.189 E.01036
G1 X146.891 Y126.259
G1 X146.723 Y126.371
G1 X146.653 Y126.301
G1 X145.743 Y125.392 E.01041
G1 X145.673 Y125.322
G1 X145.501 Y125.43
G1 X145.571 Y125.5
G1 X146.485 Y126.414 E.01045
G1 X146.555 Y126.484
G1 X146.386 Y126.596
G1 X146.316 Y126.526
G1 X145.399 Y125.608 E.0105
G1 X145.329 Y125.538
G1 X145.156 Y125.647
G1 X145.226 Y125.717
G1 X146.148 Y126.638 E.01054
G1 X146.218 Y126.708
G1 X146.049 Y126.82
G1 X145.979 Y126.75
G1 X145.054 Y125.825 E.01059
G1 X144.984 Y125.755
G1 X144.811 Y125.863
G1 X144.881 Y125.933
G1 X145.811 Y126.863 E.01063
G1 X145.881 Y126.933
G1 X145.712 Y127.045
G1 X145.642 Y126.975
G1 X144.709 Y126.042 E.01068
G1 X144.639 Y125.972
G1 X144.467 Y126.08
G1 X144.537 Y126.15
G1 X145.474 Y127.087 E.01072
G1 X145.544 Y127.157
G1 X145.375 Y127.27
G1 X145.305 Y127.2
G1 X144.364 Y126.259 E.01077
G1 X144.294 Y126.189
G1 X144.122 Y126.297
G1 X144.192 Y126.367
G1 X145.137 Y127.312 E.01081
G1 X145.207 Y127.382
G1 X145.038 Y127.494
G1 X144.968 Y127.424
G1 X144.019 Y126.475 E.01086
G1 X143.949 Y126.405
G1 X143.777 Y126.514
G1 X143.847 Y126.584
G1 X144.8 Y127.537 E.0109
G1 X144.87 Y127.607
G1 X144.702 Y127.719
G1 X144.632 Y127.649
G1 X143.675 Y126.692 E.01095
G1 X143.605 Y126.622
G1 X143.432 Y126.73
G1 X143.502 Y126.8
G1 X144.463 Y127.761 E.01099
G1 X144.533 Y127.831
G1 X144.365 Y127.944
G1 X144.295 Y127.874
G1 X143.33 Y126.909 E.01104
G1 X143.26 Y126.839
G1 X143.087 Y126.947
G1 X143.157 Y127.017
G1 X144.126 Y127.986 E.01108
G1 X144.196 Y128.056
G1 X144.028 Y128.168
G1 X143.958 Y128.098
G1 X142.985 Y127.125 E.01113
G1 X142.915 Y127.055
G1 X142.743 Y127.164
G1 X142.813 Y127.234
G1 X143.789 Y128.21 E.01117
G1 X143.859 Y128.28
G1 X143.691 Y128.393
G1 X143.621 Y128.323
G1 X142.64 Y127.342 E.01122
G1 X142.57 Y127.272
G1 X142.398 Y127.381
G1 X142.468 Y127.451
G1 X143.452 Y128.435 E.01126
G1 X143.522 Y128.505
G1 X143.354 Y128.617
G1 X143.284 Y128.547
G1 X142.295 Y127.559 E.01131
G1 X142.225 Y127.489
G1 X142.053 Y127.597
G1 X142.123 Y127.667
G1 X143.115 Y128.66 E.01135
G1 X143.185 Y128.73
G1 X143.025 Y128.85
G1 X142.955 Y128.78
G1 X141.951 Y127.776 E.01149
G1 X141.881 Y127.706
G1 X141.708 Y127.814
G1 X141.778 Y127.884
G1 X142.899 Y129.005 E.01282
; WIPE_START
M204 S8000
G1 X141.778 Y127.884 E-.30118
G1 X141.708 Y127.814 E-.01881
G1 X141.881 Y127.706 E-.03869
G1 X141.951 Y127.776 E-.01881
G1 X141.96 Y127.785 E-.00251
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X141.606 Y127.992 Z1.1 F60000
G1 Z.7
G1 E.4 F1800
G1 F6044.128
M204 S2000
G1 X145.394 Y131.781 E.04334
G1 X145.464 Y131.851
G1 X145.184 Y131.851
G1 X145.114 Y131.781
G1 X141.433 Y128.101 E.0421
G1 X141.363 Y128.031
G1 X141.191 Y128.139
G1 X141.261 Y128.209
G1 X144.833 Y131.781 E.04086
G1 X144.903 Y131.851
G1 X144.622 Y131.851
G1 X144.552 Y131.781
G1 X141.089 Y128.317 E.03962
G1 X141.019 Y128.247
G1 X140.846 Y128.356
G1 X140.916 Y128.426
G1 X144.271 Y131.781 E.03838
G1 X144.341 Y131.851
G1 X144.06 Y131.851
G1 X143.99 Y131.781
G1 X140.744 Y128.534 E.03714
G1 X140.674 Y128.464
G1 X140.501 Y128.573
G1 X140.571 Y128.643
G1 X143.71 Y131.781 E.0359
G1 X143.78 Y131.851
G1 X143.499 Y131.851
G1 X143.429 Y131.781
G1 X140.399 Y128.751 E.03466
G1 X140.329 Y128.681
G1 X140.157 Y128.789
G1 X140.227 Y128.859
G1 X143.148 Y131.781 E.03342
G1 X143.218 Y131.851
G1 X142.937 Y131.851
G1 X142.867 Y131.781
G1 X140.054 Y128.968 E.03218
G1 X139.984 Y128.898
G1 X139.812 Y129.006
G1 X139.882 Y129.076
G1 X142.587 Y131.781 E.03094
G1 X142.657 Y131.851
G1 X142.376 Y131.851
G1 X142.306 Y131.781
G1 X139.709 Y129.184 E.0297
G1 X139.639 Y129.114
G1 X139.467 Y129.223
G1 X139.537 Y129.293
G1 X142.025 Y131.781 E.02846
G1 X142.095 Y131.851
G1 X141.814 Y131.851
G1 X141.744 Y131.781
G1 X139.365 Y129.401 E.02722
G1 X139.295 Y129.331
G1 X139.15 Y129.467
G1 X139.22 Y129.537
G1 X141.464 Y131.781 E.02567
G1 X141.534 Y131.851
G1 X141.253 Y131.851
G1 X141.183 Y131.781
G1 X139.212 Y129.81 E.02254
G1 X139.142 Y129.74
G1 X139.083 Y129.962
G1 X139.153 Y130.032
G1 X140.902 Y131.781 E.02001
G1 X140.972 Y131.851
G1 X140.691 Y131.851
G1 X140.621 Y131.781
G1 X139.009 Y130.168 E.01845
G1 X138.939 Y130.098
G1 X138.699 Y130.14
G1 X138.769 Y130.21
G1 X140.341 Y131.781 E.01797
G1 X140.411 Y131.851
G1 X140.13 Y131.851
G1 X140.06 Y131.781
G1 X138.489 Y130.21 E.01797
G1 X138.419 Y130.14
G1 X138.138 Y130.14
G1 X138.208 Y130.21
G1 X139.779 Y131.781 E.01797
G1 X139.849 Y131.851
G1 X139.568 Y131.851
G1 X139.498 Y131.781
G1 X137.927 Y130.21 E.01797
G1 X137.857 Y130.14
G1 X137.577 Y130.14
G1 X137.647 Y130.21
G1 X139.217 Y131.781 E.01797
G1 X139.287 Y131.851
G1 X139.007 Y131.851
G1 X138.937 Y131.781
G1 X137.366 Y130.21 E.01797
G1 X137.296 Y130.14
G1 X137.015 Y130.14
G1 X137.085 Y130.21
G1 X138.656 Y131.781 E.01797
G1 X138.726 Y131.851
G1 X138.445 Y131.851
G1 X138.375 Y131.781
G1 X136.804 Y130.21 E.01797
G1 X136.734 Y130.14
M73 P97 R0
G1 X136.454 Y130.14
G1 X136.524 Y130.21
G1 X138.094 Y131.781 E.01797
G1 X138.164 Y131.851
G1 X137.884 Y131.851
G1 X137.814 Y131.781
G1 X136.243 Y130.21 E.01797
G1 X136.173 Y130.14
G1 X135.892 Y130.14
G1 X135.962 Y130.21
G1 X137.533 Y131.781 E.01797
G1 X137.603 Y131.851
G1 X137.322 Y131.851
G1 X137.252 Y131.781
G1 X135.682 Y130.21 E.01797
G1 X135.612 Y130.14
G1 X135.331 Y130.14
G1 X135.401 Y130.21
G1 X136.971 Y131.781 E.01797
G1 X137.041 Y131.851
G1 X136.761 Y131.851
G1 X136.691 Y131.781
G1 X135.12 Y130.21 E.01797
G1 X135.05 Y130.14
G1 X134.769 Y130.14
G1 X134.839 Y130.21
G1 X136.41 Y131.781 E.01797
G1 X136.48 Y131.851
G1 X136.199 Y131.851
G1 X136.129 Y131.781
G1 X134.559 Y130.211 E.01796
G1 X134.489 Y130.141
G1 X134.208 Y130.141
G1 X134.278 Y130.211
G1 X135.848 Y131.781 E.01796
G1 X135.918 Y131.851
G1 X135.638 Y131.851
G1 X135.568 Y131.781
G1 X133.997 Y130.211 E.01796
G1 X133.927 Y130.141
G1 X133.647 Y130.141
G1 X133.717 Y130.211
G1 X135.287 Y131.781 E.01796
G1 X135.357 Y131.851
G1 X135.076 Y131.851
G1 X135.006 Y131.781
G1 X133.436 Y130.211 E.01796
G1 X133.366 Y130.141
G1 X133.085 Y130.141
G1 X133.155 Y130.211
G1 X134.725 Y131.781 E.01796
G1 X134.795 Y131.851
G1 X134.514 Y131.851
G1 X134.444 Y131.781
G1 X132.874 Y130.211 E.01796
G1 X132.804 Y130.141
G1 X132.524 Y130.141
G1 X132.594 Y130.211
G1 X134.164 Y131.781 E.01796
G1 X134.234 Y131.851
G1 X133.953 Y131.851
G1 X133.883 Y131.781
G1 X132.313 Y130.211 E.01796
G1 X132.243 Y130.141
G1 X131.962 Y130.141
G1 X132.032 Y130.211
G1 X133.602 Y131.781 E.01796
G1 X133.672 Y131.851
G1 X133.391 Y131.851
G1 X133.321 Y131.781
G1 X131.752 Y130.211 E.01796
G1 X131.682 Y130.141
G1 X131.401 Y130.141
G1 X131.471 Y130.211
G1 X133.041 Y131.781 E.01796
G1 X133.111 Y131.851
G1 X132.83 Y131.851
G1 X132.76 Y131.781
G1 X131.19 Y130.211 E.01796
G1 X131.12 Y130.141
G1 X130.839 Y130.141
G1 X130.909 Y130.211
G1 X132.479 Y131.781 E.01796
G1 X132.549 Y131.851
G1 X132.268 Y131.851
G1 X132.198 Y131.781
G1 X130.629 Y130.211 E.01796
G1 X130.559 Y130.141
G1 X130.278 Y130.141
G1 X130.348 Y130.211
G1 X131.918 Y131.781 E.01796
G1 X131.988 Y131.851
G1 X131.707 Y131.851
G1 X131.637 Y131.781
G1 X130.067 Y130.211 E.01796
G1 X129.997 Y130.141
G1 X129.717 Y130.141
G1 X129.787 Y130.211
G1 X131.356 Y131.781 E.01795
G1 X131.426 Y131.851
G1 X131.145 Y131.851
G1 X131.075 Y131.781
G1 X129.506 Y130.211 E.01795
G1 X129.436 Y130.141
G1 X129.155 Y130.141
G1 X129.225 Y130.211
G1 X130.795 Y131.781 E.01795
G1 X130.865 Y131.851
G1 X130.584 Y131.851
G1 X130.514 Y131.781
G1 X128.944 Y130.212 E.01795
G1 X128.874 Y130.142
G1 X128.594 Y130.142
G1 X128.664 Y130.212
G1 X130.233 Y131.781 E.01795
G1 X130.303 Y131.851
G1 X130.022 Y131.851
G1 X129.952 Y131.781
G1 X128.383 Y130.212 E.01795
G1 X128.313 Y130.142
G1 X128.032 Y130.142
G1 X128.102 Y130.212
G1 X129.672 Y131.781 E.01795
G1 X129.742 Y131.851
G1 X129.461 Y131.851
G1 X129.391 Y131.781
G1 X127.822 Y130.212 E.01795
G1 X127.752 Y130.142
G1 X127.471 Y130.142
G1 X127.541 Y130.212
G1 X129.11 Y131.781 E.01795
G1 X129.18 Y131.851
G1 X128.899 Y131.851
G1 X128.829 Y131.781
G1 X127.26 Y130.212 E.01795
G1 X127.19 Y130.142
G1 X126.909 Y130.142
G1 X126.979 Y130.212
G1 X128.548 Y131.781 E.01795
G1 X128.618 Y131.851
G1 X128.338 Y131.851
G1 X128.268 Y131.781
G1 X126.699 Y130.212 E.01795
G1 X126.629 Y130.142
G1 X126.348 Y130.142
G1 X126.418 Y130.212
G1 X127.987 Y131.781 E.01795
G1 X128.057 Y131.851
G1 X127.776 Y131.851
G1 X127.706 Y131.781
G1 X126.137 Y130.212 E.01795
G1 X126.067 Y130.142
G1 X125.787 Y130.142
G1 X125.857 Y130.212
G1 X127.425 Y131.781 E.01795
G1 X127.495 Y131.851
G1 X127.215 Y131.851
G1 X127.145 Y131.781
G1 X125.576 Y130.212 E.01795
G1 X125.506 Y130.142
G1 X125.225 Y130.142
G1 X125.295 Y130.212
G1 X126.864 Y131.781 E.01795
G1 X126.934 Y131.851
G1 X126.653 Y131.851
G1 X126.583 Y131.781
G1 X126.016 Y131.214 E.00649
G1 X125.946 Y131.144
G1 X125.947 Y131.426
G1 X126.017 Y131.496
G1 X126.302 Y131.781 E.00326
M204 S10000
G1 X125.783 Y130.981 F60000
G1 F6044.128
M204 S2000
G1 X125.014 Y130.212 E.00879
G1 X124.944 Y130.142
G1 X124.664 Y130.142
G1 X124.734 Y130.212
G1 X125.503 Y130.982 E.0088
G1 X125.573 Y131.052
G1 X125.294 Y131.053
G1 X125.224 Y130.983
G1 X124.453 Y130.212 E.00882
G1 X124.383 Y130.142
G1 X124.102 Y130.142
G1 X124.172 Y130.212
G1 X124.947 Y130.987 E.00887
G1 X125.017 Y131.057
G1 X124.875 Y131.196
G1 X124.805 Y131.126
G1 X123.892 Y130.212 E.01045
G1 X123.822 Y130.142
G1 X123.541 Y130.142
G1 X123.611 Y130.212
G1 X124.783 Y131.385 E.01341
G1 X124.853 Y131.455
G1 X124.852 Y131.734
G1 X124.782 Y131.664
G1 X123.33 Y130.213 E.0166
G1 X123.26 Y130.143
G1 X122.979 Y130.143
G1 X123.049 Y130.213
G1 X124.618 Y131.781 E.01794
G1 X124.688 Y131.851
G1 X124.407 Y131.851
G1 X124.337 Y131.781
G1 X122.769 Y130.213 E.01794
G1 X122.699 Y130.143
G1 X122.418 Y130.143
G1 X122.488 Y130.213
G1 X124.056 Y131.781 E.01794
G1 X124.126 Y131.851
G1 X123.845 Y131.851
G1 X123.775 Y131.781
G1 X122.207 Y130.213 E.01794
; WIPE_START
M204 S8000
G1 X123.622 Y131.627 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X128.517 Y125.771 Z1.1 F60000
G1 X141.521 Y110.219 Z1.1
G1 Z.7
G1 E.4 F1800
G1 F6044.128
M204 S2000
G1 X151.576 Y120.275 E.11504
M204 S10000
G1 X150.821 Y119.8 F60000
G1 F6044.128
M204 S2000
G1 X141.24 Y110.219 E.1096
G1 X141.17 Y110.149
G1 X140.889 Y110.149
G1 X140.959 Y110.219
G1 X150.065 Y119.325 E.10417
M204 S10000
G1 X149.309 Y118.849 F60000
G1 F6044.128
M204 S2000
G1 X140.678 Y110.219 E.09873
G1 X140.608 Y110.149
G1 X140.328 Y110.149
G1 X140.398 Y110.219
G1 X148.553 Y118.374 E.09329
M204 S10000
G1 X147.797 Y117.899 F60000
G1 F6044.128
M204 S2000
G1 X140.117 Y110.219 E.08786
G1 X140.047 Y110.149
G1 X139.766 Y110.149
G1 X139.836 Y110.219
G1 X147.041 Y117.424 E.08242
M204 S10000
G1 X146.285 Y116.949 F60000
G1 F6044.128
M204 S2000
G1 X139.555 Y110.219 E.07699
G1 X139.485 Y110.149
G1 X139.205 Y110.149
G1 X139.275 Y110.219
G1 X145.529 Y116.474 E.07155
M204 S10000
G1 X144.773 Y115.999 F60000
G1 F6044.128
M204 S2000
G1 X138.994 Y110.219 E.06612
G1 X138.924 Y110.149
G1 X138.643 Y110.149
G1 X138.713 Y110.219
G1 X144.017 Y115.524 E.06068
M204 S10000
G1 X143.262 Y115.048 F60000
G1 F6044.128
M204 S2000
G1 X138.432 Y110.219 E.05525
G1 X138.362 Y110.149
G1 X138.082 Y110.149
G1 X138.152 Y110.219
G1 X142.506 Y114.573 E.04981
M204 S10000
G1 X141.75 Y114.098 F60000
G1 F6044.128
M204 S2000
G1 X137.871 Y110.219 E.04437
G1 X137.801 Y110.149
G1 X137.52 Y110.149
G1 X137.59 Y110.219
G1 X140.994 Y113.623 E.03894
M204 S10000
G1 X140.238 Y113.148 F60000
G1 F6044.128
M204 S2000
G1 X139.21 Y112.12 E.01176
G1 X138.877 Y111.787
G1 X137.309 Y110.219 E.01794
G1 X137.239 Y110.149
G1 X136.959 Y110.149
G1 X137.029 Y110.219
G1 X138.597 Y111.787 E.01794
G1 X138.667 Y111.857
G1 X138.386 Y111.857
G1 X138.316 Y111.787
G1 X136.748 Y110.219 E.01794
G1 X136.678 Y110.149
G1 X136.397 Y110.149
G1 X136.467 Y110.219
G1 X138.035 Y111.787 E.01794
G1 X138.105 Y111.857
G1 X137.824 Y111.857
G1 X137.754 Y111.787
G1 X136.186 Y110.219 E.01793
G1 X136.116 Y110.149
G1 X135.835 Y110.149
G1 X135.905 Y110.219
G1 X137.473 Y111.787 E.01793
G1 X137.543 Y111.857
G1 X137.262 Y111.857
G1 X137.192 Y111.787
G1 X135.625 Y110.219 E.01793
G1 X135.555 Y110.149
G1 X135.274 Y110.149
G1 X135.344 Y110.219
G1 X136.911 Y111.787 E.01793
G1 X136.981 Y111.857
G1 X136.7 Y111.856
G1 X136.63 Y111.786
G1 X135.063 Y110.219 E.01793
G1 X134.993 Y110.149
G1 X134.712 Y110.149
G1 X134.782 Y110.219
G1 X136.35 Y111.786 E.01793
G1 X136.42 Y111.856
G1 X136.139 Y111.856
G1 X136.069 Y111.786
G1 X134.502 Y110.219 E.01793
G1 X134.432 Y110.149
G1 X134.151 Y110.149
G1 X134.221 Y110.219
G1 X135.788 Y111.786 E.01793
G1 X135.858 Y111.856
G1 X135.577 Y111.856
G1 X135.507 Y111.786
G1 X133.94 Y110.219 E.01792
G1 X133.87 Y110.149
G1 X133.589 Y110.149
G1 X133.659 Y110.219
G1 X135.226 Y111.786 E.01792
G1 X135.296 Y111.856
G1 X135.015 Y111.856
G1 X134.945 Y111.786
G1 X133.379 Y110.219 E.01792
G1 X133.309 Y110.149
G1 X133.028 Y110.149
G1 X133.098 Y110.219
G1 X134.664 Y111.786 E.01792
G1 X134.734 Y111.856
G1 X134.453 Y111.856
G1 X134.383 Y111.786
G1 X132.817 Y110.219 E.01792
G1 X132.747 Y110.149
G1 X132.466 Y110.149
G1 X132.536 Y110.219
G1 X134.103 Y111.785 E.01792
G1 X134.173 Y111.855
G1 X133.892 Y111.855
G1 X133.822 Y111.785
G1 X132.256 Y110.219 E.01792
G1 X132.186 Y110.149
G1 X131.905 Y110.149
G1 X131.975 Y110.219
G1 X133.541 Y111.785 E.01792
G1 X133.611 Y111.855
G1 X133.33 Y111.855
G1 X133.26 Y111.785
G1 X131.694 Y110.219 E.01791
G1 X131.624 Y110.149
G1 X131.343 Y110.149
G1 X131.413 Y110.219
G1 X132.979 Y111.785 E.01791
G1 X133.049 Y111.855
G1 X132.768 Y111.855
G1 X132.698 Y111.785
G1 X131.132 Y110.219 E.01791
G1 X131.062 Y110.149
G1 X130.782 Y110.149
G1 X130.852 Y110.219
G1 X132.417 Y111.785 E.01791
G1 X132.487 Y111.855
G1 X132.206 Y111.855
G1 X132.136 Y111.785
G1 X130.571 Y110.219 E.01791
G1 X130.501 Y110.149
G1 X130.22 Y110.149
G1 X130.29 Y110.219
G1 X131.856 Y111.785 E.01791
G1 X131.926 Y111.855
G1 X131.645 Y111.854
G1 X131.575 Y111.784
G1 X130.009 Y110.219 E.01791
G1 X129.939 Y110.149
G1 X129.659 Y110.149
G1 X129.729 Y110.219
G1 X131.294 Y111.784 E.01791
G1 X131.364 Y111.854
G1 X131.083 Y111.854
G1 X131.013 Y111.784
G1 X129.448 Y110.219 E.0179
G1 X129.378 Y110.149
G1 X129.097 Y110.149
G1 X129.167 Y110.219
G1 X130.732 Y111.784 E.0179
G1 X130.802 Y111.854
G1 X130.521 Y111.854
G1 X130.451 Y111.784
G1 X128.886 Y110.219 E.0179
G1 X128.816 Y110.149
G1 X128.536 Y110.149
G1 X128.606 Y110.219
G1 X130.17 Y111.784 E.0179
G1 X130.24 Y111.854
G1 X129.959 Y111.854
G1 X129.889 Y111.784
G1 X128.325 Y110.219 E.0179
G1 X128.255 Y110.149
G1 X127.974 Y110.149
G1 X128.044 Y110.219
G1 X129.609 Y111.784 E.0179
G1 X129.679 Y111.854
G1 X129.398 Y111.854
G1 X129.328 Y111.784
G1 X127.763 Y110.219 E.0179
G1 X127.693 Y110.149
G1 X127.413 Y110.149
G1 X127.483 Y110.219
G1 X129.047 Y111.783 E.0179
G1 X129.117 Y111.853
G1 X128.836 Y111.853
G1 X128.766 Y111.783
G1 X127.202 Y110.219 E.01789
G1 X127.132 Y110.149
G1 X126.851 Y110.149
G1 X126.921 Y110.219
G1 X128.485 Y111.783 E.01789
G1 X128.555 Y111.853
G1 X128.274 Y111.853
G1 X128.204 Y111.783
G1 X126.64 Y110.219 E.01789
G1 X126.57 Y110.149
G1 X126.289 Y110.149
G1 X126.359 Y110.219
G1 X127.923 Y111.783 E.01789
G1 X127.993 Y111.853
G1 X127.712 Y111.853
G1 X127.642 Y111.783
G1 X126.079 Y110.219 E.01789
G1 X126.009 Y110.149
G1 X125.728 Y110.149
G1 X125.798 Y110.219
G1 X127.362 Y111.783 E.01789
G1 X127.432 Y111.853
G1 X127.151 Y111.853
G1 X127.081 Y111.783
G1 X125.517 Y110.219 E.01789
G1 X125.447 Y110.149
G1 X125.166 Y110.149
G1 X125.236 Y110.219
G1 X126.8 Y111.783 E.01789
G1 X126.87 Y111.853
G1 X126.589 Y111.852
G1 X126.519 Y111.782
G1 X124.956 Y110.219 E.01788
G1 X124.886 Y110.149
G1 X124.605 Y110.149
G1 X124.675 Y110.219
G1 X126.238 Y111.782 E.01788
G1 X126.308 Y111.852
G1 X126.027 Y111.852
G1 X125.957 Y111.782
G1 X124.394 Y110.219 E.01788
G1 X124.324 Y110.149
G1 X124.043 Y110.149
G1 X124.113 Y110.219
G1 X125.676 Y111.782 E.01788
G1 X125.746 Y111.852
G1 X125.466 Y111.852
G1 X125.396 Y111.782
G1 X123.833 Y110.219 E.01788
G1 X123.763 Y110.149
G1 X123.482 Y110.149
G1 X123.552 Y110.219
G1 X125.115 Y111.782 E.01788
G1 X125.185 Y111.852
G1 X124.904 Y111.852
G1 X124.834 Y111.782
G1 X123.271 Y110.219 E.01788
G1 X123.201 Y110.149
G1 X122.92 Y110.149
G1 X122.99 Y110.219
G1 X124.553 Y111.782 E.01788
G1 X124.623 Y111.852
G1 X124.342 Y111.852
G1 X124.272 Y111.782
G1 X122.71 Y110.219 E.01787
G1 X122.64 Y110.149
G1 X122.359 Y110.149
G1 X122.429 Y110.219
G1 X123.991 Y111.782 E.01787
G1 X124.061 Y111.852
G1 X123.78 Y111.851
G1 X123.71 Y111.781
G1 X122.148 Y110.219 E.01787
G1 X122.078 Y110.149
G1 X121.797 Y110.149
G1 X121.867 Y110.219
G1 X123.429 Y111.781 E.01787
G1 X123.499 Y111.851
G1 X123.219 Y111.851
G1 X123.149 Y111.781
G1 X121.587 Y110.219 E.01787
G1 X121.517 Y110.149
G1 X121.236 Y110.149
G1 X121.306 Y110.219
G1 X122.868 Y111.781 E.01787
G1 X122.938 Y111.851
G1 X122.657 Y111.851
G1 X122.587 Y111.781
G1 X121.025 Y110.219 E.01787
G1 X120.955 Y110.149
G1 X120.674 Y110.149
G1 X120.744 Y110.219
G1 X122.306 Y111.781 E.01787
G1 X122.376 Y111.851
G1 X122.125 Y111.881
G1 X122.055 Y111.811
G1 X120.463 Y110.219 E.01821
G1 X120.393 Y110.149
G1 X120.149 Y110.186
G1 X120.219 Y110.256
G1 X121.876 Y111.912 E.01895
G1 X121.946 Y111.982
G1 X121.859 Y112.176
G1 X121.789 Y112.106
G1 X120.219 Y110.536 E.01796
G1 X120.149 Y110.466
G1 X120.149 Y110.747
G1 X120.219 Y110.817
G1 X121.781 Y112.379 E.01787
G1 X121.851 Y112.449
G1 X121.851 Y112.73
G1 X121.781 Y112.66
G1 X120.219 Y111.098 E.01787
G1 X120.149 Y111.028
G1 X120.149 Y111.309
G1 X120.219 Y111.379
G1 X121.781 Y112.94 E.01787
G1 X121.851 Y113.01
G1 X121.851 Y113.291
G1 X121.781 Y113.221
G1 X120.219 Y111.659 E.01787
G1 X120.149 Y111.589
G1 X120.149 Y111.87
G1 X120.219 Y111.94
G1 X121.781 Y113.502 E.01787
G1 X121.851 Y113.572
G1 X121.851 Y113.853
G1 X121.781 Y113.783
G1 X120.219 Y112.221 E.01787
G1 X120.149 Y112.151
G1 X120.149 Y112.432
G1 X120.219 Y112.502
G1 X121.781 Y114.063 E.01787
G1 X121.851 Y114.133
M73 P98 R0
G1 X121.851 Y114.414
G1 X121.781 Y114.344
G1 X120.219 Y112.783 E.01787
G1 X120.149 Y112.713
G1 X120.149 Y112.993
G1 X120.219 Y113.063
G1 X121.781 Y114.625 E.01787
G1 X121.851 Y114.695
G1 X121.851 Y114.976
G1 X121.781 Y114.906
G1 X120.219 Y113.344 E.01787
G1 X120.149 Y113.274
G1 X120.149 Y113.555
G1 X120.219 Y113.625
G1 X121.781 Y115.186 E.01787
G1 X121.851 Y115.256
G1 X121.851 Y115.537
G1 X121.781 Y115.467
G1 X120.219 Y113.906 E.01787
G1 X120.149 Y113.836
G1 X120.149 Y114.116
G1 X120.219 Y114.186
G1 X121.781 Y115.748 E.01787
G1 X121.851 Y115.818
G1 X121.851 Y116.099
G1 X121.781 Y116.029
G1 X120.219 Y114.467 E.01787
G1 X120.149 Y114.397
G1 X120.149 Y114.678
G1 X120.219 Y114.748
G1 X121.781 Y116.31 E.01787
G1 X121.851 Y116.38
G1 X121.851 Y116.66
G1 X121.781 Y116.59
G1 X120.219 Y115.029 E.01787
G1 X120.149 Y114.959
G1 X120.149 Y115.239
G1 X120.219 Y115.309
G1 X121.781 Y116.871 E.01787
G1 X121.851 Y116.941
G1 X121.851 Y117.222
G1 X121.781 Y117.152
G1 X120.219 Y115.59 E.01787
G1 X120.149 Y115.52
G1 X120.149 Y115.801
G1 X120.219 Y115.871
G1 X121.781 Y117.433 E.01787
G1 X121.851 Y117.503
G1 X121.851 Y117.783
G1 X121.781 Y117.713
G1 X120.219 Y116.152 E.01787
G1 X120.149 Y116.082
G1 X120.149 Y116.362
G1 X120.219 Y116.432
G1 X121.781 Y117.994 E.01787
G1 X121.851 Y118.064
G1 X121.851 Y118.345
G1 X121.781 Y118.275
G1 X120.219 Y116.713 E.01787
G1 X120.149 Y116.643
G1 X120.149 Y116.924
G1 X120.219 Y116.994
G1 X121.781 Y118.556 E.01787
G1 X121.851 Y118.626
G1 X121.851 Y118.906
G1 X121.781 Y118.836
G1 X120.219 Y117.275 E.01787
G1 X120.149 Y117.205
G1 X120.149 Y117.485
G1 X120.219 Y117.555
G1 X121.781 Y119.117 E.01787
G1 X121.851 Y119.187
G1 X121.851 Y119.468
G1 X121.781 Y119.398
G1 X120.219 Y117.836 E.01787
G1 X120.149 Y117.766
G1 X120.149 Y118.047
G1 X120.219 Y118.117
G1 X121.781 Y119.679 E.01787
G1 X121.851 Y119.749
G1 X121.851 Y120.029
G1 X121.781 Y119.959
G1 X120.219 Y118.398 E.01787
G1 X120.149 Y118.328
G1 X120.149 Y118.609
G1 X120.219 Y118.679
G1 X121.781 Y120.24 E.01787
G1 X121.851 Y120.31
G1 X121.851 Y120.591
G1 X121.781 Y120.521
G1 X120.219 Y118.959 E.01787
G1 X120.149 Y118.889
G1 X120.149 Y119.17
G1 X120.219 Y119.24
G1 X121.781 Y120.802 E.01787
G1 X121.851 Y120.872
G1 X121.851 Y121.153
G1 X121.781 Y121.083
G1 X120.219 Y119.521 E.01787
G1 X120.149 Y119.451
G1 X120.149 Y119.732
G1 X120.219 Y119.802
G1 X121.781 Y121.363 E.01787
G1 X121.851 Y121.433
G1 X121.851 Y121.714
G1 X121.781 Y121.644
G1 X120.219 Y120.082 E.01787
G1 X120.149 Y120.012
G1 X120.149 Y120.293
G1 X120.219 Y120.363
G1 X121.781 Y121.925 E.01787
G1 X121.851 Y121.995
G1 X121.851 Y122.276
G1 X121.781 Y122.206
G1 X120.219 Y120.644 E.01787
G1 X120.149 Y120.574
G1 X120.149 Y120.855
G1 X120.219 Y120.925
G1 X121.781 Y122.486 E.01787
G1 X121.851 Y122.556
G1 X121.851 Y122.837
G1 X121.781 Y122.767
G1 X120.219 Y121.205 E.01787
G1 X120.149 Y121.135
G1 X120.149 Y121.416
G1 X120.219 Y121.486
G1 X121.781 Y123.048 E.01787
G1 X121.851 Y123.118
G1 X121.851 Y123.399
G1 X121.781 Y123.329
G1 X120.219 Y121.767 E.01787
G1 X120.149 Y121.697
G1 X120.149 Y121.978
G1 X120.219 Y122.048
G1 X121.781 Y123.609 E.01787
G1 X121.851 Y123.679
G1 X121.851 Y123.96
G1 X121.781 Y123.89
G1 X120.219 Y122.328 E.01787
G1 X120.149 Y122.258
G1 X120.149 Y122.539
G1 X120.219 Y122.609
G1 X121.781 Y124.171 E.01787
G1 X121.851 Y124.241
G1 X121.851 Y124.522
G1 X121.781 Y124.452
G1 X120.219 Y122.89 E.01787
G1 X120.149 Y122.82
G1 X120.149 Y123.101
G1 X120.219 Y123.171
G1 X121.781 Y124.732 E.01787
G1 X121.851 Y124.802
G1 X121.851 Y125.083
G1 X121.781 Y125.013
G1 X120.219 Y123.452 E.01787
G1 X120.149 Y123.382
G1 X120.149 Y123.662
G1 X120.219 Y123.732
G1 X121.781 Y125.294 E.01787
G1 X121.851 Y125.364
G1 X121.851 Y125.645
G1 X121.781 Y125.575
G1 X120.219 Y124.013 E.01787
G1 X120.149 Y123.943
G1 X120.149 Y124.224
G1 X120.219 Y124.294
G1 X121.781 Y125.855 E.01787
G1 X121.851 Y125.925
G1 X121.851 Y126.206
G1 X121.781 Y126.136
G1 X120.219 Y124.575 E.01787
G1 X120.149 Y124.505
G1 X120.149 Y124.785
G1 X120.219 Y124.855
G1 X121.781 Y126.417 E.01787
G1 X121.851 Y126.487
G1 X121.851 Y126.768
G1 X121.781 Y126.698
G1 X120.219 Y125.136 E.01787
G1 X120.149 Y125.066
G1 X120.149 Y125.347
G1 X120.219 Y125.417
G1 X121.781 Y126.979 E.01787
G1 X121.851 Y127.049
G1 X121.851 Y127.329
G1 X121.781 Y127.259
G1 X120.219 Y125.698 E.01787
G1 X120.149 Y125.628
G1 X120.149 Y125.908
G1 X120.219 Y125.978
G1 X121.781 Y127.54 E.01787
G1 X121.851 Y127.61
G1 X121.851 Y127.891
G1 X121.781 Y127.821
G1 X120.219 Y126.259 E.01787
G1 X120.149 Y126.189
G1 X120.149 Y126.47
G1 X120.219 Y126.54
G1 X121.781 Y128.102 E.01787
G1 X121.851 Y128.172
G1 X121.851 Y128.452
G1 X121.781 Y128.382
G1 X120.219 Y126.821 E.01787
G1 X120.149 Y126.751
G1 X120.149 Y127.031
G1 X120.219 Y127.101
G1 X121.781 Y128.663 E.01787
G1 X121.851 Y128.733
G1 X121.851 Y129.014
G1 X121.781 Y128.944
G1 X120.219 Y127.382 E.01787
G1 X120.149 Y127.312
G1 X120.149 Y127.593
G1 X120.219 Y127.663
G1 X121.781 Y129.225 E.01787
G1 X121.851 Y129.295
G1 X121.851 Y129.575
G1 X121.781 Y129.505
G1 X120.219 Y127.944 E.01787
G1 X120.149 Y127.874
G1 X120.149 Y128.155
G1 X120.219 Y128.225
G1 X121.781 Y129.786 E.01787
; WIPE_START
M204 S8000
G1 X120.367 Y128.372 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X120.219 Y128.505 Z1.1 F60000
G1 Z.7
G1 E.4 F1800
G1 F6044.128
M204 S2000
G1 X123.495 Y131.781 E.03747
G1 X123.565 Y131.851
G1 X123.284 Y131.851
G1 X123.214 Y131.781
G1 X120.219 Y128.786 E.03426
G1 X120.149 Y128.716
G1 X120.149 Y128.997
G1 X120.219 Y129.067
G1 X122.933 Y131.781 E.03105
G1 X123.003 Y131.851
G1 X122.722 Y131.851
G1 X122.652 Y131.781
G1 X120.219 Y129.348 E.02784
G1 X120.149 Y129.278
G1 X120.149 Y129.558
G1 X120.219 Y129.628
G1 X122.372 Y131.781 E.02462
; WIPE_START
M204 S8000
G1 X120.957 Y130.367 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X121.803 Y129.941 Z1.1 F60000
G1 Z.7
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.0863843
G1 F3000
M204 S8000
G1 X121.758 Y129.856 E.00025
G1 X121.786 Y129.781 E.00021
M204 S10000
G1 X122.167 Y130.254 F60000
; LINE_WIDTH: 0.0556802
G1 F3000
M204 S8000
G1 X122.069 Y130.202 E.00015
; WIPE_START
G1 X122.167 Y130.254 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X122.164 Y131.791 Z1.1 F60000
G1 Z.7
G1 E.4 F1800
; LINE_WIDTH: 0.13063
G1 F3000
M204 S8000
G1 X120.209 Y129.836 E.0123
; WIPE_START
G1 X121.623 Y131.25 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X129.223 Y130.545 Z1.1 F60000
G1 X143.072 Y129.259 Z1.1
G1 Z.7
G1 E.4 F1800
; LINE_WIDTH: 0.0788065
G1 F3000
M204 S8000
G1 X142.933 Y129.14 E.00043
G1 X142.857 Y129.047 E.00028
; WIPE_START
G1 X142.933 Y129.14 E-.15109
G1 X143.072 Y129.259 E-.22891
; WIPE_END
G1 E-.02 F1800
M204 S10000
G1 X148.489 Y123.882 Z1.1 F60000
G1 X151.912 Y120.485 Z1.1
G1 Z.7
G1 E.4 F1800
; LINE_WIDTH: 0.0635916
G1 F3000
M204 S8000
G1 X151.76 Y120.364 E.00033
; LINE_WIDTH: 0.1002
G1 X151.608 Y120.243 E.00062
M204 S10000
G1 X151.156 Y120.01 F60000
; LINE_WIDTH: 0.0635875
G1 F3000
M204 S8000
G1 X151.004 Y119.889 E.00033
; LINE_WIDTH: 0.100189
G1 X150.853 Y119.768 E.00062
M204 S10000
G1 X150.4 Y119.535 F60000
; LINE_WIDTH: 0.0635838
G1 F3000
M204 S8000
G1 X150.248 Y119.414 E.00033
; LINE_WIDTH: 0.100197
G1 X150.097 Y119.293 E.00062
M204 S10000
G1 X149.644 Y119.059 F60000
; LINE_WIDTH: 0.0635916
G1 F3000
M204 S8000
G1 X149.492 Y118.938 E.00033
; LINE_WIDTH: 0.1002
G1 X149.341 Y118.818 E.00062
M204 S10000
G1 X148.888 Y118.584 F60000
; LINE_WIDTH: 0.0635838
G1 F3000
M204 S8000
G1 X148.736 Y118.463 E.00033
; LINE_WIDTH: 0.100197
G1 X148.585 Y118.342 E.00062
M204 S10000
G1 X148.132 Y118.109 F60000
; LINE_WIDTH: 0.0635838
G1 F3000
M204 S8000
G1 X147.981 Y117.988 E.00033
; LINE_WIDTH: 0.100197
G1 X147.829 Y117.867 E.00062
M204 S10000
G1 X147.376 Y117.634 F60000
; LINE_WIDTH: 0.0635881
G1 F3000
M204 S8000
G1 X147.225 Y117.513 E.00033
; LINE_WIDTH: 0.10019
G1 X147.073 Y117.392 E.00062
M204 S10000
G1 X146.62 Y117.159 F60000
; LINE_WIDTH: 0.0635838
G1 F3000
M204 S8000
G1 X146.469 Y117.038 E.00033
; LINE_WIDTH: 0.100197
G1 X146.317 Y116.917 E.00062
M204 S10000
G1 X145.864 Y116.684 F60000
; LINE_WIDTH: 0.0635916
G1 F3000
M204 S8000
G1 X145.713 Y116.563 E.00033
; LINE_WIDTH: 0.1002
G1 X145.561 Y116.442 E.00062
M204 S10000
G1 X145.109 Y116.209 F60000
; LINE_WIDTH: 0.0635881
G1 F3000
M204 S8000
G1 X144.957 Y116.088 E.00033
; LINE_WIDTH: 0.10019
G1 X144.805 Y115.967 E.00062
M204 S10000
G1 X144.353 Y115.733 F60000
; LINE_WIDTH: 0.0635838
G1 F3000
M204 S8000
G1 X144.201 Y115.613 E.00033
; LINE_WIDTH: 0.100197
G1 X144.049 Y115.492 E.00062
M204 S10000
G1 X143.597 Y115.258 F60000
; LINE_WIDTH: 0.0635875
G1 F3000
M204 S8000
G1 X143.445 Y115.137 E.00033
; LINE_WIDTH: 0.100189
G1 X143.293 Y115.016 E.00062
M204 S10000
G1 X142.841 Y114.783 F60000
; LINE_WIDTH: 0.0635874
G1 F3000
M204 S8000
M73 P99 R0
G1 X142.689 Y114.662 E.00033
; LINE_WIDTH: 0.100189
G1 X142.538 Y114.541 E.00062
M204 S10000
G1 X142.085 Y114.308 F60000
; LINE_WIDTH: 0.0635838
G1 F3000
M204 S8000
G1 X141.933 Y114.187 E.00033
; LINE_WIDTH: 0.100197
G1 X141.782 Y114.066 E.00062
M204 S10000
G1 X141.329 Y113.833 F60000
; LINE_WIDTH: 0.0635881
G1 F3000
M204 S8000
G1 X141.177 Y113.712 E.00033
; LINE_WIDTH: 0.10019
G1 X141.026 Y113.591 E.00062
M204 S10000
G1 X140.573 Y113.358 F60000
; LINE_WIDTH: 0.0635874
G1 F3000
M204 S8000
G1 X140.422 Y113.237 E.00033
; LINE_WIDTH: 0.100189
G1 X140.27 Y113.116 E.00062
M204 S10000
G1 X139.817 Y112.883 F60000
; LINE_WIDTH: 0.0697523
G1 F3000
M204 S8000
G1 X139.614 Y112.721 E.00051
; LINE_WIDTH: 0.118682
G1 X139.411 Y112.559 E.00103
; LINE_WIDTH: 0.167613
G1 X139.208 Y112.397 E.00155
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F3000
G1 X139.411 Y112.559 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.1 I1.217 J0 P1  F60000
; stop printing object, unique label id: 5887
M625
M106 S0
M106 P2 S0
M981 S0 P20000 ; close spaghetti detector
; FEATURE: Custom
; MACHINE_END_GCODE_START
; filament end gcode 
;========== H2D end ==========
;===== date: 2026/07/29 =====

M1003 S0
M73 P100 R0

G392 S0 ;turn off nozzle clog detect
M993 A0 B0 C0 ; nozzle cam detection not allowed.

M400 ; wait for buffer to clear
G92 E0 ; zero the extruder
M211 Z1

G90
G1 Z1.1 F900 ; lower z a little
M1002 judge_flag timelapse_record_flag
M622 J1
    G150.3
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S5 ;wait for last picture to be taken
M623  ;end of "timelapse_record_flag"

G90
G1 Z10.7 F900 ; lower z a little

G90
M141 S0 ; turn off chamber heating
M140 S0 ; turn off bed
M106 S0 ; turn off fan
M106 P2 S0 ; turn off remote part cooling fan
M106 P3 S0 ; turn off chamber cooling fan
M106 P9 S0 ; turn off ext toodhead cooling fan
; pull back filament to AMS
M620 S65535
T65535
G150.2
M621 S65535

M620 S65279
T65279
G150.2
M621 S65279

G150.3

M104 S0 T0; turn off hotend
M104 S0 T1; turn off hotend

M400 ; wait all motion done
M17 S
M17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom

    
        G1 Z100.35 F600
        G1 Z98.35
    

M400 P100
M17 R ; restore z current

M220 S100  ; Reset feedrate magnitude
M201.2 K1.0 ; Reset acc magnitude
M73.2   R1.0 ;Reset left time magnitude
M1002 set_gcode_claim_speed_level : 0

M1015.4 S0 K0 ;disable air printing detect

;=====printer finish air purification=========
M622.1 S0
M1002 judge_flag print_finish_air_filt_flag

M622 J1
M1002 gcode_claim_action : 66
M145 P1
M106 P6 S255
M400 S180
M106 P6 S0
M623

M622 J2
M1002 gcode_claim_action : 66
M145 P0
M106 P3 S127
M400 S180
M106 P3 S0
M623
;=====printer finish air purification=========


;=====printer finish  sound=========
M17
M400 S1
M1006 S1
M1006 A53 B10 L99 C53 D10 M99 E53 F10 N99 
M1006 A57 B10 L99 C57 D10 M99 E57 F10 N99 
M1006 A0 B15 L0 C0 D15 M0 E0 F15 N0 
M1006 A53 B10 L99 C53 D10 M99 E53 F10 N99 
M1006 A57 B10 L99 C57 D10 M99 E57 F10 N99 
M1006 A0 B15 L0 C0 D15 M0 E0 F15 N0 
M1006 A48 B10 L99 C48 D10 M99 E48 F10 N99 
M1006 A0 B15 L0 C0 D15 M0 E0 F15 N0 
M1006 A60 B10 L99 C60 D10 M99 E60 F10 N99 
M1006 W
;=====printer finish  sound=========
M400
M18

M73 P100 R0
; EXECUTABLE_BLOCK_END

