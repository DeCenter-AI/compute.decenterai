const CID = require('cids')

let cid_ = 'QmT4KwkG6YkhgpdGfKf2WYaUAaYUfwj7xHikFRGnY2L6MJ' //lighthouse cid

cid_ = "Qmdz1gTvCjiLV7WsnSXKw6ukj1ABEqCwPyyE8N4rgTVxdN"

const cid = new CID(cid_)
console.log(cid.toV1().toBaseEncodedString("base32"));
