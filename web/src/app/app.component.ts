import { Component } from '@angular/core';
import { RouterOutlet, Router, ResolveEnd } from '@angular/router';
import { Location } from '@angular/common';
@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent {
  title = 'ssg-test';

  constructor(private router: Router, private location: Location) {
    router.events.subscribe((val) => {
      if (val instanceof ResolveEnd) {
        if (val.url !== router.url && val.id !== 1) {
          router.navigateByUrl(router.url);

          if (typeof window !== 'undefined') {
            (window as any).webkit.messageHandlers.navigationMessageHandler.postMessage('foo')
          }
        }
      }
    });
  }
}
