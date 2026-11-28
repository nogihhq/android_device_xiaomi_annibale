#! /vendor/bin/sh
#
# Delete stale CAMX EEPROM calibration backups under /data/vendor/camera.
#
# vendor.qti.camera-provider blindly trusts checksum-valid *.EEPROM.backup
# files ("Prioritize the successful use of eeprom backup"). Backups carried
# over from another ROM (MIUI/HyperOS) can carry calibration the current
# blob set parses differently, which drives the DualSAT OFE profile manager
# to a degenerate dispOut (640x522, AR 1.2257 != 4:3); GeoLibOfeInit rejects
# it and CamX::CNodeImpl::PostPipelineCreate asserts (SIGTRAP), killing the
# provider -> MiuiCamera reports "unable to connect to camera" (Failure 239).
#
# The provider rewrites healthy backups from live EEPROM reads at every
# start, so deleting them at boot is safe and self-healing. It also keeps
# the cache single-session, so a ROM switch can never poison the next one.
#
# Escape hatch (full purge of /data/vendor/camera):
#   adb shell touch /data/vendor/camera/.purge_requested && adb reboot

if [ -d /data/vendor/camera ]; then
    rm -f /data/vendor/camera/*.EEPROM.backup 2>/dev/null

    if [ -f /data/vendor/camera/.purge_requested ]; then
        rm -rf /data/vendor/camera/* /data/vendor/camera/.purge_requested 2>/dev/null
    fi
fi

exit 0
