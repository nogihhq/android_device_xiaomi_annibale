package com.miui.securitycenter;

import android.app.Activity;
import android.os.Bundle;

/**
 * Minimal CTA responder for MiuiCamera.
 *
 * MiuiCamera builds an intent for miui.intent.action.SYSTEM_PERMISSION_DECLARE_NEW
 * and pins it to package com.miui.securitycenter (T9/a.smali), which is not
 * installed in this ROM, so startActivityForResult never returns and
 * ActivityBase.r0 (mIsNewCTAShowing) stays true forever -> setupCamera skipped.
 *
 * Camera-side result mapping (E1/z pswitch_3): resultCode 1 -> c$a.c ("agreed"),
 * and T9/a.a(1) persists pref_camera_first_use_hint_shown_key=false so every
 * later launch short-circuits at d.c() without launching anything.
 */
public class CtaActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setResult(1);
        finish();
    }
}
