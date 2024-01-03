# sayer-stashbox

Discord - https://discord.gg/3WYz3zaqG5

an advanced storage script for jobs,gangs,personal stashes
with built in Bank vault system 

## Dependencies
- [qb-core](https://github.com/qbcore-framework/qb-core)
- [qb-menu](https://github.com/qbcore-framework/qb-menu)

## Installation
- run the sql file "vaults.sql"
- configure in shared/config.lua

## Rainmad
if using rainmads pacific heist go to rm_pacificheist/server.lua and paste this event into it at the bottom
```
QBCore.Functions.CreateCallback('pacificheist:server:isBankHeist', function(_, cb)
    cb(start)
end)
```