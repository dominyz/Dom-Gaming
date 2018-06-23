toggle = 0
#MaxThreadsPerHotkey 2

F2::
Toggle := !Toggle
While Toggle{
Send 4
Send 5
sleep 300
}
return