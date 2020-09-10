The goal of the project was to as closely emulate David Rea's Darwinian Poetry as possible. 
This meant:
- starting with 1000 poems;
- whose words originated from pre-existing poetry;
- where poems were selected froms pairs to be spliced (in an undocumented way);
- and where poems were destroyed.

Given the storage constraints of Ethereum, it did not make sense to store all of the words of all of the poems. 
Rather, inspired by the mnemonic dictionary introduced in BIP39, I decided to encode these poems as byte strings.
Given that the Darwinian Poetry was roughly 19 words long, Solidity's bytes32 type was capable of holding enough words and punctiation for my purposes.

The most difficult part was to determine an appropriate splicing behavior and then coding it in Solidity. The approach I decided to take was to ensure that words were largely preserved.