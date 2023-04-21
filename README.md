#  iOS Web View Tester

## Overview
A test harness for developers to view WebView content from an external website, within an iOS app.
It allows for https on localhost to satisfy iOS App Transport Security settings.


## Generate an SSL certificate for localhost
We require an SSL certificate for communication between iOS and webview.
Generate the certificate in .der format and once complete, copy into the project's sub folder:
```
openssl genrsa -out localhost.key 

openssl req -new -x509 -key localhost.key -out openssl_crt.pem -outform pem 

openssl x509 -in openssl_crt.pem -inform pem -out localhost.der -outform der
```

## Build
If you're using the latest version of XCode, you will need to navigate to File -> Project Settings -> Advanced and select Legacy for Build Location, then you will be able to build and run the project.

## Tips
If your server uses express, you can redirect the http request to https, by adding this code to your app.js file:
```
app.use(function(req, res, next) {
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
* If you are running a simulator on the same computer, you can access your server using http://localhost:3000 or http://127.0.0.1:3000
* If you are running a device on the same network, you can access your server using http://192.168.0.1
