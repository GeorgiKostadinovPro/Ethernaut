## Ethernaut
My soluditons to the famous Ethernaut Challenges CTF.

## What is CTFs
CTFs (Capture The Flags / War games) are security challenges where vulnerable code is presented and you need to write a smart contract to exploit the vulnerability.

## What is Ethernaut CTF
<a href="https://ethernaut.openzeppelin.com/">Ethernaut</a> is a Web3/Solidity based war game inspired in <a href="https://overthewire.org/wargames/">overthewire.org</a>, to be played in the Ethereum Virtual Machine. Each level is a smart contract that needs to be 'hacked'.

The game acts both as a tool for those interested in learning Ethereum, and as a way to catalog historical hacks in levels. Levels can be infinite, and the game does not require to be played in any particular order.

The game is created by <a href="https://www.openzeppelin.com/">OpenZeppelin</a>

### Contracts
All resources from the game are in folder <a href="./src/">src</a>.

### Solutions
My soluditons are presented in the <a href="./src/attackers/">attackers</a> and <a href="./test">test</a> folders.

<strong>NOTE:</strong> Some challenges require to create an attacker contract, some may not need such contract.

<strong>NOTE:</strong> Some solidity compiler versions are old by default like "^0.6.0" in order to make the exploits working.

## Usage
```shell
git clone https://github.com/GeorgiKostadinovPro/Ethernaut
make
```
To run a specific test
```shell
forge test --match-test testAuthenticateWithPassword
```
To run all tests
```shell
forge test
```

## Disclaimer
All Solidity code, practices and patterns in this repository are DAMN VULNERABLE and for educational purposes only.

I do not give any warranties and will not be liable for any loss incurred through any use of this codebase.

DO NOT USE IN PRODUCTION.
