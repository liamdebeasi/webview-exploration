import { CanActivateFn } from '@angular/router';

export const NativeDelegateGuard: CanActivateFn = (route, state) => {
  return true;
};
