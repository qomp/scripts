; Script generated with the Venis Install Wizard

; Define your application name
!define APPNAME "qomp"
!define APPNAMEANDVERSION "qomp 0.6 beta"

; Main Install settings
Name "${APPNAMEANDVERSION}"
InstallDir "$PROGRAMFILES\qomp"
InstallDirRegKey HKLM "Software\${APPNAME}" ""
OutFile "qomp-0.6-beta-win32.exe"

; Use compression
SetCompressor LZMA

; Modern interface settings
!include "MUI.nsh"

!define MUI_ABORTWARNING
!define MUI_FINISHPAGE_RUN "$INSTDIR\qomp.exe"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "qomp\LICENSE.txt"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; Set languages (first is default language)
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Russian"
!insertmacro MUI_RESERVEFILE_LANGDLL

Section "qomp" Section1

	; Set Section properties
	SectionIn RO
	SetOverwrite on

	; Set Section Files and Shortcuts
	SetOutPath "$INSTDIR\"
	File "qomp\icudt51.dll"
	File "qomp\icuin51.dll"
	File "qomp\icuuc51.dll"
	File "qomp\libeay32.dll"
	File "qomp\ssleay32.dll"
	File "qomp\libgcc_s_dw2-1.dll"
	File "qomp\libstdc++-6.dll"
	File "qomp\libwinpthread-1.dll"
	File "qomp\LICENSE.txt"
	File "qomp\qomp.exe"
	File "qomp\qomp.dll"
	File "qomp\Qt5Core.dll"
	File "qomp\Qt5Gui.dll"
	File "qomp\Qt5Multimedia.dll"
	File "qomp\Qt5MultimediaWidgets.dll"
	File "qomp\Qt5Network.dll"
	File "qomp\Qt5OpenGL.dll"
	File "qomp\Qt5Widgets.dll"
	File "qomp\Qt5Xml.dll"
	File "qomp\libtag.dll"
	File "qomp\zlib1.dll"
	SetOutPath "$INSTDIR\audio\"
	File "qomp\audio\qtaudio_windows.dll"
	SetOutPath "$INSTDIR\bearer\"
	File "qomp\bearer\qgenericbearer.dll"
	File "qomp\bearer\qnativewifibearer.dll"
	SetOutPath "$INSTDIR\mediaservice\"
	File "qomp\mediaservice\dsengine.dll"
	File "qomp\mediaservice\qtmedia_audioengine.dll"
	SetOutPath "$INSTDIR\platforms\"
	File "qomp\platforms\qwindows.dll"
	SetOutPath "$INSTDIR\playlistformats\"
	File "qomp\playlistformats\qtmultimedia_m3u.dll"
	SetOutPath "$INSTDIR\translations\"
	File "qomp\translations\qmlviewer_ru.qm"
	File "qomp\translations\qomp_ru.qm"
	File "qomp\translations\qtbase_ru.qm"
	File "qomp\translations\qtconfig_ru.qm"
	File "qomp\translations\qtdeclarative_ru.qm"
	File "qomp\translations\qtmultimedia_ru.qm"
	File "qomp\translations\qtquick1_ru.qm"
	File "qomp\translations\qtscript_ru.qm"
	File "qomp\translations\qtxmlpatterns_ru.qm"
	File "qomp\translations\qt_help_ru.qm"
	File "qomp\translations\qt_ru.qm"
	SetOutPath "$INSTDIR\plugins\"
	File "qomp\plugins\filesystemplugin.dll"
	File "qomp\plugins\lastfmplugin.dll"
	File "qomp\plugins\myzukaruplugin.dll"
	File "qomp\plugins\prostopleerplugin.dll"
	File "qomp\plugins\tunetofileplugin.dll"
	File "qomp\plugins\urlplugin.dll"
	File "qomp\plugins\yandexmusicplugin.dll"
	
	SetShellVarContext all
	CreateShortCut "$DESKTOP\qomp.lnk" "$INSTDIR\qomp.exe"
	CreateDirectory "$SMPROGRAMS\qomp"
	CreateShortCut "$SMPROGRAMS\qomp\qomp.lnk" "$INSTDIR\qomp.exe"
	CreateShortCut "$SMPROGRAMS\qomp\Uninstall.lnk" "$INSTDIR\uninstall.exe"

SectionEnd

Section -FinishSection

	WriteRegStr HKLM "Software\${APPNAME}" "" "$INSTDIR"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayName" "${APPNAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "UninstallString" "$INSTDIR\uninstall.exe"
	WriteUninstaller "$INSTDIR\uninstall.exe"

SectionEnd

; Modern install component descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
	!insertmacro MUI_DESCRIPTION_TEXT ${Section1} ""
!insertmacro MUI_FUNCTION_DESCRIPTION_END

;Uninstall section
Section Uninstall

	;Remove from registry...
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
	DeleteRegKey HKLM "SOFTWARE\${APPNAME}"

	; Delete self
	Delete "$INSTDIR\uninstall.exe"

	; Clean up qomp
	Delete "$INSTDIR\icudt51.dll"
	Delete "$INSTDIR\icuin51.dll"
	Delete "$INSTDIR\icuuc51.dll"
	Delete "$INSTDIR\libeay32.dll"
	Delete "$INSTDIR\ssleay32.dll"
	Delete "$INSTDIR\libgcc_s_dw2-1.dll"
	Delete "$INSTDIR\libstdc++-6.dll"
	Delete "$INSTDIR\libwinpthread-1.dll"
	Delete "$INSTDIR\LICENSE.txt"
	Delete "$INSTDIR\qomp.exe"
	Delete "$INSTDIR\qomp.dll"
	Delete "$INSTDIR\Qt5Core.dll"
	Delete "$INSTDIR\Qt5Gui.dll"
	Delete "$INSTDIR\Qt5Multimedia.dll"
	Delete "$INSTDIR\Qt5MultimediaWidgets.dll"
	Delete "$INSTDIR\Qt5Network.dll"
	Delete "$INSTDIR\Qt5OpenGL.dll"
	Delete "$INSTDIR\Qt5Widgets.dll"
	Delete "$INSTDIR\Qt5Xml.dll"
	Delete "$INSTDIR\libtag.dll"
	Delete "$INSTDIR\zlib1.dll"
	Delete "$INSTDIR\audio\qtaudio_windows.dll"
	Delete "$INSTDIR\bearer\qgenericbearer.dll"
	Delete "$INSTDIR\bearer\qnativewifibearer.dll"
	Delete "$INSTDIR\mediaservice\dsengine.dll"
	Delete "$INSTDIR\mediaservice\qtmedia_audioengine.dll"
	Delete "$INSTDIR\platforms\qwindows.dll"
	Delete "$INSTDIR\playlistformats\qtmultimedia_m3u.dll"
	Delete "$INSTDIR\translations\qmlviewer_ru.qm"
	Delete "$INSTDIR\translations\qomp_ru.qm"
	Delete "$INSTDIR\translations\qtbase_ru.qm"
	Delete "$INSTDIR\translations\qtconfig_ru.qm"
	Delete "$INSTDIR\translations\qtdeclarative_ru.qm"
	Delete "$INSTDIR\translations\qtmultimedia_ru.qm"
	Delete "$INSTDIR\translations\qtquick1_ru.qm"
	Delete "$INSTDIR\translations\qtscript_ru.qm"
	Delete "$INSTDIR\translations\qtxmlpatterns_ru.qm"
	Delete "$INSTDIR\translations\qt_help_ru.qm"
	Delete "$INSTDIR\translations\qt_ru.qm"
	Delete "$INSTDIR\plugins\filesystemplugin.dll"
	Delete "$INSTDIR\plugins\lastfmplugin.dll"
	Delete "$INSTDIR\plugins\myzukaruplugin.dll"
	Delete "$INSTDIR\plugins\prostopleerplugin.dll"
	Delete "$INSTDIR\plugins\tunetofileplugin.dll"
	Delete "$INSTDIR\plugins\urlplugin.dll"
	Delete "$INSTDIR\plugins\yandexmusicplugin.dll"

	; Remove remaining directories
	RMDir "$INSTDIR\translations\"
	RMDir "$INSTDIR\playlistformats\"
	RMDir "$INSTDIR\platforms\"
	RMDir "$INSTDIR\mediaservice\"
	RMDir "$INSTDIR\bearer\"
	RMDir "$INSTDIR\plugins\"
	RMDir "$INSTDIR\"
	
	; Delete Shortcuts
	SetShellVarContext all
	Delete "$DESKTOP\qomp.lnk"
	Delete "$SMPROGRAMS\qomp\qomp.lnk"
	Delete "$SMPROGRAMS\qomp\Uninstall.lnk"
	RMDir "$SMPROGRAMS\qomp"

SectionEnd

; On initialization
Function .onInit

	!insertmacro MUI_LANGDLL_DISPLAY

FunctionEnd

BrandingText "Quick(Qt) Online Music Player"

; eof