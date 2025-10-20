#!/system/bin/sh
# Do not remove '#!/system/bin/sh' from the top of the file, doing so will break the script

MODDIR=${0%/*}

# CPU Governor and Frequency Settings
echo schedutil > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo schedutil > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor

# Set CPU frequencies (adjust based on device)
echo 300000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo 1800000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo 300000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
echo 1800000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq

# I/O Scheduler
for queue in /sys/block/*/queue/scheduler; do
    echo mq-deadline > $queue
done

# GPU Settings for Mali-G57
echo 0 > /sys/devices/platform/soc/5000000.qcom,kgsl-3d0/kgsl/kgsl-3d0/pwrnap
echo 1 > /sys/devices/platform/soc/5000000.qcom,kgsl-3d0/kgsl/kgsl-3d0/force_no_nap
echo 1 > /sys/devices/platform/soc/5000000.qcom,kgsl-3d0/kgsl/kgsl-3d0/force_bus_on
echo 1 > /sys/devices/platform/soc/5000000.qcom,kgsl-3d0/kgsl/kgsl-3d0/force_rail_on
echo 1 > /sys/devices/platform/soc/5000000.qcom,kgsl-3d0/kgsl/kgsl-3d0/force_clk_on

# Memory and ZRAM
echo 50 > /proc/sys/vm/swappiness
echo 1 > /sys/block/zram0/reset
echo 1 > /sys/block/zram0/comp_algorithm
echo 1073741824 > /sys/block/zram0/disksize  # 1GB ZRAM

# Background App Limits
settings put global activity_manager_constants max_cached_processes=32

# Battery Optimizations
dumpsys deviceidle enable
dumpsys deviceidle force-idle

# Disable Thermal Throttling (use with caution)
stop thermal-engine
setprop ctl.stop thermal-engine

# Network Optimizations
setprop net.tcp.buffersize.default 4096,87380,110208,4096,16384,110208
setprop net.tcp.buffersize.wifi 4096,87380,110208,4096,16384,110208
setprop net.tcp.buffersize.umts 4096,87380,110208,4096,16384,110208
setprop net.tcp.buffersize.hsdpa 4096,87380,110208,4096,16384,110208
setprop net.tcp.buffersize.hspa 4096,87380,110208,4096,16384,110208
setprop net.tcp.buffersize.lte 4096,87380,110208,4096,16384,110208
setprop net.tcp.buffersize.evdo_b 4096,87380,110208,4096,16384,110208

# Performance Boost
setprop ro.am.reschedule_service true
setprop ro.sys.fw.bg_cached_ratio 0.33
setprop ro.sys.fw.change_to_service_delay 1000
setprop ro.sys.fw.empty_app_percent 50
setprop ro.sys.fw.trim_cache_percent 100
setprop ro.sys.fw.trim_empty_percent 100
setprop ro.sys.fw.trim_enable_memory 1073741824
setprop ro.sys.fw.use_trim_settings true

# GPU Frequency Scaling
echo 200000000 > /sys/devices/platform/soc/5000000.qcom,kgsl-3d0/kgsl/kgsl-3d0/min_clock_mhz
echo 1000000000 > /sys/devices/platform/soc/5000000.qcom,kgsl-3d0/kgsl/kgsl-3d0/max_clock_mhz

# Additional CPU Boost
echo 1 > /sys/devices/system/cpu/cpu_boost/enabled
echo 1000000 > /sys/devices/system/cpu/cpu_boost/input_boost_freq
echo 40 > /sys/devices/system/cpu/cpu_boost/input_boost_ms

# Disable Debugging Services
setprop debug.atrace.tags.enableflags 0
setprop debug.mdpcomp.logs 0
setprop debug.sf.recomputecrop 0

# Log the tweaks applied
echo "Mika's Tweak Magisk Module applied successfully" > /cache/mikasatweak.log
date >> /cache/mikasatweak.log
