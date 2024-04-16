import { TestBed } from '@angular/core/testing';
import { CanActivateFn } from '@angular/router';

import { CanActivateRouteGuard } from './can-activate-route.guard';

describe('canActivateRouteGuard', () => {
  const executeGuard: CanActivateFn = (...guardParameters) =>
      TestBed.runInInjectionContext(() => CanActivateRouteGuard(...guardParameters));

  beforeEach(() => {
    TestBed.configureTestingModule({});
  });

  it('should be created', () => {
    expect(executeGuard).toBeTruthy();
  });
});
