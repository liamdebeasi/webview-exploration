import { Component, inject } from '@angular/core';
import { RouterOutlet, Router, ResolveEnd } from '@angular/router';
import { win } from './browser';
import { NavigationService } from './services/navigation.service';
import { NativeService } from './services/native.service';
import { MoviesService } from './services/movies.service';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent {
  private navigationService = inject(NavigationService);
  private nativeService = inject(NativeService);
  private moviesService = inject(MoviesService);
  private destroyListener: (() => void) | undefined;
  private destroyRouterListener: (() => void) | undefined;

  private skipNative = false;

  constructor(private router: Router) {
    router.events.subscribe((val) => {
      // only intercept navigation once guards have resolved
      // this lets dev rely on Angular's guards to
      // control navigation
      if (val instanceof ResolveEnd) {
        // ignore initial navigation
        if (val.url !== router.url && val.id !== 1) {
          if (this.skipNative) {
            this.skipNative = false;
            return;
          }

          this.pushNativeView(val.url);

        }
      }
    });
  }

  ngOnInit() {
    const destroy = this.moviesService.onAddMovieActivate(() => {
      this.navigationService.navigateMovieView();
    });

    this.destroyListener = destroy;

    const destroyRouterListener = this.nativeService.listenForNative('native-route', this.setWebView.bind(this));
    this.destroyRouterListener = destroyRouterListener;
  }

  ngOnDestroy() {
    if (this.destroyListener) {
      this.destroyListener();
      this.destroyListener = undefined;
    }

    if (this.destroyRouterListener) {
      this.destroyRouterListener();
      this.destroyRouterListener = undefined;
    }
  }

  // TODO this is hacky
  setWebView(path: string) {
    this.skipNative = true;
    this.router.navigateByUrl(path, { replaceUrl: true });
  }

  pushNativeView(url: string) {
    if (this.nativeService.isNative()) {
      // navigate back to previous view so app does not re-render
      // because the new view should be shown in a separate webview
      this.router.navigateByUrl(this.router.url);
      this.navigationService.navigateMovieView(url);
    }
  }
}
