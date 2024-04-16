import { TestBed } from '@angular/core/testing';
import { CanActivateFn } from '@angular/router';

import { NativeDelegateGuard } from './native-delegate.guard';

describe('nativeDelegateGuard', () => {
  const executeGuard: CanActivateFn = (...guardParameters) =>
      TestBed.runInInjectionContext(() => NativeDelegateGuard(...guardParameters));

  beforeEach(() => {
    TestBed.configureTestingModule({});
  });

  it('should be created', () => {
    expect(executeGuard).toBeTruthy();
  });
});
