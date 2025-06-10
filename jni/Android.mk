# Определяем путь к текущей директории Android.mk
LOCAL_PATH := $(call my-dir)

# --- Подключение предварительно скомпилированных статических библиотек (.a) ---
# Убедитесь, что файлы libopenal.a, libopus.a, libenet.a находятся в вашем репозитории GitHub
# по указанным путям (vendor/openal/, vendor/opus/, vendor/enet/).
# Если их там нет, сборка на GitHub Actions не сможет их найти.

include $(CLEAR_VARS)
LOCAL_MODULE    := libopenal
LOCAL_SRC_FILES := vendor/openal/libopenal.a
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libopus
LOCAL_SRC_FILES := vendor/opus/libopus.a
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := libenet
LOCAL_SRC_FILES := vendor/enet/libenet.a
include $(PREBUILT_STATIC_LIBRARY)

# --- Основной модуль JNI: sampvoice ---
include $(CLEAR_VARS)

LOCAL_MODULE := sampvoice

# Подключаемые системные библиотеки
LOCAL_LDLIBS := -llog -lOpenSLES

# >>> ВАЖНО: ПУТИ К ЗАГОЛОВОЧНЫМ ФАЙЛАМ (.h) <<<
# Здесь нужно указать ВСЕ папки, где лежат ваши заголовочные файлы (.h),
# которые используются в проекте. Компилятор ищет .h файлы в этих директориях.
# Мы добавили все папки, из которых вы берете .cpp файлы, а также пути к заголовкам vendor'ов.
LOCAL_C_INCLUDES := \
    $(LOCAL_PATH) \                       # Если есть .h в корне JNI
    $(LOCAL_PATH)/clientlogic \
    $(LOCAL_PATH)/game \                  # ОЧЕНЬ ВАЖНО: Для CCheckFileHash.h и других в game/
    $(LOCAL_PATH)/net \
    $(LOCAL_PATH)/util \
    $(LOCAL_PATH)/gui \
    $(LOCAL_PATH)/voice \
    $(LOCAL_PATH)/cryptors \
    $(LOCAL_PATH)/vendor/ini \
    $(LOCAL_PATH)/vendor/RakNet \
    $(LOCAL_PATH)/vendor/RakNet/SAMP \
    $(LOCAL_PATH)/vendor/imgui \
    $(LOCAL_PATH)/vendor/hash \
    $(LOCAL_PATH)/vendor/openal/include \ # Убедитесь, что заголовки OpenAL здесь
    $(LOCAL_PATH)/vendor/opus/include \   # Убедитесь, что заголовки Opus здесь
    $(LOCAL_PATH)/vendor/enet/include \   # Убедитесь, что заголовки Enet здесь
    $(LOCAL_PATH)/encryption              # Путь к вашей папке encryption (после её перемещения)


# --- Исходные файлы C/C++ (.cpp, .c) для компиляции ---
# Собираем список всех .cpp и .c файлов из указанных директорий.
# ОБРАТИТЕ ВНИМАНИЕ: Путь к папке 'encryption' теперь изменен на
# $(LOCAL_PATH)/encryption/*.cpp, предполагая, что вы скопировали её
# ВНУТРЬ корня вашего репозитория SAMPVoice_JNI_Builder.
FILE_LIST := $(wildcard $(LOCAL_PATH)/*.cpp)
FILE_LIST += $(wildcard $(LOCAL_PATH)/game/*.cpp)
FILE_LIST += $(wildcard $(LOCAL_PATH)/clientlogic/*.cpp)
FILE_LIST += $(wildcard $(LOCAL_PATH)/net/*.cpp)
FILE_LIST += $(wildcard $(LOCAL_PATH)/util/*.cpp)
FILE_LIST += $(wildcard $(LOCAL_PATH)/game/RW/RenderWare.cpp)
FILE_LIST += $(wildcard $(LOCAL_PATH)/gui/*.cpp)
FILE_LIST += $(wildcard $(LOCAL_PATH)/voice/*.cpp)
FILE_LIST += $(wildcard $(LOCAL_PATH)/cryptors/*.cpp)

# >>> ИСПРАВЛЕНИЕ: Пути к файлам шифрования теперь указывают ВНУТРЬ репозитория <<<
FILE_LIST += $(wildcard $(LOCAL_PATH)/encryption/*.cpp)
FILE_LIST += $(wildcard $(LOCAL_PATH)/encryption/*.c)

# Vendor-специфичные исходные файлы
FILE_LIST += $(wildcard $(LOCAL_PATH)/vendor/ini/*.cpp)
FILE_LIST += $(wildcard $(LOCAL_PATH)/vendor/RakNet/*.cpp)
FILE_LIST += $(wildcard $(LOCAL_PATH)/vendor/RakNet/SAMP/*.cpp)
FILE_LIST += $(wildcard $(LOCAL_PATH)/vendor/imgui/*.cpp)
FILE_LIST += $(wildcard $(LOCAL_PATH)/vendor/hash/md5.cpp)

# Преобразуем список путей к исходникам в формат, понятный make
LOCAL_SRC_FILES := $(FILE_LIST:$(LOCAL_PATH)/%=%)

# Подключаемые статические библиотеки, которые мы объявили выше
LOCAL_STATIC_LIBRARIES := libopenal libopus libenet

# Флаги компилятора C++
LOCAL_CPPFLAGS := -w -s -fvisibility=hidden -pthread -Wall -fpack-struct=1 -O2 -std=c++14 -fexceptions

# Собираем общую (динамическую) библиотеку
include $(BUILD_SHARED_LIBRARY)
