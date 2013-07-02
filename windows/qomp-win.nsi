; Script generated with the Venis Install Wizard

; Define your application name
!define APPNAME "qomp"
!define APPNAMEANDVERSION "qomp 0.2 beta"

; Main Install settings
Name "${APPNAMEANDVERSION}"
InstallDir "$PROGRAMFILES\qomp"
InstallDirRegKey HKLM "Software\${APPNAME}" ""
OutFile "e:\qomp-0.2-beta-win32.exe"

; Use compression
SetCompressor LZMA

; Modern interface settings
!include "MUI.nsh"

!define MUI_ABORTWARNING
!define MUI_FINISHPAGE_RUN "$INSTDIR\qomp.exe"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "qomp-0.2-beta-win32\LICENSE.txt"
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
	SetOverwrite on

	; Set Section Files and Shortcuts
	SetOutPath "$INSTDIR\"
	File "qomp-0.2-beta-win32\libgcc_s_dw2-1.dll"
	File "qomp-0.2-beta-win32\LICENSE.txt"
	File "qomp-0.2-beta-win32\mingwm10.dll"
	File "qomp-0.2-beta-win32\phonon4.dll"
	File "qomp-0.2-beta-win32\qomp.exe"
	File "qomp-0.2-beta-win32\QtCore4.dll"
	File "qomp-0.2-beta-win32\QtGui4.dll"
	File "qomp-0.2-beta-win32\QtNetwork4.dll"
	File "qomp-0.2-beta-win32\QtOpenGL4.dll"
	SetOutPath "$INSTDIR\phonon_backend\"
	File "qomp-0.2-beta-win32\phonon_backend\phonon_ds94.dll"
	SetOutPath "$INSTDIR\translations\"
	File "qomp-0.2-beta-win32\translations\qomp_ru.qm"
	File "qomp-0.2-beta-win32\translations\qt_ru.qm"
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

	; Delete Shortcuts
	Delete "$DESKTOP\qomp.lnk"
	Delete "$SMPROGRAMS\qomp\qomp.lnk"
	Delete "$SMPROGRAMS\qomp\Uninstall.lnk"

	; Clean up qomp
	Delete "$INSTDIR\libgcc_s_dw2-1.dll"
	Delete "$INSTDIR\LICENSE.txt"
	Delete "$INSTDIR\mingwm10.dll"
	Delete "$INSTDIR\phonon4.dll"
	Delete "$INSTDIR\qomp.exe"
	Delete "$INSTDIR\QtCore4.dll"
	Delete "$INSTDIR\QtGui4.dll"
	Delete "$INSTDIR\QtNetwork4.dll"
	Delete "$INSTDIR\QtOpenGL4.dll"
	Delete "$INSTDIR\phonon_backend\phonon_ds94.dll"
	Delete "$INSTDIR\translations\qomp_ru.qm"
	Delete "$INSTDIR\translations\qt_ru.qm"

	; Remove remaining directories
	RMDir "$SMPROGRAMS\qomp"
	RMDir "$INSTDIR\translations\"
	RMDir "$INSTDIR\phonon_backend\"
	RMDir "$INSTDIR\"

SectionEnd

; On initialization
Function .onInit

	!insertmacro MUI_LANGDLL_DISPLAY

FunctionEnd

BrandingText "Quick(Qt) Online Music Player"

; eof