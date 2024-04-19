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
  async queryNative<D = any, R = any>(type: string, data: D): Promise<R | undefined> {
    if (this.isNative()) {
      const response = await win!.webkit!.messageHandlers.messageHandler.postMessage({
        type,
        data
      });

      return JSON.parse(response) as R;
    }

    return;
  }
}
