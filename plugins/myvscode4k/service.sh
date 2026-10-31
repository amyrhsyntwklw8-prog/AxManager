#!/system/bin/sh
MODDIR=${0%/*}
mkdir -p "$MODDIR/sim/workspace" "$MODDIR/sim/system" "$MODDIR/sim/data"
echo "started $(date)" > "$MODDIR/sim/workspace/alive.log"
id >> "$MODDIR/sim/workspace/alive.log"
