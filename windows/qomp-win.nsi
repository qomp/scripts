; Script generated with the Venis Install Wizard

; Define your application name
!define APPNAME "qomp"
!define APPNAMEANDVERSION "qomp 1.2.1"

; Main Install settings
Name "${APPNAMEANDVERSION}"
InstallDir "$PROGRAMFILES\qomp"
InstallDirRegKey HKLM "Software\${APPNAME}" ""
OutFile "qomp-1.2.1-win32.exe"

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
	File "qomp\cue.dll"
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
	File /r "qomp\translations\"	
	SetOutPath "$INSTDIR\plugins\"
	File /r "qomp\plugins\"
	SetOutPath "$INSTDIR\codecs\"
	File /r "qomp\codecs\"
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
	
	WriteRegStr HKCR ".mp3\OpenWithProgids"  "${APPNAME}" ""
	WriteRegStr HKCR ".wav\OpenWithProgids"  "${APPNAME}" ""
	WriteRegStr HKCR ".ogg\OpenWithProgids"  "${APPNAME}" ""
	WriteRegStr HKCR ".cue\OpenWithProgids"  "${APPNAME}" ""
	WriteRegStr HKCR ".flac\OpenWithProgids" "${APPNAME}" ""
	WriteRegStr HKCR ".m3u\OpenWithProgids"  "${APPNAME}" ""
	WriteRegStr HKCR ".m3u8\OpenWithProgids" "${APPNAME}" ""
	WriteRegStr HKCR ".pls\OpenWithProgids"  "${APPNAME}" ""
	WriteRegStr HKCR ".qomp\OpenWithProgids" "${APPNAME}" ""
	
	WriteRegStr HKCR "${APPNAME}" "" "${APPNAME} media file"
	WriteRegStr HKCR "${APPNAME}\Shell\open" "" "$(OpenWith)"
	WriteRegStr HKCR "${APPNAME}\Shell\open\command" "" '"$INSTDIR\qomp.exe" "%1"'
	WriteRegStr HKCR "${APPNAME}\DefaultIcon" "" "$INSTDIR\qomp-file.ico"
	
	WriteRegStr HKCR "Applications\${APPNAME}.exe" "FriendlyAppName" "qomp media player"
	WriteRegStr HKCR "Applications\${APPNAME}.exe\SupportedTypes" ".mp3"  ""
	WriteRegStr HKCR "Applications\${APPNAME}.exe\SupportedTypes" ".ogg"  ""
	WriteRegStr HKCR "Applications\${APPNAME}.exe\SupportedTypes" ".wav"  ""
	WriteRegStr HKCR "Applications\${APPNAME}.exe\SupportedTypes" ".cue"  ""
	WriteRegStr HKCR "Applications\${APPNAME}.exe\SupportedTypes" ".flac" ""
	WriteRegStr HKCR "Applications\${APPNAME}.exe\SupportedTypes" ".m3u"  ""
	WriteRegStr HKCR "Applications\${APPNAME}.exe\SupportedTypes" ".m3u8" ""
	WriteRegStr HKCR "Applications\${APPNAME}.exe\SupportedTypes" ".pls"  ""
	WriteRegStr HKCR "Applications\${APPNAME}.exe\SupportedTypes" ".qomp" ""
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
	Delete "$INSTDIR\cue.dll"
	Delete "$INSTDIR\zlib1.dll"
	Delete "$INSTDIR\qomp-file.ico"

	; Remove remaining directories
	RMDir /r "$INSTDIR\translations\"
	RMDir /r "$INSTDIR\plugins\"
	RMDir /r "$INSTDIR\codecs\"
	RMDir /r "$INSTDIR\platforms\"
	RMDir /r "$INSTDIR\mediaservice\"
	RMDir /r "$INSTDIR\imageformats\"
	RMDir /r "$INSTDIR\bearer\"
	RMDir /r "$INSTDIR\audio\"
	RMDir /r "$INSTDIR\themes\"
	RMDir "$INSTDIR\"
	
	; Delete Shortcuts
	SetShellVarContext all
	Delete "$DESKTOP\qomp.lnk"
	Delete "$SMPROGRAMS\qomp\qomp.lnk"
	Delete "$SMPROGRAMS\qomp\Uninstall.lnk"
	RMDir  "$SMPROGRAMS\qomp"

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