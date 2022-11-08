const functions = require("firebase-functions");

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

exports.getRefreshToken = functions.https.onRequest(async (request, response) => {

    //import the module to use
    const axios = require('axios');
    const qs = require('qs')

    const code = request.query.code;
    const client_secret = makeJWT();

    let data = {
        'code': code,
        'client_id': 'XC Najim Bopp-Music-Player',
        'client_secret': client_secret,
        'grant_type': 'authorization_code'
    }
    
    return axios.post(`https://appleid.apple.com/auth/token`, qs.stringify(data), {
    headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
    },
    })
    .then(async res => {
        const refresh_token = res.data.refresh_token;
        response.send(refresh_token);
        
    });

});
exports.revokeToken = functions.https.onRequest( async (request, response) => {

    //import the module to use
    const axios = require('axios');
    const qs = require('qs');
  
    const refresh_token = request.query.refresh_token;
    const client_secret = makeJWT();
  
    let data = {
        'token': refresh_token,
        'client_id': 'XC Najim Bopp-Music-Player',
        'client_secret': client_secret,
        'token_type_hint': 'refresh_token'
    };
  
    return axios.post(`https://appleid.apple.com/auth/revoke`, qs.stringify(data), {
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
    })
    .then(async res => {
        console.log(res.data);
    });
  });
  

function makeJWT() {

    const jwt = require('jsonwebtoken')
    const fs = require('fs')
  
    // Path to download key file from developer.apple.com/account/resources/authkeys/list
    let privateKey = fs.readFileSync('AuthKey_96SQR8TBT7.p8');
  
    //Sign with your team ID and key ID information.
    let token = jwt.sign({ 
    iss: '8YBV925VBW',
    iat: Math.floor(Date.now() / 1000),
    exp: Math.floor(Date.now() / 1000) + 120,
    aud: 'https://appleid.apple.com',
    sub: 'XC Najim Bopp-Music-Player'
    
    }, privateKey, { 
    algorithm: 'ES256',
    header: {
    alg: 'ES256',
    kid: '96SQR8TBT7',
    } });
    
    return token;
  }

  