function DecodeErrorToBanks(id) {
    var bankNumbersPart = id.substring(6);
    var bankNumbers = parseInt(bankNumbersPart, 16);
    var extractedBankNumbers = [];

    for (var i = 0; i < 8; i++) {
        if ((bankNumbers & 1) === 1) {
            extractedBankNumbers.push(i + 1); // Add 1 to match bank numbering (1-indexed)
        }
        bankNumbers >>= 1;
    }

    return extractedBankNumbers;
}