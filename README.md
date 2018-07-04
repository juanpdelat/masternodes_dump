# masternodes_dump

## Add 2G RAM Swap to VPS
Check if there is any SWAP already configured:
`sudo swapon --show`
If you don't get back any output, this means your system does not have swap space available currently.

1. Download file  
`wget https://raw.githubusercontent.com/juanpdelat/masternodes_dump/master/ubuntu-ram-swap.sh`  

2. Make it executable  
`chmod +x ubuntu-ram-swap.sh`  

3. Execute it  
`./ubuntu-ram-swap.sh`  

4. Remove it  
`rm ubuntu-ram-swap.sh`  