The goal of the project was to as closely emulate David Rea's Darwinian Poetry as possible. 
This meant:
- starting with 200 poems;
- whose words originated from pre-existing poetry;
- where poems could be selected froms pairs to be spliced (in an undocumented way);
- and where poems were destroyed.


#On the 32Bytes Type
Given the storage costs of Ethereum, it did not make sense to store all of the words of all of the poems. 
Rather, inspired by the mnemonic dictionary introduced in BIP39, I decided to encode these poems as byte strings.
Given that the Darwinian Poetry was roughly 19 words long, Solidity's bytes32 type was capable of holding enough words and punctiation for my purposes.


#On creating a mapping of IDs to poems.
Given that poems will be referenced regularly by users placing inputs, and by the code itself, it makes obvious sense to create a uint => bytes32 mapping.

#On creating an creator mapping.
Given that people will want to look up the results of their poems, it makes sense to map IDs to addresses. This however, is not part of David Rea's design. I included it here as a counterbalance to the fact that users will need to pay gas to interact with the contract. In otherwise, mapping addresses to poems is a way of incentivizing participation.

#On Bit Masking During Splicing
Given that words must be passed down to the child poem, splicing poems requires a certain degree of word-atomicity.
After attempting a variety of methods, the most appropriate was to apply a random mask.
The base mask is 0x00000000000000000000000000000fffffffffffffffffffffffffffff. 
Left alone, this mask would keep the second half of the selected poem if we used the AND (&) mask.
However, because I wanted the splices to lead to more interesting poems over time and because I do not know how Rea actually spliced his poems, I added a pseudo-random modifier.
Using bit shifting (<<) of up to 128 bits, the mask can essentially cover any 16 byte section of the 32 byte poem. 
The pseudo-random shift is just the timestamp modulo 128. While I am cognizant of the timestamp's manipulability by miners, I am not worried about someone taking the extra effort to get a good result and the same goes for all other pseudo-random elements in this process.

The next step is to select a pseudo-random partner poem. This, like the bit shift, is a simple modulo of the timestamp.
The next step would normally have been to take that same mask and to NAND the partner poem. By doing so, the partner poem could AND mask the selected poem to produce a child where most words would be atomically merged. However, the NAND function does not exist, so I created a workaround where a second mask is introduced in the global variables. This mask is 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffff and gets OR masked by the bit shifted mask, thus producing the complementary mask required to AND the partner poem.

#On Partial Word Atomicity
I could have bitshifted in such a way as to produce perfect word atomicity, but I instead made it so there would likely be 2 newly introduced words or punctuations. 
This is because the mask will likely start midway through a word/punction and end midway through another word/punctuation, producing word total unrelated to either poem.
The reason for this was to keep alive the possibility for "biodiversity" in the future. Should all the poems converge on only a subset of the total dictionary, I felt it more exciting to leave it to chance to produce a rarer or even new word.

#On a LogNewPoem Event
Given that selecting a poem changes the state of the contract, best practice lead me to emit an event.

#On the absence of transfers
It would have been trivial to implement a transfer ownership function, but the desire was not to cast creators as owners. This is doubly the case by virtue of everyone's ability to destroy another else's poem from the array of poems.

#On the absence of a circuit breaker
The entire point of the project is to keep it alive forever. Circuit breakers do not prevent any risk and introduce an unwanted function instead.

