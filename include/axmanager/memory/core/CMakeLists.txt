# تعریف کتابخانه اصلی و افزودن تمام فایل‌های هسته
add_library(
    axmanager_core
    SHARED
    include/axmanager/memory/core/ShadowMemoryEngine.cpp
    include/axmanager/core/EnvironmentSimulator.cpp
    # سایر فایل‌های پروژه اگر وجود دارند...
)

# تنظیم مسیر پوشه‌های هدر (Include Directories)
target_include_directories(axmanager_core PRIVATE
    include
    include/axmanager
    include/axmanager/core
    include/axmanager/memory/core
)
