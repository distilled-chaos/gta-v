;; @author Distilled_chaoS 2017

;;;;;
;;; GLOBALS
;;;;;

Proc = GTA5
LagOutActive := false

;;;;;
;;; METHODS
;;;;;

ShowInfo() {
;; content
InfoText = 
(
WindowKey + Ctrl + F1
Show this message

WindowKey + Ctrl + Space
Solo Session

WindowKey + Ctrl + F4
Terminate after 1.5 secs

WindowKey + ESC
Check to make sure that the script is awake
)
;; end content

	MsgBox 0, Hotkeys, %InfoText%, 3
}

ProcIsActive(Proc, Timeout := 0) {
	Process, Exist, %Proc%.exe
	Output := ErrorLevel
	if(Timeout > 0) {
		Sleep %Timeout%
	}
	
	return Output != 0
}

Beep(Length := 100) {
	SoundBeep, 750, %Length%
}

SuccessBeep() {
	Beep(750)
}

Countdown(Seconds := 1) {
	Loop, %Seconds% {
		Beep()
		Sleep 1000
	}
}

;;;;;
;;; INIT
;;;;;
ShowInfo()
; TODO: add a first-run functionality to check for existence of pssuspend and to run it, ensuring the user agrees to TOS

;;;;;
;;; KEY BINDINGS
;;;;;

; Show info
#^F1::
ShowInfo()
return

; Lag out of session
#^Space::
if(!LagOutActive And ProcIsActive(Proc)) {
	LagOutActive := true
	RunWait pssuspend64.exe %Proc%
	Countdown(10)
	RunWait pssuspend64.exe -r %Proc%
	SuccessBeep()
}
LagOutActive := false
return

; Terminate game after a small timeout
#^F4::
Beep()
Beep()
Beep()
Sleep 1100
Run taskkill /im %Proc%.exe /f
return

; Test
#Esc::
Beep()

TempFile = %A_Temp%\TempDat.bat
FileAppend, 
(
@Echo Off
Echo The script is running
), %TempFile%
RunWait %TempFile%
FileDelete %TempFile%
return