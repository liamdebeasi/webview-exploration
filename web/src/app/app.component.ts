import { Component } from '@angular/core';
import { RouterOutlet, Router, ResolveEnd } from '@angular/router';
import { win } from './browser';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent {
  title = 'ssg-test';

  constructor(private router: Router) {
    router.events.subscribe((val) => {
      // only intercept navigation once guards have resolved
      // this lets dev rely on Angular's guards to
      // control navigation
      if (val instanceof ResolveEnd) {
        // ignore initial navigation
        if (val.url !== router.url && val.id !== 1) {
          this.pushNativeView(val.url);
        }
      }
    });
  }

  private handlerCallback = this.openAddMovieView.bind(this);

  ngOnInit() {
    if (win) {
      win.addEventListener('add-movie-click', this.handlerCallback);
    }
  }

  ngOnDestroy() {
    if (win) {
      win.removeEventListener('add-movie-click', this.handlerCallback);
    }
  }

  openAddMovieView() {
    console.log('Opening add movie view')
    if (win && win.webkit) {
      win.webkit.messageHandlers.navigationMessageHandler.postMessage({
        type: 'createAddMovieView',
        data: 'stub'
      });
    }
  }

  pushNativeView(url: string) {
    if (win && win.webkit) {
      // navigate back to previous view so app does not re-render
      // because the new view should be shown in a separate webview
      this.router.navigateByUrl(this.router.url);

      win.webkit.messageHandlers.navigationMessageHandler.postMessage({
        type: 'createEditMovieView',
        data: url
      });
    }
  }
}
