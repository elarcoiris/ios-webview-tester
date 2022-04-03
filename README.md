#  iOS Web View Tester

## Overview
A test harness for developers to view WebView content from an external website, within an iOS app.
It allows for https on localhost to satisfy iOS App Transport Security settings.

### If your site uses express, capture and redirect the http request to https. Add this to your app.js file:
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
* If you are running a simulator on the same computer, you can access your server using http:localhost:3000
* If you are running a device on the same network, you can access your server using http://192.168.0.1
