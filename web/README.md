# SsgTest

This project was generated with [Angular CLI](https://github.com/angular/angular-cli) version 17.3.2.

## Local Testing

1. In `web`, run `npm i && ng serve --disable-host-check`.
2. Run `ngrok http [port] --domain [custom domain]`. `port` can be found in the previous step (usually `4200`). `custom domain` is optional, but this lets you use a single domain every time you restart ngrok as opposed to always needing to update the domain in the native application.
3. Open the native app in Xcode. Replace `liam.ngrok.app` with your domain in step 2. You can use the magnifying glass in the left sidebar to find and replace all instances.
4. Deploy application on device.
