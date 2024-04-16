import { CanActivateFn } from '@angular/router';

export const NativeDelegateGuard: CanActivateFn = (route, state) => {
  console.log('NATIVE')
  return true;
};
