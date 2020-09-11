

function poemize(array) {
    array.forEach(element => {
        let binPoem = hex2bin(element);
        let wordPoem = [];
        for(i=0; i<element.lenth; i + 14) {
            wordNum = binPoem.slice(i,i+12);
            word = wordDictionary[wordNum];
            wordPoem.push(word);
            punctNum = binPoem.slice(i+11, i +15);
            punct = punctDictionary[punctNum];
            wordPoem.push(punct);
        }
        return wordPoem;
    });
}

function hex2bin(hex){
    return (parseInt(hex, 16).toString(2)).padStart(8, '0');
}

poemize(["3264917364917863"]); 