#  iOS Web View Tester

## Overview
A test harness for developers to view WebView content from an external website, within an iOS app.
It allows for https on localhost to satisfy iOS App Transport Security settings.
You will need to create an SSL certificate on your local server and import this into the iOS project.

## Steps to create a local SSL certificate
```bash
brew install mkcert
```

## Switch to your local server's folder and add the SSL to the project
```bash
mkdir ssl && cd ssl && mkcert localhost 127.0.0.1 ::1
```
- If the files are not named as localhost-key.pem and localhost.pem, you will need to rename them for the source code access.
- Run the below command to have Node load the root Certificate:
```bash
export NODE_EXTRA_CA_CERTS="$(mkcert -CAROOT)/rootCA.pem"
```
- Within the SSL folder run this command to obtain a .der file for iOS URL session pinning:
```bash
openssl x509 -outform der -in localhost.pem -out localhost.der
```
- Also copy this file into your main project folder for your server outside of src
- Then copy this file into the iOS project's sub folder

## Update source code of server project to upgrade localhost to https
- Within server.js add the required imports
```bash
const fs = require('fs')
const https = require('https')
```
- Add the following code snippet at the bottom of the file, before server.listen
```
    if (process.env.env === 'dev' || process.env.env === 'local' || !process.env.env || process.env.env === 'local-compose') {
      const opts = {
        key: fs.readFileSync('./ssl/localhost-key.pem', 'ascii'),
        cert: fs.readFileSync('./ssl/localhost.pem', 'ascii')      
      }
      process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0'
      return https.createServer(opts, server).listen(3333, () => {
        logger.info('> Ready on https://localhost:3333')
      })
    }
```
- From this point on, you will need to access localhost via https://localhost:3333 on simulator and https://192.168.0.1:3333 etc on device for local development

## Another method if your site uses express, is to capture and redirect the http request to https:
```app.use(function(req, res, next) {
  const xfp =
  req.headers["X-Forwarded-Proto"] || req.headers["x-forwarded-proto"];

  if (xfp === "http") {
      const secureUrl = `https://${req.headers.hostname}${req.url}`;
      res.redirect(301, secureUrl);
  } else {
      next();
  }
});
```
