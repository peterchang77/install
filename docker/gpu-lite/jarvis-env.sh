# ======================================================================
# JARVIS | ENV SETUP 
# ======================================================================

# --- Set conda env
if [ "${JARVIS_SOURCE_ENV:-true}" = true ]; then
    if [ -d /miniconda/envs/jarvis ]; then
        source /miniconda/bin/activate jarvis
    fi
fi

# --- Set users
if [ "${JARVIS_COPY_USERS:-true}" = true ]; then
    if [ -f ~/copyusers.py ]; then
        python ~/copyusers.py -src "${JARVIS_COPY_USERS_SRC:-$HOME/etc}" -dst "${JARVIS_COPY_USERS_DST:-/etc}"
    fi
fi
