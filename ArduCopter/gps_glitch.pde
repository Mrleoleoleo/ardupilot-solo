/// -*- tab-width: 4; Mode: C++; c-basic-offset: 4; indent-tabs-mode: nil -*-

static void gps_glitch_update() {
    bool glitch = ahrs.get_NavEKF().getGpsGlitchStatus();

    if (glitch && !failsafe.gps_glitch) {
        gps_glitch_on_event();
    } else if (!glitch && failsafe.gps_glitch) {
        gps_glitch_off_event();
    }
}

static void gps_glitch_on_event() {
    failsafe.gps_glitch = true;

    if (motors.armed() && mode_requires_RC(control_mode) && mode_requires_GPS(control_mode) && !failsafe.radio && !failsafe.ekf) {
        if(set_mode(ALT_HOLD)) {
            gps_glitch_switch_mode_on_resolve = true;
        }
    }
}

static void gps_glitch_off_event() {
    failsafe.gps_glitch = false;

    if (gps_glitch_switch_mode_on_resolve) {
        set_mode(LOITER);
    }
}