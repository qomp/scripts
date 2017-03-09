; Script generated with the Venis Install Wizard

; Define your application name
!define APPNAME "qomp"
!define APPNAMEANDVERSION "qomp 1.1.1"

; Main Install settings
Name "${APPNAMEANDVERSION}"
InstallDir "$PROGRAMFILES\qomp"
InstallDirRegKey HKLM "Software\${APPNAME}" ""
OutFile "qomp-1.1.1-win32.exe"

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

LangString 	ConfirmRemove		 ${LANG_ENGLISH}	"${APPNAME} is already installed.$\nDo you want to remove previous version?"
LangString 	ConfirmRemove		 ${LANG_RUSSIAN}	"${APPNAME} уже установлен.$\nВы хотите удалить предыдущую версию?"

LangString 	OpenWith		 ${LANG_ENGLISH}	"Open with ${APPNAME}"
LangString 	OpenWith		 ${LANG_RUSSIAN}	"Открыть с помощью ${APPNAME}"

Section "qomp" Section1

	; Set Section properties
	SectionIn RO
	SetOverwrite on

	; Set Section Files and Shortcuts
	SetOutPath "$INSTDIR\"
	File "qomp\icudt54.dll"
	File "qomp\icuin54.dll"
	File "qomp\icuuc54.dll"
	File "qomp\libeay32.dll"
	File "qomp\ssleay32.dll"
	File "qomp\libgcc_s_dw2-1.dll"
	File "qomp\libstdc++-6.dll"
	File "qomp\libwinpthread-1.dll"
	File "qomp\LICENSE.txt"
	File "qomp\qomp.exe"
	File "qomp\qomp.dll"
	File "qomp\Qt5Concurrent.dll"
	File "qomp\Qt5Core.dll"
	File "qomp\Qt5Gui.dll"
	File "qomp\Qt5Multimedia.dll"
	File "qomp\Qt5Network.dll"
	File "qomp\Qt5Widgets.dll"
	File "qomp\Qt5Xml.dll"
	File "qomp\Qt5WinExtras.dll"
	File "qomp\libtag.dll"
	File "qomp\libcue.dll"
	File "qomp\zlib1.dll"
	File "qomp\qomp-file.ico"
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
	SetOutPath "$INSTDIR\imageformats\"
	File "qomp\imageformats\qgif.dll"
	File "qomp\imageformats\qjpeg.dll"
	SetOutPath "$INSTDIR\translations\"
	File "qomp\translations\qomp_ru.qm"
	File "qomp\translations\qtbase_ru.qm"
	File "qomp\translations\qtconfig_ru.qm"
	File "qomp\translations\qtmultimedia_ru.qm"
	File "qomp\translations\qt_help_ru.qm"
	File "qomp\translations\qt_ru.qm"
	SetOutPath "$INSTDIR\plugins\"
	File "qomp\plugins\filesystemplugin.dll"
	File "qomp\plugins\lastfmplugin.dll"
	File "qomp\plugins\myzukaruplugin.dll"
	File "qomp\plugins\notificationsplugin.dll"
	File "qomp\plugins\prostopleerplugin.dll"
	File "qomp\plugins\tunetofileplugin.dll"
	File "qomp\plugins\urlplugin.dll"
	File "qomp\plugins\yandexmusicplugin.dll"
	SetOutPath "$INSTDIR\codecs\"
	File "qomp\codecs\avcodec-lav-54.dll"
	File "qomp\codecs\avformat-lav-54.dll"
	File "qomp\codecs\avutil-lav-51.dll"
	File "qomp\codecs\install_all.bat"
	File "qomp\codecs\LAVAudio.ax"
	File "qomp\codecs\LAVSplitter.ax"
	File "qomp\codecs\libbluray.dll"
	File "qomp\codecs\uninstall_all.bat"
	SetOutPath "$INSTDIR\themes\"
	File "qomp\themes\themes.rcc"
	
	ExecWait "$INSTDIR\codecs\install_all.bat"
	
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
	
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\App Paths\${APPNAME}.exe" "" "$INSTDIR\qomp.exe"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\App Paths\${APPNAME}.exe" "Path" "$INSTDIR"
	
	WriteRegStr HKCR ".mp3\OpenWithProgids" "${APPNAME}" ""
	WriteRegStr HKCR ".wav\OpenWithProgids" "${APPNAME}" ""
	WriteRegStr HKCR ".ogg\OpenWithProgids" "${APPNAME}" ""
	WriteRegStr HKCR ".cue\OpenWithProgids" "${APPNAME}" ""
	WriteRegStr HKCR ".flac\OpenWithProgids" "${APPNAME}" ""
	
	WriteRegStr HKCR "${APPNAME}" "" "${APPNAME} media file"
	WriteRegStr HKCR "${APPNAME}\Shell\open" "" "$(OpenWith)"
	WriteRegStr HKCR "${APPNAME}\Shell\open\command" "" '"$INSTDIR\qomp.exe" "%1"'
	WriteRegStr HKCR "${APPNAME}\DefaultIcon" "" "$INSTDIR\qomp-file.ico"
	
	WriteRegStr HKCR "Applications\${APPNAME}.exe" "FriendlyAppName" "qomp media player"
	WriteRegStr HKCR "Applications\${APPNAME}.exe\SupportedTypes" ".mp3" ""
	WriteRegStr HKCR "Applications\${APPNAME}.exe\SupportedTypes" ".ogg" ""
	WriteRegStr HKCR "Applications\${APPNAME}.exe\SupportedTypes" ".wav" ""
	WriteRegStr HKCR "Applications\${APPNAME}.exe\SupportedTypes" ".cue" ""
	WriteRegStr HKCR "Applications\${APPNAME}.exe\SupportedTypes" ".flac" ""
	WriteRegStr HKCR "Applications\${APPNAME}.exe\Shell\open\command" "" '"$INSTDIR\${APPNAME}.exe" "%1"'

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
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\App Paths\${APPNAME}.exe"

	; Delete self
	Delete "$INSTDIR\uninstall.exe"

	ExecWait "$INSTDIR\codecs\uninstall_all.bat"
	
	; Clean up qomp
	Delete "$INSTDIR\icudt54.dll"
	Delete "$INSTDIR\icuin54.dll"
	Delete "$INSTDIR\icuuc54.dll"
	Delete "$INSTDIR\libeay32.dll"
	Delete "$INSTDIR\ssleay32.dll"
	Delete "$INSTDIR\libgcc_s_dw2-1.dll"
	Delete "$INSTDIR\libstdc++-6.dll"
	Delete "$INSTDIR\libwinpthread-1.dll"
	Delete "$INSTDIR\LICENSE.txt"
	Delete "$INSTDIR\qomp.exe"
	Delete "$INSTDIR\qomp.dll"
	Delete "$INSTDIR\Qt5Concurrent.dll"
	Delete "$INSTDIR\Qt5Core.dll"
	Delete "$INSTDIR\Qt5Gui.dll"
	Delete "$INSTDIR\Qt5Multimedia.dll"
	Delete "$INSTDIR\Qt5Network.dll"
	Delete "$INSTDIR\Qt5Widgets.dll"
	Delete "$INSTDIR\Qt5Xml.dll"
	Delete "$INSTDIR\Qt5WinExtras.dll"
	Delete "$INSTDIR\libtag.dll"
	Delete "$INSTDIR\libcue.dll"
	Delete "$INSTDIR\zlib1.dll"
	Delete "$INSTDIR\qomp-file.ico"
	Delete "$INSTDIR\audio\qtaudio_windows.dll"
	Delete "$INSTDIR\bearer\qgenericbearer.dll"
	Delete "$INSTDIR\bearer\qnativewifibearer.dll"
	Delete "$INSTDIR\mediaservice\dsengine.dll"
	Delete "$INSTDIR\mediaservice\qtmedia_audioengine.dll"
	Delete "$INSTDIR\platforms\qwindows.dll"
	Delete "$INSTDIR\imageformats\qgif.dll"
	Delete "$INSTDIR\imageformats\qjpeg.dll"
	Delete "$INSTDIR\translations\qomp_ru.qm"
	Delete "$INSTDIR\translations\qtbase_ru.qm"
	Delete "$INSTDIR\translations\qtconfig_ru.qm"
	Delete "$INSTDIR\translations\qtmultimedia_ru.qm"
	Delete "$INSTDIR\translations\qt_help_ru.qm"
	Delete "$INSTDIR\translations\qt_ru.qm"
	Delete "$INSTDIR\plugins\filesystemplugin.dll"
	Delete "$INSTDIR\plugins\lastfmplugin.dll"
	Delete "$INSTDIR\plugins\myzukaruplugin.dll"
	Delete "$INSTDIR\plugins\notificationsplugin.dll"
	Delete "$INSTDIR\plugins\prostopleerplugin.dll"
	Delete "$INSTDIR\plugins\tunetofileplugin.dll"
	Delete "$INSTDIR\plugins\urlplugin.dll"
	Delete "$INSTDIR\plugins\yandexmusicplugin.dll"
	Delete "$INSTDIR\codecs\avcodec-lav-54.dll"
	Delete "$INSTDIR\codecs\avformat-lav-54.dll"
	Delete "$INSTDIR\codecs\avutil-lav-51.dll"
	Delete "$INSTDIR\codecs\install_all.bat"
	Delete "$INSTDIR\codecs\LAVAudio.ax"
	Delete "$INSTDIR\codecs\LAVSplitter.ax"
	Delete "$INSTDIR\codecs\libbluray.dll"
	Delete "$INSTDIR\codecs\uninstall_all.bat"
	Delete "$INSTDIR\themes\themes.rcc"

	; Remove remaining directories
	RMDir "$INSTDIR\translations\"
	RMDir "$INSTDIR\platforms\"
	RMDir "$INSTDIR\mediaservice\"
	RMDir "$INSTDIR\imageformats\"
	RMDir "$INSTDIR\bearer\"
	RMDir "$INSTDIR\audio\"
	RMDir "$INSTDIR\plugins\"
	RMDir "$INSTDIR\codecs\"
	RMDir "$INSTDIR\themes\"
	RMDir "$INSTDIR\"
	
	; Delete Shortcuts
	SetShellVarContext all
	Delete "$DESKTOP\qomp.lnk"
	Delete "$SMPROGRAMS\qomp\qomp.lnk"
	Delete "$SMPROGRAMS\qomp\Uninstall.lnk"
	RMDir "$SMPROGRAMS\qomp"

	DeleteRegKey HKCR "${APPNAME}"
	DeleteRegKey HKCR "Applications\${APPNAME}.exe"

SectionEnd

; On initialization
Function .onInit	
	 
  ReadRegStr $R0 HKLM \
  "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" \
  "UninstallString"
  StrCmp $R0 "" done
 
  MessageBox MB_YESNOCANCEL|MB_ICONEXCLAMATION \
	"$(ConfirmRemove)" \
  IDYES uninst \
	IDNO done
  Abort
 
;Run the uninstaller
uninst:
  ClearErrors
  ExecWait '$R0 _?=$INSTDIR' ;Do not copy the uninstaller to a temp file
 
  IfErrors no_remove_uninstaller done
    ;You can either use Delete /REBOOTOK in the uninstaller or add some code
    ;here to remove the uninstaller. Use a registry key to check
    ;whether the user has chosen to uninstall. If you are using an uninstaller
    ;components page, make sure all sections are uninstalled.
  no_remove_uninstaller:
 
done:

!insertmacro MUI_LANGDLL_DISPLAY

FunctionEnd

BrandingText "Quick(Qt) Online Music Player"

; eof