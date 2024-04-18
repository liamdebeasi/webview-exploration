import { Injectable, inject } from '@angular/core';
import { NativeService } from './native.service';

@Injectable({
  providedIn: 'root'
})
export class NavigationService {
  private native = inject(NativeService);

  constructor() { }

  navigateMovieView(url?: string) {
    this.native.queryNative('navigate-movie-view', url, false);
  }
}
