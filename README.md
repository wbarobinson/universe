# Universe
A solidity smart contract that records the natural selections of poems by users.

The contract is constructed with 10 psuedo-random 32 byte "poems." The first is the Keccak256 hash of the deployer's address, where the remaining are the Keccak256 of the previous.

These poems should be interpreted in sets of 14 bits. The first 11 bits select a word from the provided dictionary. The last 3 bits select punction from the provided dictionary { space, +s space, return, break, comma, period, exclamation mark, question mark }.

Users can call the evolvePoem function with two poem IDs as arguments. The first poem is "selected" and the second poem is "killed." In actuality, the first is spliced with another pseudo-random poem to create a new "child" poem. The newly created poem will overwrite the killed poem. Each newly created poem will record its selector's address.

In total, there will never be more than 10 poems each made of 18 words.

This project is inspired by David Rea's Darwinian Poetry, which created tens of thousands of generations of poems before going offline. Many of these works were of stunning beauty, although few records of them remain.

The hope here is that Universe lives longer, leaving a more durable trace.

The website wbarobinson.github.io/universe will serve users two poems at a time, prompted them to select their favorite. When they do, they will be prompted by Metamask to sign a transaction spending the required gas to update the contract's storage with a child of their selected poem.


#Setup
Universe is deployed locally using truffle develop and react.

In your first terminal
$cd universe

$truffle develop

$compile

$migrate

In your second terminal, in order to launch the webserver accessible at localhost:3000

$cd universe/app

$npm run start

#Interaction

At localhost:3000, you will be able to interact with the universe smart contract deployed on your development server.

You should be served 2 poems. 
Choose your favorite on one by entering its ID in the selected poem field. Enter the other poem's ID in the rejected bar.


