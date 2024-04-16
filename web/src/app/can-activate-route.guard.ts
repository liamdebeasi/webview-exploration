import { CanActivateFn } from '@angular/router';

export const CanActivateRouteGuard: CanActivateFn = (route, state) => {
  console.log('CanActivate returned false');

  return false;
};
