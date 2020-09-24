# ======================================================================
# JARVIS | ENTRY SCRIPT 
# ======================================================================

# --- Run startup script if set
if [ ! -z $JARVIS_ENTRY_SCRIPT ]; then
    if [ -f $JARVIS_ENTRY_SCRIPT ]; then
        source $JARVIS_ENTRY_SCRIPT
    fi
fi
