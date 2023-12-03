README?

# ISSUE-1 [version 1]

- for some reason sometimes AutoDeauth script does not show APs
- RECMON script was my main script to solve this issue the name comes from `Recover Monitor Mode` i thoutgh the issue was about airmon not being able to switch from monitor mode to managed mode
- however that wasnt the issue and i still have no idea what causes it

# ISSUE-1 Fix-1 [version 2]

- RECMON script was my main script to solve this issue the name comes from `Recover Monitor Mode` i thoutgh the issue was about airmon not being able to switch from monitor mode to managed mode
- however that wasnt the issue and i still have no idea what causes it

# ISSUE-1 Fix-2 [version 3]

- After Running `RECMON` the issue starts again with airmon-ng i guess so instead switching to monitor mode using airmon-ng i use `ALTMON` to switch to Monitor mode using the alternative `iw wlan0 set type monitor`
- Right now when `ISSUE-1` occours if i run scripts `RECMON -> ALTMON -> AutoDeauth` in this order everything works as intended. i will put everything in 1 file to have a temporary fix

# Temporary Fix to ISSUE-1

- Put the `ALTMON` and `RECMON` scripts before `AutoDeauth` in a single script
- removed comments, removed airmon for monitoring
