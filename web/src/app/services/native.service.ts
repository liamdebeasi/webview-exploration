import { Injectable } from '@angular/core';
import { win } from '../browser';

@Injectable({
  providedIn: 'root'
})
export class NativeService {

  constructor() { }

  isNative() {
    return win && win.webkit;
  }

  listenForNative<R>(event: string, callback: (detail: R) => void) {
    if (this.isNative()) {
      const cb = (ev: any) => {
        callback(ev.detail);
      }
      win!.addEventListener(event, cb);

      return () => {
        win!.removeEventListener(event, cb);
      }
    }

    return;
  }

  // TODO Is there a way to have TypeScript infer the D type based on the type of the data passed in?
  async queryNative<D = any, R = any>(type: string, data: D, waitForResponse = true): Promise<R | undefined> {
    return new Promise((resolve, reject) => {
      if (this.isNative()) {
        const eventName = `${type}-response`;
        const processData = (ev: any) => {
          win!.removeEventListener(eventName, processData);

          return resolve(ev.detail as R);
        }

        if (waitForResponse) {
          win!.addEventListener(eventName, processData);
        }

        win!.webkit!.messageHandlers.navigationMessageHandler.postMessage({
          type,
          data
        });

        if (!waitForResponse) {
          return resolve(undefined);
        }
      } else {
        return reject(undefined);
      }
    });
  }
}
