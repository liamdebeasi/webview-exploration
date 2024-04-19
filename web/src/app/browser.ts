interface MessageHandler {
  postMessage: (...args: any) => any;
}

interface MessageHandlers {
  messageHandler: MessageHandler;
}

interface WKMessageHandler {
  messageHandlers: MessageHandlers
}

interface NativeWindow extends Window {
  webkit?: WKMessageHandler;
}

export const win: NativeWindow | undefined = typeof window !== 'undefined' ? window : undefined;
